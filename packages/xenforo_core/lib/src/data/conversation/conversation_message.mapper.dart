// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'conversation_message.dart';

class XenForoConversationMessageMapper
    extends ClassMapperBase<XenForoConversationMessage> {
  XenForoConversationMessageMapper._();

  static XenForoConversationMessageMapper? _instance;
  static XenForoConversationMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = XenForoConversationMessageMapper._());
      XenForoConversationMapper.ensureInitialized();
      XenForoAttachmentMapper.ensureInitialized();
      XenForoUserMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'XenForoConversationMessage';

  static String? _$username(XenForoConversationMessage v) => v.username;
  static const Field<XenForoConversationMessage, String> _f$username =
      Field('username', _$username, opt: true);
  static bool? _$isUnread(XenForoConversationMessage v) => v.isUnread;
  static const Field<XenForoConversationMessage, bool> _f$isUnread =
      Field('isUnread', _$isUnread, opt: true);
  static String? _$messageParsed(XenForoConversationMessage v) =>
      v.messageParsed;
  static const Field<XenForoConversationMessage, String> _f$messageParsed =
      Field('messageParsed', _$messageParsed, opt: true);
  static bool? _$canEdit(XenForoConversationMessage v) => v.canEdit;
  static const Field<XenForoConversationMessage, bool> _f$canEdit =
      Field('canEdit', _$canEdit, opt: true);
  static bool? _$canReact(XenForoConversationMessage v) => v.canReact;
  static const Field<XenForoConversationMessage, bool> _f$canReact =
      Field('canReact', _$canReact, opt: true);
  static String? _$viewUrl(XenForoConversationMessage v) => v.viewUrl;
  static const Field<XenForoConversationMessage, String> _f$viewUrl =
      Field('viewUrl', _$viewUrl, opt: true);
  static XenForoConversation? _$conversation(XenForoConversationMessage v) =>
      v.conversation;
  static const Field<XenForoConversationMessage, XenForoConversation>
      _f$conversation = Field('conversation', _$conversation, opt: true);
  static List<XenForoAttachment>? _$attachments(XenForoConversationMessage v) =>
      v.attachments;
  static const Field<XenForoConversationMessage, List<XenForoAttachment>>
      _f$attachments = Field('attachments', _$attachments, opt: true);
  static bool? _$isReactedTo(XenForoConversationMessage v) => v.isReactedTo;
  static const Field<XenForoConversationMessage, bool> _f$isReactedTo =
      Field('isReactedTo', _$isReactedTo, opt: true);
  static int? _$visitorReactionId(XenForoConversationMessage v) =>
      v.visitorReactionId;
  static const Field<XenForoConversationMessage, int> _f$visitorReactionId =
      Field('visitorReactionId', _$visitorReactionId, opt: true);
  static int _$messageId(XenForoConversationMessage v) => v.messageId;
  static const Field<XenForoConversationMessage, int> _f$messageId =
      Field('messageId', _$messageId);
  static int? _$conversationId(XenForoConversationMessage v) =>
      v.conversationId;
  static const Field<XenForoConversationMessage, int> _f$conversationId =
      Field('conversationId', _$conversationId, opt: true);
  static int? _$messageDate(XenForoConversationMessage v) => v.messageDate;
  static const Field<XenForoConversationMessage, int> _f$messageDate =
      Field('messageDate', _$messageDate, opt: true);
  static int? _$userId(XenForoConversationMessage v) => v.userId;
  static const Field<XenForoConversationMessage, int> _f$userId =
      Field('userId', _$userId, opt: true);
  static String? _$message(XenForoConversationMessage v) => v.message;
  static const Field<XenForoConversationMessage, String> _f$message =
      Field('message', _$message, opt: true);
  static int? _$attachCount(XenForoConversationMessage v) => v.attachCount;
  static const Field<XenForoConversationMessage, int> _f$attachCount =
      Field('attachCount', _$attachCount, opt: true);
  static int? _$reactionScore(XenForoConversationMessage v) => v.reactionScore;
  static const Field<XenForoConversationMessage, int> _f$reactionScore =
      Field('reactionScore', _$reactionScore, opt: true);
  static XenForoUser? _$user(XenForoConversationMessage v) => v.user;
  static const Field<XenForoConversationMessage, XenForoUser> _f$user =
      Field('user', _$user, opt: true);

  @override
  final MappableFields<XenForoConversationMessage> fields = const {
    #username: _f$username,
    #isUnread: _f$isUnread,
    #messageParsed: _f$messageParsed,
    #canEdit: _f$canEdit,
    #canReact: _f$canReact,
    #viewUrl: _f$viewUrl,
    #conversation: _f$conversation,
    #attachments: _f$attachments,
    #isReactedTo: _f$isReactedTo,
    #visitorReactionId: _f$visitorReactionId,
    #messageId: _f$messageId,
    #conversationId: _f$conversationId,
    #messageDate: _f$messageDate,
    #userId: _f$userId,
    #message: _f$message,
    #attachCount: _f$attachCount,
    #reactionScore: _f$reactionScore,
    #user: _f$user,
  };

  static XenForoConversationMessage _instantiate(DecodingData data) {
    return XenForoConversationMessage(
        username: data.dec(_f$username),
        isUnread: data.dec(_f$isUnread),
        messageParsed: data.dec(_f$messageParsed),
        canEdit: data.dec(_f$canEdit),
        canReact: data.dec(_f$canReact),
        viewUrl: data.dec(_f$viewUrl),
        conversation: data.dec(_f$conversation),
        attachments: data.dec(_f$attachments),
        isReactedTo: data.dec(_f$isReactedTo),
        visitorReactionId: data.dec(_f$visitorReactionId),
        messageId: data.dec(_f$messageId),
        conversationId: data.dec(_f$conversationId),
        messageDate: data.dec(_f$messageDate),
        userId: data.dec(_f$userId),
        message: data.dec(_f$message),
        attachCount: data.dec(_f$attachCount),
        reactionScore: data.dec(_f$reactionScore),
        user: data.dec(_f$user));
  }

  @override
  final Function instantiate = _instantiate;

  static XenForoConversationMessage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<XenForoConversationMessage>(map);
  }

  static XenForoConversationMessage fromJson(String json) {
    return ensureInitialized().decodeJson<XenForoConversationMessage>(json);
  }
}

