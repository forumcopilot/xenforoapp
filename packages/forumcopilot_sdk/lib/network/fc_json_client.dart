import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/network/fc_web_call.dart';
import 'package:forumcopilot_sdk/network/fc_web_call_info.dart';
import 'dart:convert';

class FCJsonClient {
  String getJsonGetCall<TIn>(SiteContext siteContext, String url, String methodName, TIn? parameters) {
    var finalUrl = '';
    if (parameters != null) {
      late Map<String, dynamic> paramMap;
      if (parameters is Map<String, dynamic>) {
        paramMap = parameters;
      } else if ((parameters as dynamic).toJson is Function) {
        paramMap = jsonDecode((parameters as dynamic).toJson());
      } else {
        throw Exception("Unsupported parameter type. Provide either a Map or an object with a toJson() method.");
      }
      paramMap.forEach((key, value) {
        if (value != null) {
          finalUrl += "&$key=${value.toString()}";
        }
      });
    }
    return finalUrl;
  }

  String getJsonPostCall<TIn>(TIn? parameters) {
    if (parameters != null) {
      late Map<String, dynamic> paramMap;
      if (parameters is Map<String, dynamic>) {
        paramMap = parameters;
      } else if ((parameters as dynamic).toJson is Function) {
        paramMap = jsonDecode((parameters as dynamic).toJson());
      } else {
        throw Exception("Unsupported parameter type. Provide either a Map or an object with a toJson() method.");
      }
      return jsonEncode(paramMap);
    }
    return '{}';
  }

  Future<T> doCall<T>(
    SiteContext siteContext,
    String methodName,
    Map<String, dynamic>? parameters,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      // Get plugin URL
      String pluginUrl = siteContext.site.pluginUrl;
      if (pluginUrl.isEmpty) {
        throw Exception('Plugin URL is empty');
      }

      // Build URL
      String url = '$pluginUrl/mobiquo/mobiquo.php';
      if (methodName.isNotEmpty) {
        url += '?method=$methodName';
      }

      // Get parameters
      String data = '';
      if (parameters != null && parameters.isNotEmpty) {
        data = getJsonPostCall(parameters);
      } else {
        data = '{}';
      }

      // Create web call info
      FCWebCallInfo webCallInfo = FCWebCallInfo.fromSiteContext(siteContext);

      // Make HTTP call
      var result = await FCWebCall.makeHttpCall(
        url,
        'POST',
        data,
        'application/json',
        webCallInfo,
      );

      // Check for errors
      if (result.statusCode != 200) {
        throw Exception('HTTP error: ${result.statusCode}');
      }

      // Parse response
      Map<String, dynamic> responseJson = jsonDecode(result.body);

      // Check for API errors
      if (responseJson.containsKey('error')) {
        throw Exception('API error: ${responseJson['error']}');
      }

      // Convert to result type
      return fromJson(responseJson);
    } catch (e) {
      throw Exception('JSON call failed: $e');
    }
  }
}
