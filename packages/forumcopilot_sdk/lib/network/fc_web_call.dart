import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:forumcopilot_sdk/services/fc_http_overrides.dart';

import 'fc_call_result.dart';
import 'fc_web_call_info.dart';

class FCWebCall {
  static Future<FCCallResult> makeHttpCall(
    String url,
    String httpMethod,
    String data,
    String contentType,
    FCWebCallInfo webCallInfo,
  ) async {
    return makeByteHttpCall(url, httpMethod, utf8.encode(data), contentType, webCallInfo);
  }

  static Future<FCCallResult> makeByteHttpCall(
    String url,
    String httpMethod,
    Uint8List dataBytes,
    String contentType,
    FCWebCallInfo webCallInfo,
  ) async {
    try {
      // Debug logging for HTTP call
      print('🔍 [HTTP_CALL_DEBUG] makeByteHttpCall called');
      print('🔍 [HTTP_CALL_DEBUG] URL: "$url"');
      print('🔍 [HTTP_CALL_DEBUG] URL length: ${url.length}');
      print('🔍 [HTTP_CALL_DEBUG] httpMethod: $httpMethod');
      print('🔍 [HTTP_CALL_DEBUG] contentType: $contentType');

      // Validate URL before parsing
      if (url.isEmpty) {
        print('❌ [HTTP_CALL_ERROR] URL is empty');
        throw Exception('Failed to make HTTP call: URL is empty');
      }

      // Try to parse URI with detailed error handling
      Uri parsedUri;
      try {
        parsedUri = Uri.parse(url);
        print('🔍 [HTTP_CALL_DEBUG] URI parsed successfully');
        print('🔍 [HTTP_CALL_DEBUG] Host: "${parsedUri.host}"');
        print('🔍 [HTTP_CALL_DEBUG] Scheme: "${parsedUri.scheme}"');
        print('🔍 [HTTP_CALL_DEBUG] Port: ${parsedUri.port}');
        print('🔍 [HTTP_CALL_DEBUG] Path: "${parsedUri.path}"');
      } catch (e) {
        print('❌ [HTTP_CALL_ERROR] Failed to parse URI: "$url"');
        print('❌ [HTTP_CALL_ERROR] Error: $e');
        throw Exception('Failed to make HTTP call: Invalid argument(s): No host specified in URI');
      }

      // Create headers
      Map<String, String> headers = {
        'Content-Type': contentType,
        ...webCallInfo.extraHeaders,
      };

      final response = await FCDioClient.instance.request<List<int>>(
        httpMethod,
        parsedUri.toString(),
        data: dataBytes,
        headers: headers,
        responseType: ResponseType.bytes,
        options: Options(validateStatus: (_) => true),
      );

      // Get response data
      final responseBytes = response.data ?? Uint8List.fromList([]);
      final responseBody = utf8.decode(responseBytes, allowMalformed: true);
      final responseHeaders = <String, String>{};
      response.headers.forEach((key, values) {
        if (values.isNotEmpty) {
          responseHeaders[key] = values.first;
        }
      });

      // Extract cookies from response headers
      Map<String, String> responseCookies = {};
      final setCookieHeader = responseHeaders['set-cookie'];
      if (setCookieHeader != null) {
        final cookiesList = setCookieHeader.split(',');

        for (final cookieStr in cookiesList) {
          final cookieParts = cookieStr.split(';');
          if (cookieParts.isNotEmpty) {
            final mainPart = cookieParts[0].trim();
            final equalIndex = mainPart.indexOf('=');
            if (equalIndex > 0) {
              final key = mainPart.substring(0, equalIndex).trim();
              final value = mainPart.substring(equalIndex + 1).trim();
              responseCookies[key] = value;
            }
          }
        }
      }

      // Create and return CallResult
      return FCCallResult(
        statusCode: response.statusCode ?? 0,
        body: responseBody,
        headers: responseHeaders,
        cookies: responseCookies,
        fcIsLogin: responseHeaders.containsKey('fc_is_login') && (responseHeaders['fc_is_login'] == 'true' || responseHeaders['fc_is_login'] == '1'),
      );
    } catch (e) {
      // Handle exceptions
      throw Exception('Failed to make HTTP call: $e');
    }
  }
}
