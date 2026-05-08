// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Forum App';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get usernameLabel => 'Nom d\'utilisateur';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get signInWithPasskey => 'Sign in with Passkey';

  @override
  String get usePasskey => 'Use Passkey';

  @override
  String get passkeyContinuePrompt => 'Use your passkey to continue';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get pleaseEnterUsername => 'Veuillez entrer votre nom d\'utilisateur';

  @override
  String get pleaseEnterPassword => 'Veuillez entrer votre mot de passe';

  @override
  String credentialsSentToDomain(String domain) {
    return 'Votre nom d\'utilisateur et mot de passe seront envoyés à $domain';
  }

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get logIn => 'Se connecter';

  @override
  String get continueButton => 'Continuer';

  @override
  String get registrationNotAvailable => 'Inscription non disponible';

  @override
  String get registrationNotAvailableMessage =>
      'L\'inscription n\'est actuellement pas disponible. Le forum peut être fermé ou l\'inscription peut être désactivée.';

  @override
  String get webRegistrationRequired => 'Inscription web requise';

  @override
  String get webRegistrationRequiredMessage =>
      'Ce forum nécessite une inscription via le navigateur web. Veuillez cliquer sur le bouton ci-dessous pour ouvrir la page d\'inscription.';

  @override
  String get openRegistrationPage => 'Ouvrir la page d\'inscription';

  @override
  String get loadingAdditionalFields =>
      'Chargement des champs supplémentaires...';

  @override
  String get pleaseSelectDateOfBirth =>
      'Veuillez sélectionner votre date de naissance';

  @override
  String get pleaseEnterLocation => 'Veuillez entrer votre localisation';

  @override
  String get pleaseIndicateEmailPreference =>
      'Veuillez indiquer votre préférence d\'e-mail';

  @override
  String get pleaseFillAllRequiredFields =>
      'Veuillez remplir tous les champs obligatoires';

  @override
  String get pleaseAcceptTermsOfService =>
      'Veuillez accepter les Conditions d\'utilisation';

  @override
  String get pleaseAcceptPrivacyPolicy =>
      'Veuillez accepter la Politique de confidentialité';

  @override
  String get registrationError => 'Erreur d\'inscription';

  @override
  String get registrationFailed =>
      'L\'inscription a échoué. Veuillez vérifier vos informations.';

  @override
  String get registrationFailedTryAgain =>
      'L\'inscription a échoué. Veuillez réessayer.';

  @override
  String get registrationInfo => 'Informations d\'inscription';

  @override
  String get openWebsite => 'Ouvrir le site web';

  @override
  String couldNotOpenForumWebsite(String url) {
    return 'Impossible d\'ouvrir le site web du forum. Veuillez essayer de visiter : $url';
  }

  @override
  String get registrationSuccessfulEmailConfirm =>
      'Inscription réussie ! Veuillez vérifier votre e-mail pour confirmer votre compte avant de vous connecter.';

  @override
  String get registrationSuccessfulPendingApproval =>
      'Inscription réussie ! Votre compte est en attente d\'approbation. Vous serez notifié lorsque votre compte sera approuvé.';

  @override
  String get registrationSuccessfulAutoLogin =>
      'Inscription réussie ! Vous avez été automatiquement connecté.';

  @override
  String get welcome => 'Bienvenue !';

  @override
  String get registrationSuccessful => 'Inscription réussie';

  @override
  String get pleaseLoginWithNewAccount =>
      'Veuillez vous connecter avec votre nouveau compte.';

  @override
  String get forgotPasswordTitle => 'Mot de passe oublié';

  @override
  String get usernameOrEmailLabel => 'Nom d\'utilisateur ou e-mail';

  @override
  String get pleaseEnterUsernameOrEmail =>
      'Veuillez entrer votre nom d\'utilisateur ou e-mail';

  @override
  String get sendResetLink => 'Envoyer le lien de réinitialisation';

  @override
  String get resetLinkSent => 'Lien de réinitialisation envoyé';

  @override
  String get passwordResetInstructionsSent =>
      'Les instructions pour réinitialiser votre mot de passe ont été envoyées à votre adresse e-mail enregistrée.';

  @override
  String get resetFailed => 'Échec de la réinitialisation';

  @override
  String get unableToSendResetLink =>
      'Impossible d\'envoyer le lien de réinitialisation. Veuillez réessayer.';

  @override
  String get errorSendingResetLink =>
      'Une erreur s\'est produite lors de l\'envoi du lien de réinitialisation. Veuillez vérifier votre connexion et réessayer.';

  @override
  String get errorTitle => 'Erreur';

  @override
  String get okButton => 'OK';

  @override
  String get retryButton => 'Réessayer';

  @override
  String get copyToClipboard => 'Copier dans le presse-papiers';

  @override
  String get copied => 'Copié';

  @override
  String get errorMessageCopiedToClipboard =>
      'Message d\'erreur copié dans le presse-papiers';

  @override
  String get dismiss => 'Ignorer';

  @override
  String get cancel => 'Annuler';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get getHelp => 'Obtenir de l\'aide';

  @override
  String get somethingWentWrong => 'Quelque chose s\'est mal passé';

  @override
  String get unexpectedErrorOccurred =>
      'Une erreur inattendue s\'est produite. Veuillez réessayer.';

  @override
  String get noInternetConnection => 'Pas de connexion Internet';

  @override
  String get checkInternetConnection =>
      'Veuillez vérifier votre connexion Internet et réessayer.';

  @override
  String get authenticationRequired => 'Authentification requise';

  @override
  String get pleaseLoginToContinue => 'Veuillez vous connecter pour continuer.';

  @override
  String get forumError => 'Erreur du forum';

  @override
  String get anErrorOccurred => 'Une erreur s\'est produite';

  @override
  String get accountPendingApproval =>
      'Votre compte est en attente d\'approbation. Vous pouvez parcourir le forum mais ne pouvez pas publier jusqu\'à ce qu\'un modérateur approuve votre compte.';

  @override
  String get checkEmailToConfirm =>
      'Veuillez vérifier votre e-mail pour confirmer votre compte. Cliquez sur le lien de confirmation dans l\'e-mail que nous vous avons envoyé.';

  @override
  String get checkNewEmailToConfirm =>
      'Veuillez vérifier votre nouvelle adresse e-mail pour confirmer le changement. Votre ancien e-mail restera actif jusqu\'à ce que vous confirmiez le nouveau.';

  @override
  String get emailAddressInvalid =>
      'Votre adresse e-mail semble invalide ou rejette les e-mails. Veuillez mettre à jour votre adresse e-mail dans les paramètres du compte.';

  @override
  String get accountDisabled =>
      'Votre compte a été désactivé. Veuillez contacter un administrateur pour obtenir de l\'aide.';

  @override
  String get accountRegistrationRejected =>
      'L\'inscription de votre compte a été rejetée. Veuillez contacter un administrateur pour plus d\'informations.';

  @override
  String get welcomeToForumCopilot => 'Bienvenue sur Forum Copilot !';

  @override
  String get successfullyLoggedOut => 'Vous avez été déconnecté avec succès';

  @override
  String get accountStatusRequiresAttention =>
      'Le statut de votre compte nécessite une attention. Veuillez contacter un administrateur si vous avez des questions.';

  @override
  String get updateEmail => 'Mettre à jour l\'e-mail';

  @override
  String get resend => 'Renvoyer';

  @override
  String get noLatestTopics => 'Aucun sujet récent';

  @override
  String get noRecentTopicsToDisplay =>
      'Il n\'y a pas de sujets récents à afficher. Revenez plus tard pour de nouvelles discussions.';

  @override
  String get signInToViewLatestTopics =>
      'Connectez-vous pour voir les sujets récents';

  @override
  String get youNeedToBeSignedInToViewLatestTopics =>
      'Vous devez être connecté pour voir les sujets récents';

  @override
  String get noUnreadTopics => 'Aucun sujet non lu';

  @override
  String get thereAreNoUnreadTopics =>
      'Il n\'y a pas de sujets non lus. Revenez plus tard pour de nouvelles discussions.';

  @override
  String get youAreAllCaughtUp => 'Vous êtes à jour !';

  @override
  String get signInToViewUnreadTopics =>
      'Connectez-vous pour voir les sujets non lus';

  @override
  String get youNeedToBeSignedInToViewUnreadTopics =>
      'Vous devez être connecté pour voir vos sujets non lus';

  @override
  String get noSubscribedTopics => 'Aucun sujet abonné';

  @override
  String get noSubscribedTopicsMessage =>
      'Vous ne vous êtes abonné à aucun sujet. Appuyez sur le bouton étoile sur un sujet pour vous abonner et recevoir des notifications pour les nouvelles mises à jour.';

  @override
  String get signInToViewSubscribedTopics =>
      'Connectez-vous pour voir les sujets abonnés';

  @override
  String get youNeedToBeSignedInToViewSubscribedTopics =>
      'Vous devez être connecté pour voir vos sujets abonnés';

  @override
  String get noParticipatedTopics => 'Aucun sujet participé';

  @override
  String get topicsYouParticipatedIn =>
      'Les sujets auxquels vous avez participé seront affichés ici.';

  @override
  String get signInToViewParticipatedTopics =>
      'Connectez-vous pour voir les sujets participés';

  @override
  String get youNeedToBeSignedInToViewParticipatedTopics =>
      'Vous devez être connecté pour voir les sujets auxquels vous avez participé';

  @override
  String get latest => 'Récent';

  @override
  String get unread => 'Non lu';

  @override
  String get subscribed => 'Abonné';

  @override
  String get participated => 'Participé';

  @override
  String get connectionTimedOut =>
      'Délai de connexion expiré. Le site peut être hors ligne ou inaccessible.';

  @override
  String get failedToConnectToSite =>
      'Échec de la connexion au site. Le site peut être hors ligne ou inaccessible.';

  @override
  String get connectionFailed => 'Échec de la connexion';

  @override
  String failedToConnectToSiteName(String siteName) {
    return 'Échec de la connexion à $siteName';
  }

  @override
  String get loading => 'Chargement...';

  @override
  String get newConversation => 'Nouvelle conversation';

  @override
  String get newMessage => 'Nouveau message';

  @override
  String get appSettings => 'Paramètres de l\'application';

  @override
  String get searchSites => 'Rechercher des sites';

  @override
  String get language => 'Langue';

  @override
  String get systemDefault => 'Par défaut du système';

  @override
  String get followSystemLanguage => 'Suivre la langue du système';

  @override
  String get all => 'Tout';

  @override
  String get topicsOnly => 'Sujets uniquement';

  @override
  String get titlesOnly => 'Titres uniquement';

  @override
  String failedToShareTopic(String error) {
    return 'Échec du partage du sujet : $error';
  }

  @override
  String pleaseLoginToSubscribe(String action) {
    return 'Veuillez vous connecter pour $action ce fil';
  }

  @override
  String get subscribeTo => 's\'abonner à';

  @override
  String get unsubscribeFrom => 'se désabonner de';

  @override
  String get subscribe => 'S\'abonner';

  @override
  String get unsubscribe => 'Se désabonner';

  @override
  String failedToSubscribeToThread(String action) {
    return 'Échec de $action du fil';
  }

  @override
  String get youCannotReplyToThisThread =>
      'Vous ne pouvez pas répondre à ce fil';

  @override
  String get pleaseWaitForThreadToLoad =>
      'Veuillez attendre le chargement du fil';

  @override
  String get softDelete => 'Suppression douce';

  @override
  String get postCanBeRestoredLater =>
      'Le message peut être restauré plus tard';

  @override
  String get hardDelete => 'Suppression définitive';

  @override
  String get postWillBePermanentlyDeleted =>
      'Le message sera définitivement supprimé';

  @override
  String get reasonForDeletion => 'Raison de la suppression';

  @override
  String get enterReasonForDeletingPost =>
      'Entrez la raison de la suppression de ce message';

  @override
  String get pleaseEnterReasonForDeletion =>
      'Veuillez entrer une raison pour la suppression';

  @override
  String get reportPost => 'Signaler le message';

  @override
  String get pleaseProvideReasonForReporting =>
      'Veuillez fournir une raison pour signaler ce message.';

  @override
  String get reason => 'Raison';

  @override
  String get enterReasonForReportingPost =>
      'Entrez la raison de signalement de ce message';

  @override
  String get pleaseEnterReason => 'Veuillez entrer une raison';

  @override
  String get submitReport => 'Soumettre le rapport';

  @override
  String get selectedActions => 'Actions sélectionnées :';

  @override
  String get thisActionCannotBeUndone =>
      'Cette action ne peut pas être annulée.';

  @override
  String get participantsLabel => 'Participants';

  @override
  String usernameHasBeenInvited(String username) {
    return '$username a été invité à la conversation';
  }

  @override
  String errorInvitingUser(String error) {
    return 'Erreur lors de l\'invitation de l\'utilisateur : $error';
  }

  @override
  String get newTopic => 'Nouveau sujet';

  @override
  String get markRead => 'Marquer comme lu';

  @override
  String get reportUser => 'Signaler l\'utilisateur';

  @override
  String get pleaseSelectReasonForReportingUser =>
      'Veuillez sélectionner une raison pour signaler cet utilisateur.';

  @override
  String get spamOrAdvertising => 'Spam ou publicité';

  @override
  String get harassmentOrBullying => 'Harcèlement ou intimidation';

  @override
  String get inappropriateContent => 'Contenu inapproprié';

  @override
  String get impersonationOrFakeAccount =>
      'Usurpation d\'identité ou compte faux';

  @override
  String get otherPleaseSpecify => 'Autre (veuillez préciser)';

  @override
  String get pleaseSpecifyReason => 'Veuillez préciser la raison';

  @override
  String get enterReasonForReportingUser =>
      'Entrez la raison de signalement de cet utilisateur';

  @override
  String get pleaseSelectReason => 'Veuillez sélectionner une raison';

  @override
  String get banUser => 'Bannir l\'utilisateur';

  @override
  String get unbanUser => 'Débannir l\'utilisateur';

  @override
  String pleaseSelectReasonForBanningUser(String username) {
    return 'Veuillez sélectionner une raison pour bannir $username';
  }

  @override
  String get violationOfCommunityGuidelines =>
      'Violation des directives de la communauté';

  @override
  String get harassmentOrAbusiveBehavior =>
      'Harcèlement ou comportement abusif';

  @override
  String get postingInappropriateContent =>
      'Publication de contenu inapproprié';

  @override
  String get accountCompromiseOrSecurityIssue =>
      'Compromission du compte ou problème de sécurité';

  @override
  String get enterReasonForBanningUser =>
      'Entrez la raison de bannissement de cet utilisateur';

  @override
  String get banUntil => 'Bannir jusqu\'au';

  @override
  String get selectDate => 'Sélectionner la date';

  @override
  String get moreOptions => 'Plus d\'options';

  @override
  String get leaveConversation => 'Quitter la conversation';

  @override
  String get reportConversation => 'Signaler la conversation';

  @override
  String get topicClosed => 'Sujet fermé';

  @override
  String get topicOpened => 'Sujet ouvert';

  @override
  String get topicStickied => 'Sujet épinglé';

  @override
  String get topicUnstickied => 'Sujet désépinglé';

  @override
  String cannotEditMessage(String error) {
    return 'Impossible d\'éditer ce message : $error';
  }

  @override
  String get confirmSpamClean => 'Confirmer le nettoyage du spam';

  @override
  String get handleThreads => 'Gérer les fils';

  @override
  String get deleteMessages => 'Supprimer les messages';

  @override
  String get deleteConversations => 'Supprimer les conversations';

  @override
  String get myForums => 'Mes Forums';

  @override
  String get recentlyVisited => 'Récemment Visités';

  @override
  String get explore => 'Explorer';

  @override
  String get forumCopilot => 'Forum Copilot';

  @override
  String get noConversations => 'Aucune conversation';

  @override
  String get noConversationsMessage =>
      'Vous n\'avez pas encore de conversations. Démarrez une nouvelle conversation pour commencer à envoyer des messages.';

  @override
  String get imageSavedToGallery => 'Image enregistrée dans la galerie !';

  @override
  String failedToSaveImage(String error) {
    return 'Échec de l\'enregistrement de l\'image : $error';
  }

  @override
  String get userProfile => 'Profil Utilisateur';

  @override
  String get deletePost => 'Supprimer le Message';

  @override
  String get loginRequired => 'Connexion Requise';

  @override
  String get spamCleaner => 'Nettoyeur de spam';

  @override
  String get sendMessage => 'Envoyer un message';

  @override
  String get memberSince => 'Membre Depuis';

  @override
  String get lastActivity => 'Dernière Activité';

  @override
  String get likesReceived => 'J\'aime Reçus';

  @override
  String get likesGiven => 'J\'aime Donnés';

  @override
  String get showMore => 'Afficher plus';

  @override
  String get cleanSpam => 'Nettoyer le spam';

  @override
  String get failedToSaveMessage => 'Échec de l\'enregistrement du message';

  @override
  String get failedToSaveConversation =>
      'Échec de l\'enregistrement de la conversation';

  @override
  String get failedToSaveSetting => 'Échec de l\'enregistrement du paramètre';

  @override
  String get failedToSavePost => 'Échec de l\'enregistrement du message';

  @override
  String errorLoadingSites(String error) {
    return 'Erreur lors du chargement des sites : $error';
  }

  @override
  String connectingTo(String domainName) {
    return 'Connexion à $domainName...';
  }

  @override
  String get members => 'Membres';

  @override
  String get allMembers => 'Tous les Membres';

  @override
  String get online => 'En Ligne';

  @override
  String get noMembersFound => 'Aucun membre trouvé';

  @override
  String get searchForMembers => 'Rechercher des membres';

  @override
  String get enterUsernameToFindMembers =>
      'Entrez un nom d\'utilisateur pour trouver des membres du forum';

  @override
  String get noMembersOnline => 'Aucun membre n\'est actuellement en ligne';

  @override
  String get enterUsernameToSearch =>
      'Entrez le nom d\'utilisateur pour rechercher...';

  @override
  String get lookupMembers => 'Rechercher des Membres';

  @override
  String get addMembers => 'Ajouter des Membres';

  @override
  String get membersAddedSuccessfully => 'Membres ajoutés avec succès';

  @override
  String errorAddingMembers(String error) {
    return 'Erreur lors de l\'ajout de membres : $error';
  }

  @override
  String get failedToLoadOnlineUsers =>
      'Échec du chargement des utilisateurs en ligne';

  @override
  String get noUsersOnline => 'Aucun utilisateur en ligne';

  @override
  String membersCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString Membres';
  }

  @override
  String get noSubject => 'Sans objet';

  @override
  String get search => 'Rechercher';

  @override
  String get logout => 'Déconnexion';

  @override
  String get areYouSureYouWantToLogout =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get register => 'S\'inscrire';

  @override
  String get signIn => 'Se connecter';

  @override
  String get markForumRead => 'Marquer le Forum comme Lu';

  @override
  String get notificationTest => 'Test de Notification';

  @override
  String get forum => 'Forum';

  @override
  String get profile => 'Profil';

  @override
  String get messages => 'Messages';

  @override
  String get add => 'Ajouter';

  @override
  String get retry => 'Réessayer';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteMessage => 'Supprimer le Message';

  @override
  String get areYouSureYouWantToDeleteThisMessage =>
      'Êtes-vous sûr de vouloir supprimer ce message ?';

  @override
  String failedToDeleteMessage(String error) {
    return 'Échec de la suppression du message : $error';
  }

  @override
  String get deletingPost => 'Suppression du message...';

  @override
  String failedToUnlikePost(String error) {
    return 'Échec du retrait du j\'aime du message : $error';
  }

  @override
  String failedToLikePost(String error) {
    return 'Échec du j\'aime du message : $error';
  }

  @override
  String failedToThankPost(String error) {
    return 'Échec du remerciement du message : $error';
  }

  @override
  String get signInToViewMessages => 'Connectez-vous pour voir les messages';

  @override
  String get youNeedToBeSignedInToViewConversations =>
      'Vous devez être connecté pour voir vos conversations.';

  @override
  String errorLoadingConversations(String error) {
    return 'Erreur lors du chargement des conversations : $error';
  }

  @override
  String failedToLeaveConversation(String error) {
    return 'Échec de la sortie de la conversation : $error';
  }

  @override
  String errorLoadingMoreConversations(String error) {
    return 'Erreur lors du chargement de plus de conversations : $error';
  }

  @override
  String errorLoadingMoreMessages(String error) {
    return 'Erreur lors du chargement de plus de messages : $error';
  }

  @override
  String get inviteMessageOptional => 'Message d\'Invitation (optionnel)';

  @override
  String get iWouldLikeToAddYouToThisConversation =>
      'J\'aimerais vous ajouter à cette conversation.';

  @override
  String get searchFailed => 'Recherche échouée';

  @override
  String get trySearchingWithDifferentUsername =>
      'Essayez de rechercher avec un nom d\'utilisateur différent';

  @override
  String get noSitesFound => 'Aucun site trouvé.';

  @override
  String get userInformationNotAvailable =>
      'Informations utilisateur non disponibles';

  @override
  String get birthday => 'Anniversaire';

  @override
  String get posts => 'Messages';

  @override
  String get following => 'Abonnements';

  @override
  String get followers => 'Abonnés';

  @override
  String get about => 'À propos';

  @override
  String get location => 'Localisation';

  @override
  String get website => 'Site web';

  @override
  String get signature => 'Signature';

  @override
  String get next => 'Suivant';

  @override
  String get permanent => 'Permanent';

  @override
  String get temporary => 'Temporaire';

  @override
  String setBanDurationFor(String username) {
    return 'Définir la durée du bannissement pour $username';
  }

  @override
  String get pleaseSelectEndDateForTemporaryBan =>
      'Veuillez sélectionner une date de fin pour le bannissement temporaire';

  @override
  String get back => 'Retour';

  @override
  String get unban => 'Débannir';

  @override
  String get confirm => 'Confirmer';

  @override
  String spamClean(String username) {
    return 'Nettoyer le Spam de $username';
  }

  @override
  String get selectActionsToPerform => 'Sélectionnez les actions à effectuer :';

  @override
  String get moveOrDeleteThreadsBasedOnAdminSettings =>
      'Déplacer ou supprimer les fils selon les paramètres de l\'administrateur';

  @override
  String get messageUpdatedSuccessfully => 'Message mis à jour avec succès';

  @override
  String error(String error) {
    return 'Erreur : $error';
  }

  @override
  String failedToRemoveAttachment(String error) {
    return 'Échec de la suppression de la pièce jointe : $error';
  }

  @override
  String failedToLoadMessage(String error) {
    return 'Échec du chargement du message : $error';
  }

  @override
  String get editMessage => 'Modifier le Message';

  @override
  String get removeAttachment => 'Supprimer la Pièce Jointe';

  @override
  String get areYouSureYouWantToRemoveThisAttachment =>
      'Êtes-vous sûr de vouloir supprimer cette pièce jointe ?';

  @override
  String get none => 'Aucun';

  @override
  String get attachFile => 'Joindre un Fichier';

  @override
  String get uploadImage => 'Télécharger une Image';

  @override
  String get formatting => 'Formatage';

  @override
  String get bold => 'Gras';

  @override
  String get italic => 'Italique';

  @override
  String get underline => 'Souligné';

  @override
  String get strikethrough => 'Barré';

  @override
  String get link => 'Lien';

  @override
  String get image => 'Image';

  @override
  String get video => 'Vidéo';

  @override
  String get quote => 'Citation';

  @override
  String get code => 'Code';

  @override
  String get spoiler => 'Spoiler';

  @override
  String get bulletList => 'Liste à Puces';

  @override
  String get numberedList => 'Liste Numérotée';

  @override
  String get listItem => 'Élément de Liste';

  @override
  String participants(int count) {
    return 'Participants ($count)';
  }

  @override
  String get markAsUnread => 'Marquer comme non lu';

  @override
  String get invite => 'Inviter';

  @override
  String get welcomeBack => 'Bon retour !';

  @override
  String get signInToAccessYourProfile =>
      'Connectez-vous pour accéder à votre profil et gérer votre compte';

  @override
  String get enterYourUsername => 'Entrez votre nom d\'utilisateur';

  @override
  String get enterYourPassword => 'Entrez votre mot de passe';

  @override
  String get dontHaveAnAccount => 'Vous n\'avez pas de compte ?';

  @override
  String get enterKeywordsToSearchTopics =>
      'Entrez des mots-clés pour rechercher des sujets...';

  @override
  String get pleaseFillInAllRequiredFields =>
      'Veuillez remplir tous les champs obligatoires';

  @override
  String get undelete => 'Restaurer';

  @override
  String get refresh => 'Actualiser';

  @override
  String get share => 'Partager';

  @override
  String get viewOnWeb => 'Voir sur le Web';

  @override
  String get unlock => 'Déverrouiller';

  @override
  String get lock => 'Verrouiller';

  @override
  String get stick => 'Épingler';

  @override
  String get unstick => 'Désépingler';

  @override
  String get reply => 'Répondre';

  @override
  String get vote => 'Voter';

  @override
  String votesCount(int count) {
    return '$count votes';
  }

  @override
  String get pollClosed => 'Sondage fermé';

  @override
  String pollEndsOn(String date) {
    return 'Se termine le $date';
  }

  @override
  String get voteToSeeResults => 'Votez pour voir les résultats';

  @override
  String get viewFullPoll => 'Voir le sondage';

  @override
  String pollOptionsCount(int count) {
    return '$count options';
  }

  @override
  String get reactedBy => 'Réagi par';

  @override
  String get enterKeywordsToFindTopicsAndPosts =>
      'Entrez des mots-clés pour trouver des sujets et des messages';

  @override
  String get enterKeywordsOrDomainToFindForums =>
      'Entrez des mots-clés ou un domaine pour trouver des forums';

  @override
  String get enterKeywordsOrDomainNamesToFindForums =>
      'Entrez des mots-clés ou des noms de domaine pour trouver des forums';

  @override
  String get appearance => 'Apparence';

  @override
  String get followSystemTheme => 'Suivre le thème du système';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String version(String version, String buildNumber) {
    return 'version $version ($buildNumber)';
  }

  @override
  String get forumSettings => 'Paramètres du forum';

  @override
  String get noSettingsAvailable => 'Aucun paramètre disponible';

  @override
  String get settingsCategoriesWillAppearHere =>
      'Les catégories de paramètres apparaîtront ici lorsqu\'elles seront disponibles.';

  @override
  String get unableToLoadProfile => 'Impossible de charger le profil';

  @override
  String get banned => 'BANNI';

  @override
  String get reportSubmittedSuccessfully => 'Rapport soumis avec succès';

  @override
  String get failedToSubmitReport => 'Échec de la soumission du rapport';

  @override
  String get searchForForums => 'Rechercher des forums';

  @override
  String get searchForums => 'Rechercher des Forums';

  @override
  String get deleteTopic => 'Supprimer le sujet';

  @override
  String get topicCanBeRestoredLater => 'Le sujet peut être restauré plus tard';

  @override
  String get topicWillBePermanentlyDeleted =>
      'Le sujet sera supprimé définitivement';

  @override
  String get enterReasonForDeletingTopic =>
      'Entrez la raison de la suppression de ce sujet';

  @override
  String get pleaseSelectEndDate => 'Veuillez sélectionner une date de fin';

  @override
  String get userBannedSuccessfully => 'Utilisateur banni avec succès';

  @override
  String get failedToBanUser => 'Échec du bannissement de l\'utilisateur';

  @override
  String get userUnbannedSuccessfully => 'Utilisateur débanni avec succès';

  @override
  String get failedToUnbanUser => 'Échec du débannissement de l\'utilisateur';

  @override
  String get spamCleanUser => 'Nettoyer le spam de l\'utilisateur';

  @override
  String get deletePrivateConversations =>
      'Supprimer les conversations privées';

  @override
  String get banTheUserAccount => 'Bannir le compte utilisateur';

  @override
  String get handledThreads => 'Sujets traités';

  @override
  String get deletedMessages => 'Messages supprimés';

  @override
  String get deletedConversations => 'Conversations supprimées';

  @override
  String get bannedUser => 'Utilisateur banni';

  @override
  String successfullyCleanedSpam(String username, String actions) {
    return 'Spam nettoyé avec succès pour $username. Actions: $actions';
  }

  @override
  String errorLoadingMessage(String error) {
    return 'Erreur lors du chargement du message: $error';
  }

  @override
  String get messageNotFound => 'Message introuvable';

  @override
  String get home => 'Accueil';

  @override
  String get notifications => 'Notifications';

  @override
  String get forums => 'Forums';

  @override
  String get markAllForumsAsRead => 'Marquer tous les forums comme lus ?';

  @override
  String get markAllForumsAsReadMessage =>
      'Cela marquera tous les forums et sujets comme lus. Cette action ne peut pas être annulée.';

  @override
  String get markAsRead => 'Marquer comme lu';

  @override
  String get content => 'Contenu';

  @override
  String get insertImage => 'Insérer une image';

  @override
  String get howWouldYouLikeToInsertImage =>
      'Comment souhaitez-vous insérer cette image ?';

  @override
  String get thumbnail => 'Miniature';

  @override
  String get fullSize => 'Taille réelle';

  @override
  String get alignLeft => 'Aligner à gauche';

  @override
  String get alignCenter => 'Aligner au centre';

  @override
  String get alignRight => 'Aligner à droite';

  @override
  String get pleaseEnterTitle => 'Veuillez entrer un titre';

  @override
  String get pleaseEnterContent => 'Veuillez entrer du contenu';

  @override
  String get uploading => 'Téléchargement...';

  @override
  String get uploaded => 'Téléchargé';

  @override
  String get mentionUser => 'Mentionner un utilisateur';

  @override
  String get loggingIn => 'Connexion en cours...';

  @override
  String get submittingReport => 'Envoi du rapport...';

  @override
  String get banningUser => 'Bannissement de l\'utilisateur...';

  @override
  String get unbanningUser => 'Débannissement de l\'utilisateur...';

  @override
  String get cleaningSpam => 'Nettoyage du spam...';

  @override
  String get enterSubject => 'Entrez le sujet';

  @override
  String get typeYourMessageHere => 'Tapez votre message ici';

  @override
  String get writeYourMessage => 'Écrivez votre message...';

  @override
  String get writeYourReply => 'Écrivez votre réponse...';

  @override
  String get messageSentSuccessfully => 'Message envoyé avec succès';

  @override
  String get replySentSuccessfully => 'Réponse envoyée avec succès';

  @override
  String get conversationCreatedSuccessfully =>
      'Conversation créée avec succès';

  @override
  String get conversationMarkedAsUnread => 'Conversation marquée comme non lue';

  @override
  String get messageMarkedAsUnread => 'Message marqué comme non lu';

  @override
  String get conversationClosed => 'Conversation fermée';

  @override
  String get conversationOpened => 'Conversation ouverte';

  @override
  String get pleaseLoginToLikeMessages =>
      'Veuillez vous connecter pour aimer les messages';

  @override
  String get loadEarlierMessages => 'Charger les messages précédents';

  @override
  String failedToLoadQuote(String error) {
    return 'Échec du chargement de la citation : \n$error';
  }

  @override
  String failedToUploadFile(String error) {
    return 'Échec du téléchargement du fichier : $error';
  }

  @override
  String failedToUploadImage(String error) {
    return 'Échec du téléchargement de l\'image : $error';
  }

  @override
  String failedToSendMessage(String error) {
    return 'Échec de l\'envoi du message : $error';
  }

  @override
  String failedToSendReply(String error) {
    return 'Échec de l\'envoi de la réponse : $error';
  }

  @override
  String failedToMarkAsUnread(String error) {
    return 'Échec du marquage du message comme non lu : $error';
  }

  @override
  String failedToMarkConversationAsUnread(String error) {
    return 'Échec du marquage de la conversation comme non lue : $error';
  }

  @override
  String failedToCloseConversation(String error) {
    return 'Échec de la fermeture de la conversation : $error';
  }

  @override
  String failedToOpenConversation(String error) {
    return 'Échec de l\'ouverture de la conversation : $error';
  }

  @override
  String failedToJumpToMessage(String error) {
    return 'Échec du saut au message : $error';
  }

  @override
  String get goToTop => 'Aller en haut';

  @override
  String get goToBottom => 'Aller en bas';

  @override
  String get replyAll => 'Répondre à tous';

  @override
  String get forward => 'Transférer';

  @override
  String get noForumsFound => 'Aucun forum trouvé.';

  @override
  String get pleaseSelectPrefix => 'Veuillez sélectionner un préfixe';

  @override
  String get pleaseLoginToAccessContent =>
      'Veuillez vous connecter pour accéder à ce contenu et interagir avec les publications.';

  @override
  String get searchUsers => 'Rechercher des utilisateurs...';

  @override
  String get writeYourTitle => 'Écrivez votre titre...';

  @override
  String get writeYourContent => 'Écrivez votre contenu...';

  @override
  String get selectAnOption => 'Sélectionnez une option';

  @override
  String get enterConversationTitle => 'Entrez le titre de la conversation';

  @override
  String enterCode(int count) {
    return 'Entrez le code à $count chiffres';
  }

  @override
  String get edit => 'Modifier';

  @override
  String get report => 'Signaler';

  @override
  String get unfollow => 'Ne plus suivre';

  @override
  String get follow => 'Suivre';

  @override
  String get goToForums => 'Aller aux Forums';

  @override
  String get remove => 'Supprimer';

  @override
  String get subject => 'Sujet';

  @override
  String get message => 'Message';

  @override
  String get titleCannotBeEmpty => 'Le titre ne peut pas être vide';

  @override
  String get conversationUpdatedSuccessfully =>
      'Conversation mise à jour avec succès';

  @override
  String get goBack => 'Retour';

  @override
  String get privateMessagesNotAvailable => 'Messages privés non disponibles';

  @override
  String failedToLoadPost(String error) {
    return 'Échec du chargement de la publication : \n$error';
  }

  @override
  String failedToLikeOrUnlikeMessage(String action, String error) {
    return 'Échec du $action message : $error';
  }

  @override
  String get like => 'aimer';

  @override
  String get unlike => 'ne plus aimer';

  @override
  String get optimizeImage => 'Optimiser l\'image';

  @override
  String get optimizeAndUpload => 'Optimiser et télécharger';

  @override
  String downloading(String filename) {
    return 'Téléchargement de $filename...';
  }

  @override
  String openingShareSheet(String filename) {
    return 'Ouverture de la feuille de partage pour $filename';
  }

  @override
  String errorDownloading(String filename, String error) {
    return 'Erreur lors du téléchargement de $filename : $error';
  }

  @override
  String get enterANumber => 'Entrez un nombre';

  @override
  String get failedToNavigateToForum => 'Échec de la navigation vers le forum';

  @override
  String failedToNavigateToForumName(String forumName) {
    return 'Échec de la navigation vers $forumName';
  }

  @override
  String forumNotFound(String forumName) {
    return 'Forum introuvable : $forumName';
  }

  @override
  String forumNotFoundById(String forumId) {
    return 'Forum introuvable : $forumId';
  }

  @override
  String couldNotOpenLink(String error) {
    return 'Impossible d\'ouvrir le lien : $error';
  }

  @override
  String get likePost => 'Aimer le message';

  @override
  String get unlikePost => 'Ne plus aimer';

  @override
  String get thankPost => 'Remercier le message';

  @override
  String get showLikes => 'Afficher les j\'aime';

  @override
  String get showThanks => 'Afficher les remerciements';

  @override
  String get quotePost => 'Citer le message';

  @override
  String get translate => 'Traduire';

  @override
  String get showOriginal => 'Afficher l\'original';

  @override
  String get translating => 'Traduction en cours...';

  @override
  String get translated => 'Traduit';

  @override
  String get translatedContent => 'Contenu traduit';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get translateTo => 'Traduire vers :';

  @override
  String get deviceLanguage => 'Langue de l\'appareil';

  @override
  String get noPostsToTranslate => 'Aucun message à traduire';

  @override
  String get translationFailed => 'Échec de la traduction';

  @override
  String get twoFactorAuthentication => 'Authentification à deux facteurs';

  @override
  String get authenticationCodeLabel => 'Code d\'authentification';

  @override
  String get pleaseEnterYourAuthenticationCode =>
      'Veuillez saisir votre code d\'authentification';

  @override
  String codeMustBeDigits(int count) {
    return 'Le code doit contenir $count chiffres';
  }

  @override
  String get codeMustContainOnlyNumbers =>
      'Le code doit contenir uniquement des chiffres';

  @override
  String get verifyButton => 'Vérifier';

  @override
  String get attachments => 'Pièces jointes';

  @override
  String get replyOptions => 'Options de reponse';

  @override
  String get replyWithQuote => 'Repondre avec citation';

  @override
  String fileSavedToDownloads(String filename) {
    return 'Fichier enregistré dans Téléchargements : $filename';
  }

  @override
  String fileSavedToDocuments(String filename) {
    return 'Fichier enregistré dans Documents : $filename';
  }
}
