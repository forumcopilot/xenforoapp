import '../fc_call_result.dart';
import '../../context/site_context.dart';

/// Abstract interface for network clients
/// This allows different forum implementations to use different network protocols
abstract class FCNetworkClient {
  /// Make a network call
  Future<FCCallResult> makeCall(
    SiteContext context,
    String methodName,
    Map<String, dynamic>? parameters,
  );
}

/// Abstract interface for JSON-based network clients
abstract class FCJsonNetworkClient extends FCNetworkClient {
  /// Make a JSON call and parse the response
  Future<T> makeJsonCall<T>(
    SiteContext context,
    String methodName,
    Map<String, dynamic>? parameters,
    T Function(Map<String, dynamic>) fromJson,
  );
}

/// Abstract interface for XML-RPC network clients
abstract class FCXmlRpcNetworkClient extends FCNetworkClient {
  /// Make an XML-RPC call and parse the response
  Future<T> makeXmlRpcCall<T>(
    SiteContext context,
    String methodName,
    Map<String, dynamic>? parameters,
    T Function(Map<String, dynamic>) fromJson,
  );
}
