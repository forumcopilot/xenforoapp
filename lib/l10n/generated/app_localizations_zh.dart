// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Forum App';

  @override
  String get loginTitle => '登录';

  @override
  String get usernameLabel => '用户名';

  @override
  String get passwordLabel => '密码';

  @override
  String get loginButton => '登录';

  @override
  String get signInWithPasskey => 'Sign in with Passkey';

  @override
  String get usePasskey => 'Use Passkey';

  @override
  String get passkeyContinuePrompt => 'Use your passkey to continue';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get pleaseEnterUsername => '请输入您的用户名';

  @override
  String get pleaseEnterPassword => '请输入您的密码';

  @override
  String credentialsSentToDomain(String domain) {
    return '您的用户名和密码将发送到 $domain';
  }

  @override
  String get createAccount => '创建账户';

  @override
  String get alreadyHaveAccount => '已有账户？ ';

  @override
  String get logIn => '登录';

  @override
  String get continueButton => '继续';

  @override
  String get registrationNotAvailable => '注册不可用';

  @override
  String get registrationNotAvailableMessage => '目前无法注册。论坛可能已关闭或注册可能已禁用。';

  @override
  String get webRegistrationRequired => '需要网页注册';

  @override
  String get webRegistrationRequiredMessage => '此论坛需要通过网页浏览器注册。请点击下面的按钮打开注册页面。';

  @override
  String get openRegistrationPage => '打开注册页面';

  @override
  String get loadingAdditionalFields => '正在加载其他字段...';

  @override
  String get pleaseSelectDateOfBirth => '请选择您的出生日期';

  @override
  String get pleaseEnterLocation => '请输入您的位置';

  @override
  String get pleaseIndicateEmailPreference => '请指明您的电子邮件偏好';

  @override
  String get pleaseFillAllRequiredFields => '请填写所有必填字段';

  @override
  String get pleaseAcceptTermsOfService => '请接受服务条款';

  @override
  String get pleaseAcceptPrivacyPolicy => '请接受隐私政策';

  @override
  String get registrationError => '注册错误';

  @override
  String get registrationFailed => '注册失败。请检查您的信息。';

  @override
  String get registrationFailedTryAgain => '注册失败。请重试。';

  @override
  String get registrationInfo => '注册信息';

  @override
  String get openWebsite => '打开网站';

  @override
  String couldNotOpenForumWebsite(String url) {
    return '无法打开论坛网站。请尝试访问: $url';
  }

  @override
  String get registrationSuccessfulEmailConfirm => '注册成功！请在登录前检查您的电子邮件以确认您的账户。';

  @override
  String get registrationSuccessfulPendingApproval =>
      '注册成功！您的账户正在等待批准。您的账户获得批准后，您将收到通知。';

  @override
  String get registrationSuccessfulAutoLogin => '注册成功！您已自动登录。';

  @override
  String get welcome => '欢迎！';

  @override
  String get registrationSuccessful => '注册成功';

  @override
  String get pleaseLoginWithNewAccount => '请使用您的新账户登录。';

  @override
  String get forgotPasswordTitle => '忘记密码';

  @override
  String get usernameOrEmailLabel => '用户名或电子邮件';

  @override
  String get pleaseEnterUsernameOrEmail => '请输入您的用户名或电子邮件';

  @override
  String get sendResetLink => '发送重置链接';

  @override
  String get resetLinkSent => '重置链接已发送';

  @override
  String get passwordResetInstructionsSent => '密码重置说明已发送到您注册的电子邮件地址。';

  @override
  String get resetFailed => '重置失败';

  @override
  String get unableToSendResetLink => '无法发送重置链接。请重试。';

  @override
  String get errorSendingResetLink => '发送重置链接时发生错误。请检查您的连接并重试。';

  @override
  String get errorTitle => '错误';

  @override
  String get okButton => '确定';

  @override
  String get retryButton => '重试';

  @override
  String get copyToClipboard => '复制到剪贴板';

  @override
  String get copied => '已复制';

  @override
  String get errorMessageCopiedToClipboard => '错误消息已复制到剪贴板';

  @override
  String get cancel => '取消';

  @override
  String get getHelp => '获取帮助';

  @override
  String get somethingWentWrong => '出现问题';

  @override
  String get unexpectedErrorOccurred => '发生意外错误。请重试。';

  @override
  String get noInternetConnection => '无互联网连接';

  @override
  String get checkInternetConnection => '请检查您的互联网连接并重试。';

  @override
  String get authenticationRequired => '需要身份验证';

  @override
  String get pleaseLoginToContinue => '请登录以继续。';

  @override
  String get forumError => '论坛错误';

  @override
  String get anErrorOccurred => '发生错误';

  @override
  String get accountPendingApproval => '您的账户正在等待批准。您可以浏览论坛，但在版主批准您的账户之前无法发帖。';

  @override
  String get checkEmailToConfirm => '请检查您的电子邮件以确认您的账户。点击我们发送给您的电子邮件中的确认链接。';

  @override
  String get checkNewEmailToConfirm =>
      '请检查您的新电子邮件地址以确认更改。在您确认新电子邮件之前，旧电子邮件将保持活动状态。';

  @override
  String get emailAddressInvalid => '您的电子邮件地址似乎无效或正在退回邮件。请在账户设置中更新您的电子邮件地址。';

  @override
  String get accountDisabled => '您的账户已被禁用。请联系管理员寻求帮助。';

  @override
  String get accountRegistrationRejected => '您的账户注册已被拒绝。请联系管理员了解更多信息。';

  @override
  String get welcomeToForumCopilot => '欢迎使用 Forum Copilot！';

  @override
  String get successfullyLoggedOut => '您已成功退出登录';

  @override
  String get accountStatusRequiresAttention => '您的账户状态需要注意。如有疑问，请联系管理员。';

  @override
  String get updateEmail => '更新电子邮件';

  @override
  String get resend => '重新发送';

  @override
  String get noLatestTopics => '无最新主题';

  @override
  String get noRecentTopicsToDisplay => '没有要显示的最新主题。稍后再来查看新讨论。';

  @override
  String get noUnreadTopics => '无未读主题';

  @override
  String get thereAreNoUnreadTopics => '没有未读主题。稍后再来查看新讨论。';

  @override
  String get youAreAllCaughtUp => '您已全部查看完毕！';

  @override
  String get noSubscribedTopics => '没有关注的主题';

  @override
  String get noSubscribedTopicsMessage =>
      '你还没有关注任何主题。打开一个主题，在其 ⋮ 菜单中选择“关注”，即可收到新回复的通知。';

  @override
  String get noParticipatedTopics => '无参与主题';

  @override
  String get topicsYouParticipatedIn => '您参与的主题将显示在这里。';

  @override
  String get latest => '最新';

  @override
  String get unread => '未读';

  @override
  String get subscribed => '已关注';

  @override
  String get participated => '已参与';

  @override
  String get connectionTimedOut => '连接超时。网站可能已关闭或无法访问。';

  @override
  String get failedToConnectToSite => '无法连接到网站。网站可能已关闭或无法访问。';

  @override
  String get connectionFailed => '连接失败';

  @override
  String failedToConnectToSiteName(String siteName) {
    return '无法连接到 $siteName';
  }

  @override
  String get loading => '加载中...';

  @override
  String get newConversation => '新对话';

  @override
  String get newMessage => '新消息';

  @override
  String get appSettings => '应用设置';

  @override
  String get searchSites => '搜索网站';

  @override
  String get all => '全部';

  @override
  String get topicsOnly => '仅主题';

  @override
  String get titlesOnly => '仅标题';

  @override
  String failedToShareTopic(String error) {
    return '分享主题失败: $error';
  }

  @override
  String get subscribe => '关注';

  @override
  String get unsubscribe => '取消关注';

  @override
  String get youCannotReplyToThisThread => '您无法回复此主题';

  @override
  String get pleaseWaitForThreadToLoad => '请等待主题加载';

  @override
  String get postCanBeRestoredLater => '帖子稍后可以恢复';

  @override
  String get postWillBePermanentlyDeleted => '帖子将被永久删除';

  @override
  String get enterReasonForDeletingPost => '输入删除此帖子的原因';

  @override
  String get reportPost => '举报帖子';

  @override
  String get pleaseProvideReasonForReporting => '请提供举报此帖子的原因。';

  @override
  String get reason => '原因';

  @override
  String get enterReasonForReportingPost => '输入举报此帖子的原因';

  @override
  String get pleaseEnterReason => '请输入原因';

  @override
  String get selectedActions => '选定的操作:';

  @override
  String get thisActionCannotBeUndone => '此操作无法撤销。';

  @override
  String get participantsLabel => '参与者';

  @override
  String usernameHasBeenInvited(String username) {
    return '$username 已被邀请加入对话';
  }

  @override
  String errorInvitingUser(String error) {
    return '邀请用户时出错: $error';
  }

  @override
  String get newTopic => '新主题';

  @override
  String get markRead => '标记为已读';

  @override
  String get pleaseSelectReasonForReportingUser => '请选择举报此用户的原因。';

  @override
  String get spamOrAdvertising => '垃圾邮件或广告';

  @override
  String get harassmentOrBullying => '骚扰或欺凌';

  @override
  String get inappropriateContent => '不当内容';

  @override
  String get impersonationOrFakeAccount => '冒充或虚假账户';

  @override
  String get otherPleaseSpecify => '其他（请说明）';

  @override
  String get pleaseSpecifyReason => '请说明原因';

  @override
  String get enterReasonForReportingUser => '输入举报此用户的原因';

  @override
  String get pleaseSelectReason => '请选择原因';

  @override
  String pleaseSelectReasonForBanningUser(String username) {
    return '请选择封禁 $username 的原因';
  }

  @override
  String get violationOfCommunityGuidelines => '违反社区准则';

  @override
  String get harassmentOrAbusiveBehavior => '骚扰或虐待行为';

  @override
  String get postingInappropriateContent => '发布不当内容';

  @override
  String get accountCompromiseOrSecurityIssue => '账户泄露或安全问题';

  @override
  String get enterReasonForBanningUser => '输入封禁此用户的原因';

  @override
  String get banUntil => '封禁至';

  @override
  String get selectDate => '选择日期';

  @override
  String get unbanUser => '解除封禁';

  @override
  String get leaveConversation => '离开对话';

  @override
  String get reportConversation => '举报对话';

  @override
  String get topicClosed => '主题已关闭';

  @override
  String get topicOpened => '主题已打开';

  @override
  String get topicStickied => '主题已置顶';

  @override
  String get topicUnstickied => '主题已取消置顶';

  @override
  String cannotEditMessage(String error) {
    return '无法编辑此消息: $error';
  }

  @override
  String get confirmSpamClean => '确认清理垃圾邮件';

  @override
  String get myForums => '我的论坛';

  @override
  String get recentlyVisited => '最近访问';

  @override
  String get explore => '探索';

  @override
  String get forumCopilot => 'Forum Copilot';

  @override
  String get noConversations => '无对话';

  @override
  String get noConversationsMessage => '您还没有对话。开始新对话以开始发送消息。';

  @override
  String get imageSavedToGallery => '图片已保存到相册！';

  @override
  String failedToSaveImage(String error) {
    return '保存图片失败: $error';
  }

  @override
  String get userProfile => '用户资料';

  @override
  String get deletePost => '删除帖子';

  @override
  String get loginRequired => '需要登录';

  @override
  String get tryAgain => '重试';

  @override
  String get memberSince => '注册日期';

  @override
  String get lastActivity => '最后活动';

  @override
  String get likesReceived => '收到的赞';

  @override
  String get likesGiven => '给出的赞';

  @override
  String get failedToSaveMessage => '保存消息失败';

  @override
  String get failedToSaveSetting => '保存设置失败';

  @override
  String get failedToSavePost => '保存帖子失败';

  @override
  String errorLoadingSites(String error) {
    return '加载网站错误: $error';
  }

  @override
  String connectingTo(String domainName) {
    return '正在连接到 $domainName...';
  }

  @override
  String get members => '成员';

  @override
  String get allMembers => '所有成员';

  @override
  String get online => '在线';

  @override
  String get noMembersFound => '未找到成员';

  @override
  String get searchForMembers => '搜索成员';

  @override
  String get enterUsernameToFindMembers => '输入用户名以查找论坛成员';

  @override
  String get noMembersOnline => '当前没有成员在线';

  @override
  String get lookupMembers => '查找成员';

  @override
  String get addMembers => '添加成员';

  @override
  String get membersAddedSuccessfully => '成员已成功添加';

  @override
  String errorAddingMembers(String error) {
    return '添加成员时出错: $error';
  }

  @override
  String get failedToLoadOnlineUsers => '加载在线用户失败';

  @override
  String get noUsersOnline => '没有用户在线';

  @override
  String membersCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString 成员';
  }

  @override
  String get noSubject => '无主题';

  @override
  String get search => '搜索';

  @override
  String get moreOptions => '更多选项';

  @override
  String get logout => '退出登录';

  @override
  String get areYouSureYouWantToLogout => '您确定要退出登录吗？';

  @override
  String get register => '注册';

  @override
  String get signIn => '登录';

  @override
  String get markForumRead => '标记论坛为已读';

  @override
  String get notificationTest => '通知测试';

  @override
  String get forum => '论坛';

  @override
  String get profile => '资料';

  @override
  String get messages => '消息';

  @override
  String get add => '添加';

  @override
  String get dismiss => '关闭';

  @override
  String get retry => '重试';

  @override
  String get delete => '删除';

  @override
  String get deleteMessage => '删除消息';

  @override
  String get areYouSureYouWantToDeleteThisMessage => '您确定要删除此消息吗？';

  @override
  String failedToDeleteMessage(String error) {
    return '删除消息失败: $error';
  }

  @override
  String get deletingPost => '正在删除帖子...';

  @override
  String failedToUnlikePost(String error) {
    return '取消点赞帖子失败: $error';
  }

  @override
  String failedToLikePost(String error) {
    return '点赞帖子失败: $error';
  }

  @override
  String get youNeedToBeSignedInToViewConversations => '您需要登录才能查看您的对话。';

  @override
  String errorLoadingConversations(String error) {
    return '加载对话错误: $error';
  }

  @override
  String failedToLeaveConversation(String error) {
    return '离开对话失败: $error';
  }

  @override
  String errorLoadingMoreConversations(String error) {
    return '加载更多对话错误: $error';
  }

  @override
  String errorLoadingMoreMessages(String error) {
    return '加载更多消息时出错: $error';
  }

  @override
  String get inviteMessageOptional => '邀请消息（可选）';

  @override
  String get iWouldLikeToAddYouToThisConversation => '我想将您添加到此对话中。';

  @override
  String get searchFailed => '搜索失败';

  @override
  String get trySearchingWithDifferentUsername => '尝试使用不同的用户名搜索';

  @override
  String get enterUsernameToSearch => '输入用户名以搜索...';

  @override
  String get noSitesFound => '未找到网站。';

  @override
  String get userInformationNotAvailable => '用户信息不可用';

  @override
  String get birthday => '生日';

  @override
  String get posts => '帖子';

  @override
  String get following => '关注中';

  @override
  String get followers => '粉丝';

  @override
  String get about => '关于';

  @override
  String get location => '位置';

  @override
  String get website => '网站';

  @override
  String get signature => '签名';

  @override
  String get next => '下一步';

  @override
  String get permanent => '永久';

  @override
  String get temporary => '临时';

  @override
  String setBanDurationFor(String username) {
    return '设置 $username 的封禁期限';
  }

  @override
  String get pleaseSelectEndDateForTemporaryBan => '请选择临时封禁的结束日期';

  @override
  String get back => '返回';

  @override
  String get unban => '解除封禁';

  @override
  String get confirm => '确认';

  @override
  String spamClean(String username) {
    return '清理 $username 的垃圾邮件';
  }

  @override
  String get selectActionsToPerform => '选择要执行的操作:';

  @override
  String get handleThreads => '处理主题';

  @override
  String get moveOrDeleteThreadsBasedOnAdminSettings => '根据管理员设置移动或删除主题';

  @override
  String get deleteMessages => '删除消息';

  @override
  String get deleteConversations => '删除对话';

  @override
  String get messageUpdatedSuccessfully => '消息更新成功';

  @override
  String error(String error) {
    return '错误: $error';
  }

  @override
  String failedToRemoveAttachment(String error) {
    return '删除附件失败: $error';
  }

  @override
  String failedToLoadMessage(String error) {
    return '加载消息失败: $error';
  }

  @override
  String get editMessage => '编辑消息';

  @override
  String get removeAttachment => '删除附件';

  @override
  String get areYouSureYouWantToRemoveThisAttachment => '您确定要删除此附件吗？';

  @override
  String get none => '无';

  @override
  String get formatting => '格式';

  @override
  String get bold => '粗体';

  @override
  String get italic => '斜体';

  @override
  String get underline => '下划线';

  @override
  String get strikethrough => '删除线';

  @override
  String get link => '链接';

  @override
  String get image => '图片';

  @override
  String get video => '视频';

  @override
  String get quote => '引用';

  @override
  String get code => '代码';

  @override
  String get spoiler => '剧透';

  @override
  String get bulletList => '项目符号列表';

  @override
  String get numberedList => '编号列表';

  @override
  String get listItem => '列表项';

  @override
  String participants(int count) {
    return '参与者 ($count)';
  }

  @override
  String get enterKeywordsToSearchTopics => '输入关键词以搜索主题...';

  @override
  String get pleaseFillInAllRequiredFields => '请填写所有必填字段';

  @override
  String get undelete => '恢复';

  @override
  String get signInToViewUnreadTopics => '登录以查看未读主题';

  @override
  String get youNeedToBeSignedInToViewUnreadTopics => '您需要登录才能查看未读主题';

  @override
  String get signInToViewSubscribedTopics => '登录以查看关注的主题';

  @override
  String get youNeedToBeSignedInToViewSubscribedTopics => '您需要登录才能查看关注的主题';

  @override
  String get signInToViewParticipatedTopics => '登录以查看参与的主题';

  @override
  String get youNeedToBeSignedInToViewParticipatedTopics => '您需要登录才能查看您参与的主题';

  @override
  String get signInToViewLatestTopics => '登录以查看最新主题';

  @override
  String get youNeedToBeSignedInToViewLatestTopics => '您需要登录才能查看最新主题';

  @override
  String get markAsUnread => '标记为未读';

  @override
  String get invite => '邀请';

  @override
  String get welcomeBack => '欢迎回来！';

  @override
  String get signInToAccessYourProfile => '登录以访问您的资料并管理您的账户';

  @override
  String get enterYourUsername => '输入您的用户名';

  @override
  String get enterYourPassword => '输入您的密码';

  @override
  String get dontHaveAnAccount => '没有账户？';

  @override
  String get refresh => '刷新';

  @override
  String get share => '分享';

  @override
  String get viewOnWeb => '在网页中查看';

  @override
  String get unlock => '解锁';

  @override
  String get lock => '锁定';

  @override
  String get stick => '置顶';

  @override
  String get unstick => '取消置顶';

  @override
  String get reply => '回复';

  @override
  String get vote => '投票';

  @override
  String votesCount(int count) {
    return '$count 票';
  }

  @override
  String get pollClosed => '投票已结束';

  @override
  String pollEndsOn(String date) {
    return '截止于 $date';
  }

  @override
  String get voteToSeeResults => '投票后查看结果';

  @override
  String get viewFullPoll => '查看完整投票';

  @override
  String pollOptionsCount(int count) {
    return '$count 个选项';
  }

  @override
  String get reactedBy => '已反应';

  @override
  String likesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个赞',
    );
    return '$_temp0';
  }

  @override
  String reactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个反应',
    );
    return '$_temp0';
  }

  @override
  String get showWhoReacted => '点按可查看谁做出了反应。';

  @override
  String get react => '添加反应';

  @override
  String get changeYourReaction => '更改反应';

  @override
  String get reactionsAll => '全部';

  @override
  String get reactionYou => '你';

  @override
  String reactionFilterSemantics(String reaction, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$reaction，$count 人',
    );
    return '$_temp0';
  }

  @override
  String viewProfileOfUser(String username) {
    return '查看 $username 的个人资料';
  }

  @override
  String get enterKeywordsToFindTopicsAndPosts => '输入关键词以查找主题和帖子';

  @override
  String get enterKeywordsOrDomainToFindForums => '输入关键词或域名以查找论坛';

  @override
  String get enterKeywordsOrDomainNamesToFindForums => '输入关键词或域名以查找论坛';

  @override
  String get language => '语言';

  @override
  String get systemDefault => '系统默认';

  @override
  String get followSystemLanguage => '跟随系统语言';

  @override
  String get appearance => '外观';

  @override
  String get followSystemTheme => '跟随系统主题';

  @override
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String version(String version, String buildNumber) {
    return '版本 $version ($buildNumber)';
  }

  @override
  String get forumSettings => '论坛设置';

  @override
  String get noSettingsAvailable => '没有可用设置';

  @override
  String get settingsCategoriesWillAppearHere => '设置类别在可用时将显示在此处。';

  @override
  String get spamCleaner => '垃圾清理';

  @override
  String get unableToLoadProfile => '无法加载个人资料';

  @override
  String get banned => '已封禁';

  @override
  String get sendMessage => '发送消息';

  @override
  String get showMore => '显示更多';

  @override
  String get reportUser => '举报用户';

  @override
  String get submitReport => '提交举报';

  @override
  String get reportSubmittedSuccessfully => '举报提交成功';

  @override
  String get failedToSubmitReport => '提交举报失败';

  @override
  String get searchForForums => '搜索论坛';

  @override
  String get searchForums => '搜索论坛';

  @override
  String get deleteTopic => '删除主题';

  @override
  String get softDelete => '软删除';

  @override
  String get topicCanBeRestoredLater => '主题可以稍后恢复';

  @override
  String get hardDelete => '硬删除';

  @override
  String get topicWillBePermanentlyDeleted => '主题将被永久删除';

  @override
  String get reasonForDeletion => '删除原因';

  @override
  String get enterReasonForDeletingTopic => '输入删除此主题的原因';

  @override
  String get pleaseEnterReasonForDeletion => '请输入删除原因';

  @override
  String get pleaseSelectEndDate => '请选择结束日期';

  @override
  String get banUser => '封禁用户';

  @override
  String get userBannedSuccessfully => '用户封禁成功';

  @override
  String get failedToBanUser => '封禁用户失败';

  @override
  String get userUnbannedSuccessfully => '用户解封成功';

  @override
  String get failedToUnbanUser => '解封用户失败';

  @override
  String get spamCleanUser => '清理用户垃圾信息';

  @override
  String get deletePrivateConversations => '删除私密对话';

  @override
  String get banTheUserAccount => '封禁用户账户';

  @override
  String get cleanSpam => '清理垃圾信息';

  @override
  String get handledThreads => '已处理的线程';

  @override
  String get deletedMessages => '已删除的消息';

  @override
  String get deletedConversations => '已删除的对话';

  @override
  String get bannedUser => '已封禁的用户';

  @override
  String successfullyCleanedSpam(String username, String actions) {
    return '成功清理 $username 的垃圾信息。操作: $actions';
  }

  @override
  String errorLoadingMessage(String error) {
    return '加载消息时出错: $error';
  }

  @override
  String get messageNotFound => '未找到消息';

  @override
  String get home => '首页';

  @override
  String get notifications => '通知';

  @override
  String get forums => '论坛';

  @override
  String get markAllForumsAsRead => '将所有论坛标记为已读？';

  @override
  String get markAllForumsAsReadMessage => '这将把所有论坛和主题标记为已读。此操作无法撤销。';

  @override
  String get markAsRead => '标记为已读';

  @override
  String get content => '内容';

  @override
  String get insertImage => '插入图片';

  @override
  String get howWouldYouLikeToInsertImage => '您想如何插入此图片？';

  @override
  String get thumbnail => '缩略图';

  @override
  String get fullSize => '完整尺寸';

  @override
  String get alignLeft => '左对齐';

  @override
  String get alignCenter => '居中对齐';

  @override
  String get alignRight => '右对齐';

  @override
  String get pleaseEnterTitle => '请输入标题';

  @override
  String get pleaseEnterContent => '请输入内容';

  @override
  String get uploading => '上传中...';

  @override
  String get uploaded => '已上传';

  @override
  String get mentionUser => '提及用户';

  @override
  String get loggingIn => '登录中...';

  @override
  String get submittingReport => '提交报告中...';

  @override
  String get banningUser => '封禁用户中...';

  @override
  String get unbanningUser => '解封用户中...';

  @override
  String get cleaningSpam => '清理垃圾信息中...';

  @override
  String get enterSubject => '输入主题';

  @override
  String get typeYourMessageHere => '在此输入您的消息';

  @override
  String get writeYourMessage => '编写您的消息...';

  @override
  String get writeYourReply => '编写您的回复...';

  @override
  String get messageSentSuccessfully => '消息发送成功';

  @override
  String get replySentSuccessfully => '回复发送成功';

  @override
  String get conversationCreatedSuccessfully => '对话创建成功';

  @override
  String get conversationMarkedAsUnread => '对话已标记为未读';

  @override
  String get messageMarkedAsUnread => '消息已标记为未读';

  @override
  String get conversationClosed => '对话已关闭';

  @override
  String get conversationOpened => '对话已打开';

  @override
  String get pleaseLoginToLikeMessages => '请登录以点赞消息';

  @override
  String get loadEarlierMessages => '加载更早的消息';

  @override
  String failedToLoadQuote(String error) {
    return '加载引用失败: \n$error';
  }

  @override
  String failedToUploadFile(String error) {
    return '上传文件失败: $error';
  }

  @override
  String failedToUploadImage(String error) {
    return '上传图片失败: $error';
  }

  @override
  String failedToSendMessage(String error) {
    return '发送消息失败: $error';
  }

  @override
  String failedToSendReply(String error) {
    return '发送回复失败: $error';
  }

  @override
  String failedToMarkAsUnread(String error) {
    return '标记消息为未读失败: $error';
  }

  @override
  String failedToMarkConversationAsUnread(String error) {
    return '标记对话为未读失败: $error';
  }

  @override
  String failedToCloseConversation(String error) {
    return '关闭对话失败: $error';
  }

  @override
  String failedToOpenConversation(String error) {
    return '打开对话失败: $error';
  }

  @override
  String failedToJumpToMessage(String error) {
    return '跳转到消息失败: $error';
  }

  @override
  String get goToTop => '返回顶部';

  @override
  String get goToBottom => '跳到底部';

  @override
  String get replyAll => '全部回复';

  @override
  String get forward => '转发';

  @override
  String get noForumsFound => '未找到论坛。';

  @override
  String get pleaseSelectPrefix => '请选择前缀';

  @override
  String get pleaseLoginToAccessContent => '请登录以访问此内容并与帖子互动。';

  @override
  String get searchUsers => '搜索用户...';

  @override
  String get writeYourTitle => '编写您的标题...';

  @override
  String get writeYourContent => '编写您的内容...';

  @override
  String get selectAnOption => '选择选项';

  @override
  String get enterConversationTitle => '输入对话标题';

  @override
  String enterCode(int count) {
    return '输入$count位代码';
  }

  @override
  String get edit => '编辑';

  @override
  String get report => '举报';

  @override
  String get unfollow => '取消关注';

  @override
  String get follow => '关注';

  @override
  String get remove => '删除';

  @override
  String get subject => '主题';

  @override
  String get message => '消息';

  @override
  String get titleCannotBeEmpty => '标题不能为空';

  @override
  String get conversationUpdatedSuccessfully => '对话更新成功';

  @override
  String get goBack => '返回';

  @override
  String get signInToViewMessages => '请登录以查看对话';

  @override
  String get privateMessagesNotAvailable => '对话不可用';

  @override
  String failedToLoadPost(String error) {
    return '加载帖子失败: \n$error';
  }

  @override
  String failedToLikeOrUnlikeMessage(String action, String error) {
    return '对消息$action失败: $error';
  }

  @override
  String get like => '点赞';

  @override
  String get unlike => '取消点赞';

  @override
  String get optimizeImage => '优化图片';

  @override
  String get optimizeAndUpload => '优化并上传';

  @override
  String downloading(String filename) {
    return '正在下载$filename...';
  }

  @override
  String openingShareSheet(String filename) {
    return '正在为$filename打开分享表';
  }

  @override
  String errorDownloading(String filename, String error) {
    return '下载$filename时出错: $error';
  }

  @override
  String get enterANumber => '输入数字';

  @override
  String get failedToNavigateToForum => '导航到论坛失败';

  @override
  String failedToNavigateToForumName(String forumName) {
    return '导航到$forumName失败';
  }

  @override
  String get failedToSaveConversation => '保存对话失败';

  @override
  String forumNotFound(String forumName) {
    return '未找到论坛: $forumName';
  }

  @override
  String forumNotFoundById(String forumId) {
    return '未找到论坛: $forumId';
  }

  @override
  String couldNotOpenLink(String error) {
    return '无法打开链接: $error';
  }

  @override
  String get likePost => '点赞帖子';

  @override
  String get unlikePost => '取消点赞';

  @override
  String get showLikes => '显示点赞';

  @override
  String get quotePost => '引用帖子';

  @override
  String get attachFile => '附加文件';

  @override
  String get uploadImage => '上传图片';

  @override
  String get translate => '翻译';

  @override
  String get showOriginal => '显示原文';

  @override
  String get translating => '翻译中...';

  @override
  String get translated => '已翻译';

  @override
  String get translatedContent => '翻译内容';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get translateTo => '翻译为:';

  @override
  String get deviceLanguage => '设备语言';

  @override
  String get noPostsToTranslate => '没有可翻译的帖子';

  @override
  String get translationFailed => '翻译失败';

  @override
  String get twoFactorAuthentication => '双重身份验证';

  @override
  String get authenticationCodeLabel => '验证码';

  @override
  String get pleaseEnterYourAuthenticationCode => '请输入验证码';

  @override
  String codeMustBeDigits(int count) {
    return '验证码必须为 $count 位数字';
  }

  @override
  String get codeMustContainOnlyNumbers => '验证码只能包含数字';

  @override
  String get verifyButton => '验证';

  @override
  String get attachments => '附件';

  @override
  String get replyOptions => '回复选项';

  @override
  String get replyWithQuote => '引用回复';

  @override
  String fileSavedToDownloads(String filename) {
    return '文件已保存到下载：$filename';
  }

  @override
  String fileSavedToDocuments(String filename) {
    return '文件已保存到文档：$filename';
  }

  @override
  String get discardPostQuestion => '是否要放弃您的帖子？';

  @override
  String get discardChangesQuestion => '您确定要放弃所做的更改吗？';

  @override
  String get discard => '放弃';

  @override
  String get discardChanges => '舍弃更改';

  @override
  String get saveDraft => '保存草稿';

  @override
  String get notificationsTab => '通知';

  @override
  String get postAwaitingApproval => '您的帖子将在版主批准后显示。';

  @override
  String get reactionHoldHint => '长按可选择更多反应';

  @override
  String get turnOnNotifications => '开启通知';

  @override
  String get notNow => '暂不';

  @override
  String neverMissAReplyOn(Object forumName) {
    return '不错过 $forumName 上的任何回复';
  }

  @override
  String get notificationPreviewNow => '刚刚';

  @override
  String get notificationPreviewEarlier => '5 分钟前';

  @override
  String get notificationPreviewReply => 'Jane 回复了你：欢迎加入！很高兴你找到了我们。';

  @override
  String get notificationPreviewMessage => 'Sam 给你发了消息：周五你来吗？';

  @override
  String get notificationsAreTurnedOffForThisApp => '此应用的通知已关闭';

  @override
  String get deviceWillNotShowAlertsUntilAllowedInSettings =>
      '在“设置”中允许通知之前，设备不会显示提醒。';

  @override
  String get openSettings => '打开设置';

  @override
  String get notificationsPitchForum => '回复、提及和私信会第一时间显示在锁屏上。';

  @override
  String get viewProfile => '查看个人资料';

  @override
  String get settings => '设置';

  @override
  String get signOut => '退出登录';

  @override
  String get changeEmail => '更改邮箱';

  @override
  String get changePassword => '更改密码';

  @override
  String get save => '保存';

  @override
  String get currentPassword => '当前密码';

  @override
  String get newPassword => '新密码';

  @override
  String get confirmNewPassword => '确认新密码';

  @override
  String get newEmailAddress => '新邮箱地址';

  @override
  String get emailChanged => '邮箱地址已更改';

  @override
  String get emailChangeConfirm => '请查看收件箱：确认后新地址才会生效。';

  @override
  String get passwordChanged => '密码已更改';

  @override
  String get account => '账户';

  @override
  String get pleaseEnterEmail => '请输入您的电子邮箱';

  @override
  String get pleaseEnterValidEmail => '请输入有效的电子邮箱';

  @override
  String get passwordsDoNotMatch => '两次输入的密码不一致';

  @override
  String get connectionErrorTitle => '连接错误';

  @override
  String get authenticationErrorTitle => '身份验证错误';

  @override
  String get permissionErrorTitle => '权限错误';

  @override
  String get errorNoConnection => '没有网络连接。请检查您的网络设置。';

  @override
  String get errorTimeout => '请求超时。请重试。';

  @override
  String get errorServer => '服务器出错。请稍后重试。';

  @override
  String get errorNetwork => '网络出错。请重试。';

  @override
  String get errorInvalidCredentials => '用户名或密码无效。';

  @override
  String get errorSessionExpired => '您的会话已过期。请重新登录。';

  @override
  String get errorAccountLocked => '您的账户已被锁定。请联系支持人员。';

  @override
  String get errorAuthFailed => '身份验证失败。请重试。';

  @override
  String get errorForumNotFound => '未找到论坛。';

  @override
  String get errorForumAccessDenied => '您无权访问此论坛。';

  @override
  String get errorForumUnavailable => '论坛当前不可用。请稍后重试。';

  @override
  String get errorForumGeneric => '论坛出错。请重试。';

  @override
  String get errorDataNotFound => '未找到请求的数据。';

  @override
  String get errorDataCorrupted => '数据似乎已损坏。请刷新页面。';

  @override
  String get errorCache => '无法加载缓存数据。请重试。';

  @override
  String get errorInvalidInput => '您输入的内容无效。';

  @override
  String get errorRequiredField => '请填写所有必填字段。';

  @override
  String get errorPermissionDenied => '您无权执行此操作。';

  @override
  String errorFeatureNotAvailable(String feature) {
    return '此论坛不支持$feature。';
  }

  @override
  String get errorStorageFull => '存储空间已满。请释放一些空间。';

  @override
  String get errorStorageAccessDenied => '存储访问被拒绝。请检查应用权限。';

  @override
  String get loginInfo => '登录信息';

  @override
  String get loginFailed => '登录失败';

  @override
  String get topicAnnouncement => '公告';

  @override
  String get topicPinned => '置顶';

  @override
  String get topicLocked => '已锁定';

  @override
  String get topicPoll => '投票';

  @override
  String get deletedBadge => '已删除';

  @override
  String get protectedBadge => '受保护';

  @override
  String get lockTopic => '锁定主题';

  @override
  String get unlockTopic => '解锁主题';

  @override
  String get lockTopicConfirm => '确定要锁定此主题吗？其他用户将无法回复或互动。';

  @override
  String get unlockTopicConfirm => '确定要解锁此主题吗？其他用户将可以再次回复和互动。';

  @override
  String get stickTopic => '置顶主题';

  @override
  String get unstickTopic => '取消置顶';

  @override
  String get stickTopicConfirm => '确定要置顶此主题吗？它将对所有用户显示在论坛顶部。';

  @override
  String get unstickTopicConfirm => '确定要取消置顶此主题吗？它将不再显示在论坛顶部。';

  @override
  String get undeleteTopic => '恢复主题';

  @override
  String get undeleteTopicConfirm => '确定要恢复此主题吗？其他用户将可以再次看到它。';

  @override
  String get additionalInformation => '附加信息';

  @override
  String get dateOfBirth => '出生日期';

  @override
  String get selectDateOfBirth => '选择出生日期';

  @override
  String minimumAge(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: '最低年龄：$age 岁',
    );
    return '$_temp0';
  }

  @override
  String get locationIsRequired => '位置为必填项';

  @override
  String get receiveSiteMailings => '接收站点邮件';

  @override
  String iAcceptTheDocument(String document) {
    return '我接受$document';
  }

  @override
  String get termsOfService => '服务条款';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get imageExceedsUploadLimits => '此图片超出上传限制，需要优化：';

  @override
  String get originalSize => '原始大小';

  @override
  String get originalDimensions => '原始尺寸';

  @override
  String get optimizationsToBeApplied => '将应用的优化：';

  @override
  String get resizeImage => '调整大小';

  @override
  String get convertFormat => '转换格式';

  @override
  String get smallerFileSize => '更小的文件';

  @override
  String get formatNotSupported => '格式不受支持';

  @override
  String get convertToJpgReason => '转换为 JPG（格式不受支持或为了减小文件）';

  @override
  String get compressImage => '压缩';

  @override
  String compressQuality(int quality) {
    return '质量：$quality%，以满足大小限制';
  }

  @override
  String get estimatedFinalSize => '预计最终大小';

  @override
  String sizeReduction(String percent) {
    return '缩小：$percent%';
  }

  @override
  String get pleaseLoginToCreateTopic => '请登录以创建新主题';

  @override
  String get pleaseLoginToSubscribeForums => '请登录以关注论坛';

  @override
  String get pleaseLoginToUnsubscribeForums => '请登录以取消关注论坛';

  @override
  String errorLoadingContent(String error) {
    return '加载内容时出错：$error';
  }

  @override
  String get noPermissionToViewSubforumTopics => '您无权查看此子论坛中的主题。';

  @override
  String get noDiscussionsYet => '暂无讨论。';

  @override
  String get unableToLoadForums => '无法加载论坛';

  @override
  String get noForumsAvailable => '没有可用的论坛';

  @override
  String get noForumsToDisplay => '没有可显示的论坛。这可能与权限或论坛结构有关。';

  @override
  String get subscribedForums => '关注的论坛';

  @override
  String get allForumTopicsMarkedRead => '已将论坛中的所有主题标记为已读';

  @override
  String postsCountFormatted(String count) {
    return '$count 个帖子';
  }

  @override
  String get jumpToPost => '跳转到帖子';

  @override
  String get jump => '跳转';

  @override
  String get endOfDiscussion => '讨论到此结束';

  @override
  String refreshFailed(String error) {
    return '刷新失败：$error';
  }

  @override
  String get topicDeletedHidden => '此主题已删除，其他用户看不到';

  @override
  String get topicClosedNoReplies => '此主题已关闭，不再接受回复';

  @override
  String get youAreSubscribedToTopic => '您已关注此主题';

  @override
  String get refreshing => '正在刷新...';

  @override
  String get unableToLoadForumsTryAgain => '无法加载论坛。请重试。';

  @override
  String get noPostableForums => '没有可发帖的论坛。';

  @override
  String get changeForumQuestion => '更换论坛？';

  @override
  String get changeForumRemovesAttachments => '更换论坛将移除已上传的附件，因为附件与所选论坛绑定。';

  @override
  String get changeForum => '更换论坛';

  @override
  String get chooseForumBeforePosting => '发帖前请选择论坛';

  @override
  String get accountCannotUploadAttachments => '您的账户无法在此站点上传附件。';

  @override
  String get forumNoAttachments => '此论坛不允许附件。';

  @override
  String get forumNoAttachmentsChooseAnother => '此论坛不允许附件。请选择其他论坛来上传共享的文件。';

  @override
  String get forumNoAttachmentsSharedPending =>
      '此论坛不允许附件。在您选择其他论坛之前，共享的文件将保持待上传状态。';

  @override
  String get tapToChangeForum => '点按以更换论坛';

  @override
  String get chooseWhichForum => '选择要发帖的论坛';

  @override
  String get selectAForum => '选择论坛';

  @override
  String get unableToLoadForumsNow => '暂时无法加载论坛。';

  @override
  String get pickForumBeforeUploading => '上传附件或发帖前请先选择论坛。';

  @override
  String get uploadingSharedFiles => '正在上传共享的文件...';

  @override
  String get selectForum => '选择论坛';

  @override
  String get noForumsMatchSearch => '没有与搜索匹配的论坛。';

  @override
  String get unknown => '未知';

  @override
  String get closeConversationConfirm => '确定要关闭此对话吗？关闭后将无法发送新的回复。';

  @override
  String get openConversationConfirm => '确定要开启此对话吗？开启后可以发送新的回复。';

  @override
  String get leaveConversationConfirm => '确定要离开此对话吗？它将从您的收件箱中隐藏。';

  @override
  String get close => '关闭';

  @override
  String get open => '开启';

  @override
  String get leave => '离开';

  @override
  String errorLoadingConversation(String error) {
    return '加载对话时出错：$error';
  }

  @override
  String get conversationNotFound => '未找到对话';

  @override
  String get conversationClosedNoReplies => '此对话已关闭，不再接受回复';

  @override
  String get noMessagesFound => '未找到消息';

  @override
  String get endOfConversation => '对话到此结束';

  @override
  String get jumpToMessage => '跳转到消息';

  @override
  String get jumpToFirstMessage => '跳转到第一条消息';

  @override
  String get jumpToLastMessage => '跳转到最后一条消息';

  @override
  String messagePositionOf(int position, int total) {
    return '第 $position 条，共 $total 条';
  }

  @override
  String get tapToJumpToMessage => '点按以跳转到指定消息';

  @override
  String failedToReact(String error) {
    return '回应失败：$error';
  }

  @override
  String participantCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 位参与者',
    );
    return '$_temp0';
  }

  @override
  String get noImagesToDisplay => '没有可显示的图片。';

  @override
  String get pleaseLoginToViewAttachment => '请登录以查看此附件';

  @override
  String get inbox => '收件箱';

  @override
  String get sent => '已发送';

  @override
  String errorLoadingMessages(String error) {
    return '加载消息时出错：$error';
  }

  @override
  String get noInboxMessages => '收件箱中没有消息';

  @override
  String get noSentMessages => '没有已发送的消息';

  @override
  String get unknownDate => '日期未知';

  @override
  String get searchForTopics => '搜索主题';

  @override
  String get noTopicsFound => '未找到主题';

  @override
  String get noPostsFound => '未找到帖子';

  @override
  String get trySearchingDifferentKeywords => '请尝试使用其他关键词搜索';

  @override
  String errorLoadingSettings(String error) {
    return '加载设置时出错：$error';
  }

  @override
  String get pleaseEnterValidNumber => '请输入有效的数字';

  @override
  String valueMustBeAtLeast(String min) {
    return '值不能小于 $min';
  }

  @override
  String valueMustBeAtMost(String max) {
    return '值不能大于 $max';
  }

  @override
  String maximumLengthCharacters(int max) {
    return '最多 $max 个字符';
  }

  @override
  String get invalidFormat => '格式无效';

  @override
  String get shareToForumCopilot => '分享到 Forum Copilot';

  @override
  String get noSavedForumAccounts => '未找到已保存的论坛账户。';

  @override
  String get addForumAccountFirst => '请先在 Forum Copilot 中添加论坛账户，然后再分享。';

  @override
  String filesReadyToAttach(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个文件可附加',
    );
    return '$_temp0';
  }

  @override
  String get sharedTextWillBePrefilled => '共享的文本将预先填入';

  @override
  String errorSearchingForums(String error) {
    return '搜索论坛时出错：$error';
  }

  @override
  String failedToLoadUserInfo(String error) {
    return '无法加载用户信息：$error';
  }

  @override
  String areYouSureUnban(String username) {
    return '确定要解除对 $username 的封禁吗？';
  }

  @override
  String get deletePostsProfilePostsComments => '删除帖子、个人资料帖子和评论';

  @override
  String areYouSureSpamClean(String username) {
    return '确定要清理 $username 的垃圾内容吗？';
  }

  @override
  String successfullyCleanedSpamFor(String username) {
    return '已清理 $username 的垃圾内容';
  }

  @override
  String get failedToCleanSpam => '清理垃圾内容失败';

  @override
  String imagesCount(int count) {
    return '图片（$count）';
  }

  @override
  String get pleaseLoginToViewProfiles => '请登录以查看用户资料。';

  @override
  String get tapToOpen => '点按以打开';

  @override
  String get imageNotAvailable => '图片不可用';

  @override
  String get tapToViewFullSizeImage => '点按查看原图';

  @override
  String get loadingImage => '正在加载图片...';

  @override
  String loadingImageFrom(String host) {
    return '正在从 $host 加载图片';
  }

  @override
  String get tapToReveal => '（点按显示）';

  @override
  String get inlineAttachments => '内嵌附件';

  @override
  String get thisFieldIsRequired => '此字段为必填项';

  @override
  String get pleaseEnterValidPhoneNumber => '请输入有效的电话号码';

  @override
  String get pleaseEnterValidUrl => '请输入有效的网址';

  @override
  String get permissionDeniedToSaveImage => '没有保存图片的权限';

  @override
  String get postNotFound => '未找到帖子。';

  @override
  String get failedToUploadFileTryAgain => '上传文件失败。请重试。';

  @override
  String get failedToPickFile => '选择文件失败';

  @override
  String onlyMoreAttachmentsAllowed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '最多还能添加 $count 个附件，将使用前 $count 张图片。',
    );
    return '$_temp0';
  }

  @override
  String get attachmentLimitReachedSkipping => '已达到附件上限，其余图片将被跳过。';

  @override
  String get imageValidationFailed => '图片验证失败';

  @override
  String get imageUploadFailed => '上传图片失败';

  @override
  String get failedToUploadImageTryAgain => '上传图片失败。请重试。';

  @override
  String get failedToPickImage => '选择图片失败';

  @override
  String get prefix => '前缀';

  @override
  String get failedToLoadPrefixes => '加载前缀失败';

  @override
  String get attachFileHint => '为此消息附加文件';

  @override
  String get uploadImageHint => '为此消息上传图片';

  @override
  String get openFormattingOptions => '打开格式选项';

  @override
  String get failedToPostReply => '发布回复失败。请重试。';

  @override
  String get failedToUpdatePost => '更新帖子失败。请重试。';

  @override
  String get postDeletedSuccessfully => '帖子已删除';

  @override
  String failedToDeletePost(String error) {
    return '删除帖子失败：$error';
  }

  @override
  String get noPermissionToUploadAvatars => '您无权上传头像';

  @override
  String get avatarUploadedSuccessfully => '头像已上传';

  @override
  String get unknownTopic => '未知主题';

  @override
  String get connectionTimeoutTitle => '连接超时';

  @override
  String connectionTimedOutTo(String siteName) {
    return '连接 $siteName 超时。请检查网络连接后重试。';
  }

  @override
  String failedToConnectCheckPlugin(String siteName) {
    return '无法连接到 $siteName。请检查论坛是否可用以及插件是否已安装。';
  }

  @override
  String get voteFailedTryAgain => '投票失败。请重试。';

  @override
  String get noUserSpecified => '未指定用户';

  @override
  String get failedToLoadRecentPosts => '加载最近的帖子失败';

  @override
  String failedToLoadPreview(String error) {
    return '加载预览失败：$error';
  }

  @override
  String thanksCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 人表示感谢',
    );
    return '$_temp0';
  }

  @override
  String get thankedBy => '感谢者';

  @override
  String maximumAttachmentsAllowed(int count) {
    return '最多允许 $count 个附件';
  }

  @override
  String get toLabel => '收件人';

  @override
  String get closeConversation => '关闭对话';

  @override
  String get openConversation => '打开对话';

  @override
  String get loginSucceeded => '登录成功';

  @override
  String get verificationErrorTryAgain => '验证时出错。请重试。';

  @override
  String get passkeyChallengeFailed => '无法开始通行密钥登录。';

  @override
  String get passkeyNotSetUp => '此论坛尚未在本应用中启用通行密钥。请使用用户名和密码登录。';

  @override
  String get noPasskeyForForum => '未找到此论坛的通行密钥。请使用密码登录，或先在论坛网站上创建通行密钥。';

  @override
  String get pushNotificationsNotReady => '推送通知尚未就绪';

  @override
  String pushEnabledFor(String siteName) {
    return '已为 $siteName 开启推送通知';
  }

  @override
  String get failedToEnablePush => '开启推送通知失败';

  @override
  String get failedToRegisterPush => '注册推送通知失败';

  @override
  String translatedFromTo(String source, String target) {
    return '已从 $source 翻译为 $target';
  }

  @override
  String get unableToOpenNotification => '无法打开通知';

  @override
  String get notificationMissingInfo => '此通知缺少信息。';

  @override
  String get couldNotOpenForum => '无法打开论坛。';

  @override
  String get notificationChannelName => 'Forum Copilot 通知';

  @override
  String get notificationChannelDescription => 'Forum Copilot 应用的通知';

  @override
  String fileTypeNotAllowed(String extension, String allowed) {
    return '不允许 .$extension 类型的文件。允许的类型：$allowed';
  }

  @override
  String fileSizeExceedsMaximum(String size, String max) {
    return '文件大小（$size）超过上限 $max';
  }

  @override
  String get fileTypeAudio => '音频';

  @override
  String get fileTypeText => '文本';

  @override
  String get fileTypeArchive => '压缩包';

  @override
  String get fileTypeFile => '文件';

  @override
  String get imageFileNotFound => '未找到图片文件。文件可能已被移动或删除。';

  @override
  String get imagePermissionDenied => '没有权限，无法读取图片文件。';

  @override
  String get imageInsufficientSpace => '磁盘空间不足，无法优化图片。';

  @override
  String cannotAccessImageFile(String error) {
    return '无法访问图片文件：$error';
  }

  @override
  String get imageFormatUnsupported => '图片格式已损坏或不受支持。请换一张图片。';

  @override
  String get failedToResizeImage => '调整图片大小失败。图片可能已损坏或格式不受支持。';

  @override
  String get failedToConvertImageToJpg => '无法将图片转换为 JPG。图片可能已损坏。';

  @override
  String get failedToCompressImage => '压缩图片失败。可能是磁盘空间不足或图片已损坏。';

  @override
  String get cannotDecodeImage => '无法解码图片。文件可能已损坏或格式不受支持。';

  @override
  String get cannotReadImageFile => '无法读取图片文件。文件可能已被移动或删除。';

  @override
  String failedToOptimizeImage(String error) {
    return '优化图片失败：$error';
  }

  @override
  String emailCopiedToClipboard(String email) {
    return '电子邮件已复制到剪贴板：$email';
  }

  @override
  String couldNotOpenEmail(String email) {
    return '无法打开电子邮件：$email';
  }

  @override
  String get editPost => '编辑帖子';

  @override
  String get thisTopicIsPinnedToTopOfForum => '该主题已置顶到论坛顶部';

  @override
  String get editConversation => '编辑对话';

  @override
  String get failedToLoadConversation => '加载会话失败';

  @override
  String get cannotEditConversation => '无法编辑此会话';

  @override
  String get titleLabel => '标题';

  @override
  String get options => '选项';

  @override
  String get openInvite => '开放邀请';

  @override
  String get allowAnyParticipantToInviteOthers => '允许任何参与者邀请其他人';

  @override
  String get conversationOpen => '会话开启';

  @override
  String failedToCreateConversation(String error) {
    return '创建会话失败：$error';
  }

  @override
  String get lockConversation => '锁定会话';

  @override
  String get createConversationAsClosed => '将会话创建为关闭状态（不允许回复）';

  @override
  String get deleteAccount => '删除账户';

  @override
  String get deleteAccountDescription => '从此论坛中删除您的账户。';

  @override
  String get deleteAccountContactForumMessage =>
      '您的账户由论坛管理。如需删除账户，请直接联系论坛。请使用论坛主页底部的“联系我们”按钮。';

  @override
  String get forumUrlUnavailable => '论坛 URL 不可用。';

  @override
  String get couldNotOpenForumUrl => '无法打开论坛 URL。';

  @override
  String get noActionUrlAvailableForThisNotificationType => '此通知没有可打开的链接。';

  @override
  String get signInToViewNotifications => '登录后可查看通知';

  @override
  String get youNeedToBeSignedInToViewYourNotifications => '您需要登录后才能查看您的通知。';

  @override
  String get errorLoadingNotifications => '加载通知时出错';

  @override
  String get pullDownToRefresh => '下拉刷新';

  @override
  String get youHaveNoNewNotificationsCheckBackLater => '您暂无新通知。请稍后回来查看。';

  @override
  String get signInToViewProfile => '登录后可查看个人资料';

  @override
  String get youNeedToBeSignedInToViewYourProfile => '您需要登录后才能查看您的个人资料。';

  @override
  String get emailLabel => '电子邮箱';

  @override
  String get confirmPasswordLabel => '确认密码';

  @override
  String get protectedForum => '受保护的论坛';

  @override
  String forumIsPasswordProtected(String forumName) {
    return '$forumName 受密码保护。';
  }

  @override
  String get enterButton => '进入';

  @override
  String get recentPosts => '最近帖子';

  @override
  String passkeyNotAvailableInForum(int code) {
    return '当前论坛暂不支持通行密钥（代码：$code）';
  }

  @override
  String get initializingForum => '正在初始化论坛…';

  @override
  String get retryConnection => '重新连接';

  @override
  String get pleaseConfirmPassword => '请确认您的密码';

  @override
  String get pleaseEnterTheForumPassword => '请输入论坛密码';

  @override
  String get editYourPost => '编辑你的帖子...';

  @override
  String get topicIdIsMissingCannotNavigateToThePost => '缺少主题 ID，无法跳转到该帖子。';

  @override
  String get conversationIsOpenForReplies => '会话已开启，可回复';

  @override
  String get conversationIsClosedNoRepliesAllowed => '会话已关闭（不允许回复）';

  @override
  String get pleaseEnterAUsername => '请输入用户名';

  @override
  String usernameMinLength(int count) {
    return '用户名至少需要 $count 个字符';
  }

  @override
  String get pleaseEnterAPassword => '请输入密码';

  @override
  String passwordMinLength(int count) {
    return '密码至少需要 $count 个字符';
  }

  @override
  String get writeYourTopicTitle => '输入主题标题...';

  @override
  String get writeYourTopicContent => '输入主题内容...';

  @override
  String pushDisabledFor(String siteName) {
    return '已关闭 $siteName 的推送通知';
  }

  @override
  String get failedToDisablePush => '关闭推送通知失败';

  @override
  String get thisForumInSentence => '此论坛';

  @override
  String get openFullEditor => '完整编辑器';

  @override
  String statsMembers(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 位成员',
    );
    return '$_temp0';
  }

  @override
  String statsTopics(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 个主题',
    );
    return '$_temp0';
  }

  @override
  String statsPosts(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 个帖子',
    );
    return '$_temp0';
  }

  @override
  String searchForumName(String forumName) {
    return '搜索 $forumName';
  }

  @override
  String get copyLink => '复制链接';

  @override
  String get linkCopied => '链接已复制';

  @override
  String sharedFilesAttached(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已附加 $count 个共享文件。',
    );
    return '$_temp0';
  }

  @override
  String sharedFilesPartlyAttached(int count, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已附加 $count 个文件。未能附加：$names',
    );
    return '$_temp0';
  }

  @override
  String get notificationChannelMessages => '私信';

  @override
  String get notificationChannelMessagesDescription => '新的私信及其回复';

  @override
  String get notificationChannelReplies => '回复和提及';

  @override
  String get notificationChannelRepliesDescription => '关注主题中的回复、引用和提及';

  @override
  String get notificationChannelReactions => '点赞和回应';

  @override
  String get notificationChannelReactionsDescription => '对你的帖子和消息的点赞与回应';

  @override
  String get notificationChannelOther => '其他通知';

  @override
  String get notificationChannelOtherDescription => '关注、奖杯和其他论坛提醒';

  @override
  String get deleteAccountConfirmTitle => '删除你的账户？';

  @override
  String deleteAccountConfirmMessage(String forumName) {
    return '你在 $forumName 的账户将被删除，包括个人资料和设置。你的帖子会以你的名字保留。此操作无法撤销。';
  }

  @override
  String get deleteAccountNoPassword => '没有密码？用用户名确认';

  @override
  String get deleteAccountUsePassword => '用密码确认';

  @override
  String get accountDeleted => '你的账户已删除。';

  @override
  String get signInOnWebsite => '在论坛网站上登录';

  @override
  String get signInOnWebsiteHint => '适用于 Google、Facebook 及你在网站上使用的其他登录方式';

  @override
  String get browserLoginFailed => '网站登录未成功，请重试。';

  @override
  String get subForums => '子论坛';

  @override
  String postPositionOf(int position, int total) {
    return '第 $position 楼，共 $total 楼';
  }

  @override
  String get tapToJumpToPost => '点按以跳转到指定帖子';

  @override
  String get jumpToFirstPost => '跳转到第一个帖子';

  @override
  String get jumpToLastPost => '跳转到最后一个帖子';

  @override
  String get send => '发送';

  @override
  String get postAction => '发布';

  @override
  String messageCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条消息',
    );
    return '$_temp0';
  }

  @override
  String replyCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条回复',
    );
    return '$_temp0';
  }

  @override
  String subForumCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个子论坛',
    );
    return '$_temp0';
  }

  @override
  String get trustThisDevice => '信任此设备';

  @override
  String get trustThisDeviceHint => '下次在此设备上登录时不再要求输入验证码';

  @override
  String get passkeyNotOnThisDevice => '此设备上没有该论坛的通行密钥。请选择其他方式，或先在论坛网站上添加通行密钥。';

  @override
  String get passkeyStepNotSetUp => '该论坛尚未在此应用中设置通行密钥。请选择其他方式。';

  @override
  String get ignoreMember => '忽略成员';

  @override
  String get stopIgnoringMember => '取消忽略';

  @override
  String memberIgnored(String name) {
    return '你现在忽略了 $name。';
  }

  @override
  String memberNoLongerIgnored(String name) {
    return '你已不再忽略 $name。';
  }

  @override
  String get ignoredMembers => '已忽略的成员';

  @override
  String get ignoredMembersExplanation => '你忽略的成员发布的内容会被隐藏，且他们无法与你发起对话。';

  @override
  String get noIgnoredMembers => '你没有忽略任何人。';

  @override
  String youAreIgnoringMember(String name) {
    return '你正在忽略 $name。';
  }

  @override
  String get showIgnoredContent => '显示';

  @override
  String get markAllAlertsRead => '全部标为已读';

  @override
  String get topicSolved => '已解决';

  @override
  String get topicQuestion => '问题';

  @override
  String get solutionBadge => '解决方案';

  @override
  String get forumClosedTitle => '论坛已关闭';

  @override
  String get updatedTermsTitle => '条款已更新';

  @override
  String get updatedTermsMessage => '论坛已更新其条款或隐私政策。请在网站上查看并接受。';

  @override
  String get reviewTerms => '查看';

  @override
  String get forumTerms => '条款和规则';

  @override
  String get contactForum => '联系我们';

  @override
  String get notifyMeOf => '通知我';

  @override
  String get watchNewThreads => '新主题';

  @override
  String get watchNewMessages => '新消息';

  @override
  String get watchSendAlerts => '通知';

  @override
  String get watchSendEmails => '电子邮件';

  @override
  String get logInToWatchThread => '请登录以关注此主题';

  @override
  String get failedToWatchThread => '无法关注该主题';

  @override
  String get failedToUnwatchThread => '无法取消关注该主题';

  @override
  String get watchThreadAlertsNote => '有人回复时你会收到通知。';

  @override
  String get threadFilters => '筛选';

  @override
  String get anyPrefix => '（任意）';

  @override
  String get startedBy => '发起人';

  @override
  String get lastUpdated => '最后更新';

  @override
  String get anyTime => '任何时间';

  @override
  String periodDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天',
    );
    return '$_temp0';
  }

  @override
  String periodMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个月',
    );
    return '$_temp0';
  }

  @override
  String periodYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 年',
    );
    return '$_temp0';
  }

  @override
  String get sortBy => '排序方式';

  @override
  String get sortAscending => '升序';

  @override
  String get sortDescending => '降序';

  @override
  String get clearFilters => '清除筛选';

  @override
  String get applyFilters => '筛选';

  @override
  String get noThreadsMatchFilters => '没有符合这些筛选条件的主题。';

  @override
  String get threadTypeLabel => '主题类型';

  @override
  String get pollQuestion => '投票问题';

  @override
  String get pollResponses => '可选答案';

  @override
  String pollResponseNumber(int number) {
    return '答案 $number';
  }

  @override
  String get addPollResponse => '添加答案';

  @override
  String get removePollResponse => '删除答案';

  @override
  String get pollMultipleChoice => '允许选择多个答案';

  @override
  String get pollChangeVote => '允许投票者更改投票';

  @override
  String get pollPublicVotes => '公开显示投票';

  @override
  String get pollViewResultsUnvoted => '允许不投票查看结果';

  @override
  String get pollCloseAfter => '投票关闭时间';

  @override
  String get pollNeverCloses => '永不';

  @override
  String get noneOption => '（无）';

  @override
  String get tagsLabel => '标签';

  @override
  String get tagsHint => '用逗号分隔标签';

  @override
  String addAtLeastTags(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '请至少添加 $count 个标签',
    );
    return '$_temp0';
  }

  @override
  String threadFieldRequired(String field) {
    return '请填写$field。';
  }

  @override
  String get pollNeedsQuestionAndResponses => '请输入投票问题和至少两个答案。';

  @override
  String get awaitingApprovalBadge => '等待审核';

  @override
  String get approve => '批准';

  @override
  String get postApproved => '帖子已批准';

  @override
  String get postUndeleted => '帖子已恢复';

  @override
  String quoteSaid(String name) {
    return '$name 说：';
  }

  @override
  String timeGapDaysLater(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天后',
    );
    return '$_temp0';
  }

  @override
  String timeGapMonthsLater(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个月后',
    );
    return '$_temp0';
  }

  @override
  String timeGapYearsLater(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 年后',
    );
    return '$_temp0';
  }

  @override
  String topicMapViews(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '浏览',
    );
    return '$_temp0';
  }

  @override
  String topicMapReplies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '回复',
    );
    return '$_temp0';
  }

  @override
  String get thisForum => '本论坛';
}
