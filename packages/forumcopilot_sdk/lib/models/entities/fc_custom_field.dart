import 'package:dart_mappable/dart_mappable.dart';

part 'fc_custom_field.mapper.dart';

@MappableClass()
class FCCustomField with FCCustomFieldMappable {
  /// Field name
  @MappableField()
  String name;

  /// Field value
  @MappableField()
  String value;

  FCCustomField({
    required this.name,
    required this.value,
  });
}
