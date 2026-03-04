import '../interfaces/fc_network_client.dart';
import '../fc_call_result.dart';
import '../fc_web_call.dart';
import '../fc_web_call_info.dart';
import '../../context/site_context.dart';
import 'dart:convert';

/// Generic JSON network client implementation
class FCJsonNetworkClientImpl implements FCJsonNetworkClient {
  @override
  Future<FCCallResult> makeCall(
    SiteContext context,
    String methodName,
    Map<String, dynamic>? parameters,
  ) async {
    try {
      // Get plugin URL
      String pluginUrl = context.site.pluginUrl;
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
        data = jsonEncode(parameters);
      } else {
        data = '{}';
      }

      // Create web call info
      FCWebCallInfo webCallInfo = FCWebCallInfo.fromSiteContext(context);

      // Make HTTP call
      return await FCWebCall.makeHttpCall(
        url,
        'POST',
        data,
        'application/json',
        webCallInfo,
      );
    } catch (e) {
      throw Exception('JSON network call failed: $e');
    }
  }

  @override
  Future<T> makeJsonCall<T>(
    SiteContext context,
    String methodName,
    Map<String, dynamic>? parameters,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      // Make the call
      FCCallResult result = await makeCall(context, methodName, parameters);

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
