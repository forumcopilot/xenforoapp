import 'package:dart_mappable/dart_mappable.dart';

/// Parses milliseconds-since-epoch (int or string) or ISO-8601 string into DateTime
class MillisOrIsoDateHook extends MappingHook {
  const MillisOrIsoDateHook();

  @override
  Object? beforeDecode(Object? value) {
    if (value == null) return null;
    // Accept int millis, numeric string millis, or ISO-8601 string
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    final s = value.toString();
    final millis = int.tryParse(s);
    if (millis != null) {
      return DateTime.fromMillisecondsSinceEpoch(millis);
    }
    return DateTime.tryParse(s);
  }

  @override
  Object? beforeEncode(Object? value) {
    if (value is DateTime) {
      return value.millisecondsSinceEpoch;
    }
    return value;
  }
}

/// Coerces 0/1/"0"/"1"/true/false into bool
class FlexibleBoolHook extends MappingHook {
  const FlexibleBoolHook();

  @override
  Object? beforeDecode(Object? value) {
    if (value == null) return false;
    if (value is bool) return value;
    final s = value.toString().toLowerCase().trim();
    if (s == '1' || s == 'true') return true;
    if (s == '0' || s == 'false') return false;
    return false;
  }
}

/// Coerces numeric strings/ints into int
class FlexibleIntHook extends MappingHook {
  const FlexibleIntHook();

  @override
  Object? beforeDecode(Object? value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
