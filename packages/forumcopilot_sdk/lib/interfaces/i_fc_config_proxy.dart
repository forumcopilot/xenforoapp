import '../models/results/fc_config_result.dart';

/// Interface for configuration management operations
/// This interface handles forum configuration retrieval
abstract class IFCConfigProxy {
  /// This function is always the first function to invoke when the app attempts to enter a specific forum.
  /// It returns configuration name/value pair for this forum system. There are two kind of name/value pairs.
  /// One is those based on some of the forum system configuration, and one is a simple name/value pairs
  /// declared in the config.txt file, usually located in mobiquo/conf/config.txt.
  /// E.g. the "guest_okay" is based on the forum system configuration while the "api_level" is mobiquo
  Future<FCConfigResult> getConfig(String url, {bool forceRefresh = false});
}
