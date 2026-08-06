// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'alert.dart';

class XenForoAlertMapper extends ClassMapperBase<XenForoAlert> {
  XenForoAlertMapper._();

  static XenForoAlertMapper? _instance;
  static XenForoAlertMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = XenForoAlertMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'XenForoAlert';

  static String _$id(XenForoAlert v) => v.id;
  static const Field<XenForoAlert, String> _f$id = Field('id', _$id);
  static String _$alertType(XenForoAlert v) => v.alertType;
  static const Field<XenForoAlert, String> _f$alertType = Field(
    'alertType',
    _$alertType,
  );
  static String _$contentType(XenForoAlert v) => v.contentType;
  static const Field<XenForoAlert, String> _f$contentType = Field(
    'contentType',
    _$contentType,
  );
  static String _$contentId(XenForoAlert v) => v.contentId;
  static const Field<XenForoAlert, String> _f$contentId = Field(
    'contentId',
    _$contentId,
  );
  static String _$userId(XenForoAlert v) => v.userId;
  static const Field<XenForoAlert, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static String _$userName(XenForoAlert v) => v.userName;
  static const Field<XenForoAlert, String> _f$userName = Field(
    'userName',
    _$userName,
  );
  static String _$action(XenForoAlert v) => v.action;
  static const Field<XenForoAlert, String> _f$action = Field(
    'action',
    _$action,
  );
  static String _$message(XenForoAlert v) => v.message;
  static const Field<XenForoAlert, String> _f$message = Field(
    'message',
    _$message,
  );
  static DateTime _$alertDate(XenForoAlert v) => v.alertDate;
  static const Field<XenForoAlert, DateTime> _f$alertDate = Field(
    'alertDate',
    _$alertDate,
  );
  static bool _$isRead(XenForoAlert v) => v.isRead;
  static const Field<XenForoAlert, bool> _f$isRead = Field('isRead', _$isRead);
  static bool _$isDismissed(XenForoAlert v) => v.isDismissed;
  static const Field<XenForoAlert, bool> _f$isDismissed = Field(
    'isDismissed',
    _$isDismissed,
  );
  static Map<String, dynamic> _$extraData(XenForoAlert v) => v.extraData;
  static const Field<XenForoAlert, Map<String, dynamic>> _f$extraData = Field(
    'extraData',
    _$extraData,
  );

  @override
  final MappableFields<XenForoAlert> fields = const {
    #id: _f$id,
    #alertType: _f$alertType,
    #contentType: _f$contentType,
    #contentId: _f$contentId,
    #userId: _f$userId,
    #userName: _f$userName,
    #action: _f$action,
    #message: _f$message,
    #alertDate: _f$alertDate,
    #isRead: _f$isRead,
    #isDismissed: _f$isDismissed,
    #extraData: _f$extraData,
  };

  static XenForoAlert _instantiate(DecodingData data) {
    return XenForoAlert(
      id: data.dec(_f$id),
      alertType: data.dec(_f$alertType),
      contentType: data.dec(_f$contentType),
      contentId: data.dec(_f$contentId),
      userId: data.dec(_f$userId),
      userName: data.dec(_f$userName),
      action: data.dec(_f$action),
      message: data.dec(_f$message),
      alertDate: data.dec(_f$alertDate),
      isRead: data.dec(_f$isRead),
      isDismissed: data.dec(_f$isDismissed),
      extraData: data.dec(_f$extraData),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static XenForoAlert fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<XenForoAlert>(map);
  }

  static XenForoAlert fromJson(String json) {
    return ensureInitialized().decodeJson<XenForoAlert>(json);
  }
}

mixin XenForoAlertMappable {
  String toJson() {
    return XenForoAlertMapper.ensureInitialized().encodeJson<XenForoAlert>(
      this as XenForoAlert,
    );
  }

  Map<String, dynamic> toMap() {
    return XenForoAlertMapper.ensureInitialized().encodeMap<XenForoAlert>(
      this as XenForoAlert,
    );
  }

  XenForoAlertCopyWith<XenForoAlert, XenForoAlert, XenForoAlert> get copyWith =>
      _XenForoAlertCopyWithImpl<XenForoAlert, XenForoAlert>(
        this as XenForoAlert,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return XenForoAlertMapper.ensureInitialized().stringifyValue(
      this as XenForoAlert,
    );
  }

  @override
  bool operator ==(Object other) {
    return XenForoAlertMapper.ensureInitialized().equalsValue(
      this as XenForoAlert,
      other,
    );
  }

  @override
  int get hashCode {
    return XenForoAlertMapper.ensureInitialized().hashValue(
      this as XenForoAlert,
    );
  }
}

extension XenForoAlertValueCopy<$R, $Out>
    on ObjectCopyWith<$R, XenForoAlert, $Out> {
  XenForoAlertCopyWith<$R, XenForoAlert, $Out> get $asXenForoAlert =>
      $base.as((v, t, t2) => _XenForoAlertCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class XenForoAlertCopyWith<$R, $In extends XenForoAlert, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get extraData;
  $R call({
    String? id,
    String? alertType,
    String? contentType,
    String? contentId,
    String? userId,
    String? userName,
    String? action,
    String? message,
    DateTime? alertDate,
    bool? isRead,
    bool? isDismissed,
    Map<String, dynamic>? extraData,
  });
  XenForoAlertCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _XenForoAlertCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, XenForoAlert, $Out>
    implements XenForoAlertCopyWith<$R, XenForoAlert, $Out> {
  _XenForoAlertCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<XenForoAlert> $mapper =
      XenForoAlertMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get extraData => MapCopyWith(
    $value.extraData,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(extraData: v),
  );
  @override
  $R call({
    String? id,
    String? alertType,
    String? contentType,
    String? contentId,
    String? userId,
    String? userName,
    String? action,
    String? message,
    DateTime? alertDate,
    bool? isRead,
    bool? isDismissed,
    Map<String, dynamic>? extraData,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (alertType != null) #alertType: alertType,
      if (contentType != null) #contentType: contentType,
      if (contentId != null) #contentId: contentId,
      if (userId != null) #userId: userId,
      if (userName != null) #userName: userName,
      if (action != null) #action: action,
      if (message != null) #message: message,
      if (alertDate != null) #alertDate: alertDate,
      if (isRead != null) #isRead: isRead,
      if (isDismissed != null) #isDismissed: isDismissed,
      if (extraData != null) #extraData: extraData,
    }),
  );
  @override
  XenForoAlert $make(CopyWithData data) => XenForoAlert(
    id: data.get(#id, or: $value.id),
    alertType: data.get(#alertType, or: $value.alertType),
    contentType: data.get(#contentType, or: $value.contentType),
    contentId: data.get(#contentId, or: $value.contentId),
    userId: data.get(#userId, or: $value.userId),
    userName: data.get(#userName, or: $value.userName),
    action: data.get(#action, or: $value.action),
    message: data.get(#message, or: $value.message),
    alertDate: data.get(#alertDate, or: $value.alertDate),
    isRead: data.get(#isRead, or: $value.isRead),
    isDismissed: data.get(#isDismissed, or: $value.isDismissed),
    extraData: data.get(#extraData, or: $value.extraData),
  );

  @override
  XenForoAlertCopyWith<$R2, XenForoAlert, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _XenForoAlertCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

