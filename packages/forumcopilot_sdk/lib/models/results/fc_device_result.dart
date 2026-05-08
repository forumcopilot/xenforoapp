import 'package:dart_mappable/dart_mappable.dart';
import 'fc_base_result.dart';

part 'fc_device_result.mapper.dart';

/// Result for device-token register/unregister/update calls.
/// Just the standard `result` + `resultText` envelope.
@MappableClass()
class FCDeviceResult extends FCBaseResult with FCDeviceResultMappable {
  /// Echo of the registered device id (set on successful register/update).
  final String? deviceId;

  FCDeviceResult({
    required super.result,
    super.resultText,
    this.deviceId,
  });
}
