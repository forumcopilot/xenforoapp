// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Forum App';

  @override
  String get loginTitle => 'ログイン';

  @override
  String get usernameLabel => 'ユーザー名';

  @override
  String get passwordLabel => 'パスワード';

  @override
  String get loginButton => 'ログイン';

  @override
  String get signInWithPasskey => 'Sign in with Passkey';

  @override
  String get usePasskey => 'Use Passkey';

  @override
  String get passkeyContinuePrompt => 'Use your passkey to continue';

  @override
  String get forgotPassword => 'パスワードをお忘れですか？';

  @override
  String get pleaseEnterUsername => 'ユーザー名を入力してください';

  @override
  String get pleaseEnterPassword => 'パスワードを入力してください';

  @override
  String credentialsSentToDomain(String domain) {
    return 'ユーザー名とパスワードは $domain に送信されます';
  }

  @override
  String get createAccount => 'アカウント作成';

  @override
  String get alreadyHaveAccount => '既にアカウントをお持ちですか？ ';

  @override
  String get logIn => 'ログイン';

  @override
  String get continueButton => '続ける';

  @override
  String get registrationNotAvailable => '登録は利用できません';

  @override
  String get registrationNotAvailableMessage =>
      '現在、登録は利用できません。フォーラムが閉鎖されているか、登録が無効になっている可能性があります。';

  @override
  String get webRegistrationRequired => 'ウェブ登録が必要です';

  @override
  String get webRegistrationRequiredMessage =>
      'このフォーラムはウェブブラウザ経由での登録が必要です。下のボタンをクリックして登録ページを開いてください。';

  @override
  String get openRegistrationPage => '登録ページを開く';

  @override
  String get loadingAdditionalFields => '追加フィールドを読み込み中...';

  @override
  String get pleaseSelectDateOfBirth => '生年月日を選択してください';

  @override
  String get pleaseEnterLocation => '所在地を入力してください';

  @override
  String get pleaseIndicateEmailPreference => 'メール設定を指定してください';

  @override
  String get pleaseFillAllRequiredFields => 'すべての必須フィールドに入力してください';

  @override
  String get pleaseAcceptTermsOfService => '利用規約に同意してください';

  @override
  String get pleaseAcceptPrivacyPolicy => 'プライバシーポリシーに同意してください';

  @override
  String get registrationError => '登録エラー';

  @override
  String get registrationFailed => '登録に失敗しました。情報を確認してください。';

  @override
  String get registrationFailedTryAgain => '登録に失敗しました。もう一度お試しください。';

  @override
  String get registrationInfo => '登録情報';

  @override
  String get openWebsite => 'ウェブサイトを開く';

  @override
  String couldNotOpenForumWebsite(String url) {
    return 'フォーラムのウェブサイトを開けませんでした。次のURLにアクセスしてください: $url';
  }

  @override
  String get registrationSuccessfulEmailConfirm =>
      '登録が完了しました！ログインする前に、メールを確認してアカウントを確認してください。';

  @override
  String get registrationSuccessfulPendingApproval =>
      '登録が完了しました！アカウントは承認待ちです。アカウントが承認されると通知されます。';

  @override
  String get registrationSuccessfulAutoLogin => '登録が完了しました！自動的にログインされました。';

  @override
  String get welcome => 'ようこそ！';

  @override
  String get registrationSuccessful => '登録成功';

  @override
  String get pleaseLoginWithNewAccount => '新しいアカウントでログインしてください。';

  @override
  String get forgotPasswordTitle => 'パスワードを忘れた場合';

  @override
  String get usernameOrEmailLabel => 'ユーザー名またはメールアドレス';

  @override
  String get pleaseEnterUsernameOrEmail => 'ユーザー名またはメールアドレスを入力してください';

  @override
  String get sendResetLink => 'リセットリンクを送信';

  @override
  String get resetLinkSent => 'リセットリンクを送信しました';

  @override
  String get passwordResetInstructionsSent =>
      'パスワードリセットの手順が登録済みのメールアドレスに送信されました。';

  @override
  String get resetFailed => 'リセット失敗';

  @override
  String get unableToSendResetLink => 'リセットリンクを送信できませんでした。もう一度お試しください。';

  @override
  String get errorSendingResetLink =>
      'リセットリンクの送信中にエラーが発生しました。接続を確認してもう一度お試しください。';

  @override
  String get errorTitle => 'エラー';

  @override
  String get okButton => 'OK';

  @override
  String get retryButton => '再試行';

  @override
  String get copyToClipboard => 'クリップボードにコピー';

  @override
  String get copied => 'コピーしました';

  @override
  String get errorMessageCopiedToClipboard => 'エラーメッセージをクリップボードにコピーしました';

  @override
  String get cancel => 'キャンセル';

  @override
  String get getHelp => 'ヘルプを取得';

  @override
  String get somethingWentWrong => '問題が発生しました';

  @override
  String get unexpectedErrorOccurred => '予期しないエラーが発生しました。もう一度お試しください。';

  @override
  String get noInternetConnection => 'インターネット接続なし';

  @override
  String get checkInternetConnection => 'インターネット接続を確認してもう一度お試しください。';

  @override
  String get authenticationRequired => '認証が必要です';

  @override
  String get pleaseLoginToContinue => '続行するにはログインしてください。';

  @override
  String get forumError => 'フォーラムエラー';

  @override
  String get anErrorOccurred => 'エラーが発生しました';

  @override
  String get accountPendingApproval =>
      'アカウントは承認待ちです。フォーラムを閲覧できますが、モデレーターがアカウントを承認するまで投稿できません。';

  @override
  String get checkEmailToConfirm =>
      'アカウントを確認するためにメールを確認してください。送信したメールの確認リンクをクリックしてください。';

  @override
  String get checkNewEmailToConfirm =>
      '変更を確認するために新しいメールアドレスを確認してください。新しいメールを確認するまで、古いメールは有効のままです。';

  @override
  String get emailAddressInvalid =>
      'メールアドレスが無効であるか、メールが拒否されているようです。アカウント設定でメールアドレスを更新してください。';

  @override
  String get accountDisabled => 'アカウントが無効になっています。サポートについては管理者にお問い合わせください。';

  @override
  String get accountRegistrationRejected =>
      'アカウント登録が拒否されました。詳細については管理者にお問い合わせください。';

  @override
  String get welcomeToForumCopilot => 'Forum Copilotへようこそ！';

  @override
  String get successfullyLoggedOut => '正常にログアウトしました';

  @override
  String get accountStatusRequiresAttention =>
      'アカウントの状態に注意が必要です。ご質問がある場合は管理者にお問い合わせください。';

  @override
  String get updateEmail => 'メールを更新';

  @override
  String get resend => '再送信';

  @override
  String get noLatestTopics => '最新トピックなし';

  @override
  String get noRecentTopicsToDisplay =>
      '表示する最新トピックがありません。後で新しいディスカッションを確認してください。';

  @override
  String get noUnreadTopics => '未読トピックなし';

  @override
  String get thereAreNoUnreadTopics => '未読トピックがありません。後で新しいディスカッションを確認してください。';

  @override
  String get youAreAllCaughtUp => 'すべて確認済みです！';

  @override
  String get noSubscribedTopics => '購読トピックなし';

  @override
  String get noSubscribedTopicsMessage =>
      'トピックを購読していません。トピックの星ボタンをタップして購読し、新しい更新の通知を受け取ります。';

  @override
  String get noParticipatedTopics => '参加トピックなし';

  @override
  String get topicsYouParticipatedIn => '参加したトピックがここに表示されます。';

  @override
  String get latest => '最新';

  @override
  String get unread => '未読';

  @override
  String get subscribed => '購読';

  @override
  String get participated => '参加';

  @override
  String get connectionTimedOut =>
      '接続がタイムアウトしました。サイトがダウンしているか、アクセスできない可能性があります。';

  @override
  String get failedToConnectToSite =>
      'サイトに接続できませんでした。サイトがダウンしているか、アクセスできない可能性があります。';

  @override
  String get connectionFailed => '接続失敗';

  @override
  String failedToConnectToSiteName(String siteName) {
    return '$siteName に接続できませんでした';
  }

  @override
  String get loading => '読み込み中...';

  @override
  String get newConversation => '新しい会話';

  @override
  String get newMessage => '新しいメッセージ';

  @override
  String get appSettings => 'アプリ設定';

  @override
  String get searchSites => 'サイトを検索';

  @override
  String get all => 'すべて';

  @override
  String get topicsOnly => 'トピックのみ';

  @override
  String get titlesOnly => 'タイトルのみ';

  @override
  String failedToShareTopic(String error) {
    return 'トピックの共有に失敗しました: $error';
  }

  @override
  String pleaseLoginToSubscribe(String action) {
    return 'このスレッドを $action するにはログインしてください';
  }

  @override
  String get subscribeTo => '購読する';

  @override
  String get unsubscribeFrom => '購読を解除する';

  @override
  String get subscribe => '購読';

  @override
  String get unsubscribe => '購読解除';

  @override
  String failedToSubscribeToThread(String action) {
    return 'スレッドの $action に失敗しました';
  }

  @override
  String get youCannotReplyToThisThread => 'このスレッドに返信できません';

  @override
  String get pleaseWaitForThreadToLoad => 'スレッドの読み込みを待ってください';

  @override
  String get postCanBeRestoredLater => '投稿は後で復元できます';

  @override
  String get postWillBePermanentlyDeleted => '投稿は完全に削除されます';

  @override
  String get enterReasonForDeletingPost => 'この投稿を削除する理由を入力してください';

  @override
  String get reportPost => '投稿を報告';

  @override
  String get pleaseProvideReasonForReporting => 'この投稿を報告する理由を入力してください。';

  @override
  String get reason => '理由';

  @override
  String get enterReasonForReportingPost => 'この投稿を報告する理由を入力してください';

  @override
  String get pleaseEnterReason => '理由を入力してください';

  @override
  String get selectedActions => '選択されたアクション:';

  @override
  String get thisActionCannotBeUndone => 'このアクションは元に戻せません。';

  @override
  String get participantsLabel => '参加者';

  @override
  String usernameHasBeenInvited(String username) {
    return '$username が会話に招待されました';
  }

  @override
  String errorInvitingUser(String error) {
    return 'ユーザーの招待エラー: $error';
  }

  @override
  String get newTopic => '新しいトピック';

  @override
  String get markRead => '既読にする';

  @override
  String get pleaseSelectReasonForReportingUser => 'このユーザーを報告する理由を選択してください。';

  @override
  String get spamOrAdvertising => 'スパムまたは広告';

  @override
  String get harassmentOrBullying => '嫌がらせまたはいじめ';

  @override
  String get inappropriateContent => '不適切なコンテンツ';

  @override
  String get impersonationOrFakeAccount => 'なりすましまたは偽アカウント';

  @override
  String get otherPleaseSpecify => 'その他（指定してください）';

  @override
  String get pleaseSpecifyReason => '理由を指定してください';

  @override
  String get enterReasonForReportingUser => 'このユーザーを報告する理由を入力してください';

  @override
  String get pleaseSelectReason => '理由を選択してください';

  @override
  String pleaseSelectReasonForBanningUser(String username) {
    return '$username を禁止する理由を選択してください';
  }

  @override
  String get violationOfCommunityGuidelines => 'コミュニティガイドライン違反';

  @override
  String get harassmentOrAbusiveBehavior => '嫌がらせまたは虐待的行為';

  @override
  String get postingInappropriateContent => '不適切なコンテンツの投稿';

  @override
  String get accountCompromiseOrSecurityIssue => 'アカウントの侵害またはセキュリティ問題';

  @override
  String get enterReasonForBanningUser => 'このユーザーを禁止する理由を入力してください';

  @override
  String get banUntil => '禁止期限';

  @override
  String get selectDate => '日付を選択';

  @override
  String get unbanUser => 'ユーザーの禁止を解除';

  @override
  String get leaveConversation => '会話を退出';

  @override
  String get reportConversation => '会話を報告';

  @override
  String get topicClosed => 'トピックが閉じられました';

  @override
  String get topicOpened => 'トピックが開かれました';

  @override
  String get topicStickied => 'トピックが固定されました';

  @override
  String get topicUnstickied => 'トピックの固定が解除されました';

  @override
  String cannotEditMessage(String error) {
    return 'このメッセージを編集できません: $error';
  }

  @override
  String get confirmSpamClean => 'スパムクリーンを確認';

  @override
  String get myForums => 'マイフォーラム';

  @override
  String get recentlyVisited => '最近訪問した';

  @override
  String get explore => '探索';

  @override
  String get forumCopilot => 'Forum Copilot';

  @override
  String get noConversations => '会話なし';

  @override
  String get noConversationsMessage => 'まだ会話がありません。新しい会話を開始してメッセージングを始めましょう。';

  @override
  String get imageSavedToGallery => '画像がギャラリーに保存されました！';

  @override
  String failedToSaveImage(String error) {
    return '画像の保存に失敗しました: $error';
  }

  @override
  String get userProfile => 'ユーザープロフィール';

  @override
  String get deletePost => '投稿を削除';

  @override
  String get loginRequired => 'ログインが必要です';

  @override
  String get tryAgain => '再試行';

  @override
  String get memberSince => 'メンバー登録日';

  @override
  String get lastActivity => '最終アクティビティ';

  @override
  String get likesReceived => '受け取ったいいね';

  @override
  String get likesGiven => '与えたいいね';

  @override
  String get failedToSaveMessage => 'メッセージの保存に失敗しました';

  @override
  String get failedToSaveSetting => '設定の保存に失敗しました';

  @override
  String get failedToSavePost => '投稿の保存に失敗しました';

  @override
  String errorLoadingSites(String error) {
    return 'サイトの読み込みエラー: $error';
  }

  @override
  String connectingTo(String domainName) {
    return '$domainNameに接続中...';
  }

  @override
  String get members => 'メンバー';

  @override
  String get allMembers => 'すべてのメンバー';

  @override
  String get online => 'オンライン';

  @override
  String get noMembersFound => 'メンバーが見つかりません';

  @override
  String get searchForMembers => 'メンバーを検索';

  @override
  String get enterUsernameToFindMembers => 'フォーラムメンバーを見つけるためにユーザー名を入力してください';

  @override
  String get noMembersOnline => '現在オンラインのメンバーはいません';

  @override
  String get lookupMembers => 'メンバーを検索';

  @override
  String get addMembers => 'メンバーを追加';

  @override
  String get membersAddedSuccessfully => 'メンバーが正常に追加されました';

  @override
  String errorAddingMembers(String error) {
    return 'メンバーの追加エラー: $error';
  }

  @override
  String get failedToLoadOnlineUsers => 'オンラインユーザーの読み込みに失敗しました';

  @override
  String get noUsersOnline => 'オンラインユーザーなし';

  @override
  String membersCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString メンバー';
  }

  @override
  String get noSubject => '件名なし';

  @override
  String get search => '検索';

  @override
  String get moreOptions => 'その他のオプション';

  @override
  String get logout => 'ログアウト';

  @override
  String get areYouSureYouWantToLogout => 'ログアウトしてもよろしいですか？';

  @override
  String get register => '登録';

  @override
  String get signIn => 'ログイン';

  @override
  String get markForumRead => 'フォーラムを既読にする';

  @override
  String get notificationTest => '通知テスト';

  @override
  String get forum => 'フォーラム';

  @override
  String get profile => 'プロフィール';

  @override
  String get messages => 'メッセージ';

  @override
  String get add => '追加';

  @override
  String get dismiss => '閉じる';

  @override
  String get retry => '再試行';

  @override
  String get delete => '削除';

  @override
  String get deleteMessage => 'メッセージを削除';

  @override
  String get areYouSureYouWantToDeleteThisMessage => 'このメッセージを削除してもよろしいですか？';

  @override
  String failedToDeleteMessage(String error) {
    return 'メッセージの削除に失敗しました: $error';
  }

  @override
  String get deletingPost => '投稿を削除中...';

  @override
  String failedToUnlikePost(String error) {
    return '投稿のいいねを解除できませんでした: $error';
  }

  @override
  String failedToLikePost(String error) {
    return '投稿にいいねできませんでした: $error';
  }

  @override
  String get youNeedToBeSignedInToViewConversations =>
      '会話を表示するにはログインする必要があります。';

  @override
  String errorLoadingConversations(String error) {
    return '会話の読み込みエラー: $error';
  }

  @override
  String failedToLeaveConversation(String error) {
    return '会話を退出できませんでした: $error';
  }

  @override
  String errorLoadingMoreConversations(String error) {
    return '追加の会話の読み込みエラー: $error';
  }

  @override
  String errorLoadingMoreMessages(String error) {
    return 'メッセージの読み込みエラー: $error';
  }

  @override
  String get inviteMessageOptional => '招待メッセージ（オプション）';

  @override
  String get iWouldLikeToAddYouToThisConversation => 'この会話に追加させていただきたいです。';

  @override
  String get searchFailed => '検索に失敗しました';

  @override
  String get trySearchingWithDifferentUsername => '別のユーザー名で検索してみてください';

  @override
  String get enterUsernameToSearch => '検索するユーザー名を入力...';

  @override
  String get noSitesFound => 'サイトが見つかりませんでした。';

  @override
  String get userInformationNotAvailable => 'ユーザー情報が利用できません';

  @override
  String get birthday => '誕生日';

  @override
  String get posts => '投稿';

  @override
  String get following => 'フォロー中';

  @override
  String get followers => 'フォロワー';

  @override
  String get about => 'について';

  @override
  String get location => '場所';

  @override
  String get website => 'ウェブサイト';

  @override
  String get signature => '署名';

  @override
  String get next => '次へ';

  @override
  String get permanent => '永続的';

  @override
  String get temporary => '一時的';

  @override
  String setBanDurationFor(String username) {
    return '$usernameの禁止期間を設定';
  }

  @override
  String get pleaseSelectEndDateForTemporaryBan => '一時的な禁止の終了日を選択してください';

  @override
  String get back => '戻る';

  @override
  String get unban => '禁止を解除';

  @override
  String get confirm => '確認';

  @override
  String spamClean(String username) {
    return '$usernameのスパムをクリーン';
  }

  @override
  String get selectActionsToPerform => '実行するアクションを選択:';

  @override
  String get handleThreads => 'スレッドを処理';

  @override
  String get moveOrDeleteThreadsBasedOnAdminSettings =>
      '管理者設定に基づいてスレッドを移動または削除';

  @override
  String get deleteMessages => 'メッセージを削除';

  @override
  String get deleteConversations => '会話を削除';

  @override
  String get messageUpdatedSuccessfully => 'メッセージが正常に更新されました';

  @override
  String error(String error) {
    return 'エラー: $error';
  }

  @override
  String failedToRemoveAttachment(String error) {
    return '添付ファイルの削除に失敗しました: $error';
  }

  @override
  String failedToLoadMessage(String error) {
    return 'メッセージの読み込みに失敗しました: $error';
  }

  @override
  String get editMessage => 'メッセージを編集';

  @override
  String get removeAttachment => '添付ファイルを削除';

  @override
  String get areYouSureYouWantToRemoveThisAttachment =>
      'この添付ファイルを削除してもよろしいですか？';

  @override
  String get none => 'なし';

  @override
  String get formatting => '書式設定';

  @override
  String get bold => '太字';

  @override
  String get italic => '斜体';

  @override
  String get underline => '下線';

  @override
  String get strikethrough => '取り消し線';

  @override
  String get link => 'リンク';

  @override
  String get image => '画像';

  @override
  String get video => '動画';

  @override
  String get quote => '引用';

  @override
  String get code => 'コード';

  @override
  String get spoiler => 'ネタバレ';

  @override
  String get bulletList => '箇条書きリスト';

  @override
  String get numberedList => '番号付きリスト';

  @override
  String get listItem => 'リスト項目';

  @override
  String participants(int count) {
    return '参加者 ($count)';
  }

  @override
  String get enterKeywordsToSearchTopics => 'トピックを検索するキーワードを入力...';

  @override
  String get pleaseFillInAllRequiredFields => 'すべての必須フィールドに入力してください';

  @override
  String get undelete => '復元';

  @override
  String get signInToViewUnreadTopics => '未読トピックを表示するにはログインしてください';

  @override
  String get youNeedToBeSignedInToViewUnreadTopics =>
      '未読トピックを表示するにはログインする必要があります';

  @override
  String get signInToViewSubscribedTopics => '購読トピックを表示するにはログインしてください';

  @override
  String get youNeedToBeSignedInToViewSubscribedTopics =>
      '購読トピックを表示するにはログインする必要があります';

  @override
  String get signInToViewParticipatedTopics => '参加トピックを表示するにはログインしてください';

  @override
  String get youNeedToBeSignedInToViewParticipatedTopics =>
      '参加したトピックを表示するにはログインする必要があります';

  @override
  String get signInToViewLatestTopics => '最新トピックを表示するにはログインしてください';

  @override
  String get youNeedToBeSignedInToViewLatestTopics =>
      '最新トピックを表示するにはログインする必要があります';

  @override
  String get markAsUnread => '未読としてマーク';

  @override
  String get invite => '招待';

  @override
  String get welcomeBack => 'おかえりなさい！';

  @override
  String get signInToAccessYourProfile => 'ログインしてプロフィールにアクセスし、アカウントを管理してください';

  @override
  String get enterYourUsername => 'ユーザー名を入力してください';

  @override
  String get enterYourPassword => 'パスワードを入力してください';

  @override
  String get dontHaveAnAccount => 'アカウントをお持ちでないですか？';

  @override
  String get refresh => '更新';

  @override
  String get share => '共有';

  @override
  String get viewOnWeb => 'Webで表示';

  @override
  String get unlock => 'ロック解除';

  @override
  String get lock => 'ロック';

  @override
  String get stick => '固定';

  @override
  String get unstick => '固定解除';

  @override
  String get reply => '返信';

  @override
  String get vote => '投票';

  @override
  String votesCount(int count) {
    return '$count票';
  }

  @override
  String get pollClosed => '投票は終了しました';

  @override
  String pollEndsOn(String date) {
    return '$dateに終了';
  }

  @override
  String get voteToSeeResults => '投票して結果を見る';

  @override
  String get viewFullPoll => '投票を表示';

  @override
  String pollOptionsCount(int count) {
    return '$count件の選択肢';
  }

  @override
  String get reactedBy => 'リアクションした人';

  @override
  String likesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のいいね',
    );
    return '$_temp0';
  }

  @override
  String reactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'リアクション $count 件',
    );
    return '$_temp0';
  }

  @override
  String get showWhoReacted => 'タップでリアクションした人を表示。';

  @override
  String get react => 'リアクション';

  @override
  String get changeYourReaction => 'リアクションを変更';

  @override
  String get reactionsAll => 'すべて';

  @override
  String get reactionYou => 'あなた';

  @override
  String reactionFilterSemantics(String reaction, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$reaction、$count 人',
    );
    return '$_temp0';
  }

  @override
  String viewProfileOfUser(String username) {
    return '$username さんのプロフィールを見る';
  }

  @override
  String get enterKeywordsToFindTopicsAndPosts => 'キーワードを入力してトピックと投稿を検索';

  @override
  String get enterKeywordsOrDomainToFindForums => 'キーワードまたはドメインを入力してフォーラムを検索';

  @override
  String get enterKeywordsOrDomainNamesToFindForums =>
      'キーワードまたはドメイン名を入力してフォーラムを検索';

  @override
  String get language => '言語';

  @override
  String get systemDefault => 'システムデフォルト';

  @override
  String get followSystemLanguage => 'システムの言語に従う';

  @override
  String get appearance => '外観';

  @override
  String get followSystemTheme => 'システムのテーマに従う';

  @override
  String get light => 'ライト';

  @override
  String get dark => 'ダーク';

  @override
  String version(String version, String buildNumber) {
    return 'バージョン $version ($buildNumber)';
  }

  @override
  String get forumSettings => 'フォーラム設定';

  @override
  String get noSettingsAvailable => '設定が利用できません';

  @override
  String get settingsCategoriesWillAppearHere => '設定カテゴリは利用可能になるとここに表示されます。';

  @override
  String get spamCleaner => 'スパムクリーナー';

  @override
  String get unableToLoadProfile => 'プロフィールを読み込めません';

  @override
  String get banned => '禁止';

  @override
  String get sendMessage => 'メッセージを送信';

  @override
  String get showMore => 'もっと見る';

  @override
  String get reportUser => 'ユーザーを報告';

  @override
  String get submitReport => '報告を送信';

  @override
  String get reportSubmittedSuccessfully => '報告が正常に送信されました';

  @override
  String get failedToSubmitReport => '報告の送信に失敗しました';

  @override
  String get searchForForums => 'フォーラムを検索';

  @override
  String get searchForums => 'フォーラムを検索';

  @override
  String get deleteTopic => 'トピックを削除';

  @override
  String get softDelete => 'ソフト削除';

  @override
  String get topicCanBeRestoredLater => 'トピックは後で復元できます';

  @override
  String get hardDelete => '完全削除';

  @override
  String get topicWillBePermanentlyDeleted => 'トピックは完全に削除されます';

  @override
  String get reasonForDeletion => '削除理由';

  @override
  String get enterReasonForDeletingTopic => 'このトピックを削除する理由を入力してください';

  @override
  String get pleaseEnterReasonForDeletion => '削除理由を入力してください';

  @override
  String get pleaseSelectEndDate => '終了日を選択してください';

  @override
  String get banUser => 'ユーザーを禁止';

  @override
  String get userBannedSuccessfully => 'ユーザーが正常に禁止されました';

  @override
  String get failedToBanUser => 'ユーザーの禁止に失敗しました';

  @override
  String get userUnbannedSuccessfully => 'ユーザーの禁止が正常に解除されました';

  @override
  String get failedToUnbanUser => 'ユーザーの禁止解除に失敗しました';

  @override
  String get spamCleanUser => 'ユーザーのスパムをクリーンアップ';

  @override
  String get deletePrivateConversations => 'プライベート会話を削除';

  @override
  String get banTheUserAccount => 'ユーザーアカウントを禁止';

  @override
  String get cleanSpam => 'スパムをクリーンアップ';

  @override
  String get handledThreads => '処理されたスレッド';

  @override
  String get deletedMessages => '削除されたメッセージ';

  @override
  String get deletedConversations => '削除された会話';

  @override
  String get bannedUser => '禁止されたユーザー';

  @override
  String successfullyCleanedSpam(String username, String actions) {
    return '$usernameのスパムが正常にクリーンアップされました。アクション: $actions';
  }

  @override
  String errorLoadingMessage(String error) {
    return 'メッセージの読み込みエラー: $error';
  }

  @override
  String get messageNotFound => 'メッセージが見つかりません';

  @override
  String get home => 'ホーム';

  @override
  String get notifications => '通知';

  @override
  String get forums => 'フォーラム';

  @override
  String get markAllForumsAsRead => 'すべてのフォーラムを既読にしますか？';

  @override
  String get markAllForumsAsReadMessage =>
      'これにより、すべてのフォーラムとトピックが既読としてマークされます。この操作は元に戻せません。';

  @override
  String get markAsRead => '既読にする';

  @override
  String get content => 'コンテンツ';

  @override
  String get insertImage => '画像を挿入';

  @override
  String get howWouldYouLikeToInsertImage => 'この画像をどのように挿入しますか？';

  @override
  String get thumbnail => 'サムネイル';

  @override
  String get fullSize => 'フルサイズ';

  @override
  String get alignLeft => '左揃え';

  @override
  String get alignCenter => '中央揃え';

  @override
  String get alignRight => '右揃え';

  @override
  String get pleaseEnterTitle => 'タイトルを入力してください';

  @override
  String get pleaseEnterContent => 'コンテンツを入力してください';

  @override
  String get uploading => 'アップロード中...';

  @override
  String get uploaded => 'アップロード済み';

  @override
  String get mentionUser => 'ユーザーをメンション';

  @override
  String get loggingIn => 'ログイン中...';

  @override
  String get submittingReport => 'レポート送信中...';

  @override
  String get banningUser => 'ユーザーを禁止中...';

  @override
  String get unbanningUser => 'ユーザーの禁止解除中...';

  @override
  String get cleaningSpam => 'スパムをクリーンアップ中...';

  @override
  String get enterSubject => '件名を入力';

  @override
  String get typeYourMessageHere => 'ここにメッセージを入力';

  @override
  String get writeYourMessage => 'メッセージを書く...';

  @override
  String get writeYourReply => '返信を書く...';

  @override
  String get messageSentSuccessfully => 'メッセージが正常に送信されました';

  @override
  String get replySentSuccessfully => '返信が正常に送信されました';

  @override
  String get conversationCreatedSuccessfully => '会話が正常に作成されました';

  @override
  String get conversationMarkedAsUnread => '会話が未読としてマークされました';

  @override
  String get messageMarkedAsUnread => 'メッセージが未読としてマークされました';

  @override
  String get conversationClosed => '会話が閉じられました';

  @override
  String get conversationOpened => '会話が開かれました';

  @override
  String get pleaseLoginToLikeMessages => 'メッセージにいいねするにはログインしてください';

  @override
  String get loadEarlierMessages => '以前のメッセージを読み込む';

  @override
  String failedToLoadQuote(String error) {
    return '引用の読み込みに失敗しました: \n$error';
  }

  @override
  String failedToUploadFile(String error) {
    return 'ファイルのアップロードに失敗しました: $error';
  }

  @override
  String failedToUploadImage(String error) {
    return '画像のアップロードに失敗しました: $error';
  }

  @override
  String failedToSendMessage(String error) {
    return 'メッセージの送信に失敗しました: $error';
  }

  @override
  String failedToSendReply(String error) {
    return '返信の送信に失敗しました: $error';
  }

  @override
  String failedToMarkAsUnread(String error) {
    return 'メッセージを未読としてマークできませんでした: $error';
  }

  @override
  String failedToMarkConversationAsUnread(String error) {
    return '会話を未読としてマークできませんでした: $error';
  }

  @override
  String failedToCloseConversation(String error) {
    return '会話を閉じることができませんでした: $error';
  }

  @override
  String failedToOpenConversation(String error) {
    return '会話を開くことができませんでした: $error';
  }

  @override
  String failedToJumpToMessage(String error) {
    return 'メッセージにジャンプできませんでした: $error';
  }

  @override
  String get goToTop => 'トップへ';

  @override
  String get goToBottom => 'ボトムへ';

  @override
  String get replyAll => '全員に返信';

  @override
  String get forward => '転送';

  @override
  String get noForumsFound => 'フォーラムが見つかりません。';

  @override
  String get pleaseSelectPrefix => 'プレフィックスを選択してください';

  @override
  String get pleaseLoginToAccessContent =>
      'このコンテンツにアクセスして投稿とやり取りするには、ログインしてください。';

  @override
  String get searchUsers => 'ユーザーを検索...';

  @override
  String get writeYourTitle => 'タイトルを書く...';

  @override
  String get writeYourContent => 'コンテンツを書く...';

  @override
  String get selectAnOption => 'オプションを選択';

  @override
  String get enterConversationTitle => '会話のタイトルを入力';

  @override
  String enterCode(int count) {
    return '$count桁のコードを入力';
  }

  @override
  String get edit => '編集';

  @override
  String get report => '報告';

  @override
  String get unfollow => 'フォロー解除';

  @override
  String get follow => 'フォロー';

  @override
  String get remove => '削除';

  @override
  String get subject => '件名';

  @override
  String get message => 'メッセージ';

  @override
  String get titleCannotBeEmpty => 'タイトルを入力してください';

  @override
  String get conversationUpdatedSuccessfully => '会話が正常に更新されました';

  @override
  String get goBack => '戻る';

  @override
  String get signInToViewMessages => 'メッセージを表示するにはログインしてください';

  @override
  String get privateMessagesNotAvailable => 'プライベートメッセージは利用できません';

  @override
  String failedToLoadPost(String error) {
    return '投稿の読み込みに失敗しました: \n$error';
  }

  @override
  String failedToLikeOrUnlikeMessage(String action, String error) {
    return 'メッセージの$actionに失敗しました: $error';
  }

  @override
  String get like => 'いいね';

  @override
  String get unlike => 'いいねを取り消す';

  @override
  String get optimizeImage => '画像を最適化';

  @override
  String get optimizeAndUpload => '最適化してアップロード';

  @override
  String downloading(String filename) {
    return '$filenameをダウンロード中...';
  }

  @override
  String openingShareSheet(String filename) {
    return '$filenameの共有シートを開いています';
  }

  @override
  String errorDownloading(String filename, String error) {
    return '$filenameのダウンロードエラー: $error';
  }

  @override
  String get enterANumber => '数字を入力';

  @override
  String get failedToNavigateToForum => 'フォーラムへの移動に失敗しました';

  @override
  String failedToNavigateToForumName(String forumName) {
    return '$forumNameへの移動に失敗しました';
  }

  @override
  String get failedToSaveConversation => '会話の保存に失敗しました';

  @override
  String forumNotFound(String forumName) {
    return 'フォーラムが見つかりません: $forumName';
  }

  @override
  String forumNotFoundById(String forumId) {
    return 'フォーラムが見つかりません: $forumId';
  }

  @override
  String couldNotOpenLink(String error) {
    return 'リンクを開けませんでした: $error';
  }

  @override
  String get likePost => 'いいね';

  @override
  String get unlikePost => 'いいねを取り消す';

  @override
  String get showLikes => 'いいねを表示';

  @override
  String get quotePost => '投稿を引用';

  @override
  String get attachFile => 'ファイルを添付';

  @override
  String get uploadImage => '画像をアップロード';

  @override
  String get translate => '翻訳';

  @override
  String get showOriginal => '原文を表示';

  @override
  String get translating => '翻訳中...';

  @override
  String get translated => '翻訳済み';

  @override
  String get translatedContent => '翻訳されたコンテンツ';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get translateTo => '翻訳先:';

  @override
  String get deviceLanguage => 'デバイスの言語';

  @override
  String get noPostsToTranslate => '翻訳する投稿がありません';

  @override
  String get translationFailed => '翻訳に失敗しました';

  @override
  String get twoFactorAuthentication => '2 要素認証';

  @override
  String get authenticationCodeLabel => '認証コード';

  @override
  String get pleaseEnterYourAuthenticationCode => '認証コードを入力してください';

  @override
  String codeMustBeDigits(int count) {
    return 'コードは $count 桁で入力してください';
  }

  @override
  String get codeMustContainOnlyNumbers => 'コードは数字のみを含めてください';

  @override
  String get verifyButton => '確認';

  @override
  String get attachments => '添付ファイル';

  @override
  String get replyOptions => '返信オプション';

  @override
  String get replyWithQuote => '引用して返信';

  @override
  String fileSavedToDownloads(String filename) {
    return 'ファイルをダウンロードに保存しました: $filename';
  }

  @override
  String fileSavedToDocuments(String filename) {
    return 'ファイルをドキュメントに保存しました: $filename';
  }

  @override
  String get discardPostQuestion => '投稿を破棄しますか？';

  @override
  String get discardChangesQuestion => '変更を破棄しますか？';

  @override
  String get discard => '破棄';

  @override
  String get discardChanges => '変更を破棄';

  @override
  String get notificationsTab => '通知';

  @override
  String get postAwaitingApproval => 'モデレーターが承認すると、投稿が表示されます。';

  @override
  String get reactionHoldHint => '長押しでほかのリアクション';

  @override
  String get turnOnNotifications => '通知をオンにする';

  @override
  String get notNow => 'あとで';

  @override
  String neverMissAReplyOn(Object forumName) {
    return '$forumName の返信を見逃さない';
  }

  @override
  String get notificationPreviewNow => '今';

  @override
  String get notificationPreviewEarlier => '5分前';

  @override
  String get notificationPreviewReply => 'Jane があなたに返信しました：ようこそ！見つけてくれてうれしいです。';

  @override
  String get notificationPreviewMessage => 'Sam からメッセージ：金曜日は来ますか？';

  @override
  String get notificationsAreTurnedOffForThisApp => 'このアプリの通知はオフになっています';

  @override
  String get deviceWillNotShowAlertsUntilAllowedInSettings =>
      '設定で通知を許可するまで、この端末には通知が表示されません。';

  @override
  String get openSettings => '設定を開く';

  @override
  String get notificationsPitchForum => '返信、メンション、ダイレクトメッセージをロック画面ですぐにお知らせします。';

  @override
  String get viewProfile => 'プロフィールを見る';

  @override
  String get settings => '設定';

  @override
  String get signOut => 'サインアウト';

  @override
  String get changeEmail => 'メールアドレスを変更';

  @override
  String get changePassword => 'パスワードを変更';

  @override
  String get save => '保存';

  @override
  String get currentPassword => '現在のパスワード';

  @override
  String get newPassword => '新しいパスワード';

  @override
  String get confirmNewPassword => '新しいパスワード（確認）';

  @override
  String get newEmailAddress => '新しいメールアドレス';

  @override
  String get emailChanged => 'メールアドレスを変更しました';

  @override
  String get emailChangeConfirm => '受信トレイを確認してください。確認すると新しいアドレスが有効になります。';

  @override
  String get passwordChanged => 'パスワードを変更しました';

  @override
  String get account => 'アカウント';

  @override
  String get pleaseEnterEmail => 'メールアドレスを入力してください';

  @override
  String get pleaseEnterValidEmail => '有効なメールアドレスを入力してください';

  @override
  String get passwordsDoNotMatch => 'パスワードが一致しません';

  @override
  String get connectionErrorTitle => '接続エラー';

  @override
  String get authenticationErrorTitle => '認証エラー';

  @override
  String get permissionErrorTitle => '権限エラー';

  @override
  String get errorNoConnection => 'インターネットに接続されていません。ネットワーク設定を確認してください。';

  @override
  String get errorTimeout => 'リクエストがタイムアウトしました。もう一度お試しください。';

  @override
  String get errorServer => 'サーバーエラーが発生しました。しばらくしてからもう一度お試しください。';

  @override
  String get errorNetwork => 'ネットワークエラーが発生しました。もう一度お試しください。';

  @override
  String get errorInvalidCredentials => 'ユーザー名またはパスワードが正しくありません。';

  @override
  String get errorSessionExpired => 'セッションの有効期限が切れました。もう一度ログインしてください。';

  @override
  String get errorAccountLocked => 'アカウントがロックされています。サポートにお問い合わせください。';

  @override
  String get errorAuthFailed => '認証に失敗しました。もう一度お試しください。';

  @override
  String get errorForumNotFound => 'フォーラムが見つかりません。';

  @override
  String get errorForumAccessDenied => 'このフォーラムにアクセスする権限がありません。';

  @override
  String get errorForumUnavailable => 'フォーラムは現在利用できません。しばらくしてからもう一度お試しください。';

  @override
  String get errorForumGeneric => 'フォーラムでエラーが発生しました。もう一度お試しください。';

  @override
  String get errorDataNotFound => '要求されたデータが見つかりません。';

  @override
  String get errorDataCorrupted => 'データが破損しているようです。ページを更新してください。';

  @override
  String get errorCache => 'キャッシュデータを読み込めませんでした。もう一度お試しください。';

  @override
  String get errorInvalidInput => '入力内容に無効なものがあります。';

  @override
  String get errorRequiredField => '必須項目をすべて入力してください。';

  @override
  String get errorPermissionDenied => 'この操作を行う権限がありません。';

  @override
  String errorFeatureNotAvailable(String feature) {
    return 'このフォーラムでは$featureを利用できません。';
  }

  @override
  String get errorStorageFull => 'ストレージがいっぱいです。空き容量を確保してください。';

  @override
  String get errorStorageAccessDenied => 'ストレージへのアクセスが拒否されました。アプリの権限を確認してください。';

  @override
  String get loginInfo => 'ログイン情報';

  @override
  String get loginFailed => 'ログインに失敗しました';

  @override
  String get topicAnnouncement => 'お知らせ';

  @override
  String get topicPinned => 'ピン留め';

  @override
  String get topicLocked => 'ロック中';

  @override
  String get topicPoll => '投票';

  @override
  String get deletedBadge => '削除済み';

  @override
  String get protectedBadge => '保護';

  @override
  String get lockTopic => 'トピックをロック';

  @override
  String get unlockTopic => 'トピックのロックを解除';

  @override
  String get lockTopicConfirm => 'このトピックをロックしてもよろしいですか？他のユーザーは返信や操作ができなくなります。';

  @override
  String get unlockTopicConfirm =>
      'このトピックのロックを解除してもよろしいですか？他のユーザーが再び返信や操作をできるようになります。';

  @override
  String get stickTopic => 'トピックを固定';

  @override
  String get unstickTopic => 'トピックの固定を解除';

  @override
  String get stickTopicConfirm =>
      'このトピックを固定してもよろしいですか？すべてのユーザーのフォーラム上部に表示されます。';

  @override
  String get unstickTopicConfirm =>
      'このトピックの固定を解除してもよろしいですか？フォーラムの上部に表示されなくなります。';

  @override
  String get undeleteTopic => 'トピックを復元';

  @override
  String get undeleteTopicConfirm => 'このトピックを復元してもよろしいですか？他のユーザーに再び表示されます。';

  @override
  String get additionalInformation => '追加情報';

  @override
  String get dateOfBirth => '生年月日';

  @override
  String get selectDateOfBirth => '生年月日を選択';

  @override
  String minimumAge(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: '最低年齢: $age歳',
    );
    return '$_temp0';
  }

  @override
  String get locationIsRequired => '所在地は必須です';

  @override
  String get receiveSiteMailings => 'サイトからのメールを受け取る';

  @override
  String iAcceptTheDocument(String document) {
    return '$documentに同意します';
  }

  @override
  String get termsOfService => '利用規約';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get imageExceedsUploadLimits => 'この画像はアップロードの上限を超えているため、最適化が必要です:';

  @override
  String get originalSize => '元のサイズ';

  @override
  String get originalDimensions => '元の寸法';

  @override
  String get optimizationsToBeApplied => '適用される最適化:';

  @override
  String get resizeImage => 'サイズ変更';

  @override
  String get convertFormat => '形式を変換';

  @override
  String get smallerFileSize => 'ファイルサイズ縮小';

  @override
  String get formatNotSupported => '非対応の形式';

  @override
  String get convertToJpgReason => 'JPG に変換（非対応の形式、またはサイズ縮小のため）';

  @override
  String get compressImage => '圧縮';

  @override
  String compressQuality(int quality) {
    return 'サイズ上限に収めるため品質 $quality%';
  }

  @override
  String get estimatedFinalSize => '推定最終サイズ';

  @override
  String sizeReduction(String percent) {
    return '削減率: $percent%';
  }

  @override
  String get pleaseLoginToCreateTopic => '新しいトピックを作成するにはログインしてください';

  @override
  String get pleaseLoginToSubscribeForums => 'フォーラムを購読するにはログインしてください';

  @override
  String get pleaseLoginToUnsubscribeForums => 'フォーラムの購読を解除するにはログインしてください';

  @override
  String errorLoadingContent(String error) {
    return 'コンテンツの読み込みエラー: $error';
  }

  @override
  String get noPermissionToViewSubforumTopics => 'このサブフォーラムのトピックを閲覧する権限がありません。';

  @override
  String get noDiscussionsYet => 'まだディスカッションはありません。';

  @override
  String get unableToLoadForums => 'フォーラムを読み込めません';

  @override
  String get noForumsAvailable => '利用できるフォーラムはありません';

  @override
  String get noForumsToDisplay => '表示するフォーラムがありません。権限またはフォーラムの構成が原因の可能性があります。';

  @override
  String get subscribedForums => '購読中のフォーラム';

  @override
  String get allForumTopicsMarkedRead => 'フォーラムのすべてのトピックを既読にしました';

  @override
  String postsCountFormatted(String count) {
    return '$count 件の投稿';
  }

  @override
  String get jumpToPost => '投稿へ移動';

  @override
  String get jump => '移動';

  @override
  String get endOfDiscussion => 'ディスカッションの終わり';

  @override
  String refreshFailed(String error) {
    return '更新に失敗しました: $error';
  }

  @override
  String get topicDeletedHidden => 'このトピックは削除されており、他のユーザーには表示されません';

  @override
  String get topicClosedNoReplies => 'このトピックはロックされており、返信できません';

  @override
  String get youAreSubscribedToTopic => 'このトピックを購読しています';

  @override
  String get refreshing => '更新中...';

  @override
  String get unableToLoadForumsTryAgain => 'フォーラムを読み込めませんでした。もう一度お試しください。';

  @override
  String get noPostableForums => '投稿できるフォーラムがありません。';

  @override
  String get changeForumQuestion => 'フォーラムを変更しますか？';

  @override
  String get changeForumRemovesAttachments =>
      '添付ファイルは選択したフォーラムに紐づいているため、フォーラムを変更するとアップロード済みの添付ファイルは削除されます。';

  @override
  String get changeForum => 'フォーラムを変更';

  @override
  String get chooseForumBeforePosting => '投稿する前にフォーラムを選択してください';

  @override
  String get accountCannotUploadAttachments =>
      'このサイトではお使いのアカウントで添付ファイルをアップロードできません。';

  @override
  String get forumNoAttachments => 'このフォーラムでは添付ファイルを使用できません。';

  @override
  String get forumNoAttachmentsChooseAnother =>
      'このフォーラムでは添付ファイルを使用できません。共有したファイルをアップロードするには別のフォーラムを選択してください。';

  @override
  String get forumNoAttachmentsSharedPending =>
      'このフォーラムでは添付ファイルを使用できません。別のフォーラムを選択するまで、共有したファイルは保留されます。';

  @override
  String get tapToChangeForum => 'タップしてフォーラムを変更';

  @override
  String get chooseWhichForum => '投稿先のフォーラムを選択してください';

  @override
  String get selectAForum => 'フォーラムを選択';

  @override
  String get unableToLoadForumsNow => '現在フォーラムを読み込めません。';

  @override
  String get pickForumBeforeUploading =>
      '添付ファイルをアップロードまたは投稿する前にフォーラムを選択してください。';

  @override
  String get uploadingSharedFiles => '共有したファイルをアップロード中...';

  @override
  String get selectForum => 'フォーラムを選択';

  @override
  String get noForumsMatchSearch => '検索に一致するフォーラムはありません。';

  @override
  String get unknown => '不明';

  @override
  String get closeConversationConfirm => 'この会話を閉じてもよろしいですか？新しい返信を送信できなくなります。';

  @override
  String get openConversationConfirm => 'この会話を開いてもよろしいですか？新しい返信を送信できるようになります。';

  @override
  String get leaveConversationConfirm => 'この会話から退出してもよろしいですか？受信トレイに表示されなくなります。';

  @override
  String get close => '閉じる';

  @override
  String get open => '開く';

  @override
  String get leave => '退出';

  @override
  String errorLoadingConversation(String error) {
    return '会話の読み込みエラー: $error';
  }

  @override
  String get conversationNotFound => '会話が見つかりません';

  @override
  String get conversationClosedNoReplies => 'この会話は閉じられており、返信できません';

  @override
  String get noMessagesFound => 'メッセージが見つかりません';

  @override
  String get endOfConversation => '会話の終わり';

  @override
  String get jumpToMessage => 'メッセージへ移動';

  @override
  String get jumpToFirstMessage => '最初のメッセージへ移動';

  @override
  String get jumpToLastMessage => '最後のメッセージへ移動';

  @override
  String messagePositionOf(int position, int total) {
    return 'メッセージ $position/$total';
  }

  @override
  String get tapToJumpToMessage => 'タップして特定のメッセージへ移動';

  @override
  String failedToReact(String error) {
    return 'リアクションに失敗しました: $error';
  }

  @override
  String participantCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '参加者 $count 人',
    );
    return '$_temp0';
  }

  @override
  String get noImagesToDisplay => '表示する画像がありません。';

  @override
  String get pleaseLoginToViewAttachment => 'この添付ファイルを表示するにはログインしてください';

  @override
  String get inbox => '受信トレイ';

  @override
  String get sent => '送信済み';

  @override
  String errorLoadingMessages(String error) {
    return 'メッセージの読み込みエラー: $error';
  }

  @override
  String get noInboxMessages => '受信メッセージはありません';

  @override
  String get noSentMessages => '送信済みメッセージはありません';

  @override
  String get unknownDate => '日付不明';

  @override
  String get searchForTopics => 'トピックを検索';

  @override
  String get noTopicsFound => 'トピックが見つかりません';

  @override
  String get noPostsFound => '投稿が見つかりません';

  @override
  String get trySearchingDifferentKeywords => '別のキーワードで検索してみてください';

  @override
  String errorLoadingSettings(String error) {
    return '設定の読み込みエラー: $error';
  }

  @override
  String get pleaseEnterValidNumber => '有効な数値を入力してください';

  @override
  String valueMustBeAtLeast(String min) {
    return '$min 以上の値を入力してください';
  }

  @override
  String valueMustBeAtMost(String max) {
    return '$max 以下の値を入力してください';
  }

  @override
  String maximumLengthCharacters(int max) {
    return '最大 $max 文字までです';
  }

  @override
  String get invalidFormat => '形式が正しくありません';

  @override
  String get shareToForumCopilot => 'Forum Copilot に共有';

  @override
  String get noSavedForumAccounts => '保存されたフォーラムアカウントがありません。';

  @override
  String get addForumAccountFirst =>
      'まず Forum Copilot でフォーラムアカウントを追加してから、もう一度共有してください。';

  @override
  String filesReadyToAttach(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '添付できるファイル $count 件',
    );
    return '$_temp0';
  }

  @override
  String get sharedTextWillBePrefilled => '共有したテキストが入力されます';

  @override
  String errorSearchingForums(String error) {
    return 'フォーラム検索エラー: $error';
  }

  @override
  String failedToLoadUserInfo(String error) {
    return 'ユーザー情報を読み込めませんでした: $error';
  }

  @override
  String areYouSureUnban(String username) {
    return '$username の禁止を解除してもよろしいですか？';
  }

  @override
  String get deletePostsProfilePostsComments => '投稿、プロフィール投稿、コメントを削除';

  @override
  String areYouSureSpamClean(String username) {
    return '$username のスパムを一掃してもよろしいですか？';
  }

  @override
  String successfullyCleanedSpamFor(String username) {
    return '$username のスパムを一掃しました';
  }

  @override
  String get failedToCleanSpam => 'スパムを一掃できませんでした';

  @override
  String imagesCount(int count) {
    return '画像 ($count)';
  }

  @override
  String get pleaseLoginToViewProfiles => 'ユーザープロフィールを表示するにはログインしてください。';

  @override
  String get tapToOpen => 'タップして開く';

  @override
  String get imageNotAvailable => '画像を表示できません';

  @override
  String get tapToViewFullSizeImage => 'タップして画像を原寸で表示';

  @override
  String get loadingImage => '画像を読み込み中...';

  @override
  String loadingImageFrom(String host) {
    return '$host から画像を読み込み中';
  }

  @override
  String get tapToReveal => '（タップして表示）';

  @override
  String get inlineAttachments => 'インライン添付ファイル';

  @override
  String get thisFieldIsRequired => 'この項目は必須です';

  @override
  String get pleaseEnterValidPhoneNumber => '有効な電話番号を入力してください';

  @override
  String get pleaseEnterValidUrl => '有効な URL を入力してください';

  @override
  String get permissionDeniedToSaveImage => '画像を保存する権限がありません';

  @override
  String get postNotFound => '投稿が見つかりません。';

  @override
  String get failedToUploadFileTryAgain => 'ファイルをアップロードできませんでした。もう一度お試しください。';

  @override
  String get failedToPickFile => 'ファイルを選択できませんでした';

  @override
  String onlyMoreAttachmentsAllowed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '添付できるのはあと $count 件です。最初の $count 枚の画像を使用します。',
    );
    return '$_temp0';
  }

  @override
  String get attachmentLimitReachedSkipping =>
      '添付ファイルの上限に達しました。残りの画像はスキップされます。';

  @override
  String get imageValidationFailed => '画像の検証に失敗しました';

  @override
  String get imageUploadFailed => '画像をアップロードできませんでした';

  @override
  String get failedToUploadImageTryAgain => '画像をアップロードできませんでした。もう一度お試しください。';

  @override
  String get failedToPickImage => '画像を選択できませんでした';

  @override
  String get prefix => 'プレフィックス';

  @override
  String get failedToLoadPrefixes => 'プレフィックスを読み込めませんでした';

  @override
  String get attachFileHint => 'このメッセージにファイルを添付';

  @override
  String get uploadImageHint => 'このメッセージに画像をアップロード';

  @override
  String get openFormattingOptions => '書式オプションを開く';

  @override
  String get failedToPostReply => '返信を投稿できませんでした。もう一度お試しください。';

  @override
  String get failedToUpdatePost => '投稿を更新できませんでした。もう一度お試しください。';

  @override
  String get postDeletedSuccessfully => '投稿を削除しました';

  @override
  String failedToDeletePost(String error) {
    return '投稿を削除できませんでした: $error';
  }

  @override
  String get noPermissionToUploadAvatars => 'アバターをアップロードする権限がありません';

  @override
  String get avatarUploadedSuccessfully => 'アバターをアップロードしました';

  @override
  String get unknownTopic => '不明なトピック';

  @override
  String get connectionTimeoutTitle => '接続タイムアウト';

  @override
  String connectionTimedOutTo(String siteName) {
    return '$siteName への接続がタイムアウトしました。インターネット接続を確認して、もう一度お試しください。';
  }

  @override
  String failedToConnectCheckPlugin(String siteName) {
    return '$siteName に接続できませんでした。フォーラムが利用可能で、プラグインがインストールされているか確認してください。';
  }

  @override
  String get voteFailedTryAgain => '投票できませんでした。もう一度お試しください。';

  @override
  String get noUserSpecified => 'ユーザーが指定されていません';

  @override
  String get failedToLoadRecentPosts => '最近の投稿を読み込めませんでした';

  @override
  String failedToLoadPreview(String error) {
    return 'プレビューを読み込めませんでした: $error';
  }

  @override
  String thanksCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 人が感謝',
    );
    return '$_temp0';
  }

  @override
  String get thankedBy => '感謝したメンバー';

  @override
  String maximumAttachmentsAllowed(int count) {
    return '添付できるファイルは最大$count件です';
  }

  @override
  String get toLabel => '宛先';

  @override
  String get closeConversation => '会話を閉じる';

  @override
  String get openConversation => '会話を開く';

  @override
  String get loginSucceeded => 'ログインしました';

  @override
  String get verificationErrorTryAgain => '確認中にエラーが発生しました。もう一度お試しください。';

  @override
  String get passkeyChallengeFailed => 'パスキーでのログインを開始できませんでした。';

  @override
  String get passkeyNotSetUp =>
      'このフォーラムはまだこのアプリでのパスキーに対応していません。ユーザー名とパスワードでログインしてください。';

  @override
  String get noPasskeyForForum =>
      'このフォーラムのパスキーが見つかりません。パスワードでログインするか、先にフォーラムのウェブサイトでパスキーを作成してください。';

  @override
  String get pushNotificationsNotReady => 'プッシュ通知の準備ができていません';

  @override
  String pushEnabledFor(String siteName) {
    return '$siteName のプッシュ通知をオンにしました';
  }

  @override
  String get failedToEnablePush => 'プッシュ通知をオンにできませんでした';

  @override
  String get failedToRegisterPush => 'プッシュ通知の登録に失敗しました';

  @override
  String translatedFromTo(String source, String target) {
    return '$source から $target に翻訳';
  }

  @override
  String get unableToOpenNotification => '通知を開けません';

  @override
  String get notificationMissingInfo => 'この通知には必要な情報がありません。';

  @override
  String get couldNotOpenForum => 'フォーラムを開けませんでした。';

  @override
  String get notificationChannelName => 'Forum Copilot の通知';

  @override
  String get notificationChannelDescription => 'Forum Copilot アプリの通知';

  @override
  String fileTypeNotAllowed(String extension, String allowed) {
    return 'ファイル形式 .$extension は使用できません。使用できる形式: $allowed';
  }

  @override
  String fileSizeExceedsMaximum(String size, String max) {
    return 'ファイルサイズ ($size) が上限の $max を超えています';
  }

  @override
  String get fileTypeAudio => '音声';

  @override
  String get fileTypeText => 'テキスト';

  @override
  String get fileTypeArchive => 'アーカイブ';

  @override
  String get fileTypeFile => 'ファイル';

  @override
  String get imageFileNotFound => '画像ファイルが見つかりません。移動または削除された可能性があります。';

  @override
  String get imagePermissionDenied => '権限がありません。画像ファイルを読み取れません。';

  @override
  String get imageInsufficientSpace => '画像を最適化するための空き容量が足りません。';

  @override
  String cannotAccessImageFile(String error) {
    return '画像ファイルにアクセスできません: $error';
  }

  @override
  String get imageFormatUnsupported => '画像形式が破損しているか、対応していません。別の画像をお試しください。';

  @override
  String get failedToResizeImage =>
      '画像のサイズを変更できませんでした。画像が破損しているか、対応していない形式の可能性があります。';

  @override
  String get failedToConvertImageToJpg =>
      '画像を JPG に変換できませんでした。画像が破損している可能性があります。';

  @override
  String get failedToCompressImage =>
      '画像を圧縮できませんでした。空き容量が不足しているか、画像が破損している可能性があります。';

  @override
  String get cannotDecodeImage =>
      '画像をデコードできません。ファイルが破損しているか、対応していない形式の可能性があります。';

  @override
  String get cannotReadImageFile => '画像ファイルを読み取れません。移動または削除された可能性があります。';

  @override
  String failedToOptimizeImage(String error) {
    return '画像を最適化できませんでした: $error';
  }

  @override
  String emailCopiedToClipboard(String email) {
    return 'メールアドレスをクリップボードにコピーしました: $email';
  }

  @override
  String couldNotOpenEmail(String email) {
    return 'メールを開けませんでした: $email';
  }

  @override
  String get editPost => '投稿を編集';

  @override
  String get thisTopicIsPinnedToTopOfForum => 'このトピックはフォーラムの上部に固定されています';

  @override
  String get editConversation => '会話を編集';

  @override
  String get failedToLoadConversation => '会話の読み込みに失敗しました';

  @override
  String get cannotEditConversation => 'この会話は編集できません';

  @override
  String get titleLabel => 'タイトル';

  @override
  String get options => 'オプション';

  @override
  String get openInvite => '招待を開放';

  @override
  String get allowAnyParticipantToInviteOthers => '参加者が他のユーザーを招待できるようにする';

  @override
  String get conversationOpen => '会話を開く';

  @override
  String failedToCreateConversation(String error) {
    return '会話の作成に失敗しました: $error';
  }

  @override
  String get lockConversation => '会話をロック';

  @override
  String get createConversationAsClosed => '会話を閉じた状態で作成（返信不可）';

  @override
  String get deleteAccount => 'アカウントを削除';

  @override
  String get deleteAccountDescription => 'このフォーラムからあなたのアカウントを削除します。';

  @override
  String get deleteAccountContactForumMessage =>
      'アカウントはフォーラム側で管理されています。アカウント削除はフォーラムへ直接お問い合わせください。フォーラムホーム下部の「お問い合わせ」ボタンをご利用ください。';

  @override
  String get forumUrlUnavailable => 'フォーラムURLを利用できません。';

  @override
  String get couldNotOpenForumUrl => 'フォーラムURLを開けませんでした。';

  @override
  String get noActionUrlAvailableForThisNotificationType =>
      'この通知タイプには利用可能なアクション URL がありません。';

  @override
  String get signInToViewNotifications => '通知を表示するにはサインインしてください';

  @override
  String get youNeedToBeSignedInToViewYourNotifications =>
      '通知を表示するにはサインインが必要です。';

  @override
  String get errorLoadingNotifications => '通知の読み込みエラー';

  @override
  String get pullDownToRefresh => '下に引いて更新';

  @override
  String get youHaveNoNewNotificationsCheckBackLater =>
      '新しい通知はありません。後でもう一度ご確認ください。';

  @override
  String get signInToViewProfile => 'プロフィールを表示するにはサインインしてください';

  @override
  String get youNeedToBeSignedInToViewYourProfile => 'プロフィールを表示するにはサインインが必要です。';

  @override
  String get emailLabel => 'メールアドレス';

  @override
  String get confirmPasswordLabel => 'パスワードを確認';

  @override
  String get protectedForum => '保護されたフォーラム';

  @override
  String forumIsPasswordProtected(String forumName) {
    return '$forumName はパスワードで保護されています。';
  }

  @override
  String get enterButton => '入力';

  @override
  String get recentPosts => '最近の投稿';

  @override
  String passkeyNotAvailableInForum(int code) {
    return 'このフォーラムでは現在パスキーを利用できません（コード: $code）';
  }

  @override
  String get initializingForum => 'フォーラムを準備中…';

  @override
  String get retryConnection => '再接続';

  @override
  String get pleaseConfirmPassword => 'パスワードを確認してください';

  @override
  String get pleaseEnterTheForumPassword => 'フォーラムのパスワードを入力してください';

  @override
  String get editYourPost => '投稿を編集...';

  @override
  String get topicIdIsMissingCannotNavigateToThePost =>
      'トピック ID がありません。投稿に移動できません。';

  @override
  String get conversationIsOpenForReplies => 'この会話は返信可能です';

  @override
  String get conversationIsClosedNoRepliesAllowed => 'この会話は閉じています（返信できません）';

  @override
  String get pleaseEnterAUsername => 'ユーザー名を入力してください';

  @override
  String usernameMinLength(int count) {
    return 'ユーザー名は $count 文字以上にしてください';
  }

  @override
  String get pleaseEnterAPassword => 'パスワードを入力してください';

  @override
  String passwordMinLength(int count) {
    return 'パスワードは $count 文字以上にしてください';
  }

  @override
  String get writeYourTopicTitle => 'トピックのタイトルを入力...';

  @override
  String get writeYourTopicContent => 'トピックの内容を入力...';

  @override
  String pushDisabledFor(String siteName) {
    return '$siteName のプッシュ通知をオフにしました';
  }

  @override
  String get failedToDisablePush => 'プッシュ通知をオフにできませんでした';

  @override
  String get thisForum => 'このフォーラム';

  @override
  String get openFullEditor => 'フルエディター';
}
