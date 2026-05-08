// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Forum App';

  @override
  String get loginTitle => 'Вход';

  @override
  String get usernameLabel => 'Имя пользователя';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get loginButton => 'Войти';

  @override
  String get signInWithPasskey => 'Sign in with Passkey';

  @override
  String get usePasskey => 'Use Passkey';

  @override
  String get passkeyContinuePrompt => 'Use your passkey to continue';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get pleaseEnterUsername => 'Пожалуйста, введите ваше имя пользователя';

  @override
  String get pleaseEnterPassword => 'Пожалуйста, введите ваш пароль';

  @override
  String credentialsSentToDomain(String domain) {
    return 'Ваше имя пользователя и пароль будут отправлены на $domain';
  }

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт? ';

  @override
  String get logIn => 'Войти';

  @override
  String get continueButton => 'Продолжить';

  @override
  String get registrationNotAvailable => 'Регистрация недоступна';

  @override
  String get registrationNotAvailableMessage =>
      'Регистрация в настоящее время недоступна. Форум может быть закрыт или регистрация может быть отключена.';

  @override
  String get webRegistrationRequired => 'Требуется регистрация через веб';

  @override
  String get webRegistrationRequiredMessage =>
      'Этот форум требует регистрации через веб-браузер. Пожалуйста, нажмите кнопку ниже, чтобы открыть страницу регистрации.';

  @override
  String get openRegistrationPage => 'Открыть страницу регистрации';

  @override
  String get loadingAdditionalFields => 'Загрузка дополнительных полей...';

  @override
  String get pleaseSelectDateOfBirth =>
      'Пожалуйста, выберите вашу дату рождения';

  @override
  String get pleaseEnterLocation => 'Пожалуйста, введите ваше местоположение';

  @override
  String get pleaseIndicateEmailPreference =>
      'Пожалуйста, укажите ваши предпочтения по электронной почте';

  @override
  String get pleaseFillAllRequiredFields =>
      'Пожалуйста, заполните все обязательные поля';

  @override
  String get pleaseAcceptTermsOfService =>
      'Пожалуйста, примите Условия использования';

  @override
  String get pleaseAcceptPrivacyPolicy =>
      'Пожалуйста, примите Политику конфиденциальности';

  @override
  String get registrationError => 'Ошибка регистрации';

  @override
  String get registrationFailed =>
      'Регистрация не удалась. Пожалуйста, проверьте вашу информацию.';

  @override
  String get registrationFailedTryAgain =>
      'Регистрация не удалась. Пожалуйста, попробуйте снова.';

  @override
  String get registrationInfo => 'Информация о регистрации';

  @override
  String get openWebsite => 'Открыть веб-сайт';

  @override
  String couldNotOpenForumWebsite(String url) {
    return 'Не удалось открыть веб-сайт форума. Пожалуйста, попробуйте посетить: $url';
  }

  @override
  String get registrationSuccessfulEmailConfirm =>
      'Регистрация успешна! Пожалуйста, проверьте вашу электронную почту, чтобы подтвердить ваш аккаунт перед входом.';

  @override
  String get registrationSuccessfulPendingApproval =>
      'Регистрация успешна! Ваш аккаунт ожидает одобрения. Вы будете уведомлены, когда ваш аккаунт будет одобрен.';

  @override
  String get registrationSuccessfulAutoLogin =>
      'Регистрация успешна! Вы автоматически вошли в систему.';

  @override
  String get welcome => 'Добро пожаловать!';

  @override
  String get registrationSuccessful => 'Регистрация успешна';

  @override
  String get pleaseLoginWithNewAccount =>
      'Пожалуйста, войдите с вашим новым аккаунтом.';

  @override
  String get forgotPasswordTitle => 'Забыли пароль';

  @override
  String get usernameOrEmailLabel => 'Имя пользователя или электронная почта';

  @override
  String get pleaseEnterUsernameOrEmail =>
      'Пожалуйста, введите ваше имя пользователя или электронную почту';

  @override
  String get sendResetLink => 'Отправить ссылку для сброса';

  @override
  String get resetLinkSent => 'Ссылка для сброса отправлена';

  @override
  String get passwordResetInstructionsSent =>
      'Инструкции по сбросу пароля были отправлены на ваш зарегистрированный адрес электронной почты.';

  @override
  String get resetFailed => 'Сброс не удался';

  @override
  String get unableToSendResetLink =>
      'Не удалось отправить ссылку для сброса. Пожалуйста, попробуйте снова.';

  @override
  String get errorSendingResetLink =>
      'Произошла ошибка при отправке ссылки для сброса. Пожалуйста, проверьте ваше соединение и попробуйте снова.';

  @override
  String get errorTitle => 'Ошибка';

  @override
  String get okButton => 'ОК';

  @override
  String get retryButton => 'Повторить';

  @override
  String get copyToClipboard => 'Копировать в буфер обмена';

  @override
  String get copied => 'Скопировано';

  @override
  String get errorMessageCopiedToClipboard =>
      'Сообщение об ошибке скопировано в буфер обмена';

  @override
  String get dismiss => 'Закрыть';

  @override
  String get cancel => 'Отмена';

  @override
  String get tryAgain => 'Попробовать Снова';

  @override
  String get getHelp => 'Получить помощь';

  @override
  String get somethingWentWrong => 'Что-то пошло не так';

  @override
  String get unexpectedErrorOccurred =>
      'Произошла неожиданная ошибка. Пожалуйста, попробуйте снова.';

  @override
  String get noInternetConnection => 'Нет подключения к интернету';

  @override
  String get checkInternetConnection =>
      'Пожалуйста, проверьте ваше подключение к интернету и попробуйте снова.';

  @override
  String get authenticationRequired => 'Требуется аутентификация';

  @override
  String get pleaseLoginToContinue => 'Пожалуйста, войдите, чтобы продолжить.';

  @override
  String get forumError => 'Ошибка форума';

  @override
  String get anErrorOccurred => 'Произошла ошибка';

  @override
  String get accountPendingApproval =>
      'Ваш аккаунт ожидает одобрения. Вы можете просматривать форум, но не можете публиковать сообщения, пока модератор не одобрит ваш аккаунт.';

  @override
  String get checkEmailToConfirm =>
      'Пожалуйста, проверьте вашу электронную почту, чтобы подтвердить ваш аккаунт. Нажмите на ссылку подтверждения в письме, которое мы вам отправили.';

  @override
  String get checkNewEmailToConfirm =>
      'Пожалуйста, проверьте ваш новый адрес электронной почты, чтобы подтвердить изменение. Ваш старый адрес электронной почты останется активным, пока вы не подтвердите новый.';

  @override
  String get emailAddressInvalid =>
      'Ваш адрес электронной почты кажется недействительным или отклоняет письма. Пожалуйста, обновите ваш адрес электронной почты в настройках аккаунта.';

  @override
  String get accountDisabled =>
      'Ваш аккаунт был отключен. Пожалуйста, свяжитесь с администратором для получения помощи.';

  @override
  String get accountRegistrationRejected =>
      'Регистрация вашего аккаунта была отклонена. Пожалуйста, свяжитесь с администратором для получения дополнительной информации.';

  @override
  String get welcomeToForumCopilot => 'Добро пожаловать в Forum Copilot!';

  @override
  String get successfullyLoggedOut => 'Вы успешно вышли из системы';

  @override
  String get accountStatusRequiresAttention =>
      'Статус вашего аккаунта требует внимания. Пожалуйста, свяжитесь с администратором, если у вас есть вопросы.';

  @override
  String get updateEmail => 'Обновить электронную почту';

  @override
  String get resend => 'Отправить снова';

  @override
  String get noLatestTopics => 'Нет последних тем';

  @override
  String get noRecentTopicsToDisplay =>
      'Нет последних тем для отображения. Вернитесь позже для новых обсуждений.';

  @override
  String get signInToViewLatestTopics =>
      'Войдите, чтобы просмотреть последние темы';

  @override
  String get youNeedToBeSignedInToViewLatestTopics =>
      'Вам нужно войти, чтобы просмотреть последние темы';

  @override
  String get noUnreadTopics => 'Нет непрочитанных тем';

  @override
  String get thereAreNoUnreadTopics =>
      'Нет непрочитанных тем. Вернитесь позже для новых обсуждений.';

  @override
  String get youAreAllCaughtUp => 'Вы все просмотрели!';

  @override
  String get signInToViewUnreadTopics =>
      'Войдите, чтобы просмотреть непрочитанные темы';

  @override
  String get youNeedToBeSignedInToViewUnreadTopics =>
      'Вам нужно войти, чтобы просмотреть ваши непрочитанные темы';

  @override
  String get noSubscribedTopics => 'Нет подписанных тем';

  @override
  String get noSubscribedTopicsMessage =>
      'Вы не подписались ни на одну тему. Нажмите кнопку звездочки на теме, чтобы подписаться и получать уведомления о новых обновлениях.';

  @override
  String get signInToViewSubscribedTopics =>
      'Войдите, чтобы просмотреть подписанные темы';

  @override
  String get youNeedToBeSignedInToViewSubscribedTopics =>
      'Вам нужно войти, чтобы просмотреть ваши подписанные темы';

  @override
  String get noParticipatedTopics => 'Нет тем с участием';

  @override
  String get topicsYouParticipatedIn =>
      'Темы, в которых вы участвовали, будут показаны здесь.';

  @override
  String get signInToViewParticipatedTopics =>
      'Войдите, чтобы просмотреть темы с участием';

  @override
  String get youNeedToBeSignedInToViewParticipatedTopics =>
      'Вам нужно войти, чтобы просмотреть темы, в которых вы участвовали';

  @override
  String get latest => 'Последние';

  @override
  String get unread => 'Непрочитанные';

  @override
  String get subscribed => 'Подписанные';

  @override
  String get participated => 'С участием';

  @override
  String get connectionTimedOut =>
      'Время соединения истекло. Сайт может быть недоступен или недостижим.';

  @override
  String get failedToConnectToSite =>
      'Не удалось подключиться к сайту. Сайт может быть недоступен или недостижим.';

  @override
  String get connectionFailed => 'Ошибка подключения';

  @override
  String failedToConnectToSiteName(String siteName) {
    return 'Не удалось подключиться к $siteName';
  }

  @override
  String get loading => 'Загрузка...';

  @override
  String get newConversation => 'Новый разговор';

  @override
  String get newMessage => 'Новое сообщение';

  @override
  String get appSettings => 'Настройки приложения';

  @override
  String get searchSites => 'Поиск сайтов';

  @override
  String get language => 'Язык';

  @override
  String get systemDefault => 'По умолчанию системы';

  @override
  String get followSystemLanguage => 'Следовать языку системы';

  @override
  String get all => 'Все';

  @override
  String get topicsOnly => 'Только темы';

  @override
  String get titlesOnly => 'Только заголовки';

  @override
  String failedToShareTopic(String error) {
    return 'Не удалось поделиться темой: $error';
  }

  @override
  String pleaseLoginToSubscribe(String action) {
    return 'Пожалуйста, войдите, чтобы $action эту тему';
  }

  @override
  String get subscribeTo => 'подписаться на';

  @override
  String get unsubscribeFrom => 'отписаться от';

  @override
  String get subscribe => 'Подписаться';

  @override
  String get unsubscribe => 'Отписаться';

  @override
  String failedToSubscribeToThread(String action) {
    return 'Не удалось $action тему';
  }

  @override
  String get youCannotReplyToThisThread => 'Вы не можете ответить на эту тему';

  @override
  String get pleaseWaitForThreadToLoad =>
      'Пожалуйста, подождите, пока тема загрузится';

  @override
  String get softDelete => 'Мягкое удаление';

  @override
  String get postCanBeRestoredLater => 'Сообщение можно восстановить позже';

  @override
  String get hardDelete => 'Жёсткое удаление';

  @override
  String get postWillBePermanentlyDeleted => 'Сообщение будет удалено навсегда';

  @override
  String get reasonForDeletion => 'Причина удаления';

  @override
  String get enterReasonForDeletingPost =>
      'Введите причину удаления этого сообщения';

  @override
  String get pleaseEnterReasonForDeletion =>
      'Пожалуйста, введите причину удаления';

  @override
  String get reportPost => 'Пожаловаться на сообщение';

  @override
  String get pleaseProvideReasonForReporting =>
      'Пожалуйста, укажите причину жалобы на это сообщение.';

  @override
  String get reason => 'Причина';

  @override
  String get enterReasonForReportingPost =>
      'Введите причину жалобы на это сообщение';

  @override
  String get pleaseEnterReason => 'Пожалуйста, введите причину';

  @override
  String get submitReport => 'Отправить жалобу';

  @override
  String get selectedActions => 'Выбранные действия:';

  @override
  String get thisActionCannotBeUndone => 'Это действие нельзя отменить.';

  @override
  String get participantsLabel => 'Участники';

  @override
  String usernameHasBeenInvited(String username) {
    return '$username был приглашен в разговор';
  }

  @override
  String errorInvitingUser(String error) {
    return 'Ошибка приглашения пользователя: $error';
  }

  @override
  String get newTopic => 'Новая тема';

  @override
  String get markRead => 'Отметить как прочитанное';

  @override
  String get reportUser => 'Пожаловаться на пользователя';

  @override
  String get pleaseSelectReasonForReportingUser =>
      'Пожалуйста, выберите причину жалобы на этого пользователя.';

  @override
  String get spamOrAdvertising => 'Спам или реклама';

  @override
  String get harassmentOrBullying => 'Преследование или издевательство';

  @override
  String get inappropriateContent => 'Неуместный контент';

  @override
  String get impersonationOrFakeAccount =>
      'Подделка личности или фальшивый аккаунт';

  @override
  String get otherPleaseSpecify => 'Другое (пожалуйста, укажите)';

  @override
  String get pleaseSpecifyReason => 'Пожалуйста, укажите причину';

  @override
  String get enterReasonForReportingUser =>
      'Введите причину жалобы на этого пользователя';

  @override
  String get pleaseSelectReason => 'Пожалуйста, выберите причину';

  @override
  String get banUser => 'Заблокировать пользователя';

  @override
  String get unbanUser => 'Разблокировать пользователя';

  @override
  String pleaseSelectReasonForBanningUser(String username) {
    return 'Пожалуйста, выберите причину блокировки $username';
  }

  @override
  String get violationOfCommunityGuidelines => 'Нарушение правил сообщества';

  @override
  String get harassmentOrAbusiveBehavior =>
      'Преследование или оскорбительное поведение';

  @override
  String get postingInappropriateContent => 'Публикация неуместного контента';

  @override
  String get accountCompromiseOrSecurityIssue =>
      'Компрометация аккаунта или проблема безопасности';

  @override
  String get enterReasonForBanningUser =>
      'Введите причину блокировки этого пользователя';

  @override
  String get banUntil => 'Заблокировать до';

  @override
  String get selectDate => 'Выбрать дату';

  @override
  String get moreOptions => 'Дополнительные опции';

  @override
  String get leaveConversation => 'Покинуть разговор';

  @override
  String get reportConversation => 'Пожаловаться на разговор';

  @override
  String get topicClosed => 'Тема закрыта';

  @override
  String get topicOpened => 'Тема открыта';

  @override
  String get topicStickied => 'Тема закреплена';

  @override
  String get topicUnstickied => 'Тема откреплена';

  @override
  String cannotEditMessage(String error) {
    return 'Невозможно отредактировать это сообщение: $error';
  }

  @override
  String get confirmSpamClean => 'Подтвердить очистку спама';

  @override
  String get handleThreads => 'Управление темами';

  @override
  String get deleteMessages => 'Удалить сообщения';

  @override
  String get deleteConversations => 'Удалить разговоры';

  @override
  String get myForums => 'Мои Форумы';

  @override
  String get recentlyVisited => 'Недавно Посещенные';

  @override
  String get explore => 'Исследовать';

  @override
  String get forumCopilot => 'Forum Copilot';

  @override
  String get noConversations => 'Нет разговоров';

  @override
  String get noConversationsMessage =>
      'У вас пока нет разговоров. Начните новый разговор, чтобы начать обмен сообщениями.';

  @override
  String get imageSavedToGallery => 'Изображение сохранено в галерею!';

  @override
  String failedToSaveImage(String error) {
    return 'Ошибка при сохранении изображения: $error';
  }

  @override
  String get userProfile => 'Профиль Пользователя';

  @override
  String get deletePost => 'Удалить Сообщение';

  @override
  String get loginRequired => 'Требуется Вход';

  @override
  String get spamCleaner => 'Очистка спама';

  @override
  String get sendMessage => 'Отправить сообщение';

  @override
  String get memberSince => 'Участник С';

  @override
  String get lastActivity => 'Последняя Активность';

  @override
  String get likesReceived => 'Полученные Лайки';

  @override
  String get likesGiven => 'Данные Лайки';

  @override
  String get showMore => 'Показать больше';

  @override
  String get cleanSpam => 'Очистить спам';

  @override
  String get failedToSaveMessage => 'Ошибка при сохранении сообщения';

  @override
  String get failedToSaveConversation => 'Не удалось сохранить разговор';

  @override
  String get failedToSaveSetting => 'Ошибка при сохранении настройки';

  @override
  String get failedToSavePost => 'Ошибка при сохранении сообщения';

  @override
  String errorLoadingSites(String error) {
    return 'Ошибка при загрузке сайтов: $error';
  }

  @override
  String connectingTo(String domainName) {
    return 'Подключение к $domainName...';
  }

  @override
  String get members => 'Участники';

  @override
  String get allMembers => 'Все Участники';

  @override
  String get online => 'Онлайн';

  @override
  String get noMembersFound => 'Участники не найдены';

  @override
  String get searchForMembers => 'Поиск участников';

  @override
  String get enterUsernameToFindMembers =>
      'Введите имя пользователя, чтобы найти участников форума';

  @override
  String get noMembersOnline => 'В настоящее время нет участников в сети';

  @override
  String get enterUsernameToSearch => 'Введите имя пользователя для поиска...';

  @override
  String get lookupMembers => 'Поиск Участников';

  @override
  String get addMembers => 'Добавить Участников';

  @override
  String get membersAddedSuccessfully => 'Участники успешно добавлены';

  @override
  String errorAddingMembers(String error) {
    return 'Ошибка при добавлении участников: $error';
  }

  @override
  String get failedToLoadOnlineUsers =>
      'Ошибка при загрузке пользователей в сети';

  @override
  String get noUsersOnline => 'Нет пользователей в сети';

  @override
  String membersCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString Участников';
  }

  @override
  String get noSubject => 'Без темы';

  @override
  String get search => 'Поиск';

  @override
  String get logout => 'Выйти';

  @override
  String get areYouSureYouWantToLogout => 'Вы уверены, что хотите выйти?';

  @override
  String get register => 'Зарегистрироваться';

  @override
  String get signIn => 'Войти';

  @override
  String get markForumRead => 'Отметить Форум как Прочитанный';

  @override
  String get notificationTest => 'Тест Уведомлений';

  @override
  String get forum => 'Форум';

  @override
  String get profile => 'Профиль';

  @override
  String get messages => 'Сообщения';

  @override
  String get add => 'Добавить';

  @override
  String get retry => 'Повторить';

  @override
  String get delete => 'Удалить';

  @override
  String get deleteMessage => 'Удалить Сообщение';

  @override
  String get areYouSureYouWantToDeleteThisMessage =>
      'Вы уверены, что хотите удалить это сообщение?';

  @override
  String failedToDeleteMessage(String error) {
    return 'Ошибка при удалении сообщения: $error';
  }

  @override
  String get deletingPost => 'Удаление сообщения...';

  @override
  String failedToUnlikePost(String error) {
    return 'Ошибка при снятии лайка с сообщения: $error';
  }

  @override
  String failedToLikePost(String error) {
    return 'Ошибка при лайке сообщения: $error';
  }

  @override
  String failedToThankPost(String error) {
    return 'Ошибка при благодарности сообщению: $error';
  }

  @override
  String get signInToViewMessages => 'Войдите, чтобы просмотреть сообщения';

  @override
  String get youNeedToBeSignedInToViewConversations =>
      'Вам нужно войти, чтобы просмотреть ваши разговоры.';

  @override
  String errorLoadingConversations(String error) {
    return 'Ошибка при загрузке разговоров: $error';
  }

  @override
  String failedToLeaveConversation(String error) {
    return 'Ошибка при выходе из разговора: $error';
  }

  @override
  String errorLoadingMoreConversations(String error) {
    return 'Ошибка при загрузке дополнительных разговоров: $error';
  }

  @override
  String errorLoadingMoreMessages(String error) {
    return 'Ошибка при загрузке дополнительных сообщений: $error';
  }

  @override
  String get inviteMessageOptional =>
      'Пригласительное Сообщение (необязательно)';

  @override
  String get iWouldLikeToAddYouToThisConversation =>
      'Я хотел бы добавить вас в этот разговор.';

  @override
  String get searchFailed => 'Поиск не удался';

  @override
  String get trySearchingWithDifferentUsername =>
      'Попробуйте поискать с другим именем пользователя';

  @override
  String get noSitesFound => 'Сайты не найдены.';

  @override
  String get userInformationNotAvailable =>
      'Информация о пользователе недоступна';

  @override
  String get birthday => 'День рождения';

  @override
  String get posts => 'Сообщения';

  @override
  String get following => 'Подписки';

  @override
  String get followers => 'Подписчики';

  @override
  String get about => 'О себе';

  @override
  String get location => 'Местоположение';

  @override
  String get website => 'Веб-сайт';

  @override
  String get signature => 'Подпись';

  @override
  String get next => 'Далее';

  @override
  String get permanent => 'Постоянный';

  @override
  String get temporary => 'Временный';

  @override
  String setBanDurationFor(String username) {
    return 'Установить длительность бана для $username';
  }

  @override
  String get pleaseSelectEndDateForTemporaryBan =>
      'Пожалуйста, выберите дату окончания временного бана';

  @override
  String get back => 'Назад';

  @override
  String get unban => 'Разблокировать';

  @override
  String get confirm => 'Подтвердить';

  @override
  String spamClean(String username) {
    return 'Очистить Спам $username';
  }

  @override
  String get selectActionsToPerform => 'Выберите действия для выполнения:';

  @override
  String get moveOrDeleteThreadsBasedOnAdminSettings =>
      'Переместить или удалить темы на основе настроек администратора';

  @override
  String get messageUpdatedSuccessfully => 'Сообщение успешно обновлено';

  @override
  String error(String error) {
    return 'Ошибка: $error';
  }

  @override
  String failedToRemoveAttachment(String error) {
    return 'Ошибка при удалении вложения: $error';
  }

  @override
  String failedToLoadMessage(String error) {
    return 'Ошибка при загрузке сообщения: $error';
  }

  @override
  String get editMessage => 'Редактировать Сообщение';

  @override
  String get removeAttachment => 'Удалить Вложение';

  @override
  String get areYouSureYouWantToRemoveThisAttachment =>
      'Вы уверены, что хотите удалить это вложение?';

  @override
  String get none => 'Нет';

  @override
  String get attachFile => 'Прикрепить Файл';

  @override
  String get uploadImage => 'Загрузить Изображение';

  @override
  String get formatting => 'Форматирование';

  @override
  String get bold => 'Жирный';

  @override
  String get italic => 'Курсив';

  @override
  String get underline => 'Подчеркнутый';

  @override
  String get strikethrough => 'Зачеркнутый';

  @override
  String get link => 'Ссылка';

  @override
  String get image => 'Изображение';

  @override
  String get video => 'Видео';

  @override
  String get quote => 'Цитата';

  @override
  String get code => 'Код';

  @override
  String get spoiler => 'Спойлер';

  @override
  String get bulletList => 'Маркированный Список';

  @override
  String get numberedList => 'Нумерованный Список';

  @override
  String get listItem => 'Элемент Списка';

  @override
  String participants(int count) {
    return 'Участники ($count)';
  }

  @override
  String get markAsUnread => 'Отметить как непрочитанное';

  @override
  String get invite => 'Пригласить';

  @override
  String get welcomeBack => 'С возвращением!';

  @override
  String get signInToAccessYourProfile =>
      'Войдите, чтобы получить доступ к своему профилю и управлять аккаунтом';

  @override
  String get enterYourUsername => 'Введите ваше имя пользователя';

  @override
  String get enterYourPassword => 'Введите ваш пароль';

  @override
  String get dontHaveAnAccount => 'Нет аккаунта?';

  @override
  String get enterKeywordsToSearchTopics =>
      'Введите ключевые слова для поиска тем...';

  @override
  String get pleaseFillInAllRequiredFields =>
      'Пожалуйста, заполните все обязательные поля';

  @override
  String get undelete => 'Восстановить';

  @override
  String get refresh => 'Обновить';

  @override
  String get share => 'Поделиться';

  @override
  String get viewOnWeb => 'Открыть в браузере';

  @override
  String get unlock => 'Разблокировать';

  @override
  String get lock => 'Заблокировать';

  @override
  String get stick => 'Закрепить';

  @override
  String get unstick => 'Открепить';

  @override
  String get reply => 'Ответить';

  @override
  String get vote => 'Голосовать';

  @override
  String votesCount(int count) {
    return '$count голосов';
  }

  @override
  String get pollClosed => 'Опрос закрыт';

  @override
  String pollEndsOn(String date) {
    return 'Заканчивается $date';
  }

  @override
  String get voteToSeeResults => 'Проголосуйте, чтобы увидеть результаты';

  @override
  String get viewFullPoll => 'Полный опрос';

  @override
  String pollOptionsCount(int count) {
    return '$count вариантов';
  }

  @override
  String get reactedBy => 'Отреагировали';

  @override
  String get enterKeywordsToFindTopicsAndPosts =>
      'Введите ключевые слова для поиска тем и сообщений';

  @override
  String get enterKeywordsOrDomainToFindForums =>
      'Введите ключевые слова или домен для поиска форумов';

  @override
  String get enterKeywordsOrDomainNamesToFindForums =>
      'Введите ключевые слова или доменные имена для поиска форумов';

  @override
  String get appearance => 'Внешний вид';

  @override
  String get followSystemTheme => 'Следовать теме системы';

  @override
  String get light => 'Светлая';

  @override
  String get dark => 'Тёмная';

  @override
  String version(String version, String buildNumber) {
    return 'версия $version ($buildNumber)';
  }

  @override
  String get forumSettings => 'Настройки форума';

  @override
  String get noSettingsAvailable => 'Настройки недоступны';

  @override
  String get settingsCategoriesWillAppearHere =>
      'Категории настроек появятся здесь, когда будут доступны.';

  @override
  String get unableToLoadProfile => 'Не удалось загрузить профиль';

  @override
  String get banned => 'ЗАБЛОКИРОВАН';

  @override
  String get reportSubmittedSuccessfully => 'Жалоба успешно отправлена';

  @override
  String get failedToSubmitReport => 'Не удалось отправить жалобу';

  @override
  String get searchForForums => 'Поиск форумов';

  @override
  String get searchForums => 'Поиск форумов';

  @override
  String get deleteTopic => 'Удалить тему';

  @override
  String get topicCanBeRestoredLater => 'Тему можно восстановить позже';

  @override
  String get topicWillBePermanentlyDeleted => 'Тема будет удалена навсегда';

  @override
  String get enterReasonForDeletingTopic =>
      'Введите причину удаления этой темы';

  @override
  String get pleaseSelectEndDate => 'Пожалуйста, выберите дату окончания';

  @override
  String get userBannedSuccessfully => 'Пользователь успешно заблокирован';

  @override
  String get failedToBanUser => 'Не удалось заблокировать пользователя';

  @override
  String get userUnbannedSuccessfully => 'Пользователь успешно разблокирован';

  @override
  String get failedToUnbanUser => 'Не удалось разблокировать пользователя';

  @override
  String get spamCleanUser => 'Очистить спам пользователя';

  @override
  String get deletePrivateConversations => 'Удалить приватные разговоры';

  @override
  String get banTheUserAccount => 'Заблокировать учётную запись пользователя';

  @override
  String get handledThreads => 'Обработанные темы';

  @override
  String get deletedMessages => 'Удалённые сообщения';

  @override
  String get deletedConversations => 'Удалённые разговоры';

  @override
  String get bannedUser => 'Заблокированный пользователь';

  @override
  String successfullyCleanedSpam(String username, String actions) {
    return 'Спам успешно очищен для $username. Действия: $actions';
  }

  @override
  String errorLoadingMessage(String error) {
    return 'Ошибка загрузки сообщения: $error';
  }

  @override
  String get messageNotFound => 'Сообщение не найдено';

  @override
  String get home => 'Главная';

  @override
  String get notifications => 'Уведомления';

  @override
  String get forums => 'Форумы';

  @override
  String get markAllForumsAsRead => 'Отметить все форумы как прочитанные?';

  @override
  String get markAllForumsAsReadMessage =>
      'Это отметит все форумы и темы как прочитанные. Это действие нельзя отменить.';

  @override
  String get markAsRead => 'Отметить как прочитанное';

  @override
  String get content => 'Содержание';

  @override
  String get insertImage => 'Вставить изображение';

  @override
  String get howWouldYouLikeToInsertImage =>
      'Как вы хотите вставить это изображение?';

  @override
  String get thumbnail => 'Миниатюра';

  @override
  String get fullSize => 'Полный размер';

  @override
  String get alignLeft => 'Выровнять по левому краю';

  @override
  String get alignCenter => 'Выровнять по центру';

  @override
  String get alignRight => 'Выровнять по правому краю';

  @override
  String get pleaseEnterTitle => 'Пожалуйста, введите заголовок';

  @override
  String get pleaseEnterContent => 'Пожалуйста, введите содержимое';

  @override
  String get uploading => 'Загрузка...';

  @override
  String get uploaded => 'Загружено';

  @override
  String get mentionUser => 'Упомянуть пользователя';

  @override
  String get loggingIn => 'Вход в систему...';

  @override
  String get submittingReport => 'Отправка отчёта...';

  @override
  String get banningUser => 'Блокировка пользователя...';

  @override
  String get unbanningUser => 'Разблокировка пользователя...';

  @override
  String get cleaningSpam => 'Очистка спама...';

  @override
  String get enterSubject => 'Введите тему';

  @override
  String get typeYourMessageHere => 'Введите ваше сообщение здесь';

  @override
  String get writeYourMessage => 'Напишите ваше сообщение...';

  @override
  String get writeYourReply => 'Напишите ваш ответ...';

  @override
  String get messageSentSuccessfully => 'Сообщение успешно отправлено';

  @override
  String get replySentSuccessfully => 'Ответ успешно отправлен';

  @override
  String get conversationCreatedSuccessfully => 'Разговор успешно создан';

  @override
  String get conversationMarkedAsUnread => 'Разговор отмечен как непрочитанный';

  @override
  String get messageMarkedAsUnread => 'Сообщение отмечено как непрочитанное';

  @override
  String get conversationClosed => 'Разговор закрыт';

  @override
  String get conversationOpened => 'Разговор открыт';

  @override
  String get pleaseLoginToLikeMessages =>
      'Пожалуйста, войдите, чтобы лайкать сообщения';

  @override
  String get loadEarlierMessages => 'Загрузить более ранние сообщения';

  @override
  String failedToLoadQuote(String error) {
    return 'Не удалось загрузить цитату: \n$error';
  }

  @override
  String failedToUploadFile(String error) {
    return 'Не удалось загрузить файл: $error';
  }

  @override
  String failedToUploadImage(String error) {
    return 'Не удалось загрузить изображение: $error';
  }

  @override
  String failedToSendMessage(String error) {
    return 'Не удалось отправить сообщение: $error';
  }

  @override
  String failedToSendReply(String error) {
    return 'Не удалось отправить ответ: $error';
  }

  @override
  String failedToMarkAsUnread(String error) {
    return 'Не удалось отметить сообщение как непрочитанное: $error';
  }

  @override
  String failedToMarkConversationAsUnread(String error) {
    return 'Не удалось отметить разговор как непрочитанный: $error';
  }

  @override
  String failedToCloseConversation(String error) {
    return 'Не удалось закрыть разговор: $error';
  }

  @override
  String failedToOpenConversation(String error) {
    return 'Не удалось открыть разговор: $error';
  }

  @override
  String failedToJumpToMessage(String error) {
    return 'Не удалось перейти к сообщению: $error';
  }

  @override
  String get goToTop => 'Перейти вверх';

  @override
  String get goToBottom => 'Перейти вниз';

  @override
  String get replyAll => 'Ответить всем';

  @override
  String get forward => 'Переслать';

  @override
  String get noForumsFound => 'Форумы не найдены.';

  @override
  String get pleaseSelectPrefix => 'Пожалуйста, выберите префикс';

  @override
  String get pleaseLoginToAccessContent =>
      'Пожалуйста, войдите, чтобы получить доступ к этому содержимому и взаимодействовать с сообщениями.';

  @override
  String get searchUsers => 'Поиск пользователей...';

  @override
  String get writeYourTitle => 'Напишите ваш заголовок...';

  @override
  String get writeYourContent => 'Напишите ваше содержимое...';

  @override
  String get selectAnOption => 'Выберите опцию';

  @override
  String get enterConversationTitle => 'Введите заголовок разговора';

  @override
  String enterCode(int count) {
    return 'Введите $count-значный код';
  }

  @override
  String get edit => 'Редактировать';

  @override
  String get report => 'Пожаловаться';

  @override
  String get unfollow => 'Отписаться';

  @override
  String get follow => 'Подписаться';

  @override
  String get goToForums => 'Перейти к форумам';

  @override
  String get remove => 'Удалить';

  @override
  String get subject => 'Тема';

  @override
  String get message => 'Сообщение';

  @override
  String get titleCannotBeEmpty => 'Заголовок не может быть пустым';

  @override
  String get conversationUpdatedSuccessfully => 'Разговор успешно обновлён';

  @override
  String get goBack => 'Назад';

  @override
  String get privateMessagesNotAvailable => 'Приватные сообщения недоступны';

  @override
  String failedToLoadPost(String error) {
    return 'Не удалось загрузить сообщение: \n$error';
  }

  @override
  String failedToLikeOrUnlikeMessage(String action, String error) {
    return 'Не удалось $action сообщение: $error';
  }

  @override
  String get like => 'лайкнуть';

  @override
  String get unlike => 'убрать лайк';

  @override
  String get optimizeImage => 'Оптимизировать изображение';

  @override
  String get optimizeAndUpload => 'Оптимизировать и загрузить';

  @override
  String downloading(String filename) {
    return 'Загрузка $filename...';
  }

  @override
  String openingShareSheet(String filename) {
    return 'Открытие листа общего доступа для $filename';
  }

  @override
  String errorDownloading(String filename, String error) {
    return 'Ошибка при загрузке $filename: $error';
  }

  @override
  String get enterANumber => 'Введите число';

  @override
  String get failedToNavigateToForum => 'Не удалось перейти к форуму';

  @override
  String failedToNavigateToForumName(String forumName) {
    return 'Не удалось перейти к $forumName';
  }

  @override
  String forumNotFound(String forumName) {
    return 'Форум не найден: $forumName';
  }

  @override
  String forumNotFoundById(String forumId) {
    return 'Форум не найден: $forumId';
  }

  @override
  String couldNotOpenLink(String error) {
    return 'Не удалось открыть ссылку: $error';
  }

  @override
  String get likePost => 'Нравится';

  @override
  String get unlikePost => 'Больше не нравится';

  @override
  String get thankPost => 'Поблагодарить';

  @override
  String get showLikes => 'Показать лайки';

  @override
  String get showThanks => 'Показать благодарности';

  @override
  String get quotePost => 'Цитировать пост';

  @override
  String get translate => 'Перевести';

  @override
  String get showOriginal => 'Показать оригинал';

  @override
  String get translating => 'Перевод...';

  @override
  String get translated => 'Переведено';

  @override
  String get translatedContent => 'Переведённый контент';

  @override
  String get selectLanguage => 'Выберите язык';

  @override
  String get translateTo => 'Перевести на:';

  @override
  String get deviceLanguage => 'Язык устройства';

  @override
  String get noPostsToTranslate => 'Нет постов для перевода';

  @override
  String get translationFailed => 'Ошибка перевода';

  @override
  String get twoFactorAuthentication => 'Двухфакторная аутентификация';

  @override
  String get authenticationCodeLabel => 'Код аутентификации';

  @override
  String get pleaseEnterYourAuthenticationCode => 'Введите код аутентификации';

  @override
  String codeMustBeDigits(int count) {
    return 'Код должен содержать $count цифр';
  }

  @override
  String get codeMustContainOnlyNumbers => 'Код должен содержать только цифры';

  @override
  String get verifyButton => 'Проверить';

  @override
  String get attachments => 'Вложения';

  @override
  String get replyOptions => 'Параметры ответа';

  @override
  String get replyWithQuote => 'Ответить с цитатой';

  @override
  String fileSavedToDownloads(String filename) {
    return 'Файл сохранен в Загрузки: $filename';
  }

  @override
  String fileSavedToDocuments(String filename) {
    return 'Файл сохранен в Документы: $filename';
  }
}
