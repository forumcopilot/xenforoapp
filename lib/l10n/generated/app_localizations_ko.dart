// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Forum App';

  @override
  String get loginTitle => '로그인';

  @override
  String get usernameLabel => '사용자 이름';

  @override
  String get passwordLabel => '비밀번호';

  @override
  String get loginButton => '로그인';

  @override
  String get signInWithPasskey => 'Sign in with Passkey';

  @override
  String get usePasskey => 'Use Passkey';

  @override
  String get passkeyContinuePrompt => 'Use your passkey to continue';

  @override
  String get forgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get pleaseEnterUsername => '사용자 이름을 입력하세요';

  @override
  String get pleaseEnterPassword => '비밀번호를 입력하세요';

  @override
  String credentialsSentToDomain(String domain) {
    return '사용자 이름과 비밀번호가 $domain에 전송됩니다';
  }

  @override
  String get createAccount => '계정 만들기';

  @override
  String get alreadyHaveAccount => '이미 계정이 있으신가요? ';

  @override
  String get logIn => '로그인';

  @override
  String get continueButton => '계속';

  @override
  String get registrationNotAvailable => '등록 불가';

  @override
  String get registrationNotAvailableMessage =>
      '현재 등록이 불가능합니다. 포럼이 닫혀 있거나 등록이 비활성화되었을 수 있습니다.';

  @override
  String get webRegistrationRequired => '웹 등록 필요';

  @override
  String get webRegistrationRequiredMessage =>
      '이 포럼은 웹 브라우저를 통한 등록이 필요합니다. 아래 버튼을 클릭하여 등록 페이지를 열어주세요.';

  @override
  String get openRegistrationPage => '등록 페이지 열기';

  @override
  String get loadingAdditionalFields => '추가 필드 로드 중...';

  @override
  String get pleaseSelectDateOfBirth => '생년월일을 선택하세요';

  @override
  String get pleaseEnterLocation => '위치를 입력하세요';

  @override
  String get pleaseIndicateEmailPreference => '이메일 설정을 지정하세요';

  @override
  String get pleaseFillAllRequiredFields => '모든 필수 필드를 입력하세요';

  @override
  String get pleaseAcceptTermsOfService => '서비스 약관에 동의하세요';

  @override
  String get pleaseAcceptPrivacyPolicy => '개인정보 보호정책에 동의하세요';

  @override
  String get registrationError => '등록 오류';

  @override
  String get registrationFailed => '등록에 실패했습니다. 정보를 확인하세요.';

  @override
  String get registrationFailedTryAgain => '등록에 실패했습니다. 다시 시도하세요.';

  @override
  String get registrationInfo => '등록 정보';

  @override
  String get openWebsite => '웹사이트 열기';

  @override
  String couldNotOpenForumWebsite(String url) {
    return '포럼 웹사이트를 열 수 없습니다. 다음 주소를 방문해보세요: $url';
  }

  @override
  String get registrationSuccessfulEmailConfirm =>
      '등록 성공! 로그인하기 전에 이메일을 확인하여 계정을 인증하세요.';

  @override
  String get registrationSuccessfulPendingApproval =>
      '등록 성공! 계정이 승인 대기 중입니다. 계정이 승인되면 알림을 받으실 수 있습니다.';

  @override
  String get registrationSuccessfulAutoLogin => '등록 성공! 자동으로 로그인되었습니다.';

  @override
  String get welcome => '환영합니다!';

  @override
  String get registrationSuccessful => '등록 성공';

  @override
  String get pleaseLoginWithNewAccount => '새 계정으로 로그인하세요.';

  @override
  String get forgotPasswordTitle => '비밀번호 찾기';

  @override
  String get usernameOrEmailLabel => '사용자 이름 또는 이메일';

  @override
  String get pleaseEnterUsernameOrEmail => '사용자 이름 또는 이메일을 입력하세요';

  @override
  String get sendResetLink => '재설정 링크 보내기';

  @override
  String get resetLinkSent => '재설정 링크 전송됨';

  @override
  String get passwordResetInstructionsSent =>
      '비밀번호 재설정 안내가 등록된 이메일 주소로 전송되었습니다.';

  @override
  String get resetFailed => '재설정 실패';

  @override
  String get unableToSendResetLink => '재설정 링크를 보낼 수 없습니다. 다시 시도하세요.';

  @override
  String get errorSendingResetLink =>
      '재설정 링크 전송 중 오류가 발생했습니다. 연결을 확인하고 다시 시도하세요.';

  @override
  String get errorTitle => '오류';

  @override
  String get okButton => '확인';

  @override
  String get retryButton => '다시 시도';

  @override
  String get copyToClipboard => '클립보드에 복사';

  @override
  String get copied => '복사됨';

  @override
  String get errorMessageCopiedToClipboard => '오류 메시지가 클립보드에 복사되었습니다';

  @override
  String get dismiss => '닫기';

  @override
  String get cancel => '취소';

  @override
  String get tryAgain => '다시 시도';

  @override
  String get getHelp => '도움말 보기';

  @override
  String get somethingWentWrong => '문제가 발생했습니다';

  @override
  String get unexpectedErrorOccurred => '예기치 않은 오류가 발생했습니다. 다시 시도하세요.';

  @override
  String get noInternetConnection => '인터넷 연결 없음';

  @override
  String get checkInternetConnection => '인터넷 연결을 확인하고 다시 시도하세요.';

  @override
  String get authenticationRequired => '인증 필요';

  @override
  String get pleaseLoginToContinue => '계속하려면 로그인하세요.';

  @override
  String get forumError => '포럼 오류';

  @override
  String get anErrorOccurred => '오류가 발생했습니다';

  @override
  String get accountPendingApproval =>
      '계정이 승인 대기 중입니다. 포럼을 둘러볼 수 있지만 관리자가 계정을 승인할 때까지 게시할 수 없습니다.';

  @override
  String get checkEmailToConfirm =>
      '계정을 인증하려면 이메일을 확인하세요. 보낸 이메일의 인증 링크를 클릭하세요.';

  @override
  String get checkNewEmailToConfirm =>
      '변경 사항을 확인하려면 새 이메일 주소를 확인하세요. 새 이메일을 확인할 때까지 기존 이메일이 활성 상태로 유지됩니다.';

  @override
  String get emailAddressInvalid =>
      '이메일 주소가 유효하지 않거나 이메일을 거부하는 것 같습니다. 계정 설정에서 이메일 주소를 업데이트하세요.';

  @override
  String get accountDisabled => '계정이 비활성화되었습니다. 도움을 받으려면 관리자에게 문의하세요.';

  @override
  String get accountRegistrationRejected =>
      '계정 등록이 거부되었습니다. 자세한 내용은 관리자에게 문의하세요.';

  @override
  String get welcomeToForumCopilot => 'Forum Copilot에 오신 것을 환영합니다!';

  @override
  String get successfullyLoggedOut => '성공적으로 로그아웃되었습니다';

  @override
  String get accountStatusRequiresAttention =>
      '계정 상태에 주의가 필요합니다. 질문이 있으시면 관리자에게 문의하세요.';

  @override
  String get updateEmail => '이메일 업데이트';

  @override
  String get resend => '다시 보내기';

  @override
  String get noLatestTopics => '최신 주제 없음';

  @override
  String get noRecentTopicsToDisplay => '표시할 최신 주제가 없습니다. 나중에 새로운 토론을 확인하세요.';

  @override
  String get signInToViewLatestTopics => '최신 주제를 보려면 로그인하세요';

  @override
  String get youNeedToBeSignedInToViewLatestTopics => '최신 주제를 보려면 로그인해야 합니다';

  @override
  String get noUnreadTopics => '읽지 않은 주제 없음';

  @override
  String get thereAreNoUnreadTopics => '읽지 않은 주제가 없습니다. 나중에 새로운 토론을 확인하세요.';

  @override
  String get youAreAllCaughtUp => '모두 확인하셨습니다!';

  @override
  String get signInToViewUnreadTopics => '읽지 않은 주제를 보려면 로그인하세요';

  @override
  String get youNeedToBeSignedInToViewUnreadTopics => '읽지 않은 주제를 보려면 로그인해야 합니다';

  @override
  String get noSubscribedTopics => '구독한 주제 없음';

  @override
  String get noSubscribedTopicsMessage =>
      '주제를 구독하지 않았습니다. 주제의 별 버튼을 탭하여 구독하고 새 업데이트 알림을 받으세요.';

  @override
  String get signInToViewSubscribedTopics => '구독한 주제를 보려면 로그인하세요';

  @override
  String get youNeedToBeSignedInToViewSubscribedTopics =>
      '구독한 주제를 보려면 로그인해야 합니다';

  @override
  String get noParticipatedTopics => '참여한 주제 없음';

  @override
  String get topicsYouParticipatedIn => '참여한 주제가 여기에 표시됩니다.';

  @override
  String get signInToViewParticipatedTopics => '참여한 주제를 보려면 로그인하세요';

  @override
  String get youNeedToBeSignedInToViewParticipatedTopics =>
      '참여한 주제를 보려면 로그인해야 합니다';

  @override
  String get latest => '최신';

  @override
  String get unread => '읽지 않음';

  @override
  String get subscribed => '구독';

  @override
  String get participated => '참여';

  @override
  String get connectionTimedOut => '연결 시간 초과. 사이트가 다운되었거나 접근할 수 없을 수 있습니다.';

  @override
  String get failedToConnectToSite =>
      '사이트에 연결하지 못했습니다. 사이트가 다운되었거나 접근할 수 없을 수 있습니다.';

  @override
  String get connectionFailed => '연결 실패';

  @override
  String failedToConnectToSiteName(String siteName) {
    return '$siteName에 연결하지 못했습니다';
  }

  @override
  String get loading => '로드 중...';

  @override
  String get newConversation => '새 대화';

  @override
  String get newMessage => '새 메시지';

  @override
  String get appSettings => '앱 설정';

  @override
  String get searchSites => '사이트 검색';

  @override
  String get language => '언어';

  @override
  String get systemDefault => '시스템 기본값';

  @override
  String get followSystemLanguage => '시스템 언어 따르기';

  @override
  String get all => '전체';

  @override
  String get topicsOnly => '주제만';

  @override
  String get titlesOnly => '제목만';

  @override
  String failedToShareTopic(String error) {
    return '주제 공유 실패: $error';
  }

  @override
  String pleaseLoginToSubscribe(String action) {
    return '이 스레드를 $action하려면 로그인하세요';
  }

  @override
  String get subscribeTo => '구독';

  @override
  String get unsubscribeFrom => '구독 취소';

  @override
  String get subscribe => '구독';

  @override
  String get unsubscribe => '구독 취소';

  @override
  String failedToSubscribeToThread(String action) {
    return '스레드 $action 실패';
  }

  @override
  String get youCannotReplyToThisThread => '이 스레드에 답변할 수 없습니다';

  @override
  String get pleaseWaitForThreadToLoad => '스레드가 로드될 때까지 기다려주세요';

  @override
  String get softDelete => '소프트 삭제';

  @override
  String get postCanBeRestoredLater => '게시물은 나중에 복원할 수 있습니다';

  @override
  String get hardDelete => '완전 삭제';

  @override
  String get postWillBePermanentlyDeleted => '게시물이 영구적으로 삭제됩니다';

  @override
  String get reasonForDeletion => '삭제 이유';

  @override
  String get enterReasonForDeletingPost => '이 게시물을 삭제하는 사유를 입력하세요';

  @override
  String get pleaseEnterReasonForDeletion => '삭제 이유를 입력하세요';

  @override
  String get reportPost => '게시물 신고';

  @override
  String get pleaseProvideReasonForReporting => '이 게시물을 신고하는 사유를 제공하세요.';

  @override
  String get reason => '사유';

  @override
  String get enterReasonForReportingPost => '이 게시물을 신고하는 사유를 입력하세요';

  @override
  String get pleaseEnterReason => '사유를 입력하세요';

  @override
  String get submitReport => '신고 제출';

  @override
  String get selectedActions => '선택한 작업:';

  @override
  String get thisActionCannotBeUndone => '이 작업은 취소할 수 없습니다.';

  @override
  String get participantsLabel => '참가자';

  @override
  String usernameHasBeenInvited(String username) {
    return '$username님이 대화에 초대되었습니다';
  }

  @override
  String errorInvitingUser(String error) {
    return '사용자 초대 오류: $error';
  }

  @override
  String get newTopic => '새 주제';

  @override
  String get markRead => '읽음으로 표시';

  @override
  String get reportUser => '사용자 신고';

  @override
  String get pleaseSelectReasonForReportingUser => '이 사용자를 신고하는 사유를 선택하세요.';

  @override
  String get spamOrAdvertising => '스팸 또는 광고';

  @override
  String get harassmentOrBullying => '괴롭힘 또는 따돌림';

  @override
  String get inappropriateContent => '부적절한 콘텐츠';

  @override
  String get impersonationOrFakeAccount => '사칭 또는 가짜 계정';

  @override
  String get otherPleaseSpecify => '기타 (지정해주세요)';

  @override
  String get pleaseSpecifyReason => '사유를 지정하세요';

  @override
  String get enterReasonForReportingUser => '이 사용자를 신고하는 사유를 입력하세요';

  @override
  String get pleaseSelectReason => '사유를 선택하세요';

  @override
  String get banUser => '사용자 차단';

  @override
  String get unbanUser => '사용자 차단 해제';

  @override
  String pleaseSelectReasonForBanningUser(String username) {
    return '$username님을 차단하는 사유를 선택하세요';
  }

  @override
  String get violationOfCommunityGuidelines => '커뮤니티 가이드라인 위반';

  @override
  String get harassmentOrAbusiveBehavior => '괴롭힘 또는 학대 행위';

  @override
  String get postingInappropriateContent => '부적절한 콘텐츠 게시';

  @override
  String get accountCompromiseOrSecurityIssue => '계정 손상 또는 보안 문제';

  @override
  String get enterReasonForBanningUser => '이 사용자를 차단하는 사유를 입력하세요';

  @override
  String get banUntil => '차단 기간';

  @override
  String get selectDate => '날짜 선택';

  @override
  String get moreOptions => '더 많은 옵션';

  @override
  String get leaveConversation => '대화 나가기';

  @override
  String get reportConversation => '대화 신고';

  @override
  String get topicClosed => '주제 닫힘';

  @override
  String get topicOpened => '주제 열림';

  @override
  String get topicStickied => '주제 고정됨';

  @override
  String get topicUnstickied => '주제 고정 해제됨';

  @override
  String cannotEditMessage(String error) {
    return '이 메시지를 편집할 수 없습니다: $error';
  }

  @override
  String get confirmSpamClean => '스팸 정리 확인';

  @override
  String get handleThreads => '스레드 관리';

  @override
  String get deleteMessages => '메시지 삭제';

  @override
  String get deleteConversations => '대화 삭제';

  @override
  String get myForums => '내 포럼';

  @override
  String get recentlyVisited => '최근 방문';

  @override
  String get explore => '탐색';

  @override
  String get forumCopilot => 'Forum Copilot';

  @override
  String get noConversations => '대화 없음';

  @override
  String get noConversationsMessage => '아직 대화가 없습니다. 새 대화를 시작하여 메시징을 시작하세요.';

  @override
  String get imageSavedToGallery => '이미지가 갤러리에 저장되었습니다!';

  @override
  String failedToSaveImage(String error) {
    return '이미지 저장 실패: $error';
  }

  @override
  String get userProfile => '사용자 프로필';

  @override
  String get deletePost => '게시물 삭제';

  @override
  String get loginRequired => '로그인 필요';

  @override
  String get spamCleaner => '스팸 정리';

  @override
  String get sendMessage => '메시지 보내기';

  @override
  String get memberSince => '회원 가입일';

  @override
  String get lastActivity => '마지막 활동';

  @override
  String get likesReceived => '받은 좋아요';

  @override
  String get likesGiven => '준 좋아요';

  @override
  String get showMore => '더 보기';

  @override
  String get cleanSpam => '스팸 정리';

  @override
  String get failedToSaveMessage => '메시지 저장 실패';

  @override
  String get failedToSaveConversation => '대화 저장 실패';

  @override
  String get failedToSaveSetting => '설정 저장 실패';

  @override
  String get failedToSavePost => '게시물 저장 실패';

  @override
  String errorLoadingSites(String error) {
    return '사이트 로드 오류: $error';
  }

  @override
  String connectingTo(String domainName) {
    return '$domainName에 연결 중...';
  }

  @override
  String get members => '회원';

  @override
  String get allMembers => '모든 회원';

  @override
  String get online => '온라인';

  @override
  String get noMembersFound => '회원을 찾을 수 없습니다';

  @override
  String get searchForMembers => '회원 검색';

  @override
  String get enterUsernameToFindMembers => '포럼 회원을 찾으려면 사용자 이름을 입력하세요';

  @override
  String get noMembersOnline => '현재 온라인 회원이 없습니다';

  @override
  String get enterUsernameToSearch => '검색할 사용자 이름 입력...';

  @override
  String get lookupMembers => '회원 검색';

  @override
  String get addMembers => '회원 추가';

  @override
  String get membersAddedSuccessfully => '회원이 성공적으로 추가되었습니다';

  @override
  String errorAddingMembers(String error) {
    return '회원 추가 오류: $error';
  }

  @override
  String get failedToLoadOnlineUsers => '온라인 사용자 로드 실패';

  @override
  String get noUsersOnline => '온라인 사용자 없음';

  @override
  String membersCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString명';
  }

  @override
  String get noSubject => '제목 없음';

  @override
  String get search => '검색';

  @override
  String get logout => '로그아웃';

  @override
  String get areYouSureYouWantToLogout => '로그아웃하시겠습니까?';

  @override
  String get register => '등록';

  @override
  String get signIn => '로그인';

  @override
  String get markForumRead => '포럼을 읽음으로 표시';

  @override
  String get notificationTest => '알림 테스트';

  @override
  String get forum => '포럼';

  @override
  String get profile => '프로필';

  @override
  String get messages => '메시지';

  @override
  String get add => '추가';

  @override
  String get retry => '다시 시도';

  @override
  String get delete => '삭제';

  @override
  String get deleteMessage => '메시지 삭제';

  @override
  String get areYouSureYouWantToDeleteThisMessage => '이 메시지를 삭제하시겠습니까?';

  @override
  String failedToDeleteMessage(String error) {
    return '메시지 삭제 실패: $error';
  }

  @override
  String get deletingPost => '게시물 삭제 중...';

  @override
  String failedToUnlikePost(String error) {
    return '게시물 좋아요 취소 실패: $error';
  }

  @override
  String failedToLikePost(String error) {
    return '게시물 좋아요 실패: $error';
  }

  @override
  String failedToThankPost(String error) {
    return '게시물 감사 실패: $error';
  }

  @override
  String get signInToViewMessages => '메시지를 보려면 로그인하세요';

  @override
  String get youNeedToBeSignedInToViewConversations => '대화를 보려면 로그인해야 합니다.';

  @override
  String errorLoadingConversations(String error) {
    return '대화 로드 오류: $error';
  }

  @override
  String failedToLeaveConversation(String error) {
    return '대화 나가기 실패: $error';
  }

  @override
  String errorLoadingMoreConversations(String error) {
    return '추가 대화 로드 오류: $error';
  }

  @override
  String errorLoadingMoreMessages(String error) {
    return '메시지를 더 불러오는 중 오류 발생: $error';
  }

  @override
  String get inviteMessageOptional => '초대 메시지 (선택사항)';

  @override
  String get iWouldLikeToAddYouToThisConversation => '이 대화에 추가하고 싶습니다.';

  @override
  String get searchFailed => '검색 실패';

  @override
  String get trySearchingWithDifferentUsername => '다른 사용자 이름으로 검색해보세요';

  @override
  String get noSitesFound => '사이트를 찾을 수 없습니다.';

  @override
  String get userInformationNotAvailable => '사용자 정보를 사용할 수 없습니다';

  @override
  String get birthday => '생일';

  @override
  String get posts => '게시물';

  @override
  String get following => '팔로잉';

  @override
  String get followers => '팔로워';

  @override
  String get about => '소개';

  @override
  String get location => '위치';

  @override
  String get website => '웹사이트';

  @override
  String get signature => '서명';

  @override
  String get next => '다음';

  @override
  String get permanent => '영구';

  @override
  String get temporary => '임시';

  @override
  String setBanDurationFor(String username) {
    return '$username의 차단 기간 설정';
  }

  @override
  String get pleaseSelectEndDateForTemporaryBan => '임시 차단의 종료일을 선택하세요';

  @override
  String get back => '뒤로';

  @override
  String get unban => '차단 해제';

  @override
  String get confirm => '확인';

  @override
  String spamClean(String username) {
    return '$username의 스팸 정리';
  }

  @override
  String get selectActionsToPerform => '수행할 작업 선택:';

  @override
  String get moveOrDeleteThreadsBasedOnAdminSettings =>
      '관리자 설정에 따라 스레드를 이동하거나 삭제';

  @override
  String get messageUpdatedSuccessfully => '메시지가 성공적으로 업데이트되었습니다';

  @override
  String error(String error) {
    return '오류: $error';
  }

  @override
  String failedToRemoveAttachment(String error) {
    return '첨부 파일 제거 실패: $error';
  }

  @override
  String failedToLoadMessage(String error) {
    return '메시지 로드 실패: $error';
  }

  @override
  String get editMessage => '메시지 편집';

  @override
  String get removeAttachment => '첨부 파일 제거';

  @override
  String get areYouSureYouWantToRemoveThisAttachment => '이 첨부 파일을 제거하시겠습니까?';

  @override
  String get none => '없음';

  @override
  String get attachFile => '파일 첨부';

  @override
  String get uploadImage => '이미지 업로드';

  @override
  String get formatting => '서식';

  @override
  String get bold => '굵게';

  @override
  String get italic => '기울임꼴';

  @override
  String get underline => '밑줄';

  @override
  String get strikethrough => '취소선';

  @override
  String get link => '링크';

  @override
  String get image => '이미지';

  @override
  String get video => '동영상';

  @override
  String get quote => '인용';

  @override
  String get code => '코드';

  @override
  String get spoiler => '스포일러';

  @override
  String get bulletList => '글머리 기호 목록';

  @override
  String get numberedList => '번호 매기기 목록';

  @override
  String get listItem => '목록 항목';

  @override
  String participants(int count) {
    return '참가자 ($count)';
  }

  @override
  String get markAsUnread => '읽지 않음으로 표시';

  @override
  String get invite => '초대';

  @override
  String get welcomeBack => '다시 오신 것을 환영합니다!';

  @override
  String get signInToAccessYourProfile => '로그인하여 프로필에 액세스하고 계정을 관리하세요';

  @override
  String get enterYourUsername => '사용자 이름을 입력하세요';

  @override
  String get enterYourPassword => '비밀번호를 입력하세요';

  @override
  String get dontHaveAnAccount => '계정이 없으신가요?';

  @override
  String get enterKeywordsToSearchTopics => '주제를 검색할 키워드 입력...';

  @override
  String get pleaseFillInAllRequiredFields => '모든 필수 필드를 입력하세요';

  @override
  String get undelete => '복원';

  @override
  String get refresh => '새로고침';

  @override
  String get share => '공유';

  @override
  String get viewOnWeb => '웹에서 보기';

  @override
  String get unlock => '잠금 해제';

  @override
  String get lock => '잠금';

  @override
  String get stick => '고정';

  @override
  String get unstick => '고정 해제';

  @override
  String get reply => '답장';

  @override
  String get vote => '투표';

  @override
  String votesCount(int count) {
    return '$count표';
  }

  @override
  String get pollClosed => '투표 종료';

  @override
  String pollEndsOn(String date) {
    return '$date에 종료';
  }

  @override
  String get voteToSeeResults => '결과를 보려면 투표하세요';

  @override
  String get viewFullPoll => '전체 투표 보기';

  @override
  String pollOptionsCount(int count) {
    return '$count개 옵션';
  }

  @override
  String get reactedBy => '반응한 사람';

  @override
  String get enterKeywordsToFindTopicsAndPosts => '키워드를 입력하여 주제와 게시물 찾기';

  @override
  String get enterKeywordsOrDomainToFindForums => '키워드 또는 도메인을 입력하여 포럼 찾기';

  @override
  String get enterKeywordsOrDomainNamesToFindForums =>
      '키워드 또는 도메인 이름을 입력하여 포럼 찾기';

  @override
  String get appearance => '모양';

  @override
  String get followSystemTheme => '시스템 테마 따르기';

  @override
  String get light => '라이트';

  @override
  String get dark => '다크';

  @override
  String version(String version, String buildNumber) {
    return '버전 $version ($buildNumber)';
  }

  @override
  String get forumSettings => '포럼 설정';

  @override
  String get noSettingsAvailable => '사용 가능한 설정이 없습니다';

  @override
  String get settingsCategoriesWillAppearHere => '설정 카테고리는 사용 가능할 때 여기에 표시됩니다.';

  @override
  String get unableToLoadProfile => '프로필을 불러올 수 없습니다';

  @override
  String get banned => '차단됨';

  @override
  String get reportSubmittedSuccessfully => '신고가 성공적으로 제출되었습니다';

  @override
  String get failedToSubmitReport => '신고 제출 실패';

  @override
  String get searchForForums => '포럼 검색';

  @override
  String get searchForums => '포럼 검색';

  @override
  String get deleteTopic => '주제 삭제';

  @override
  String get topicCanBeRestoredLater => '주제는 나중에 복원할 수 있습니다';

  @override
  String get topicWillBePermanentlyDeleted => '주제가 영구적으로 삭제됩니다';

  @override
  String get enterReasonForDeletingTopic => '이 주제를 삭제하는 이유를 입력하세요';

  @override
  String get pleaseSelectEndDate => '종료일을 선택하세요';

  @override
  String get userBannedSuccessfully => '사용자가 성공적으로 차단되었습니다';

  @override
  String get failedToBanUser => '사용자 차단 실패';

  @override
  String get userUnbannedSuccessfully => '사용자 차단 해제 성공';

  @override
  String get failedToUnbanUser => '사용자 차단 해제 실패';

  @override
  String get spamCleanUser => '사용자 스팸 정리';

  @override
  String get deletePrivateConversations => '비공개 대화 삭제';

  @override
  String get banTheUserAccount => '사용자 계정 차단';

  @override
  String get handledThreads => '처리된 스레드';

  @override
  String get deletedMessages => '삭제된 메시지';

  @override
  String get deletedConversations => '삭제된 대화';

  @override
  String get bannedUser => '차단된 사용자';

  @override
  String successfullyCleanedSpam(String username, String actions) {
    return '$username의 스팸이 성공적으로 정리되었습니다. 작업: $actions';
  }

  @override
  String errorLoadingMessage(String error) {
    return '메시지 로드 오류: $error';
  }

  @override
  String get messageNotFound => '메시지를 찾을 수 없습니다';

  @override
  String get home => '홈';

  @override
  String get notifications => '알림';

  @override
  String get forums => '포럼';

  @override
  String get markAllForumsAsRead => '모든 포럼을 읽음으로 표시하시겠습니까?';

  @override
  String get markAllForumsAsReadMessage =>
      '모든 포럼과 주제가 읽음으로 표시됩니다. 이 작업은 취소할 수 없습니다.';

  @override
  String get markAsRead => '읽음으로 표시';

  @override
  String get content => '내용';

  @override
  String get insertImage => '이미지 삽입';

  @override
  String get howWouldYouLikeToInsertImage => '이 이미지를 어떻게 삽입하시겠습니까?';

  @override
  String get thumbnail => '썸네일';

  @override
  String get fullSize => '전체 크기';

  @override
  String get alignLeft => '왼쪽 정렬';

  @override
  String get alignCenter => '가운데 정렬';

  @override
  String get alignRight => '오른쪽 정렬';

  @override
  String get pleaseEnterTitle => '제목을 입력하세요';

  @override
  String get pleaseEnterContent => '내용을 입력하세요';

  @override
  String get uploading => '업로드 중...';

  @override
  String get uploaded => '업로드됨';

  @override
  String get mentionUser => '사용자 멘션';

  @override
  String get loggingIn => '로그인 중...';

  @override
  String get submittingReport => '신고 제출 중...';

  @override
  String get banningUser => '사용자 차단 중...';

  @override
  String get unbanningUser => '사용자 차단 해제 중...';

  @override
  String get cleaningSpam => '스팸 정리 중...';

  @override
  String get enterSubject => '제목 입력';

  @override
  String get typeYourMessageHere => '여기에 메시지를 입력하세요';

  @override
  String get writeYourMessage => '메시지 작성...';

  @override
  String get writeYourReply => '답장 작성...';

  @override
  String get messageSentSuccessfully => '메시지가 성공적으로 전송되었습니다';

  @override
  String get replySentSuccessfully => '답장이 성공적으로 전송되었습니다';

  @override
  String get conversationCreatedSuccessfully => '대화가 성공적으로 생성되었습니다';

  @override
  String get conversationMarkedAsUnread => '대화가 읽지 않음으로 표시되었습니다';

  @override
  String get messageMarkedAsUnread => '메시지가 읽지 않음으로 표시되었습니다';

  @override
  String get conversationClosed => '대화가 닫혔습니다';

  @override
  String get conversationOpened => '대화가 열렸습니다';

  @override
  String get pleaseLoginToLikeMessages => '메시지에 좋아요를 누르려면 로그인하세요';

  @override
  String get loadEarlierMessages => '이전 메시지 불러오기';

  @override
  String failedToLoadQuote(String error) {
    return '인용문을 불러오지 못했습니다: \n$error';
  }

  @override
  String failedToUploadFile(String error) {
    return '파일 업로드에 실패했습니다: $error';
  }

  @override
  String failedToUploadImage(String error) {
    return '이미지 업로드에 실패했습니다: $error';
  }

  @override
  String failedToSendMessage(String error) {
    return '메시지 전송에 실패했습니다: $error';
  }

  @override
  String failedToSendReply(String error) {
    return '답장 전송에 실패했습니다: $error';
  }

  @override
  String failedToMarkAsUnread(String error) {
    return '메시지를 읽지 않음으로 표시하지 못했습니다: $error';
  }

  @override
  String failedToMarkConversationAsUnread(String error) {
    return '대화를 읽지 않음으로 표시하지 못했습니다: $error';
  }

  @override
  String failedToCloseConversation(String error) {
    return '대화를 닫지 못했습니다: $error';
  }

  @override
  String failedToOpenConversation(String error) {
    return '대화를 열지 못했습니다: $error';
  }

  @override
  String failedToJumpToMessage(String error) {
    return '메시지로 이동하지 못했습니다: $error';
  }

  @override
  String get goToTop => '맨 위로';

  @override
  String get goToBottom => '맨 아래로';

  @override
  String get replyAll => '전체 답장';

  @override
  String get forward => '전달';

  @override
  String get noForumsFound => '포럼을 찾을 수 없습니다.';

  @override
  String get pleaseSelectPrefix => '접두사를 선택하세요';

  @override
  String get pleaseLoginToAccessContent => '이 콘텐츠에 액세스하고 게시물과 상호 작용하려면 로그인하세요.';

  @override
  String get searchUsers => '사용자 검색...';

  @override
  String get writeYourTitle => '제목 작성...';

  @override
  String get writeYourContent => '내용 작성...';

  @override
  String get selectAnOption => '옵션 선택';

  @override
  String get enterConversationTitle => '대화 제목 입력';

  @override
  String enterCode(int count) {
    return '$count자리 코드 입력';
  }

  @override
  String get edit => '편집';

  @override
  String get report => '신고';

  @override
  String get unfollow => '언팔로우';

  @override
  String get follow => '팔로우';

  @override
  String get goToForums => '포럼으로 이동';

  @override
  String get remove => '제거';

  @override
  String get subject => '제목';

  @override
  String get message => '메시지';

  @override
  String get titleCannotBeEmpty => '제목을 입력하세요';

  @override
  String get conversationUpdatedSuccessfully => '대화가 성공적으로 업데이트되었습니다';

  @override
  String get goBack => '돌아가기';

  @override
  String get privateMessagesNotAvailable => '비공개 메시지를 사용할 수 없습니다';

  @override
  String failedToLoadPost(String error) {
    return '게시물을 불러오지 못했습니다: \n$error';
  }

  @override
  String failedToLikeOrUnlikeMessage(String action, String error) {
    return '메시지 $action 실패: $error';
  }

  @override
  String get like => '좋아요';

  @override
  String get unlike => '좋아요 취소';

  @override
  String get optimizeImage => '이미지 최적화';

  @override
  String get optimizeAndUpload => '최적화하고 업로드';

  @override
  String downloading(String filename) {
    return '$filename 다운로드 중...';
  }

  @override
  String openingShareSheet(String filename) {
    return '$filename 공유 시트 열기';
  }

  @override
  String errorDownloading(String filename, String error) {
    return '$filename 다운로드 오류: $error';
  }

  @override
  String get enterANumber => '숫자 입력';

  @override
  String get failedToNavigateToForum => '포럼으로 이동 실패';

  @override
  String failedToNavigateToForumName(String forumName) {
    return '$forumName로 이동 실패';
  }

  @override
  String forumNotFound(String forumName) {
    return '포럼을 찾을 수 없습니다: $forumName';
  }

  @override
  String forumNotFoundById(String forumId) {
    return '포럼을 찾을 수 없습니다: $forumId';
  }

  @override
  String couldNotOpenLink(String error) {
    return '링크를 열 수 없습니다: $error';
  }

  @override
  String get likePost => '좋아요';

  @override
  String get unlikePost => '좋아요 취소';

  @override
  String get thankPost => '게시물 감사';

  @override
  String get showLikes => '좋아요 보기';

  @override
  String get showThanks => '감사 보기';

  @override
  String get quotePost => '게시물 인용';

  @override
  String get translate => '번역';

  @override
  String get showOriginal => '원문 보기';

  @override
  String get translating => '번역 중...';

  @override
  String get translated => '번역됨';

  @override
  String get translatedContent => '번역된 내용';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String get translateTo => '번역 대상:';

  @override
  String get deviceLanguage => '기기 언어';

  @override
  String get noPostsToTranslate => '번역할 게시물이 없습니다';

  @override
  String get translationFailed => '번역 실패';

  @override
  String get twoFactorAuthentication => '2단계 인증';

  @override
  String get authenticationCodeLabel => '인증 코드';

  @override
  String get pleaseEnterYourAuthenticationCode => '인증 코드를 입력하세요';

  @override
  String codeMustBeDigits(int count) {
    return '코드는 $count자리여야 합니다';
  }

  @override
  String get codeMustContainOnlyNumbers => '코드는 숫자만 포함해야 합니다';

  @override
  String get verifyButton => '확인';

  @override
  String get attachments => '첨부파일';

  @override
  String get replyOptions => '답글 옵션';

  @override
  String get replyWithQuote => '인용하여 답글';

  @override
  String fileSavedToDownloads(String filename) {
    return '파일이 다운로드에 저장되었습니다: $filename';
  }

  @override
  String fileSavedToDocuments(String filename) {
    return '파일이 문서에 저장되었습니다: $filename';
  }
}
