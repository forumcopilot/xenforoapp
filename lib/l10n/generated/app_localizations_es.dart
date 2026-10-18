// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Forum App';

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get usernameLabel => 'Nombre de usuario';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get signInWithPasskey => 'Sign in with Passkey';

  @override
  String get usePasskey => 'Use Passkey';

  @override
  String get passkeyContinuePrompt => 'Use your passkey to continue';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get pleaseEnterUsername => 'Por favor ingresa tu nombre de usuario';

  @override
  String get pleaseEnterPassword => 'Por favor ingresa tu contraseña';

  @override
  String credentialsSentToDomain(String domain) {
    return 'Tu nombre de usuario y contraseña serán enviados a $domain';
  }

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta? ';

  @override
  String get logIn => 'Iniciar sesión';

  @override
  String get continueButton => 'Continuar';

  @override
  String get registrationNotAvailable => 'Registro no disponible';

  @override
  String get registrationNotAvailableMessage =>
      'El registro no está disponible actualmente. El foro puede estar cerrado o el registro puede estar deshabilitado.';

  @override
  String get webRegistrationRequired => 'Registro web requerido';

  @override
  String get webRegistrationRequiredMessage =>
      'Este foro requiere registro a través del navegador web. Por favor haz clic en el botón de abajo para abrir la página de registro.';

  @override
  String get openRegistrationPage => 'Abrir página de registro';

  @override
  String get loadingAdditionalFields => 'Cargando campos adicionales...';

  @override
  String get pleaseSelectDateOfBirth =>
      'Por favor selecciona tu fecha de nacimiento';

  @override
  String get pleaseEnterLocation => 'Por favor ingresa tu ubicación';

  @override
  String get pleaseIndicateEmailPreference =>
      'Por favor indica tu preferencia de correo electrónico';

  @override
  String get pleaseFillAllRequiredFields =>
      'Por favor completa todos los campos requeridos';

  @override
  String get pleaseAcceptTermsOfService =>
      'Por favor acepta los Términos de Servicio';

  @override
  String get pleaseAcceptPrivacyPolicy =>
      'Por favor acepta la Política de Privacidad';

  @override
  String get registrationError => 'Error de registro';

  @override
  String get registrationFailed =>
      'El registro falló. Por favor verifica tu información.';

  @override
  String get registrationFailedTryAgain =>
      'El registro falló. Por favor intenta de nuevo.';

  @override
  String get registrationInfo => 'Información de registro';

  @override
  String get openWebsite => 'Abrir sitio web';

  @override
  String couldNotOpenForumWebsite(String url) {
    return 'No se pudo abrir el sitio web del foro. Por favor intenta visitar: $url';
  }

  @override
  String get registrationSuccessfulEmailConfirm =>
      '¡Registro exitoso! Por favor revisa tu correo electrónico para confirmar tu cuenta antes de iniciar sesión.';

  @override
  String get registrationSuccessfulPendingApproval =>
      '¡Registro exitoso! Tu cuenta está pendiente de aprobación. Serás notificado cuando tu cuenta sea aprobada.';

  @override
  String get registrationSuccessfulAutoLogin =>
      '¡Registro exitoso! Has sido iniciado sesión automáticamente.';

  @override
  String get welcome => '¡Bienvenido!';

  @override
  String get registrationSuccessful => 'Registro exitoso';

  @override
  String get pleaseLoginWithNewAccount =>
      'Por favor inicia sesión con tu nueva cuenta.';

  @override
  String get forgotPasswordTitle => 'Olvidé mi contraseña';

  @override
  String get usernameOrEmailLabel => 'Nombre de usuario o correo electrónico';

  @override
  String get pleaseEnterUsernameOrEmail =>
      'Por favor ingresa tu nombre de usuario o correo electrónico';

  @override
  String get sendResetLink => 'Enviar enlace de restablecimiento';

  @override
  String get resetLinkSent => 'Enlace de restablecimiento enviado';

  @override
  String get passwordResetInstructionsSent =>
      'Las instrucciones para restablecer tu contraseña han sido enviadas a tu dirección de correo electrónico registrada.';

  @override
  String get resetFailed => 'Restablecimiento fallido';

  @override
  String get unableToSendResetLink =>
      'No se pudo enviar el enlace de restablecimiento. Por favor intenta de nuevo.';

  @override
  String get errorSendingResetLink =>
      'Ocurrió un error al enviar el enlace de restablecimiento. Por favor verifica tu conexión e intenta de nuevo.';

  @override
  String get errorTitle => 'Error';

  @override
  String get okButton => 'Aceptar';

  @override
  String get retryButton => 'Reintentar';

  @override
  String get copyToClipboard => 'Copiar al portapapeles';

  @override
  String get copied => 'Copiado';

  @override
  String get errorMessageCopiedToClipboard =>
      'Mensaje de error copiado al portapapeles';

  @override
  String get cancel => 'Cancelar';

  @override
  String get getHelp => 'Obtener ayuda';

  @override
  String get somethingWentWrong => 'Algo salió mal';

  @override
  String get unexpectedErrorOccurred =>
      'Ocurrió un error inesperado. Por favor intenta de nuevo.';

  @override
  String get noInternetConnection => 'Sin conexión a Internet';

  @override
  String get checkInternetConnection =>
      'Por favor verifica tu conexión a Internet e intenta de nuevo.';

  @override
  String get authenticationRequired => 'Autenticación requerida';

  @override
  String get pleaseLoginToContinue => 'Por favor inicia sesión para continuar.';

  @override
  String get forumError => 'Error del foro';

  @override
  String get anErrorOccurred => 'Ocurrió un error';

  @override
  String get accountPendingApproval =>
      'Tu cuenta está pendiente de aprobación. Puedes navegar por el foro pero no puedes publicar hasta que un moderador apruebe tu cuenta.';

  @override
  String get checkEmailToConfirm =>
      'Por favor revisa tu correo electrónico para confirmar tu cuenta. Haz clic en el enlace de confirmación en el correo que te enviamos.';

  @override
  String get checkNewEmailToConfirm =>
      'Por favor revisa tu nueva dirección de correo electrónico para confirmar el cambio. Tu correo anterior permanecerá activo hasta que confirmes el nuevo.';

  @override
  String get emailAddressInvalid =>
      'Tu dirección de correo electrónico parece ser inválida o está rebotando correos. Por favor actualiza tu dirección de correo electrónico en la configuración de la cuenta.';

  @override
  String get accountDisabled =>
      'Tu cuenta ha sido deshabilitada. Por favor contacta a un administrador para obtener asistencia.';

  @override
  String get accountRegistrationRejected =>
      'El registro de tu cuenta fue rechazado. Por favor contacta a un administrador para más información.';

  @override
  String get welcomeToForumCopilot => '¡Bienvenido a Forum Copilot!';

  @override
  String get successfullyLoggedOut => 'Has cerrado sesión exitosamente';

  @override
  String get accountStatusRequiresAttention =>
      'El estado de tu cuenta requiere atención. Por favor contacta a un administrador si tienes preguntas.';

  @override
  String get updateEmail => 'Actualizar correo electrónico';

  @override
  String get resend => 'Reenviar';

  @override
  String get noLatestTopics => 'No hay temas recientes';

  @override
  String get noRecentTopicsToDisplay =>
      'No hay temas recientes para mostrar. Vuelve más tarde para nuevas discusiones.';

  @override
  String get noUnreadTopics => 'No hay temas sin leer';

  @override
  String get thereAreNoUnreadTopics =>
      'No hay temas sin leer. Vuelve más tarde para nuevas discusiones.';

  @override
  String get youAreAllCaughtUp => '¡Estás al día!';

  @override
  String get noSubscribedTopics => 'No hay temas suscritos';

  @override
  String get noSubscribedTopicsMessage =>
      'No te has suscrito a ningún tema. Toca el botón de estrella en un tema para suscribirte y recibir notificaciones de nuevas actualizaciones.';

  @override
  String get noParticipatedTopics => 'No hay temas participados';

  @override
  String get topicsYouParticipatedIn =>
      'Los temas en los que has participado se mostrarán aquí.';

  @override
  String get latest => 'Recientes';

  @override
  String get unread => 'Sin leer';

  @override
  String get subscribed => 'Suscritos';

  @override
  String get participated => 'Participados';

  @override
  String get connectionTimedOut =>
      'La conexión expiró. El sitio puede estar caído o inaccesible.';

  @override
  String get failedToConnectToSite =>
      'Error al conectar con el sitio. El sitio puede estar caído o inaccesible.';

  @override
  String get connectionFailed => 'Error de conexión';

  @override
  String failedToConnectToSiteName(String siteName) {
    return 'Error al conectar con $siteName';
  }

  @override
  String get loading => 'Cargando...';

  @override
  String get newConversation => 'Nueva conversación';

  @override
  String get newMessage => 'Nuevo mensaje';

  @override
  String get appSettings => 'Configuración de la aplicación';

  @override
  String get searchSites => 'Buscar sitios';

  @override
  String get all => 'Todo';

  @override
  String get topicsOnly => 'Solo temas';

  @override
  String get titlesOnly => 'Solo títulos';

  @override
  String failedToShareTopic(String error) {
    return 'Error al compartir tema: $error';
  }

  @override
  String pleaseLoginToSubscribe(String action) {
    return 'Por favor inicia sesión para $action este hilo';
  }

  @override
  String get subscribeTo => 'suscribirte a';

  @override
  String get unsubscribeFrom => 'desuscribirte de';

  @override
  String get subscribe => 'Suscribirse';

  @override
  String get unsubscribe => 'Cancelar suscripción';

  @override
  String failedToSubscribeToThread(String action) {
    return 'Error al $action hilo';
  }

  @override
  String get youCannotReplyToThisThread => 'No puedes responder a este hilo';

  @override
  String get pleaseWaitForThreadToLoad =>
      'Por favor espera a que el hilo se cargue';

  @override
  String get postCanBeRestoredLater =>
      'La publicación puede ser restaurada más tarde';

  @override
  String get postWillBePermanentlyDeleted =>
      'La publicación será eliminada permanentemente';

  @override
  String get enterReasonForDeletingPost =>
      'Ingresa la razón para eliminar esta publicación';

  @override
  String get reportPost => 'Reportar publicación';

  @override
  String get pleaseProvideReasonForReporting =>
      'Por favor proporciona una razón para reportar esta publicación.';

  @override
  String get reason => 'Razón';

  @override
  String get enterReasonForReportingPost =>
      'Ingresa la razón para reportar esta publicación';

  @override
  String get pleaseEnterReason => 'Por favor ingresa una razón';

  @override
  String get selectedActions => 'Acciones seleccionadas:';

  @override
  String get thisActionCannotBeUndone => 'Esta acción no se puede deshacer.';

  @override
  String get participantsLabel => 'Participantes';

  @override
  String usernameHasBeenInvited(String username) {
    return '$username ha sido invitado a la conversación';
  }

  @override
  String errorInvitingUser(String error) {
    return 'Error al invitar usuario: $error';
  }

  @override
  String get newTopic => 'Nuevo tema';

  @override
  String get markRead => 'Marcar como leído';

  @override
  String get pleaseSelectReasonForReportingUser =>
      'Por favor selecciona un motivo para reportar a este usuario.';

  @override
  String get spamOrAdvertising => 'Spam o publicidad';

  @override
  String get harassmentOrBullying => 'Acoso o intimidación';

  @override
  String get inappropriateContent => 'Contenido inapropiado';

  @override
  String get impersonationOrFakeAccount => 'Suplantación o cuenta falsa';

  @override
  String get otherPleaseSpecify => 'Otro (por favor especifica)';

  @override
  String get pleaseSpecifyReason => 'Por favor especifica el motivo';

  @override
  String get enterReasonForReportingUser =>
      'Ingresa el motivo para reportar a este usuario';

  @override
  String get pleaseSelectReason => 'Por favor selecciona un motivo';

  @override
  String pleaseSelectReasonForBanningUser(String username) {
    return 'Por favor selecciona un motivo para banear a $username';
  }

  @override
  String get violationOfCommunityGuidelines =>
      'Violación de las pautas de la comunidad';

  @override
  String get harassmentOrAbusiveBehavior => 'Acoso o comportamiento abusivo';

  @override
  String get postingInappropriateContent =>
      'Publicación de contenido inapropiado';

  @override
  String get accountCompromiseOrSecurityIssue =>
      'Compromiso de cuenta o problema de seguridad';

  @override
  String get enterReasonForBanningUser =>
      'Ingresa el motivo para banear a este usuario';

  @override
  String get banUntil => 'Banear hasta';

  @override
  String get selectDate => 'Seleccionar fecha';

  @override
  String get unbanUser => 'Desbanear Usuario';

  @override
  String get leaveConversation => 'Dejar conversación';

  @override
  String get reportConversation => 'Reportar conversación';

  @override
  String get topicClosed => 'Tema cerrado';

  @override
  String get topicOpened => 'Tema abierto';

  @override
  String get topicStickied => 'Tema fijado';

  @override
  String get topicUnstickied => 'Tema desfijado';

  @override
  String cannotEditMessage(String error) {
    return 'No se puede editar este mensaje: $error';
  }

  @override
  String get confirmSpamClean => 'Confirmar Limpieza de Spam';

  @override
  String get myForums => 'Mis Foros';

  @override
  String get recentlyVisited => 'Visitados Recientemente';

  @override
  String get explore => 'Explorar';

  @override
  String get forumCopilot => 'Forum Copilot';

  @override
  String get noConversations => 'Sin conversaciones';

  @override
  String get noConversationsMessage =>
      'Aún no tienes conversaciones. Inicia una nueva conversación para comenzar a enviar mensajes.';

  @override
  String get imageSavedToGallery => '¡Imagen guardada en la galería!';

  @override
  String failedToSaveImage(String error) {
    return 'Error al guardar imagen: $error';
  }

  @override
  String get userProfile => 'Perfil de Usuario';

  @override
  String get deletePost => 'Eliminar Publicación';

  @override
  String get loginRequired => 'Inicio de Sesión Requerido';

  @override
  String get tryAgain => 'Intentar de Nuevo';

  @override
  String get memberSince => 'Miembro Desde';

  @override
  String get lastActivity => 'Última Actividad';

  @override
  String get likesReceived => 'Me Gusta Recibidos';

  @override
  String get likesGiven => 'Me Gusta Dados';

  @override
  String get failedToSaveMessage => 'Error al guardar mensaje';

  @override
  String get failedToSaveSetting => 'Error al guardar configuración';

  @override
  String get failedToSavePost => 'Error al guardar publicación';

  @override
  String errorLoadingSites(String error) {
    return 'Error al cargar sitios: $error';
  }

  @override
  String connectingTo(String domainName) {
    return 'Conectando a $domainName...';
  }

  @override
  String get members => 'Miembros';

  @override
  String get allMembers => 'Todos los Miembros';

  @override
  String get online => 'En Línea';

  @override
  String get noMembersFound => 'No se encontraron miembros';

  @override
  String get searchForMembers => 'Buscar miembros';

  @override
  String get enterUsernameToFindMembers =>
      'Ingresa un nombre de usuario para encontrar miembros del foro';

  @override
  String get noMembersOnline => 'No hay miembros en línea actualmente';

  @override
  String get lookupMembers => 'Buscar Miembros';

  @override
  String get addMembers => 'Agregar Miembros';

  @override
  String get membersAddedSuccessfully => 'Miembros agregados exitosamente';

  @override
  String errorAddingMembers(String error) {
    return 'Error al agregar miembros: $error';
  }

  @override
  String get failedToLoadOnlineUsers => 'Error al cargar usuarios en línea';

  @override
  String get noUsersOnline => 'No hay usuarios en línea';

  @override
  String membersCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString Miembros';
  }

  @override
  String get noSubject => 'Sin asunto';

  @override
  String get search => 'Buscar';

  @override
  String get moreOptions => 'Más opciones';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get areYouSureYouWantToLogout =>
      '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get register => 'Registrarse';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get markForumRead => 'Marcar foro como leído';

  @override
  String get notificationTest => 'Prueba de notificaciones';

  @override
  String get forum => 'Foro';

  @override
  String get profile => 'Perfil';

  @override
  String get messages => 'Mensajes';

  @override
  String get add => 'Agregar';

  @override
  String get dismiss => 'Descartar';

  @override
  String get retry => 'Reintentar';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteMessage => 'Eliminar Mensaje';

  @override
  String get areYouSureYouWantToDeleteThisMessage =>
      '¿Estás seguro de que quieres eliminar este mensaje?';

  @override
  String failedToDeleteMessage(String error) {
    return 'Error al eliminar mensaje: $error';
  }

  @override
  String get deletingPost => 'Eliminando publicación...';

  @override
  String failedToUnlikePost(String error) {
    return 'Error al quitar me gusta de la publicación: $error';
  }

  @override
  String failedToLikePost(String error) {
    return 'Error al dar me gusta a la publicación: $error';
  }

  @override
  String get youNeedToBeSignedInToViewConversations =>
      'Necesitas iniciar sesión para ver tus conversaciones.';

  @override
  String errorLoadingConversations(String error) {
    return 'Error al cargar conversaciones: $error';
  }

  @override
  String failedToLeaveConversation(String error) {
    return 'Error al dejar conversación: $error';
  }

  @override
  String errorLoadingMoreConversations(String error) {
    return 'Error al cargar más conversaciones: $error';
  }

  @override
  String errorLoadingMoreMessages(String error) {
    return 'Error al cargar más mensajes: $error';
  }

  @override
  String get inviteMessageOptional => 'Mensaje de Invitación (opcional)';

  @override
  String get iWouldLikeToAddYouToThisConversation =>
      'Me gustaría agregarte a esta conversación.';

  @override
  String get searchFailed => 'Búsqueda fallida';

  @override
  String get trySearchingWithDifferentUsername =>
      'Intenta buscar con un nombre de usuario diferente';

  @override
  String get enterUsernameToSearch =>
      'Ingresa nombre de usuario para buscar...';

  @override
  String get noSitesFound => 'No se encontraron sitios.';

  @override
  String get userInformationNotAvailable =>
      'Información de usuario no disponible';

  @override
  String get birthday => 'Cumpleaños';

  @override
  String get posts => 'Publicaciones';

  @override
  String get following => 'Siguiendo';

  @override
  String get followers => 'Seguidores';

  @override
  String get about => 'Acerca de';

  @override
  String get location => 'Ubicación';

  @override
  String get website => 'Sitio web';

  @override
  String get signature => 'Firma';

  @override
  String get next => 'Siguiente';

  @override
  String get permanent => 'Permanente';

  @override
  String get temporary => 'Temporal';

  @override
  String setBanDurationFor(String username) {
    return 'Establecer la duración del ban para $username';
  }

  @override
  String get pleaseSelectEndDateForTemporaryBan =>
      'Por favor selecciona una fecha de finalización para el ban temporal';

  @override
  String get back => 'Atrás';

  @override
  String get unban => 'Desbanear';

  @override
  String get confirm => 'Confirmar';

  @override
  String spamClean(String username) {
    return 'Limpiar Spam de $username';
  }

  @override
  String get selectActionsToPerform => 'Selecciona las acciones a realizar:';

  @override
  String get handleThreads => 'Gestionar Hilos';

  @override
  String get moveOrDeleteThreadsBasedOnAdminSettings =>
      'Mover o eliminar hilos según la configuración del administrador';

  @override
  String get deleteMessages => 'Eliminar Mensajes';

  @override
  String get deleteConversations => 'Eliminar Conversaciones';

  @override
  String get messageUpdatedSuccessfully => 'Mensaje actualizado exitosamente';

  @override
  String error(String error) {
    return 'Error: $error';
  }

  @override
  String failedToRemoveAttachment(String error) {
    return 'Error al eliminar adjunto: $error';
  }

  @override
  String failedToLoadMessage(String error) {
    return 'Error al cargar mensaje: $error';
  }

  @override
  String get editMessage => 'Editar Mensaje';

  @override
  String get removeAttachment => 'Eliminar Adjunto';

  @override
  String get areYouSureYouWantToRemoveThisAttachment =>
      '¿Estás seguro de que quieres eliminar este adjunto?';

  @override
  String get none => 'Ninguno';

  @override
  String get formatting => 'Formato';

  @override
  String get bold => 'Negrita';

  @override
  String get italic => 'Cursiva';

  @override
  String get underline => 'Subrayado';

  @override
  String get strikethrough => 'Tachado';

  @override
  String get link => 'Enlace';

  @override
  String get image => 'Imagen';

  @override
  String get video => 'Video';

  @override
  String get quote => 'Cita';

  @override
  String get code => 'Código';

  @override
  String get spoiler => 'Spoiler';

  @override
  String get bulletList => 'Lista con Viñetas';

  @override
  String get numberedList => 'Lista Numerada';

  @override
  String get listItem => 'Elemento de Lista';

  @override
  String participants(int count) {
    return 'Participantes ($count)';
  }

  @override
  String get enterKeywordsToSearchTopics =>
      'Ingresa palabras clave para buscar temas...';

  @override
  String get pleaseFillInAllRequiredFields =>
      'Por favor completa todos los campos obligatorios';

  @override
  String get undelete => 'Restaurar';

  @override
  String get signInToViewUnreadTopics =>
      'Inicia sesión para ver temas sin leer';

  @override
  String get youNeedToBeSignedInToViewUnreadTopics =>
      'Necesitas iniciar sesión para ver tus temas sin leer';

  @override
  String get signInToViewSubscribedTopics =>
      'Inicia sesión para ver temas suscritos';

  @override
  String get youNeedToBeSignedInToViewSubscribedTopics =>
      'Necesitas iniciar sesión para ver tus temas suscritos';

  @override
  String get signInToViewParticipatedTopics =>
      'Inicia sesión para ver temas participados';

  @override
  String get youNeedToBeSignedInToViewParticipatedTopics =>
      'Necesitas iniciar sesión para ver temas en los que has participado';

  @override
  String get signInToViewLatestTopics =>
      'Inicia sesión para ver temas recientes';

  @override
  String get youNeedToBeSignedInToViewLatestTopics =>
      'Necesitas iniciar sesión para ver temas recientes';

  @override
  String get markAsUnread => 'Marcar como no leído';

  @override
  String get invite => 'Invitar';

  @override
  String get welcomeBack => '¡Bienvenido de nuevo!';

  @override
  String get signInToAccessYourProfile =>
      'Inicia sesión para acceder a tu perfil y gestionar tu cuenta';

  @override
  String get enterYourUsername => 'Ingresa tu nombre de usuario';

  @override
  String get enterYourPassword => 'Ingresa tu contraseña';

  @override
  String get dontHaveAnAccount => '¿No tienes una cuenta?';

  @override
  String get refresh => 'Actualizar';

  @override
  String get share => 'Compartir';

  @override
  String get viewOnWeb => 'Ver en la Web';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get lock => 'Bloquear';

  @override
  String get stick => 'Fijar';

  @override
  String get unstick => 'Desfijar';

  @override
  String get reply => 'Responder';

  @override
  String get vote => 'Votar';

  @override
  String votesCount(int count) {
    return '$count votos';
  }

  @override
  String get pollClosed => 'Encuesta cerrada';

  @override
  String pollEndsOn(String date) {
    return 'Termina el $date';
  }

  @override
  String get voteToSeeResults => 'Vota para ver resultados';

  @override
  String get viewFullPoll => 'Ver encuesta completa';

  @override
  String pollOptionsCount(int count) {
    return '$count opciones';
  }

  @override
  String get reactedBy => 'Reaccionado por';

  @override
  String likesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Me gusta',
      one: '$count Me gusta',
    );
    return '$_temp0';
  }

  @override
  String reactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reacciones',
      one: '$count reacción',
    );
    return '$_temp0';
  }

  @override
  String get showWhoReacted => 'Toca para ver quién reaccionó.';

  @override
  String get react => 'Reaccionar';

  @override
  String get changeYourReaction => 'Cambiar tu reacción';

  @override
  String get reactionsAll => 'Todas';

  @override
  String get reactionYou => 'Tú';

  @override
  String reactionFilterSemantics(String reaction, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$reaction, $count personas',
      one: '$reaction, $count persona',
    );
    return '$_temp0';
  }

  @override
  String viewProfileOfUser(String username) {
    return 'Ver el perfil de $username';
  }

  @override
  String get enterKeywordsToFindTopicsAndPosts =>
      'Ingresa palabras clave para encontrar temas y publicaciones';

  @override
  String get enterKeywordsOrDomainToFindForums =>
      'Ingresa palabras clave o dominio para encontrar foros';

  @override
  String get enterKeywordsOrDomainNamesToFindForums =>
      'Ingresa palabras clave o nombres de dominio para encontrar foros';

  @override
  String get language => 'Idioma';

  @override
  String get systemDefault => 'Predeterminado del sistema';

  @override
  String get followSystemLanguage => 'Seguir el idioma del sistema';

  @override
  String get appearance => 'Apariencia';

  @override
  String get followSystemTheme => 'Seguir el tema del sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String version(String version, String buildNumber) {
    return 'versión $version ($buildNumber)';
  }

  @override
  String get forumSettings => 'Configuración del Foro';

  @override
  String get noSettingsAvailable => 'No hay configuraciones disponibles';

  @override
  String get settingsCategoriesWillAppearHere =>
      'Las categorías de configuración aparecerán aquí cuando estén disponibles.';

  @override
  String get spamCleaner => 'Limpiador de Spam';

  @override
  String get unableToLoadProfile => 'No se puede cargar el perfil';

  @override
  String get banned => 'BLOQUEADO';

  @override
  String get sendMessage => 'Enviar mensaje';

  @override
  String get showMore => 'Mostrar más';

  @override
  String get reportUser => 'Reportar usuario';

  @override
  String get submitReport => 'Enviar reporte';

  @override
  String get reportSubmittedSuccessfully => 'Reporte enviado exitosamente';

  @override
  String get failedToSubmitReport => 'Error al enviar el reporte';

  @override
  String get searchForForums => 'Buscar foros';

  @override
  String get searchForums => 'Buscar Foros';

  @override
  String get deleteTopic => 'Eliminar tema';

  @override
  String get softDelete => 'Eliminación suave';

  @override
  String get topicCanBeRestoredLater => 'El tema puede restaurarse más tarde';

  @override
  String get hardDelete => 'Eliminación permanente';

  @override
  String get topicWillBePermanentlyDeleted =>
      'El tema será eliminado permanentemente';

  @override
  String get reasonForDeletion => 'Razón de eliminación';

  @override
  String get enterReasonForDeletingTopic =>
      'Ingresa la razón para eliminar este tema';

  @override
  String get pleaseEnterReasonForDeletion =>
      'Por favor ingresa una razón para la eliminación';

  @override
  String get pleaseSelectEndDate =>
      'Por favor selecciona una fecha de finalización';

  @override
  String get banUser => 'Bloquear usuario';

  @override
  String get userBannedSuccessfully => 'Usuario bloqueado exitosamente';

  @override
  String get failedToBanUser => 'Error al bloquear usuario';

  @override
  String get userUnbannedSuccessfully => 'Usuario desbloqueado exitosamente';

  @override
  String get failedToUnbanUser => 'Error al desbloquear usuario';

  @override
  String get spamCleanUser => 'Limpiar spam del usuario';

  @override
  String get deletePrivateConversations => 'Eliminar conversaciones privadas';

  @override
  String get banTheUserAccount => 'Bloquear la cuenta del usuario';

  @override
  String get cleanSpam => 'Limpiar spam';

  @override
  String get handledThreads => 'Temas manejados';

  @override
  String get deletedMessages => 'Mensajes eliminados';

  @override
  String get deletedConversations => 'Conversaciones eliminadas';

  @override
  String get bannedUser => 'Usuario bloqueado';

  @override
  String successfullyCleanedSpam(String username, String actions) {
    return 'Spam limpiado exitosamente para $username. Acciones: $actions';
  }

  @override
  String errorLoadingMessage(String error) {
    return 'Error al cargar mensaje: $error';
  }

  @override
  String get messageNotFound => 'Mensaje no encontrado';

  @override
  String get home => 'Inicio';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get forums => 'Foros';

  @override
  String get markAllForumsAsRead => '¿Marcar todos los foros como leídos?';

  @override
  String get markAllForumsAsReadMessage =>
      'Esto marcará todos los foros y temas como leídos. Esta acción no se puede deshacer.';

  @override
  String get markAsRead => 'Marcar como leído';

  @override
  String get content => 'Contenido';

  @override
  String get insertImage => 'Insertar imagen';

  @override
  String get howWouldYouLikeToInsertImage =>
      '¿Cómo te gustaría insertar esta imagen?';

  @override
  String get thumbnail => 'Miniatura';

  @override
  String get fullSize => 'Tamaño completo';

  @override
  String get alignLeft => 'Alinear a la izquierda';

  @override
  String get alignCenter => 'Alinear al centro';

  @override
  String get alignRight => 'Alinear a la derecha';

  @override
  String get pleaseEnterTitle => 'Por favor ingresa un título';

  @override
  String get pleaseEnterContent => 'Por favor ingresa algún contenido';

  @override
  String get uploading => 'Subiendo...';

  @override
  String get uploaded => 'Subido';

  @override
  String get mentionUser => 'Mencionar usuario';

  @override
  String get loggingIn => 'Iniciando sesión...';

  @override
  String get submittingReport => 'Enviando reporte...';

  @override
  String get banningUser => 'Prohibiendo usuario...';

  @override
  String get unbanningUser => 'Desprohibiendo usuario...';

  @override
  String get cleaningSpam => 'Limpiando spam...';

  @override
  String get enterSubject => 'Ingresa el asunto';

  @override
  String get typeYourMessageHere => 'Escribe tu mensaje aquí';

  @override
  String get writeYourMessage => 'Escribe tu mensaje...';

  @override
  String get writeYourReply => 'Escribe tu respuesta...';

  @override
  String get messageSentSuccessfully => 'Mensaje enviado exitosamente';

  @override
  String get replySentSuccessfully => 'Respuesta enviada exitosamente';

  @override
  String get conversationCreatedSuccessfully =>
      'Conversación creada exitosamente';

  @override
  String get conversationMarkedAsUnread => 'Conversación marcada como no leída';

  @override
  String get messageMarkedAsUnread => 'Mensaje marcado como no leído';

  @override
  String get conversationClosed => 'Conversación cerrada';

  @override
  String get conversationOpened => 'Conversación abierta';

  @override
  String get pleaseLoginToLikeMessages =>
      'Por favor inicia sesión para dar me gusta a los mensajes';

  @override
  String get loadEarlierMessages => 'Cargar mensajes anteriores';

  @override
  String failedToLoadQuote(String error) {
    return 'Error al cargar cita: \n$error';
  }

  @override
  String failedToUploadFile(String error) {
    return 'Error al subir archivo: $error';
  }

  @override
  String failedToUploadImage(String error) {
    return 'Error al subir imagen: $error';
  }

  @override
  String failedToSendMessage(String error) {
    return 'Error al enviar mensaje: $error';
  }

  @override
  String failedToSendReply(String error) {
    return 'Error al enviar respuesta: $error';
  }

  @override
  String failedToMarkAsUnread(String error) {
    return 'Error al marcar mensaje como no leído: $error';
  }

  @override
  String failedToMarkConversationAsUnread(String error) {
    return 'Error al marcar conversación como no leída: $error';
  }

  @override
  String failedToCloseConversation(String error) {
    return 'Error al cerrar conversación: $error';
  }

  @override
  String failedToOpenConversation(String error) {
    return 'Error al abrir conversación: $error';
  }

  @override
  String failedToJumpToMessage(String error) {
    return 'Error al saltar al mensaje: $error';
  }

  @override
  String get goToTop => 'Ir arriba';

  @override
  String get goToBottom => 'Ir abajo';

  @override
  String get replyAll => 'Responder a todos';

  @override
  String get forward => 'Reenviar';

  @override
  String get noForumsFound => 'No se encontraron foros.';

  @override
  String get pleaseSelectPrefix => 'Por favor selecciona un prefijo';

  @override
  String get pleaseLoginToAccessContent =>
      'Por favor inicia sesión para acceder a este contenido e interactuar con las publicaciones.';

  @override
  String get searchUsers => 'Buscar usuarios...';

  @override
  String get writeYourTitle => 'Escribe tu título...';

  @override
  String get writeYourContent => 'Escribe tu contenido...';

  @override
  String get selectAnOption => 'Selecciona una opción';

  @override
  String get enterConversationTitle => 'Ingresa el título de la conversación';

  @override
  String enterCode(int count) {
    return 'Ingresa código de $count dígitos';
  }

  @override
  String get edit => 'Editar';

  @override
  String get report => 'Reportar';

  @override
  String get unfollow => 'Dejar de seguir';

  @override
  String get follow => 'Seguir';

  @override
  String get remove => 'Eliminar';

  @override
  String get subject => 'Asunto';

  @override
  String get message => 'Mensaje';

  @override
  String get titleCannotBeEmpty => 'El título no puede estar vacío';

  @override
  String get conversationUpdatedSuccessfully =>
      'Conversación actualizada exitosamente';

  @override
  String get goBack => 'Volver';

  @override
  String get signInToViewMessages => 'Inicia sesión para ver mensajes';

  @override
  String get privateMessagesNotAvailable =>
      'Los mensajes privados no están disponibles';

  @override
  String failedToLoadPost(String error) {
    return 'Error al cargar publicación: \n$error';
  }

  @override
  String failedToLikeOrUnlikeMessage(String action, String error) {
    return 'Error al $action mensaje: $error';
  }

  @override
  String get like => 'dar me gusta a';

  @override
  String get unlike => 'quitar me gusta a';

  @override
  String get optimizeImage => 'Optimizar imagen';

  @override
  String get optimizeAndUpload => 'Optimizar y subir';

  @override
  String downloading(String filename) {
    return 'Descargando $filename...';
  }

  @override
  String openingShareSheet(String filename) {
    return 'Abriendo hoja de compartir para $filename';
  }

  @override
  String errorDownloading(String filename, String error) {
    return 'Error al descargar $filename: $error';
  }

  @override
  String get enterANumber => 'Ingresa un número';

  @override
  String get failedToNavigateToForum => 'Error al navegar al foro';

  @override
  String failedToNavigateToForumName(String forumName) {
    return 'Error al navegar a $forumName';
  }

  @override
  String get failedToSaveConversation => 'Error al guardar conversación';

  @override
  String forumNotFound(String forumName) {
    return 'Foro no encontrado: $forumName';
  }

  @override
  String forumNotFoundById(String forumId) {
    return 'Foro no encontrado: $forumId';
  }

  @override
  String couldNotOpenLink(String error) {
    return 'No se pudo abrir el enlace: $error';
  }

  @override
  String get likePost => 'Me gusta';

  @override
  String get unlikePost => 'Ya no me gusta';

  @override
  String get showLikes => 'Mostrar me gusta';

  @override
  String get quotePost => 'Citar publicación';

  @override
  String get attachFile => 'Adjuntar Archivo';

  @override
  String get uploadImage => 'Subir Imagen';

  @override
  String get translate => 'Traducir';

  @override
  String get showOriginal => 'Mostrar original';

  @override
  String get translating => 'Traduciendo...';

  @override
  String get translated => 'Traducido';

  @override
  String get translatedContent => 'Contenido traducido';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get translateTo => 'Traducir a:';

  @override
  String get deviceLanguage => 'Idioma del dispositivo';

  @override
  String get noPostsToTranslate => 'No hay publicaciones para traducir';

  @override
  String get translationFailed => 'Error en la traducción';

  @override
  String get twoFactorAuthentication => 'Autenticación en dos factores';

  @override
  String get authenticationCodeLabel => 'Código de autenticación';

  @override
  String get pleaseEnterYourAuthenticationCode =>
      'Introduce tu código de autenticación';

  @override
  String codeMustBeDigits(int count) {
    return 'El código debe tener $count dígitos';
  }

  @override
  String get codeMustContainOnlyNumbers =>
      'El código solo debe contener números';

  @override
  String get verifyButton => 'Verificar';

  @override
  String get attachments => 'Archivos adjuntos';

  @override
  String get replyOptions => 'Opciones de respuesta';

  @override
  String get replyWithQuote => 'Responder con cita';

  @override
  String fileSavedToDownloads(String filename) {
    return 'Archivo guardado en Descargas: $filename';
  }

  @override
  String fileSavedToDocuments(String filename) {
    return 'Archivo guardado en Documentos: $filename';
  }

  @override
  String get discardPostQuestion => '¿Quieres descartar tu publicación?';

  @override
  String get discardChangesQuestion => '¿Quieres descartar tus cambios?';

  @override
  String get discard => 'Descartar';

  @override
  String get discardChanges => 'Descartar cambios';

  @override
  String get notificationsTab => 'Avisos';

  @override
  String get postAwaitingApproval =>
      'Tu publicación aparecerá cuando un moderador la apruebe.';

  @override
  String get reactionHoldHint => 'Mantén pulsado para ver más reacciones';

  @override
  String get turnOnNotifications => 'Activar notificaciones';

  @override
  String get notNow => 'Ahora no';

  @override
  String neverMissAReplyOn(Object forumName) {
    return 'No te pierdas ninguna respuesta en $forumName';
  }

  @override
  String get notificationPreviewNow => 'ahora';

  @override
  String get notificationPreviewEarlier => 'hace 5 min';

  @override
  String get notificationPreviewReply =>
      'Jane te respondió: ¡Bienvenido! Nos alegra que nos encontraras.';

  @override
  String get notificationPreviewMessage =>
      'Sam te envió un mensaje: ¿Vienes el viernes?';

  @override
  String get notificationsAreTurnedOffForThisApp =>
      'Las notificaciones están desactivadas para esta app';

  @override
  String get deviceWillNotShowAlertsUntilAllowedInSettings =>
      'Tu dispositivo no mostrará avisos hasta que permitas las notificaciones en Ajustes.';

  @override
  String get openSettings => 'Abrir ajustes';

  @override
  String get notificationsPitchForum =>
      'Respuestas, menciones y mensajes directos en tu pantalla de bloqueo en cuanto llegan.';

  @override
  String get viewProfile => 'Ver perfil';

  @override
  String get settings => 'Ajustes';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get changeEmail => 'Cambiar correo electrónico';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get save => 'Guardar';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get confirmNewPassword => 'Confirma la nueva contraseña';

  @override
  String get newEmailAddress => 'Nueva dirección de correo';

  @override
  String get emailChanged => 'Dirección de correo cambiada';

  @override
  String get emailChangeConfirm =>
      'Revisa tu correo: la nueva dirección se aplica cuando la confirmes.';

  @override
  String get passwordChanged => 'Contraseña cambiada';

  @override
  String get account => 'Cuenta';

  @override
  String get pleaseEnterEmail => 'Por favor ingresa tu correo electrónico';

  @override
  String get pleaseEnterValidEmail =>
      'Por favor ingresa un correo electrónico válido';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get connectionErrorTitle => 'Error de conexión';

  @override
  String get authenticationErrorTitle => 'Error de autenticación';

  @override
  String get permissionErrorTitle => 'Error de permisos';

  @override
  String get errorNoConnection =>
      'Sin conexión a internet. Revisa la configuración de red.';

  @override
  String get errorTimeout =>
      'La solicitud tardó demasiado. Inténtalo de nuevo.';

  @override
  String get errorServer => 'Error del servidor. Inténtalo más tarde.';

  @override
  String get errorNetwork => 'Error de red. Inténtalo de nuevo.';

  @override
  String get errorInvalidCredentials => 'Usuario o contraseña incorrectos.';

  @override
  String get errorSessionExpired =>
      'Tu sesión ha caducado. Inicia sesión de nuevo.';

  @override
  String get errorAccountLocked =>
      'Tu cuenta ha sido bloqueada. Ponte en contacto con el soporte.';

  @override
  String get errorAuthFailed => 'Error de autenticación. Inténtalo de nuevo.';

  @override
  String get errorForumNotFound => 'No se encontró el foro.';

  @override
  String get errorForumAccessDenied =>
      'No tienes permiso para acceder a este foro.';

  @override
  String get errorForumUnavailable =>
      'El foro no está disponible en este momento. Inténtalo más tarde.';

  @override
  String get errorForumGeneric =>
      'Se produjo un error en el foro. Inténtalo de nuevo.';

  @override
  String get errorDataNotFound => 'No se encontraron los datos solicitados.';

  @override
  String get errorDataCorrupted =>
      'Los datos parecen estar dañados. Actualiza la página.';

  @override
  String get errorCache =>
      'No se pudieron cargar los datos guardados. Inténtalo de nuevo.';

  @override
  String get errorInvalidInput =>
      'Algo de lo que has introducido no es válido.';

  @override
  String get errorRequiredField => 'Completa todos los campos obligatorios.';

  @override
  String get errorPermissionDenied => 'No tienes permiso para hacer eso.';

  @override
  String errorFeatureNotAvailable(String feature) {
    return '$feature no está disponible en este foro.';
  }

  @override
  String get errorStorageFull =>
      'El almacenamiento está lleno. Libera algo de espacio.';

  @override
  String get errorStorageAccessDenied =>
      'Acceso al almacenamiento denegado. Revisa los permisos de la app.';

  @override
  String get loginInfo => 'Información de inicio de sesión';

  @override
  String get loginFailed => 'Error al iniciar sesión';

  @override
  String get topicAnnouncement => 'Anuncio';

  @override
  String get topicPinned => 'Fijado';

  @override
  String get topicLocked => 'Cerrado';

  @override
  String get topicPoll => 'Encuesta';

  @override
  String get deletedBadge => 'ELIMINADO';

  @override
  String get protectedBadge => 'Protegido';

  @override
  String get lockTopic => 'Cerrar tema';

  @override
  String get unlockTopic => 'Reabrir tema';

  @override
  String get lockTopicConfirm =>
      '¿Seguro que quieres cerrar este tema? Los demás usuarios no podrán responder ni interactuar con él.';

  @override
  String get unlockTopicConfirm =>
      '¿Seguro que quieres reabrir este tema? Los demás usuarios podrán volver a responder e interactuar con él.';

  @override
  String get stickTopic => 'Fijar tema';

  @override
  String get unstickTopic => 'Desfijar tema';

  @override
  String get stickTopicConfirm =>
      '¿Seguro que quieres fijar este tema? Aparecerá arriba del foro para todos los usuarios.';

  @override
  String get unstickTopicConfirm =>
      '¿Seguro que quieres desfijar este tema? Ya no aparecerá arriba del foro.';

  @override
  String get undeleteTopic => 'Restaurar tema';

  @override
  String get undeleteTopicConfirm =>
      '¿Seguro que quieres restaurar este tema? Volverá a ser visible para los demás usuarios.';

  @override
  String get additionalInformation => 'Información adicional';

  @override
  String get dateOfBirth => 'Fecha de nacimiento';

  @override
  String get selectDateOfBirth => 'Selecciona tu fecha de nacimiento';

  @override
  String minimumAge(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: 'Edad mínima: $age años',
      one: 'Edad mínima: $age año',
    );
    return '$_temp0';
  }

  @override
  String get locationIsRequired => 'La ubicación es obligatoria';

  @override
  String get receiveSiteMailings => 'Recibir correos del sitio';

  @override
  String iAcceptTheDocument(String document) {
    return 'Acepto los $document';
  }

  @override
  String get termsOfService => 'Términos del servicio';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get imageExceedsUploadLimits =>
      'Esta imagen supera los límites de subida y debe optimizarse:';

  @override
  String get originalSize => 'Tamaño original';

  @override
  String get originalDimensions => 'Dimensiones originales';

  @override
  String get optimizationsToBeApplied => 'Optimizaciones que se aplicarán:';

  @override
  String get resizeImage => 'Redimensionar';

  @override
  String get convertFormat => 'Convertir formato';

  @override
  String get smallerFileSize => 'archivo más pequeño';

  @override
  String get formatNotSupported => 'formato no compatible';

  @override
  String get convertToJpgReason =>
      'Convertir a JPG (formato no compatible o para reducir el tamaño)';

  @override
  String get compressImage => 'Comprimir';

  @override
  String compressQuality(int quality) {
    return 'Calidad: $quality % para cumplir el límite de tamaño';
  }

  @override
  String get estimatedFinalSize => 'Tamaño final estimado';

  @override
  String sizeReduction(String percent) {
    return 'Reducción: $percent %';
  }

  @override
  String get pleaseLoginToCreateTopic =>
      'Inicia sesión para crear un tema nuevo';

  @override
  String get pleaseLoginToSubscribeForums =>
      'Inicia sesión para suscribirte a foros';

  @override
  String get pleaseLoginToUnsubscribeForums =>
      'Inicia sesión para cancelar la suscripción a foros';

  @override
  String errorLoadingContent(String error) {
    return 'Error al cargar el contenido: $error';
  }

  @override
  String get noPermissionToViewSubforumTopics =>
      'No tienes permiso para ver los temas de este subforo.';

  @override
  String get noDiscussionsYet => 'Todavía no hay conversaciones.';

  @override
  String get unableToLoadForums => 'No se pudieron cargar los foros';

  @override
  String get noForumsAvailable => 'No hay foros disponibles';

  @override
  String get noForumsToDisplay =>
      'No hay foros para mostrar. Puede deberse a los permisos o a la estructura del foro.';

  @override
  String get subscribedForums => 'Foros suscritos';

  @override
  String get allForumTopicsMarkedRead =>
      'Todos los temas del foro se marcaron como leídos';

  @override
  String postsCountFormatted(String count) {
    return '$count mensajes';
  }

  @override
  String get jumpToPost => 'Ir al mensaje';

  @override
  String get jump => 'Ir';

  @override
  String get endOfDiscussion => 'Fin de la conversación';

  @override
  String refreshFailed(String error) {
    return 'Error al actualizar: $error';
  }

  @override
  String get topicDeletedHidden =>
      'Este tema está eliminado y oculto para los demás usuarios';

  @override
  String get topicClosedNoReplies =>
      'Este tema está cerrado y ya no admite respuestas';

  @override
  String get youAreSubscribedToTopic => 'Estás suscrito a este tema';

  @override
  String get refreshing => 'Actualizando...';

  @override
  String get unableToLoadForumsTryAgain =>
      'No se pudieron cargar los foros. Inténtalo de nuevo.';

  @override
  String get noPostableForums => 'No hay foros en los que puedas publicar.';

  @override
  String get changeForumQuestion => '¿Cambiar de foro?';

  @override
  String get changeForumRemovesAttachments =>
      'Al cambiar de foro se quitarán los archivos adjuntos que subiste, porque están vinculados al foro elegido.';

  @override
  String get changeForum => 'Cambiar de foro';

  @override
  String get chooseForumBeforePosting => 'Elige un foro antes de publicar';

  @override
  String get accountCannotUploadAttachments =>
      'Tu cuenta no puede subir archivos adjuntos en este sitio.';

  @override
  String get forumNoAttachments => 'Este foro no admite archivos adjuntos.';

  @override
  String get forumNoAttachmentsChooseAnother =>
      'Este foro no admite archivos adjuntos. Elige otro foro para subir los archivos compartidos.';

  @override
  String get forumNoAttachmentsSharedPending =>
      'Este foro no admite archivos adjuntos. Los archivos compartidos quedarán pendientes hasta que elijas otro foro.';

  @override
  String get tapToChangeForum => 'Toca para cambiar de foro';

  @override
  String get chooseWhichForum => 'Elige en qué foro publicar';

  @override
  String get selectAForum => 'Selecciona un foro';

  @override
  String get unableToLoadForumsNow =>
      'No se pueden cargar los foros en este momento.';

  @override
  String get pickForumBeforeUploading =>
      'Elige un foro antes de subir archivos adjuntos o publicar.';

  @override
  String get uploadingSharedFiles => 'Subiendo archivos compartidos...';

  @override
  String get selectForum => 'Seleccionar foro';

  @override
  String get noForumsMatchSearch => 'Ningún foro coincide con tu búsqueda.';

  @override
  String get unknown => 'Desconocido';

  @override
  String get closeConversationConfirm =>
      '¿Seguro que quieres cerrar esta conversación? No se podrán enviar respuestas nuevas.';

  @override
  String get openConversationConfirm =>
      '¿Seguro que quieres abrir esta conversación? Se podrán enviar respuestas nuevas.';

  @override
  String get leaveConversationConfirm =>
      '¿Seguro que quieres salir de esta conversación? Se ocultará de tu bandeja de entrada.';

  @override
  String get close => 'Cerrar';

  @override
  String get open => 'Abrir';

  @override
  String get leave => 'Salir';

  @override
  String errorLoadingConversation(String error) {
    return 'Error al cargar la conversación: $error';
  }

  @override
  String get conversationNotFound => 'No se encontró la conversación';

  @override
  String get conversationClosedNoReplies =>
      'Esta conversación está cerrada y ya no admite respuestas';

  @override
  String get noMessagesFound => 'No se encontraron mensajes';

  @override
  String get endOfConversation => 'Fin de la conversación';

  @override
  String get jumpToMessage => 'Ir al mensaje';

  @override
  String get jumpToFirstMessage => 'Ir al primer mensaje';

  @override
  String get jumpToLastMessage => 'Ir al último mensaje';

  @override
  String messagePositionOf(int position, int total) {
    return 'Mensaje $position de $total';
  }

  @override
  String get tapToJumpToMessage => 'Toca para ir a un mensaje concreto';

  @override
  String failedToReact(String error) {
    return 'No se pudo reaccionar: $error';
  }

  @override
  String participantCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count participantes',
      one: '$count participante',
    );
    return '$_temp0';
  }

  @override
  String get noImagesToDisplay => 'No hay imágenes para mostrar.';

  @override
  String get pleaseLoginToViewAttachment =>
      'Inicia sesión para ver este archivo adjunto';

  @override
  String get inbox => 'Recibidos';

  @override
  String get sent => 'Enviados';

  @override
  String errorLoadingMessages(String error) {
    return 'Error al cargar los mensajes: $error';
  }

  @override
  String get noInboxMessages => 'No hay mensajes recibidos';

  @override
  String get noSentMessages => 'No hay mensajes enviados';

  @override
  String get unknownDate => 'Fecha desconocida';

  @override
  String get searchForTopics => 'Buscar temas';

  @override
  String get noTopicsFound => 'No se encontraron temas';

  @override
  String get noPostsFound => 'No se encontraron mensajes';

  @override
  String get trySearchingDifferentKeywords => 'Prueba con otras palabras clave';

  @override
  String errorLoadingSettings(String error) {
    return 'Error al cargar los ajustes: $error';
  }

  @override
  String get pleaseEnterValidNumber => 'Introduce un número válido';

  @override
  String valueMustBeAtLeast(String min) {
    return 'El valor debe ser al menos $min';
  }

  @override
  String valueMustBeAtMost(String max) {
    return 'El valor debe ser como máximo $max';
  }

  @override
  String maximumLengthCharacters(int max) {
    return 'La longitud máxima es de $max caracteres';
  }

  @override
  String get invalidFormat => 'Formato no válido';

  @override
  String get shareToForumCopilot => 'Compartir en Forum Copilot';

  @override
  String get noSavedForumAccounts =>
      'No se encontraron cuentas de foro guardadas.';

  @override
  String get addForumAccountFirst =>
      'Primero añade una cuenta de foro en Forum Copilot y vuelve a compartir.';

  @override
  String filesReadyToAttach(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count archivos listos para adjuntar',
      one: '$count archivo listo para adjuntar',
    );
    return '$_temp0';
  }

  @override
  String get sharedTextWillBePrefilled =>
      'El texto compartido se rellenará automáticamente';

  @override
  String errorSearchingForums(String error) {
    return 'Error al buscar foros: $error';
  }

  @override
  String failedToLoadUserInfo(String error) {
    return 'No se pudo cargar la información del usuario: $error';
  }

  @override
  String areYouSureUnban(String username) {
    return '¿Seguro que quieres desbloquear a $username?';
  }

  @override
  String get deletePostsProfilePostsComments =>
      'Eliminar mensajes, mensajes de perfil y comentarios';

  @override
  String areYouSureSpamClean(String username) {
    return '¿Seguro que quieres limpiar el spam de $username?';
  }

  @override
  String successfullyCleanedSpamFor(String username) {
    return 'Se limpió el spam de $username';
  }

  @override
  String get failedToCleanSpam => 'No se pudo limpiar el spam';

  @override
  String imagesCount(int count) {
    return 'Imágenes ($count)';
  }

  @override
  String get pleaseLoginToViewProfiles =>
      'Inicia sesión para ver los perfiles de usuario.';

  @override
  String get tapToOpen => 'Toca para abrir';

  @override
  String get imageNotAvailable => 'Imagen no disponible';

  @override
  String get tapToViewFullSizeImage =>
      'Toca para ver la imagen a tamaño completo';

  @override
  String get loadingImage => 'Cargando imagen...';

  @override
  String loadingImageFrom(String host) {
    return 'Cargando imagen de $host';
  }

  @override
  String get tapToReveal => '(toca para mostrar)';

  @override
  String get inlineAttachments => 'Archivos adjuntos insertados';

  @override
  String get thisFieldIsRequired => 'Este campo es obligatorio';

  @override
  String get pleaseEnterValidPhoneNumber =>
      'Introduce un número de teléfono válido';

  @override
  String get pleaseEnterValidUrl => 'Introduce una URL válida';

  @override
  String get permissionDeniedToSaveImage =>
      'No hay permiso para guardar la imagen';

  @override
  String get postNotFound => 'No se encontró el mensaje.';

  @override
  String get failedToUploadFileTryAgain =>
      'No se pudo subir el archivo. Inténtalo de nuevo.';

  @override
  String get failedToPickFile => 'No se pudo seleccionar el archivo';

  @override
  String onlyMoreAttachmentsAllowed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Solo se permiten $count archivos adjuntos más. Se usarán las primeras $count imágenes.',
      one: 'Solo se permite 1 archivo adjunto más. Se usará la primera imagen.',
    );
    return '$_temp0';
  }

  @override
  String get attachmentLimitReachedSkipping =>
      'Se alcanzó el límite de archivos adjuntos. Se omiten las imágenes restantes.';

  @override
  String get imageValidationFailed => 'La imagen no es válida';

  @override
  String get imageUploadFailed => 'No se pudo subir la imagen';

  @override
  String get failedToUploadImageTryAgain =>
      'No se pudo subir la imagen. Inténtalo de nuevo.';

  @override
  String get failedToPickImage => 'No se pudo seleccionar la imagen';

  @override
  String get prefix => 'Prefijo';

  @override
  String get failedToLoadPrefixes => 'No se pudieron cargar los prefijos';

  @override
  String get attachFileHint => 'Adjuntar un archivo a este mensaje';

  @override
  String get uploadImageHint => 'Subir una imagen a este mensaje';

  @override
  String get openFormattingOptions => 'Abrir opciones de formato';

  @override
  String get failedToPostReply =>
      'No se pudo publicar la respuesta. Inténtalo de nuevo.';

  @override
  String get failedToUpdatePost =>
      'No se pudo actualizar el mensaje. Inténtalo de nuevo.';

  @override
  String get postDeletedSuccessfully => 'Mensaje eliminado';

  @override
  String failedToDeletePost(String error) {
    return 'No se pudo eliminar el mensaje: $error';
  }

  @override
  String get noPermissionToUploadAvatars =>
      'No tienes permiso para subir avatares';

  @override
  String get avatarUploadedSuccessfully => 'Avatar subido';

  @override
  String get unknownTopic => 'Tema desconocido';

  @override
  String get connectionTimeoutTitle => 'Tiempo de conexión agotado';

  @override
  String connectionTimedOutTo(String siteName) {
    return 'Se agotó el tiempo de conexión con $siteName. Revisa tu conexión a internet e inténtalo de nuevo.';
  }

  @override
  String failedToConnectCheckPlugin(String siteName) {
    return 'No se pudo conectar con $siteName. Comprueba que el foro esté disponible y que el plugin esté instalado.';
  }

  @override
  String get voteFailedTryAgain => 'No se pudo votar. Inténtalo de nuevo.';

  @override
  String get noUserSpecified => 'No se indicó ningún usuario';

  @override
  String get failedToLoadRecentPosts =>
      'No se pudieron cargar los mensajes recientes';

  @override
  String failedToLoadPreview(String error) {
    return 'No se pudo cargar la vista previa: $error';
  }

  @override
  String thanksCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Agradecido por $count personas',
      one: 'Agradecido por $count persona',
    );
    return '$_temp0';
  }

  @override
  String get thankedBy => 'Agradecido por';

  @override
  String maximumAttachmentsAllowed(int count) {
    return 'Máximo de $count archivo(s) adjunto(s) permitido(s)';
  }

  @override
  String get toLabel => 'Para';

  @override
  String get closeConversation => 'Cerrar conversación';

  @override
  String get openConversation => 'Abrir conversación';

  @override
  String get loginSucceeded => 'Sesión iniciada';

  @override
  String get verificationErrorTryAgain =>
      'Se produjo un error durante la verificación. Inténtalo de nuevo.';

  @override
  String get passkeyChallengeFailed =>
      'No se pudo iniciar el acceso con llave de acceso.';

  @override
  String get passkeyNotSetUp =>
      'Este foro aún no admite llaves de acceso en esta app. Inicia sesión con tu usuario y contraseña.';

  @override
  String get noPasskeyForForum =>
      'No hay ninguna llave de acceso para este foro. Inicia sesión con tu contraseña o crea primero una llave de acceso en la web del foro.';

  @override
  String get pushNotificationsNotReady =>
      'Las notificaciones push aún no están listas';

  @override
  String pushEnabledFor(String siteName) {
    return 'Notificaciones push activadas para $siteName';
  }

  @override
  String get failedToEnablePush =>
      'No se pudieron activar las notificaciones push';

  @override
  String get failedToRegisterPush =>
      'No se pudo registrar para notificaciones push';

  @override
  String translatedFromTo(String source, String target) {
    return 'Traducido de $source a $target';
  }

  @override
  String get unableToOpenNotification => 'No se puede abrir la notificación';

  @override
  String get notificationMissingInfo =>
      'A esta notificación le falta información.';

  @override
  String get couldNotOpenForum => 'No se pudo abrir el foro.';

  @override
  String get notificationChannelName => 'Notificaciones de Forum Copilot';

  @override
  String get notificationChannelDescription =>
      'Notificaciones de la app Forum Copilot';

  @override
  String fileTypeNotAllowed(String extension, String allowed) {
    return 'El tipo de archivo .$extension no está permitido. Tipos permitidos: $allowed';
  }

  @override
  String fileSizeExceedsMaximum(String size, String max) {
    return 'El tamaño del archivo ($size) supera el máximo de $max';
  }

  @override
  String get fileTypeAudio => 'Audio';

  @override
  String get fileTypeText => 'Texto';

  @override
  String get fileTypeArchive => 'Archivo comprimido';

  @override
  String get fileTypeFile => 'Archivo';

  @override
  String get imageFileNotFound =>
      'No se encontró el archivo de imagen. Puede que se haya movido o eliminado.';

  @override
  String get imagePermissionDenied =>
      'Permiso denegado. No se puede leer el archivo de imagen.';

  @override
  String get imageInsufficientSpace =>
      'No hay espacio suficiente para optimizar la imagen.';

  @override
  String cannotAccessImageFile(String error) {
    return 'No se puede acceder al archivo de imagen: $error';
  }

  @override
  String get imageFormatUnsupported =>
      'El formato de la imagen está dañado o no es compatible. Prueba con otra imagen.';

  @override
  String get failedToResizeImage =>
      'No se pudo redimensionar la imagen. Puede estar dañada o en un formato no compatible.';

  @override
  String get failedToConvertImageToJpg =>
      'No se pudo convertir la imagen a JPG. Puede estar dañada.';

  @override
  String get failedToCompressImage =>
      'No se pudo comprimir la imagen. Puede que falte espacio o que la imagen esté dañada.';

  @override
  String get cannotDecodeImage =>
      'No se puede decodificar la imagen. El archivo puede estar dañado o en un formato no compatible.';

  @override
  String get cannotReadImageFile =>
      'No se puede leer el archivo de imagen. Puede que se haya movido o eliminado.';

  @override
  String failedToOptimizeImage(String error) {
    return 'No se pudo optimizar la imagen: $error';
  }

  @override
  String emailCopiedToClipboard(String email) {
    return 'Correo copiado al portapapeles: $email';
  }

  @override
  String couldNotOpenEmail(String email) {
    return 'No se pudo abrir el correo: $email';
  }

  @override
  String get editPost => 'Editar publicacion';

  @override
  String get thisTopicIsPinnedToTopOfForum =>
      'Este tema esta fijado en la parte superior del foro';

  @override
  String get editConversation => 'Editar conversación';

  @override
  String get failedToLoadConversation => 'No se pudo cargar la conversación';

  @override
  String get cannotEditConversation => 'No se puede editar esta conversación';

  @override
  String get titleLabel => 'Título';

  @override
  String get options => 'Opciones';

  @override
  String get openInvite => 'Invitación abierta';

  @override
  String get allowAnyParticipantToInviteOthers =>
      'Permitir que cualquier participante invite a otros';

  @override
  String get conversationOpen => 'Conversación abierta';

  @override
  String failedToCreateConversation(String error) {
    return 'No se pudo crear la conversación: $error';
  }

  @override
  String get lockConversation => 'Bloquear conversación';

  @override
  String get createConversationAsClosed =>
      'Crear conversación como cerrada (sin respuestas permitidas)';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountDescription => 'Elimina tu cuenta de este foro.';

  @override
  String get deleteAccountContactForumMessage =>
      'Tu cuenta está gestionada por el foro. Ponte en contacto con el foro directamente para eliminar la cuenta. Usa el botón “Contáctanos” al final de la página principal del foro.';

  @override
  String get forumUrlUnavailable => 'La URL del foro no está disponible.';

  @override
  String get couldNotOpenForumUrl => 'No se pudo abrir la URL del foro.';

  @override
  String get noActionUrlAvailableForThisNotificationType =>
      'No hay URL de acción disponible para este tipo de notificación.';

  @override
  String get signInToViewNotifications =>
      'Inicia sesión para ver notificaciones';

  @override
  String get youNeedToBeSignedInToViewYourNotifications =>
      'Debes iniciar sesión para ver tus notificaciones.';

  @override
  String get errorLoadingNotifications => 'Error al cargar notificaciones';

  @override
  String get pullDownToRefresh => 'Desliza hacia abajo para actualizar';

  @override
  String get youHaveNoNewNotificationsCheckBackLater =>
      'No tienes notificaciones nuevas. Vuelve más tarde para ver actualizaciones.';

  @override
  String get signInToViewProfile => 'Inicia sesion para ver el perfil';

  @override
  String get youNeedToBeSignedInToViewYourProfile =>
      'Debes iniciar sesion para ver tu perfil.';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get confirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get protectedForum => 'Foro protegido';

  @override
  String forumIsPasswordProtected(String forumName) {
    return '$forumName esta protegido con contrasena.';
  }

  @override
  String get enterButton => 'Entrar';

  @override
  String get recentPosts => 'Publicaciones recientes';

  @override
  String passkeyNotAvailableInForum(int code) {
    return 'Passkey no está disponible en este foro actualmente (código: $code)';
  }

  @override
  String get initializingForum => 'Iniciando el foro…';

  @override
  String get retryConnection => 'Reintentar conexión';

  @override
  String get pleaseConfirmPassword => 'Por favor confirma tu contraseña';

  @override
  String get pleaseEnterTheForumPassword => 'Ingresa la contrasena del foro';

  @override
  String get editYourPost => 'Edita tu publicacion...';

  @override
  String get topicIdIsMissingCannotNavigateToThePost =>
      'Falta el ID del tema. No se puede navegar a la publicación.';

  @override
  String get conversationIsOpenForReplies =>
      'La conversación está abierta para respuestas';

  @override
  String get conversationIsClosedNoRepliesAllowed =>
      'La conversación está cerrada (no se permiten respuestas)';

  @override
  String get pleaseEnterAUsername => 'Introduce un nombre de usuario';

  @override
  String usernameMinLength(int count) {
    return 'El nombre de usuario debe tener al menos $count caracteres';
  }

  @override
  String get pleaseEnterAPassword => 'Introduce una contraseña';

  @override
  String passwordMinLength(int count) {
    return 'La contraseña debe tener al menos $count caracteres';
  }

  @override
  String get writeYourTopicTitle => 'Escribe el título del tema...';

  @override
  String get writeYourTopicContent => 'Escribe el contenido del tema...';

  @override
  String pushDisabledFor(String siteName) {
    return 'Notificaciones push desactivadas para $siteName';
  }

  @override
  String get failedToDisablePush =>
      'No se pudieron desactivar las notificaciones push';

  @override
  String get thisForum => 'este foro';

  @override
  String get openFullEditor => 'Editor completo';

  @override
  String statsMembers(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString miembros',
      one: '$countString miembro',
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
      other: '$countString temas',
      one: '$countString tema',
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
      other: '$countString mensajes',
      one: '$countString mensaje',
    );
    return '$_temp0';
  }

  @override
  String searchForumName(String forumName) {
    return 'Buscar en $forumName';
  }

  @override
  String get copyLink => 'Copiar enlace';

  @override
  String get linkCopied => 'Enlace copiado';

  @override
  String sharedFilesAttached(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se adjuntaron $count archivos compartidos.',
      one: 'Se adjuntó 1 archivo compartido.',
    );
    return '$_temp0';
  }

  @override
  String sharedFilesPartlyAttached(int count, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se adjuntaron $count archivos. Sin adjuntar: $names',
      one: 'Se adjuntó 1 archivo. Sin adjuntar: $names',
    );
    return '$_temp0';
  }

  @override
  String get notificationChannelMessages => 'Mensajes';

  @override
  String get notificationChannelMessagesDescription =>
      'Mensajes directos nuevos y sus respuestas';

  @override
  String get notificationChannelReplies => 'Respuestas y menciones';

  @override
  String get notificationChannelRepliesDescription =>
      'Respuestas en temas que sigues, citas y menciones';

  @override
  String get notificationChannelReactions => 'Me gusta y reacciones';

  @override
  String get notificationChannelReactionsDescription =>
      'Me gusta y reacciones a tus mensajes';

  @override
  String get notificationChannelOther => 'Otras notificaciones';

  @override
  String get notificationChannelOtherDescription =>
      'Seguidores, trofeos y otras alertas del foro';

  @override
  String get deleteAccountConfirmTitle => '¿Eliminar tu cuenta?';

  @override
  String deleteAccountConfirmMessage(String forumName) {
    return 'Tu cuenta en $forumName se eliminará, junto con tu perfil y tus ajustes. Tus mensajes se mantienen, con tu nombre. No se puede deshacer.';
  }

  @override
  String get deleteAccountNoPassword =>
      '¿Sin contraseña? Confirma con tu nombre de usuario';

  @override
  String get deleteAccountUsePassword => 'Confirmar con tu contraseña';

  @override
  String get accountDeleted => 'Tu cuenta se ha eliminado.';

  @override
  String get signInOnWebsite => 'Iniciar sesión en el sitio web del foro';

  @override
  String get signInOnWebsiteHint =>
      'Para Google, Facebook y las demás formas de entrar allí';

  @override
  String get browserLoginFailed =>
      'No se pudo iniciar sesión en el sitio web. Inténtalo de nuevo.';
}
