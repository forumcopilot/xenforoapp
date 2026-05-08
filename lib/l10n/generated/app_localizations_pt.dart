// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Forum App';

  @override
  String get loginTitle => 'Entrar';

  @override
  String get usernameLabel => 'Nome de usuário';

  @override
  String get passwordLabel => 'Senha';

  @override
  String get loginButton => 'Entrar';

  @override
  String get signInWithPasskey => 'Sign in with Passkey';

  @override
  String get usePasskey => 'Use Passkey';

  @override
  String get passkeyContinuePrompt => 'Use your passkey to continue';

  @override
  String get forgotPassword => 'Esqueceu a senha?';

  @override
  String get pleaseEnterUsername => 'Por favor, insira seu nome de usuário';

  @override
  String get pleaseEnterPassword => 'Por favor, insira sua senha';

  @override
  String credentialsSentToDomain(String domain) {
    return 'Seu nome de usuário e senha serão enviados para $domain';
  }

  @override
  String get createAccount => 'Criar conta';

  @override
  String get alreadyHaveAccount => 'Já tem uma conta? ';

  @override
  String get logIn => 'Entrar';

  @override
  String get continueButton => 'Continuar';

  @override
  String get registrationNotAvailable => 'Registro não disponível';

  @override
  String get registrationNotAvailableMessage =>
      'O registro não está disponível no momento. O fórum pode estar fechado ou o registro pode estar desabilitado.';

  @override
  String get webRegistrationRequired => 'Registro via web necessário';

  @override
  String get webRegistrationRequiredMessage =>
      'Este fórum requer registro através do navegador web. Por favor, clique no botão abaixo para abrir a página de registro.';

  @override
  String get openRegistrationPage => 'Abrir página de registro';

  @override
  String get loadingAdditionalFields => 'Carregando campos adicionais...';

  @override
  String get pleaseSelectDateOfBirth =>
      'Por favor, selecione sua data de nascimento';

  @override
  String get pleaseEnterLocation => 'Por favor, insira sua localização';

  @override
  String get pleaseIndicateEmailPreference =>
      'Por favor, indique sua preferência de e-mail';

  @override
  String get pleaseFillAllRequiredFields =>
      'Por favor, preencha todos os campos obrigatórios';

  @override
  String get pleaseAcceptTermsOfService =>
      'Por favor, aceite os Termos de Serviço';

  @override
  String get pleaseAcceptPrivacyPolicy =>
      'Por favor, aceite a Política de Privacidade';

  @override
  String get registrationError => 'Erro de registro';

  @override
  String get registrationFailed =>
      'O registro falhou. Por favor, verifique suas informações.';

  @override
  String get registrationFailedTryAgain =>
      'O registro falhou. Por favor, tente novamente.';

  @override
  String get registrationInfo => 'Informações de registro';

  @override
  String get openWebsite => 'Abrir site';

  @override
  String couldNotOpenForumWebsite(String url) {
    return 'Não foi possível abrir o site do fórum. Por favor, tente visitar: $url';
  }

  @override
  String get registrationSuccessfulEmailConfirm =>
      'Registro bem-sucedido! Por favor, verifique seu e-mail para confirmar sua conta antes de fazer login.';

  @override
  String get registrationSuccessfulPendingApproval =>
      'Registro bem-sucedido! Sua conta está aguardando aprovação. Você será notificado quando sua conta for aprovada.';

  @override
  String get registrationSuccessfulAutoLogin =>
      'Registro bem-sucedido! Você foi automaticamente conectado.';

  @override
  String get welcome => 'Bem-vindo!';

  @override
  String get registrationSuccessful => 'Registro bem-sucedido';

  @override
  String get pleaseLoginWithNewAccount =>
      'Por favor, faça login com sua nova conta.';

  @override
  String get forgotPasswordTitle => 'Esqueceu a senha';

  @override
  String get usernameOrEmailLabel => 'Nome de usuário ou e-mail';

  @override
  String get pleaseEnterUsernameOrEmail =>
      'Por favor, insira seu nome de usuário ou e-mail';

  @override
  String get sendResetLink => 'Enviar link de redefinição';

  @override
  String get resetLinkSent => 'Link de redefinição enviado';

  @override
  String get passwordResetInstructionsSent =>
      'As instruções para redefinir sua senha foram enviadas para seu endereço de e-mail registrado.';

  @override
  String get resetFailed => 'Falha na redefinição';

  @override
  String get unableToSendResetLink =>
      'Não foi possível enviar o link de redefinição. Por favor, tente novamente.';

  @override
  String get errorSendingResetLink =>
      'Ocorreu um erro ao enviar o link de redefinição. Por favor, verifique sua conexão e tente novamente.';

  @override
  String get errorTitle => 'Erro';

  @override
  String get okButton => 'OK';

  @override
  String get retryButton => 'Tentar novamente';

  @override
  String get copyToClipboard => 'Copiar para área de transferência';

  @override
  String get copied => 'Copiado';

  @override
  String get errorMessageCopiedToClipboard =>
      'Mensagem de erro copiada para área de transferência';

  @override
  String get dismiss => 'Dispensar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get tryAgain => 'Tentar Novamente';

  @override
  String get getHelp => 'Obter ajuda';

  @override
  String get somethingWentWrong => 'Algo deu errado';

  @override
  String get unexpectedErrorOccurred =>
      'Ocorreu um erro inesperado. Por favor, tente novamente.';

  @override
  String get noInternetConnection => 'Sem conexão com a Internet';

  @override
  String get checkInternetConnection =>
      'Por favor, verifique sua conexão com a Internet e tente novamente.';

  @override
  String get authenticationRequired => 'Autenticação necessária';

  @override
  String get pleaseLoginToContinue => 'Por favor, faça login para continuar.';

  @override
  String get forumError => 'Erro do fórum';

  @override
  String get anErrorOccurred => 'Ocorreu um erro';

  @override
  String get accountPendingApproval =>
      'Sua conta está aguardando aprovação. Você pode navegar pelo fórum, mas não pode postar até que um moderador aprove sua conta.';

  @override
  String get checkEmailToConfirm =>
      'Por favor, verifique seu e-mail para confirmar sua conta. Clique no link de confirmação no e-mail que enviamos.';

  @override
  String get checkNewEmailToConfirm =>
      'Por favor, verifique seu novo endereço de e-mail para confirmar a alteração. Seu e-mail antigo permanecerá ativo até que você confirme o novo.';

  @override
  String get emailAddressInvalid =>
      'Seu endereço de e-mail parece ser inválido ou está rejeitando e-mails. Por favor, atualize seu endereço de e-mail nas configurações da conta.';

  @override
  String get accountDisabled =>
      'Sua conta foi desabilitada. Por favor, entre em contato com um administrador para obter assistência.';

  @override
  String get accountRegistrationRejected =>
      'O registro da sua conta foi rejeitado. Por favor, entre em contato com um administrador para mais informações.';

  @override
  String get welcomeToForumCopilot => 'Bem-vindo ao Forum Copilot!';

  @override
  String get successfullyLoggedOut => 'Você foi desconectado com sucesso';

  @override
  String get accountStatusRequiresAttention =>
      'O status da sua conta requer atenção. Por favor, entre em contato com um administrador se tiver dúvidas.';

  @override
  String get updateEmail => 'Atualizar e-mail';

  @override
  String get resend => 'Reenviar';

  @override
  String get noLatestTopics => 'Sem tópicos recentes';

  @override
  String get noRecentTopicsToDisplay =>
      'Não há tópicos recentes para exibir. Volte mais tarde para novas discussões.';

  @override
  String get signInToViewLatestTopics => 'Faça login para ver tópicos recentes';

  @override
  String get youNeedToBeSignedInToViewLatestTopics =>
      'Você precisa estar conectado para ver tópicos recentes';

  @override
  String get noUnreadTopics => 'Sem tópicos não lidos';

  @override
  String get thereAreNoUnreadTopics =>
      'Não há tópicos não lidos. Volte mais tarde para novas discussões.';

  @override
  String get youAreAllCaughtUp => 'Você está em dia!';

  @override
  String get signInToViewUnreadTopics =>
      'Faça login para ver tópicos não lidos';

  @override
  String get youNeedToBeSignedInToViewUnreadTopics =>
      'Você precisa estar conectado para ver seus tópicos não lidos';

  @override
  String get noSubscribedTopics => 'Sem tópicos inscritos';

  @override
  String get noSubscribedTopicsMessage =>
      'Você não se inscreveu em nenhum tópico. Toque no botão de estrela em um tópico para se inscrever e receber notificações de novas atualizações.';

  @override
  String get signInToViewSubscribedTopics =>
      'Faça login para ver tópicos inscritos';

  @override
  String get youNeedToBeSignedInToViewSubscribedTopics =>
      'Você precisa estar conectado para ver seus tópicos inscritos';

  @override
  String get noParticipatedTopics => 'Sem tópicos participados';

  @override
  String get topicsYouParticipatedIn =>
      'Os tópicos em que você participou serão exibidos aqui.';

  @override
  String get signInToViewParticipatedTopics =>
      'Faça login para ver tópicos participados';

  @override
  String get youNeedToBeSignedInToViewParticipatedTopics =>
      'Você precisa estar conectado para ver tópicos em que participou';

  @override
  String get latest => 'Recentes';

  @override
  String get unread => 'Não lidos';

  @override
  String get subscribed => 'Inscritos';

  @override
  String get participated => 'Participados';

  @override
  String get connectionTimedOut =>
      'Tempo de conexão esgotado. O site pode estar fora do ar ou inacessível.';

  @override
  String get failedToConnectToSite =>
      'Falha ao conectar ao site. O site pode estar fora do ar ou inacessível.';

  @override
  String get connectionFailed => 'Falha de conexão';

  @override
  String failedToConnectToSiteName(String siteName) {
    return 'Falha ao conectar a $siteName';
  }

  @override
  String get loading => 'Carregando...';

  @override
  String get newConversation => 'Nova conversa';

  @override
  String get newMessage => 'Nova mensagem';

  @override
  String get appSettings => 'Configurações do aplicativo';

  @override
  String get searchSites => 'Buscar sites';

  @override
  String get language => 'Idioma';

  @override
  String get systemDefault => 'Padrão do sistema';

  @override
  String get followSystemLanguage => 'Seguir o idioma do sistema';

  @override
  String get all => 'Todos';

  @override
  String get topicsOnly => 'Apenas tópicos';

  @override
  String get titlesOnly => 'Apenas títulos';

  @override
  String failedToShareTopic(String error) {
    return 'Falha ao compartilhar tópico: $error';
  }

  @override
  String pleaseLoginToSubscribe(String action) {
    return 'Por favor, faça login para $action este tópico';
  }

  @override
  String get subscribeTo => 'inscrever-se em';

  @override
  String get unsubscribeFrom => 'cancelar inscrição de';

  @override
  String get subscribe => 'Inscrever-se';

  @override
  String get unsubscribe => 'Cancelar inscrição';

  @override
  String failedToSubscribeToThread(String action) {
    return 'Falha ao $action tópico';
  }

  @override
  String get youCannotReplyToThisThread =>
      'Você não pode responder a este tópico';

  @override
  String get pleaseWaitForThreadToLoad =>
      'Por favor, aguarde o carregamento do tópico';

  @override
  String get softDelete => 'Exclusão suave';

  @override
  String get postCanBeRestoredLater =>
      'A postagem pode ser restaurada mais tarde';

  @override
  String get hardDelete => 'Exclusão permanente';

  @override
  String get postWillBePermanentlyDeleted =>
      'A postagem será excluída permanentemente';

  @override
  String get reasonForDeletion => 'Motivo da exclusão';

  @override
  String get enterReasonForDeletingPost =>
      'Insira o motivo para excluir esta postagem';

  @override
  String get pleaseEnterReasonForDeletion =>
      'Por favor, digite um motivo para a exclusão';

  @override
  String get reportPost => 'Denunciar postagem';

  @override
  String get pleaseProvideReasonForReporting =>
      'Por favor, forneça um motivo para denunciar esta postagem.';

  @override
  String get reason => 'Motivo';

  @override
  String get enterReasonForReportingPost =>
      'Insira o motivo para denunciar esta postagem';

  @override
  String get pleaseEnterReason => 'Por favor, insira um motivo';

  @override
  String get submitReport => 'Enviar denúncia';

  @override
  String get selectedActions => 'Ações selecionadas:';

  @override
  String get thisActionCannotBeUndone => 'Esta ação não pode ser desfeita.';

  @override
  String get participantsLabel => 'Participantes';

  @override
  String usernameHasBeenInvited(String username) {
    return '$username foi convidado para a conversa';
  }

  @override
  String errorInvitingUser(String error) {
    return 'Erro ao convidar usuário: $error';
  }

  @override
  String get newTopic => 'Novo tópico';

  @override
  String get markRead => 'Marcar como lido';

  @override
  String get reportUser => 'Denunciar usuário';

  @override
  String get pleaseSelectReasonForReportingUser =>
      'Por favor, selecione um motivo para denunciar este usuário.';

  @override
  String get spamOrAdvertising => 'Spam ou publicidade';

  @override
  String get harassmentOrBullying => 'Assédio ou bullying';

  @override
  String get inappropriateContent => 'Conteúdo inadequado';

  @override
  String get impersonationOrFakeAccount => 'Imitação ou conta falsa';

  @override
  String get otherPleaseSpecify => 'Outro (por favor, especifique)';

  @override
  String get pleaseSpecifyReason => 'Por favor, especifique o motivo';

  @override
  String get enterReasonForReportingUser =>
      'Insira o motivo para denunciar este usuário';

  @override
  String get pleaseSelectReason => 'Por favor, selecione um motivo';

  @override
  String get banUser => 'Banir usuário';

  @override
  String get unbanUser => 'Desbanir usuário';

  @override
  String pleaseSelectReasonForBanningUser(String username) {
    return 'Por favor, selecione um motivo para banir $username';
  }

  @override
  String get violationOfCommunityGuidelines =>
      'Violação das diretrizes da comunidade';

  @override
  String get harassmentOrAbusiveBehavior => 'Assédio ou comportamento abusivo';

  @override
  String get postingInappropriateContent => 'Publicação de conteúdo inadequado';

  @override
  String get accountCompromiseOrSecurityIssue =>
      'Comprometimento da conta ou problema de segurança';

  @override
  String get enterReasonForBanningUser =>
      'Insira o motivo para banir este usuário';

  @override
  String get banUntil => 'Banir até';

  @override
  String get selectDate => 'Selecionar data';

  @override
  String get moreOptions => 'Mais opções';

  @override
  String get leaveConversation => 'Deixar conversa';

  @override
  String get reportConversation => 'Denunciar conversa';

  @override
  String get topicClosed => 'Tópico fechado';

  @override
  String get topicOpened => 'Tópico aberto';

  @override
  String get topicStickied => 'Tópico fixado';

  @override
  String get topicUnstickied => 'Tópico desfixado';

  @override
  String cannotEditMessage(String error) {
    return 'Não é possível editar esta mensagem: $error';
  }

  @override
  String get confirmSpamClean => 'Confirmar limpeza de spam';

  @override
  String get handleThreads => 'Gerenciar tópicos';

  @override
  String get deleteMessages => 'Excluir mensagens';

  @override
  String get deleteConversations => 'Excluir conversas';

  @override
  String get myForums => 'Meus Fóruns';

  @override
  String get recentlyVisited => 'Visitados Recentemente';

  @override
  String get explore => 'Explorar';

  @override
  String get forumCopilot => 'Forum Copilot';

  @override
  String get noConversations => 'Sem conversas';

  @override
  String get noConversationsMessage =>
      'Você ainda não tem conversas. Inicie uma nova conversa para começar a enviar mensagens.';

  @override
  String get imageSavedToGallery => 'Imagem salva na galeria!';

  @override
  String failedToSaveImage(String error) {
    return 'Falha ao salvar imagem: $error';
  }

  @override
  String get userProfile => 'Perfil do Usuário';

  @override
  String get deletePost => 'Excluir Publicação';

  @override
  String get loginRequired => 'Login Necessário';

  @override
  String get spamCleaner => 'Limpeza de Spam';

  @override
  String get sendMessage => 'Enviar mensagem';

  @override
  String get memberSince => 'Membro Desde';

  @override
  String get lastActivity => 'Última Atividade';

  @override
  String get likesReceived => 'Curtidas Recebidas';

  @override
  String get likesGiven => 'Curtidas Dadas';

  @override
  String get showMore => 'Mostrar mais';

  @override
  String get cleanSpam => 'Limpar spam';

  @override
  String get failedToSaveMessage => 'Falha ao salvar mensagem';

  @override
  String get failedToSaveConversation => 'Falha ao salvar conversa';

  @override
  String get failedToSaveSetting => 'Falha ao salvar configuração';

  @override
  String get failedToSavePost => 'Falha ao salvar publicação';

  @override
  String errorLoadingSites(String error) {
    return 'Erro ao carregar sites: $error';
  }

  @override
  String connectingTo(String domainName) {
    return 'Conectando a $domainName...';
  }

  @override
  String get members => 'Membros';

  @override
  String get allMembers => 'Todos os Membros';

  @override
  String get online => 'Online';

  @override
  String get noMembersFound => 'Nenhum membro encontrado';

  @override
  String get searchForMembers => 'Buscar membros';

  @override
  String get enterUsernameToFindMembers =>
      'Digite um nome de usuário para encontrar membros do fórum';

  @override
  String get noMembersOnline => 'Não há membros online no momento';

  @override
  String get enterUsernameToSearch => 'Digite o nome de usuário para buscar...';

  @override
  String get lookupMembers => 'Buscar Membros';

  @override
  String get addMembers => 'Adicionar Membros';

  @override
  String get membersAddedSuccessfully => 'Membros adicionados com sucesso';

  @override
  String errorAddingMembers(String error) {
    return 'Erro ao adicionar membros: $error';
  }

  @override
  String get failedToLoadOnlineUsers => 'Falha ao carregar usuários online';

  @override
  String get noUsersOnline => 'Nenhum usuário online';

  @override
  String membersCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString Membros';
  }

  @override
  String get noSubject => 'Sem assunto';

  @override
  String get search => 'Buscar';

  @override
  String get logout => 'Sair';

  @override
  String get areYouSureYouWantToLogout => 'Tem certeza de que deseja sair?';

  @override
  String get register => 'Registrar';

  @override
  String get signIn => 'Entrar';

  @override
  String get markForumRead => 'Marcar Fórum como Lido';

  @override
  String get notificationTest => 'Teste de Notificação';

  @override
  String get forum => 'Fórum';

  @override
  String get profile => 'Perfil';

  @override
  String get messages => 'Mensagens';

  @override
  String get add => 'Adicionar';

  @override
  String get retry => 'Tentar Novamente';

  @override
  String get delete => 'Excluir';

  @override
  String get deleteMessage => 'Excluir Mensagem';

  @override
  String get areYouSureYouWantToDeleteThisMessage =>
      'Tem certeza de que deseja excluir esta mensagem?';

  @override
  String failedToDeleteMessage(String error) {
    return 'Falha ao excluir mensagem: $error';
  }

  @override
  String get deletingPost => 'Excluindo publicação...';

  @override
  String failedToUnlikePost(String error) {
    return 'Falha ao remover curtida da publicação: $error';
  }

  @override
  String failedToLikePost(String error) {
    return 'Falha ao curtir publicação: $error';
  }

  @override
  String failedToThankPost(String error) {
    return 'Falha ao agradecer publicação: $error';
  }

  @override
  String get signInToViewMessages => 'Faça login para ver mensagens';

  @override
  String get youNeedToBeSignedInToViewConversations =>
      'Você precisa estar conectado para ver suas conversas.';

  @override
  String errorLoadingConversations(String error) {
    return 'Erro ao carregar conversas: $error';
  }

  @override
  String failedToLeaveConversation(String error) {
    return 'Falha ao deixar conversa: $error';
  }

  @override
  String errorLoadingMoreConversations(String error) {
    return 'Erro ao carregar mais conversas: $error';
  }

  @override
  String errorLoadingMoreMessages(String error) {
    return 'Erro ao carregar mais mensagens: $error';
  }

  @override
  String get inviteMessageOptional => 'Mensagem de Convite (opcional)';

  @override
  String get iWouldLikeToAddYouToThisConversation =>
      'Eu gostaria de adicionar você a esta conversa.';

  @override
  String get searchFailed => 'Busca falhou';

  @override
  String get trySearchingWithDifferentUsername =>
      'Tente buscar com um nome de usuário diferente';

  @override
  String get noSitesFound => 'Nenhum site encontrado.';

  @override
  String get userInformationNotAvailable =>
      'Informações do usuário não disponíveis';

  @override
  String get birthday => 'Aniversário';

  @override
  String get posts => 'Publicações';

  @override
  String get following => 'Seguindo';

  @override
  String get followers => 'Seguidores';

  @override
  String get about => 'Sobre';

  @override
  String get location => 'Localização';

  @override
  String get website => 'Site';

  @override
  String get signature => 'Assinatura';

  @override
  String get next => 'Próximo';

  @override
  String get permanent => 'Permanente';

  @override
  String get temporary => 'Temporário';

  @override
  String setBanDurationFor(String username) {
    return 'Definir a duração do banimento para $username';
  }

  @override
  String get pleaseSelectEndDateForTemporaryBan =>
      'Por favor, selecione uma data de término para o banimento temporário';

  @override
  String get back => 'Voltar';

  @override
  String get unban => 'Desbanir';

  @override
  String get confirm => 'Confirmar';

  @override
  String spamClean(String username) {
    return 'Limpar Spam de $username';
  }

  @override
  String get selectActionsToPerform => 'Selecione as ações a realizar:';

  @override
  String get moveOrDeleteThreadsBasedOnAdminSettings =>
      'Mover ou excluir tópicos com base nas configurações do administrador';

  @override
  String get messageUpdatedSuccessfully => 'Mensagem atualizada com sucesso';

  @override
  String error(String error) {
    return 'Erro: $error';
  }

  @override
  String failedToRemoveAttachment(String error) {
    return 'Falha ao remover anexo: $error';
  }

  @override
  String failedToLoadMessage(String error) {
    return 'Falha ao carregar mensagem: $error';
  }

  @override
  String get editMessage => 'Editar Mensagem';

  @override
  String get removeAttachment => 'Remover Anexo';

  @override
  String get areYouSureYouWantToRemoveThisAttachment =>
      'Tem certeza de que deseja remover este anexo?';

  @override
  String get none => 'Nenhum';

  @override
  String get attachFile => 'Anexar Arquivo';

  @override
  String get uploadImage => 'Enviar Imagem';

  @override
  String get formatting => 'Formatação';

  @override
  String get bold => 'Negrito';

  @override
  String get italic => 'Itálico';

  @override
  String get underline => 'Sublinhado';

  @override
  String get strikethrough => 'Tachado';

  @override
  String get link => 'Link';

  @override
  String get image => 'Imagem';

  @override
  String get video => 'Vídeo';

  @override
  String get quote => 'Citação';

  @override
  String get code => 'Código';

  @override
  String get spoiler => 'Spoiler';

  @override
  String get bulletList => 'Lista com Marcadores';

  @override
  String get numberedList => 'Lista Numerada';

  @override
  String get listItem => 'Item da Lista';

  @override
  String participants(int count) {
    return 'Participantes ($count)';
  }

  @override
  String get markAsUnread => 'Marcar como não lido';

  @override
  String get invite => 'Convidar';

  @override
  String get welcomeBack => 'Bem-vindo de volta!';

  @override
  String get signInToAccessYourProfile =>
      'Faça login para acessar seu perfil e gerenciar sua conta';

  @override
  String get enterYourUsername => 'Digite seu nome de usuário';

  @override
  String get enterYourPassword => 'Digite sua senha';

  @override
  String get dontHaveAnAccount => 'Não tem uma conta?';

  @override
  String get enterKeywordsToSearchTopics =>
      'Digite palavras-chave para buscar tópicos...';

  @override
  String get pleaseFillInAllRequiredFields =>
      'Por favor, preencha todos os campos obrigatórios';

  @override
  String get undelete => 'Restaurar';

  @override
  String get refresh => 'Atualizar';

  @override
  String get share => 'Compartilhar';

  @override
  String get viewOnWeb => 'Ver na Web';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get lock => 'Bloquear';

  @override
  String get stick => 'Fixar';

  @override
  String get unstick => 'Desfixar';

  @override
  String get reply => 'Responder';

  @override
  String get vote => 'Votar';

  @override
  String votesCount(int count) {
    return '$count votos';
  }

  @override
  String get pollClosed => 'Enquete encerrada';

  @override
  String pollEndsOn(String date) {
    return 'Termina em $date';
  }

  @override
  String get voteToSeeResults => 'Vote para ver os resultados';

  @override
  String get viewFullPoll => 'Ver enquete completa';

  @override
  String pollOptionsCount(int count) {
    return '$count opções';
  }

  @override
  String get reactedBy => 'Reagido por';

  @override
  String get enterKeywordsToFindTopicsAndPosts =>
      'Digite palavras-chave para encontrar tópicos e postagens';

  @override
  String get enterKeywordsOrDomainToFindForums =>
      'Digite palavras-chave ou domínio para encontrar fóruns';

  @override
  String get enterKeywordsOrDomainNamesToFindForums =>
      'Digite palavras-chave ou nomes de domínio para encontrar fóruns';

  @override
  String get appearance => 'Aparência';

  @override
  String get followSystemTheme => 'Seguir o tema do sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Escuro';

  @override
  String version(String version, String buildNumber) {
    return 'versão $version ($buildNumber)';
  }

  @override
  String get forumSettings => 'Configurações do Fórum';

  @override
  String get noSettingsAvailable => 'Nenhuma configuração disponível';

  @override
  String get settingsCategoriesWillAppearHere =>
      'As categorias de configurações aparecerão aqui quando disponíveis.';

  @override
  String get unableToLoadProfile => 'Não foi possível carregar o perfil';

  @override
  String get banned => 'BANIDO';

  @override
  String get reportSubmittedSuccessfully => 'Denúncia enviada com sucesso';

  @override
  String get failedToSubmitReport => 'Falha ao enviar denúncia';

  @override
  String get searchForForums => 'Buscar fóruns';

  @override
  String get searchForums => 'Buscar Fóruns';

  @override
  String get deleteTopic => 'Excluir tópico';

  @override
  String get topicCanBeRestoredLater =>
      'O tópico pode ser restaurado mais tarde';

  @override
  String get topicWillBePermanentlyDeleted =>
      'O tópico será excluído permanentemente';

  @override
  String get enterReasonForDeletingTopic =>
      'Digite o motivo para excluir este tópico';

  @override
  String get pleaseSelectEndDate => 'Por favor, selecione uma data de término';

  @override
  String get userBannedSuccessfully => 'Usuário banido com sucesso';

  @override
  String get failedToBanUser => 'Falha ao banir usuário';

  @override
  String get userUnbannedSuccessfully => 'Usuário desbanido com sucesso';

  @override
  String get failedToUnbanUser => 'Falha ao desbanir usuário';

  @override
  String get spamCleanUser => 'Limpar spam do usuário';

  @override
  String get deletePrivateConversations => 'Excluir conversas privadas';

  @override
  String get banTheUserAccount => 'Banir a conta do usuário';

  @override
  String get handledThreads => 'Tópicos tratados';

  @override
  String get deletedMessages => 'Mensagens excluídas';

  @override
  String get deletedConversations => 'Conversas excluídas';

  @override
  String get bannedUser => 'Usuário banido';

  @override
  String successfullyCleanedSpam(String username, String actions) {
    return 'Spam limpo com sucesso para $username. Ações: $actions';
  }

  @override
  String errorLoadingMessage(String error) {
    return 'Erro ao carregar mensagem: $error';
  }

  @override
  String get messageNotFound => 'Mensagem não encontrada';

  @override
  String get home => 'Início';

  @override
  String get notifications => 'Notificações';

  @override
  String get forums => 'Fóruns';

  @override
  String get markAllForumsAsRead => 'Marcar todos os fóruns como lidos?';

  @override
  String get markAllForumsAsReadMessage =>
      'Isso marcará todos os fóruns e tópicos como lidos. Esta ação não pode ser desfeita.';

  @override
  String get markAsRead => 'Marcar como lido';

  @override
  String get content => 'Conteúdo';

  @override
  String get insertImage => 'Inserir imagem';

  @override
  String get howWouldYouLikeToInsertImage =>
      'Como você gostaria de inserir esta imagem?';

  @override
  String get thumbnail => 'Miniatura';

  @override
  String get fullSize => 'Tamanho completo';

  @override
  String get alignLeft => 'Alinhar à esquerda';

  @override
  String get alignCenter => 'Alinhar ao centro';

  @override
  String get alignRight => 'Alinhar à direita';

  @override
  String get pleaseEnterTitle => 'Por favor, insira um título';

  @override
  String get pleaseEnterContent => 'Por favor, insira algum conteúdo';

  @override
  String get uploading => 'Enviando...';

  @override
  String get uploaded => 'Enviado';

  @override
  String get mentionUser => 'Mencionar usuário';

  @override
  String get loggingIn => 'Entrando...';

  @override
  String get submittingReport => 'Enviando relatório...';

  @override
  String get banningUser => 'Banindo usuário...';

  @override
  String get unbanningUser => 'Desbanindo usuário...';

  @override
  String get cleaningSpam => 'Limpando spam...';

  @override
  String get enterSubject => 'Insira o assunto';

  @override
  String get typeYourMessageHere => 'Digite sua mensagem aqui';

  @override
  String get writeYourMessage => 'Escreva sua mensagem...';

  @override
  String get writeYourReply => 'Escreva sua resposta...';

  @override
  String get messageSentSuccessfully => 'Mensagem enviada com sucesso';

  @override
  String get replySentSuccessfully => 'Resposta enviada com sucesso';

  @override
  String get conversationCreatedSuccessfully => 'Conversa criada com sucesso';

  @override
  String get conversationMarkedAsUnread => 'Conversa marcada como não lida';

  @override
  String get messageMarkedAsUnread => 'Mensagem marcada como não lida';

  @override
  String get conversationClosed => 'Conversa fechada';

  @override
  String get conversationOpened => 'Conversa aberta';

  @override
  String get pleaseLoginToLikeMessages =>
      'Por favor, faça login para curtir mensagens';

  @override
  String get loadEarlierMessages => 'Carregar mensagens anteriores';

  @override
  String failedToLoadQuote(String error) {
    return 'Falha ao carregar citação: \n$error';
  }

  @override
  String failedToUploadFile(String error) {
    return 'Falha ao enviar arquivo: $error';
  }

  @override
  String failedToUploadImage(String error) {
    return 'Falha ao enviar imagem: $error';
  }

  @override
  String failedToSendMessage(String error) {
    return 'Falha ao enviar mensagem: $error';
  }

  @override
  String failedToSendReply(String error) {
    return 'Falha ao enviar resposta: $error';
  }

  @override
  String failedToMarkAsUnread(String error) {
    return 'Falha ao marcar mensagem como não lida: $error';
  }

  @override
  String failedToMarkConversationAsUnread(String error) {
    return 'Falha ao marcar conversa como não lida: $error';
  }

  @override
  String failedToCloseConversation(String error) {
    return 'Falha ao fechar conversa: $error';
  }

  @override
  String failedToOpenConversation(String error) {
    return 'Falha ao abrir conversa: $error';
  }

  @override
  String failedToJumpToMessage(String error) {
    return 'Falha ao pular para mensagem: $error';
  }

  @override
  String get goToTop => 'Ir para o topo';

  @override
  String get goToBottom => 'Ir para o fundo';

  @override
  String get replyAll => 'Responder a todos';

  @override
  String get forward => 'Encaminhar';

  @override
  String get noForumsFound => 'Nenhum fórum encontrado.';

  @override
  String get pleaseSelectPrefix => 'Por favor, selecione um prefixo';

  @override
  String get pleaseLoginToAccessContent =>
      'Por favor, faça login para acessar este conteúdo e interagir com as postagens.';

  @override
  String get searchUsers => 'Buscar usuários...';

  @override
  String get writeYourTitle => 'Escreva seu título...';

  @override
  String get writeYourContent => 'Escreva seu conteúdo...';

  @override
  String get selectAnOption => 'Selecione uma opção';

  @override
  String get enterConversationTitle => 'Insira o título da conversa';

  @override
  String enterCode(int count) {
    return 'Insira código de $count dígitos';
  }

  @override
  String get edit => 'Editar';

  @override
  String get report => 'Denunciar';

  @override
  String get unfollow => 'Deixar de seguir';

  @override
  String get follow => 'Seguir';

  @override
  String get goToForums => 'Ir para Fóruns';

  @override
  String get remove => 'Remover';

  @override
  String get subject => 'Assunto';

  @override
  String get message => 'Mensagem';

  @override
  String get titleCannotBeEmpty => 'O título não pode estar vazio';

  @override
  String get conversationUpdatedSuccessfully =>
      'Conversa atualizada com sucesso';

  @override
  String get goBack => 'Voltar';

  @override
  String get privateMessagesNotAvailable =>
      'Mensagens privadas não disponíveis';

  @override
  String failedToLoadPost(String error) {
    return 'Erro ao carregar publicação: \n$error';
  }

  @override
  String failedToLikeOrUnlikeMessage(String action, String error) {
    return 'Falha ao $action mensagem: $error';
  }

  @override
  String get like => 'curtir';

  @override
  String get unlike => 'descurtir';

  @override
  String get optimizeImage => 'Otimizar imagem';

  @override
  String get optimizeAndUpload => 'Otimizar e enviar';

  @override
  String downloading(String filename) {
    return 'Baixando $filename...';
  }

  @override
  String openingShareSheet(String filename) {
    return 'Abrindo folha de compartilhamento para $filename';
  }

  @override
  String errorDownloading(String filename, String error) {
    return 'Erro ao baixar $filename: $error';
  }

  @override
  String get enterANumber => 'Digite um número';

  @override
  String get failedToNavigateToForum => 'Falha ao navegar para o fórum';

  @override
  String failedToNavigateToForumName(String forumName) {
    return 'Falha ao navegar para $forumName';
  }

  @override
  String forumNotFound(String forumName) {
    return 'Fórum não encontrado: $forumName';
  }

  @override
  String forumNotFoundById(String forumId) {
    return 'Fórum não encontrado: $forumId';
  }

  @override
  String couldNotOpenLink(String error) {
    return 'Não foi possível abrir o link: $error';
  }

  @override
  String get likePost => 'Curtir publicação';

  @override
  String get unlikePost => 'Descurtir publicação';

  @override
  String get thankPost => 'Agradecer publicação';

  @override
  String get showLikes => 'Mostrar curtidas';

  @override
  String get showThanks => 'Mostrar agradecimentos';

  @override
  String get quotePost => 'Citar publicação';

  @override
  String get translate => 'Traduzir';

  @override
  String get showOriginal => 'Mostrar original';

  @override
  String get translating => 'Traduzindo...';

  @override
  String get translated => 'Traduzido';

  @override
  String get translatedContent => 'Conteúdo traduzido';

  @override
  String get selectLanguage => 'Selecionar idioma';

  @override
  String get translateTo => 'Traduzir para:';

  @override
  String get deviceLanguage => 'Idioma do dispositivo';

  @override
  String get noPostsToTranslate => 'Nenhuma publicação para traduzir';

  @override
  String get translationFailed => 'Falha na tradução';

  @override
  String get twoFactorAuthentication => 'Autenticação de dois fatores';

  @override
  String get authenticationCodeLabel => 'Código de autenticação';

  @override
  String get pleaseEnterYourAuthenticationCode =>
      'Digite seu código de autenticação';

  @override
  String codeMustBeDigits(int count) {
    return 'O código deve ter $count dígitos';
  }

  @override
  String get codeMustContainOnlyNumbers =>
      'O código deve conter apenas números';

  @override
  String get verifyButton => 'Verificar';

  @override
  String get attachments => 'Anexos';

  @override
  String get replyOptions => 'Opcoes de resposta';

  @override
  String get replyWithQuote => 'Responder com citacao';

  @override
  String fileSavedToDownloads(String filename) {
    return 'Arquivo salvo em Downloads: $filename';
  }

  @override
  String fileSavedToDocuments(String filename) {
    return 'Arquivo salvo em Documentos: $filename';
  }
}
