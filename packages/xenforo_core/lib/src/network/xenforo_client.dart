import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/network/fc_call_result.dart';
import 'package:forumcopilot_sdk/services/fc_http_client.dart';
import 'package:forumcopilot_sdk/services/fc_http_overrides.dart';
import '../xf_debug.dart';

/// An [FCCallResult] that also carries the body already decoded, so callers
/// don't decode the same JSON again.
class XenForoCallResult extends FCCallResult {
  final Map<String, dynamic>? decoded;

  XenForoCallResult({
    super.statusCode,
    super.body,
    super.headers,
    super.fcIsLogin,
    this.decoded,
  });
}

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
      xfDebug('🔍 [XENFORO_CLIENT] Sending request to: $pluginUrl');
      xfDebug('🔍 [XENFORO_CLIENT] Method: ${requestData['method']}');

      // Ensure CookieJar is initialized before making requests
      await FCDioClient.instance.initialize();

      var response = await FCHttpClient.post<String>(
        url,
        headers: requestHeaders,
        body: jsonEncode(requestData),
        responseType: ResponseType.plain,
      );

      // Redirects are not followed for this POST: dart:io only follows a 303
      // (as a GET), Dio rejects any other 3xx, and replaying the request
      // elsewhere would resend the sign-in password to whatever host the
      // Location header names. A redirect is reported clearly below instead.
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
      
      // A redirect means the forum's address in the app is out of date (it
      // moved to https or www, say): say so instead of showing the HTML page.
      final location = headers['location'];
      if (statusCode >= 300 && statusCode < 400 && location != null) {
        bodyString = jsonEncode({
          'error': 'The forum answered from a different address ($location). '
              'Its address in the app may be out of date.',
          'result': false,
        });
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

    // Parse JSON response from plugin, once; the decoded map rides along on
    // the result so BaseXenForoProxy doesn't decode it again.
    final bodyString = response.data?.toString() ?? '';
    Map<String, dynamic> data;
    try {
      data = bodyString.isEmpty ? {} : jsonDecode(bodyString) as Map<String, dynamic>;
    } catch (e) {
      data = {'error': 'Failed to parse JSON response: $e'};
    }

    // Plugin returns FC-compliant data directly, so simplified error handling
    if (data.containsKey('error')) {
      final errorData = {'error': data['error'], 'result': false};
      return XenForoCallResult(
        statusCode: statusCode,
        body: jsonEncode(errorData),
        headers: headers,
        fcIsLogin: fcIsLogin,
        decoded: errorData,
      );
    }

    return XenForoCallResult(
      statusCode: statusCode,
      body: bodyString,
      headers: headers,
      fcIsLogin: fcIsLogin,
      decoded: data,
    );
  }
}