mixin XenForoConversationMessageMappable {
  String toJson() {
    return XenForoConversationMessageMapper.ensureInitialized()
        .encodeJson<XenForoConversationMessage>(
            this as XenForoConversationMessage);
  }

  Map<String, dynamic> toMap() {
    return XenForoConversationMessageMapper.ensureInitialized()
        .encodeMap<XenForoConversationMessage>(
            this as XenForoConversationMessage);
  }

  XenForoConversationMessageCopyWith<XenForoConversationMessage,
          XenForoConversationMessage, XenForoConversationMessage>
      get copyWith => _XenForoConversationMessageCopyWithImpl<
              XenForoConversationMessage, XenForoConversationMessage>(
          this as XenForoConversationMessage, $identity, $identity);
  @override
  String toString() {
    return XenForoConversationMessageMapper.ensureInitialized()
        .stringifyValue(this as XenForoConversationMessage);
  }

  @override
  bool operator ==(Object other) {
    return XenForoConversationMessageMapper.ensureInitialized()
        .equalsValue(this as XenForoConversationMessage, other);
  }

  @override
  int get hashCode {
    return XenForoConversationMessageMapper.ensureInitialized()
        .hashValue(this as XenForoConversationMessage);
  }
}

extension XenForoConversationMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, XenForoConversationMessage, $Out> {
  XenForoConversationMessageCopyWith<$R, XenForoConversationMessage, $Out>
      get $asXenForoConversationMessage => $base.as((v, t, t2) =>
          _XenForoConversationMessageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class XenForoConversationMessageCopyWith<
    $R,
    $In extends XenForoConversationMessage,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  XenForoConversationCopyWith<$R, XenForoConversation, XenForoConversation>?
      get conversation;
  ListCopyWith<$R, XenForoAttachment,
          XenForoAttachmentCopyWith<$R, XenForoAttachment, XenForoAttachment>>?
      get attachments;
  XenForoUserCopyWith<$R, XenForoUser, XenForoUser>? get user;
  $R call(
      {String? username,
      bool? isUnread,
      String? messageParsed,
      bool? canEdit,
      bool? canReact,
      String? viewUrl,
      XenForoConversation? conversation,
      List<XenForoAttachment>? attachments,
      bool? isReactedTo,
      int? visitorReactionId,
      int? messageId,
      int? conversationId,
      int? messageDate,
      int? userId,
      String? message,
      int? attachCount,
      int? reactionScore,
      XenForoUser? user});
  XenForoConversationMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _XenForoConversationMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, XenForoConversationMessage, $Out>
    implements
        XenForoConversationMessageCopyWith<$R, XenForoConversationMessage,
            $Out> {
  _XenForoConversationMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<XenForoConversationMessage> $mapper =
      XenForoConversationMessageMapper.ensureInitialized();
  @override
  XenForoConversationCopyWith<$R, XenForoConversation, XenForoConversation>?
      get conversation =>
          $value.conversation?.copyWith.$chain((v) => call(conversation: v));
  @override
  ListCopyWith<$R, XenForoAttachment,
          XenForoAttachmentCopyWith<$R, XenForoAttachment, XenForoAttachment>>?
      get attachments => $value.attachments != null
          ? ListCopyWith($value.attachments!, (v, t) => v.copyWith.$chain(t),
              (v) => call(attachments: v))
          : null;
  @override
  XenForoUserCopyWith<$R, XenForoUser, XenForoUser>? get user =>
      $value.user?.copyWith.$chain((v) => call(user: v));
  @override
  $R call(
          {Object? username = $none,
          Object? isUnread = $none,
          Object? messageParsed = $none,
          Object? canEdit = $none,
          Object? canReact = $none,
          Object? viewUrl = $none,
          Object? conversation = $none,
          Object? attachments = $none,
          Object? isReactedTo = $none,
          Object? visitorReactionId = $none,
          int? messageId,
          Object? conversationId = $none,
          Object? messageDate = $none,
          Object? userId = $none,
          Object? message = $none,
          Object? attachCount = $none,
          Object? reactionScore = $none,
          Object? user = $none}) =>
      $apply(FieldCopyWithData({
        if (username != $none) #username: username,
        if (isUnread != $none) #isUnread: isUnread,
        if (messageParsed != $none) #messageParsed: messageParsed,
        if (canEdit != $none) #canEdit: canEdit,
        if (canReact != $none) #canReact: canReact,
        if (viewUrl != $none) #viewUrl: viewUrl,
        if (conversation != $none) #conversation: conversation,
        if (attachments != $none) #attachments: attachments,
        if (isReactedTo != $none) #isReactedTo: isReactedTo,
        if (visitorReactionId != $none) #visitorReactionId: visitorReactionId,
        if (messageId != null) #messageId: messageId,
        if (conversationId != $none) #conversationId: conversationId,
        if (messageDate != $none) #messageDate: messageDate,
        if (userId != $none) #userId: userId,
        if (message != $none) #message: message,
        if (attachCount != $none) #attachCount: attachCount,
        if (reactionScore != $none) #reactionScore: reactionScore,
        if (user != $none) #user: user
      }));
  @override
  XenForoConversationMessage $make(
          CopyWithData data) =>
      XenForoConversationMessage(
          username: data.get(#username, or: $value.username),
          isUnread: data.get(#isUnread, or: $value.isUnread),
          messageParsed: data.get(#messageParsed, or: $value.messageParsed),
          canEdit: data.get(#canEdit, or: $value.canEdit),
          canReact: data.get(#canReact, or: $value.canReact),
          viewUrl: data.get(#viewUrl, or: $value.viewUrl),
          conversation: data.get(#conversation, or: $value.conversation),
          attachments: data.get(#attachments, or: $value.attachments),
          isReactedTo: data.get(#isReactedTo, or: $value.isReactedTo),
          visitorReactionId:
              data.get(#visitorReactionId, or: $value.visitorReactionId),
          messageId: data.get(#messageId, or: $value.messageId),
          conversationId: data.get(#conversationId, or: $value.conversationId),
          messageDate: data.get(#messageDate, or: $value.messageDate),
          userId: data.get(#userId, or: $value.userId),
          message: data.get(#message, or: $value.message),
          attachCount: data.get(#attachCount, or: $value.attachCount),
          reactionScore: data.get(#reactionScore, or: $value.reactionScore),
          user: data.get(#user, or: $value.user));

  @override
  XenForoConversationMessageCopyWith<$R2, XenForoConversationMessage, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _XenForoConversationMessageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
