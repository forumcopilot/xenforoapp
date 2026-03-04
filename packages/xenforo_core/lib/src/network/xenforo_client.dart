import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/network/fc_call_result.dart';
import 'package:forumcopilot_sdk/services/fc_http_client.dart';
import 'package:forumcopilot_sdk/services/fc_http_overrides.dart';

/// XenForo HTTP client for ForumCopilot plugin communication
/// Simplified to work exclusively with the FC_XenForo2 plugin endpoint
class XenForoClient {
  /// Call ForumCopilot plugin API endpoint
  /// This replaces all REST API calls with a single plugin endpoint
  Future<FCCallResult> forumcopilotApi(
    SiteContext context,
    Map<String, dynamic> requestData,
  ) async {
    try {
      // Simple headers for plugin communication
      final requestHeaders = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // Session authentication handled by cookies - no custom auth headers needed
      };

      // Single plugin endpoint URL
      final pluginUrl = context.site.pluginUrl;

      final url = Uri.parse(pluginUrl);
      print('🔍 [XENFORO_CLIENT] Sending request to: $pluginUrl');
      print('🔍 [XENFORO_CLIENT] Method: ${requestData['method']}');
      print('🔍 [XENFORO_CLIENT] Headers: $requestHeaders');

      // Ensure CookieJar is initialized before making requests
      await FCDioClient.instance.initialize();

      var response = await FCHttpClient.post<String>(
        url,
        headers: requestHeaders,
        body: jsonEncode(requestData),
        responseType: ResponseType.plain,
      );

      // Handle redirects manually if needed (301, 302, etc.)
      int redirectCount = 0;
      while ((response.statusCode ?? 0) >= 300 && (response.statusCode ?? 0) < 400 && redirectCount < 5) {
        final location = response.headers.value('location');
        if (location != null) {
          final redirectUrl = Uri.parse(location);
          final resolvedUrl = redirectUrl.isAbsolute ? redirectUrl : url.resolveUri(redirectUrl);
          print('🔄 [XENFORO_CLIENT] Following redirect to: ${resolvedUrl.toString()}');
          response = await FCHttpClient.post<String>(
            resolvedUrl,
            headers: requestHeaders,
            body: jsonEncode(requestData),
            responseType: ResponseType.plain,
          );
          redirectCount++;
        } else {
          break;
        }
      }

      return _parseResponse(response);
    } on DioException catch (e) {
      // DioException contains the actual HTTP response even when status code triggers an exception
      // Extract the real status code and response body for proper error handling
      final statusCode = e.response?.statusCode ?? 0;
      final headers = <String, String>{};
      
      // Extract headers from DioException response
      if (e.response != null) {
        e.response!.headers.forEach((key, value) {
          if (value.isNotEmpty) {
            headers[key] = value.first;
          }
        });
      }
      
      // Extract fc_is_login header value
      bool fcIsLogin = false;
      if (headers.containsKey('fc_is_login')) {
        final loginValue = headers['fc_is_login']?.toLowerCase() ?? '';
        fcIsLogin = (loginValue == 'true' || loginValue == '1');
      }
      
      // Extract response body - try to get it as string
      String bodyString = '';
      if (e.response != null) {
        final responseData = e.response!.data;
        if (responseData is String) {
          bodyString = responseData;
        } else if (responseData != null) {
          bodyString = responseData.toString();
        }
      }
      
      // If body is empty, create a structured error message
      if (bodyString.isEmpty) {
        bodyString = jsonEncode({
          'error': e.message ?? 'HTTP request failed',
          'type': e.type.toString(),
        });
      }
      
      return FCCallResult(
        statusCode: statusCode,
        body: bodyString,
        headers: headers,
        fcIsLogin: fcIsLogin,
      );
    } catch (e) {
      // For non-Dio exceptions, return a generic error
      return FCCallResult(
        statusCode: 0,
        body: jsonEncode({'error': e.toString()}),
        headers: {},
        fcIsLogin: false,
      );
    }
  }

  /// Parse plugin API response
  /// Simplified from XenForo REST API response parsing
  FCCallResult _parseResponse(Response response) {
    final statusCode = response.statusCode ?? 0;
    final headers = <String, String>{};

    // Convert response headers
    response.headers.forEach((key, value) {
      if (value.isNotEmpty) {
        headers[key] = value.first;
      }
    });

    // Extract fc_is_login header value
    bool fcIsLogin = false;
    if (headers.containsKey('fc_is_login')) {
      final loginValue = headers['fc_is_login']?.toLowerCase() ?? '';
      fcIsLogin = (loginValue == 'true' || loginValue == '1');
    }

    // Parse JSON response from plugin
    Map<String, dynamic> data;
    try {
      final bodyString = response.data?.toString() ?? '';
      if (bodyString.isEmpty) {
        data = {};
      } else {
        data = jsonDecode(bodyString) as Map<String, dynamic>;
      }
    } catch (e) {
      data = {'error': 'Failed to parse JSON response: $e'};
    }

    // Plugin returns FC-compliant data directly, so simplified error handling
    if (data.containsKey('error')) {
      return FCCallResult(
        statusCode: statusCode,
        body: jsonEncode({
          'error': data['error'],
          'result': false,
        }),
        headers: headers,
        fcIsLogin: fcIsLogin,
      );
    }

    return FCCallResult(
      statusCode: statusCode,
      body: jsonEncode(data),
      headers: headers,
      fcIsLogin: fcIsLogin,
    );
  }
}
