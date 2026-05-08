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
  String get dismiss => '閉じる';

  @override
  String get cancel => 'キャンセル';

  @override
  String get tryAgain => '再試行';

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
  String get signInToViewLatestTopics => '最新トピックを表示するにはログインしてください';

  @override
  String get youNeedToBeSignedInToViewLatestTopics =>
      '最新トピックを表示するにはログインする必要があります';

  @override
  String get noUnreadTopics => '未読トピックなし';

  @override
  String get thereAreNoUnreadTopics => '未読トピックがありません。後で新しいディスカッションを確認してください。';

  @override
  String get youAreAllCaughtUp => 'すべて確認済みです！';

  @override
  String get signInToViewUnreadTopics => '未読トピックを表示するにはログインしてください';

  @override
  String get youNeedToBeSignedInToViewUnreadTopics =>
      '未読トピックを表示するにはログインする必要があります';

  @override
  String get noSubscribedTopics => '購読トピックなし';

  @override
  String get noSubscribedTopicsMessage =>
      'トピックを購読していません。トピックの星ボタンをタップして購読し、新しい更新の通知を受け取ります。';

  @override
  String get signInToViewSubscribedTopics => '購読トピックを表示するにはログインしてください';

  @override
  String get youNeedToBeSignedInToViewSubscribedTopics =>
      '購読トピックを表示するにはログインする必要があります';

  @override
  String get noParticipatedTopics => '参加トピックなし';

  @override
  String get topicsYouParticipatedIn => '参加したトピックがここに表示されます。';

  @override
  String get signInToViewParticipatedTopics => '参加トピックを表示するにはログインしてください';

  @override
  String get youNeedToBeSignedInToViewParticipatedTopics =>
      '参加したトピックを表示するにはログインする必要があります';

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
  String get language => '言語';

  @override
  String get systemDefault => 'システムデフォルト';

  @override
  String get followSystemLanguage => 'システムの言語に従う';

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
  String get softDelete => 'ソフト削除';

  @override
  String get postCanBeRestoredLater => '投稿は後で復元できます';

  @override
  String get hardDelete => '完全削除';

  @override
  String get postWillBePermanentlyDeleted => '投稿は完全に削除されます';

  @override
  String get reasonForDeletion => '削除理由';

  @override
  String get enterReasonForDeletingPost => 'この投稿を削除する理由を入力してください';

  @override
  String get pleaseEnterReasonForDeletion => '削除理由を入力してください';

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
  String get submitReport => '報告を送信';

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
  String get reportUser => 'ユーザーを報告';

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
  String get banUser => 'ユーザーを禁止';

  @override
  String get unbanUser => 'ユーザーの禁止を解除';

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
  String get moreOptions => 'その他のオプション';

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
  String get handleThreads => 'スレッドを処理';

  @override
  String get deleteMessages => 'メッセージを削除';

  @override
  String get deleteConversations => '会話を削除';

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
  String get spamCleaner => 'スパムクリーナー';

  @override
  String get sendMessage => 'メッセージを送信';

  @override
  String get memberSince => 'メンバー登録日';

  @override
  String get lastActivity => '最終アクティビティ';

  @override
  String get likesReceived => '受け取ったいいね';

  @override
  String get likesGiven => '与えたいいね';

  @override
  String get showMore => 'もっと見る';

  @override
  String get cleanSpam => 'スパムをクリーンアップ';

  @override
  String get failedToSaveMessage => 'メッセージの保存に失敗しました';

  @override
  String get failedToSaveConversation => '会話の保存に失敗しました';

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
  String get enterUsernameToSearch => '検索するユーザー名を入力...';

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
  String failedToThankPost(String error) {
    return '投稿に感謝できませんでした: $error';
  }

  @override
  String get signInToViewMessages => 'メッセージを表示するにはログインしてください';

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
  String get moveOrDeleteThreadsBasedOnAdminSettings =>
      '管理者設定に基づいてスレッドを移動または削除';

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
  String get attachFile => 'ファイルを添付';

  @override
  String get uploadImage => '画像をアップロード';

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
  String get enterKeywordsToSearchTopics => 'トピックを検索するキーワードを入力...';

  @override
  String get pleaseFillInAllRequiredFields => 'すべての必須フィールドに入力してください';

  @override
  String get undelete => '復元';

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
  String get enterKeywordsToFindTopicsAndPosts => 'キーワードを入力してトピックと投稿を検索';

  @override
  String get enterKeywordsOrDomainToFindForums => 'キーワードまたはドメインを入力してフォーラムを検索';

  @override
  String get enterKeywordsOrDomainNamesToFindForums =>
      'キーワードまたはドメイン名を入力してフォーラムを検索';

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
  String get unableToLoadProfile => 'プロフィールを読み込めません';

  @override
  String get banned => '禁止';

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
  String get topicCanBeRestoredLater => 'トピックは後で復元できます';

  @override
  String get topicWillBePermanentlyDeleted => 'トピックは完全に削除されます';

  @override
  String get enterReasonForDeletingTopic => 'このトピックを削除する理由を入力してください';

  @override
  String get pleaseSelectEndDate => '終了日を選択してください';

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
  String get goToForums => 'フォーラムへ';

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
  String get thankPost => '投稿に感謝';

  @override
  String get showLikes => 'いいねを表示';

  @override
  String get showThanks => '感謝を表示';

  @override
  String get quotePost => '投稿を引用';

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
}
