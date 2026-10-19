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
  String get cancel => 'Cancelar';

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
  String get noUnreadTopics => 'Sem tópicos não lidos';

  @override
  String get thereAreNoUnreadTopics =>
      'Não há tópicos não lidos. Volte mais tarde para novas discussões.';

  @override
  String get youAreAllCaughtUp => 'Você está em dia!';

  @override
  String get noSubscribedTopics => 'Sem tópicos inscritos';

  @override
  String get noSubscribedTopicsMessage =>
      'Você ainda não se inscreveu em nenhum tópico. Abra um tópico e escolha Inscrever-se no menu ⋮ para ser avisado de novas respostas.';

  @override
  String get noParticipatedTopics => 'Sem tópicos participados';

  @override
  String get topicsYouParticipatedIn =>
      'Os tópicos em que você participou serão exibidos aqui.';

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
  String get postCanBeRestoredLater =>
      'A postagem pode ser restaurada mais tarde';

  @override
  String get postWillBePermanentlyDeleted =>
      'A postagem será excluída permanentemente';

  @override
  String get enterReasonForDeletingPost =>
      'Insira o motivo para excluir esta postagem';

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
  String get unbanUser => 'Desbanir usuário';

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
  String get tryAgain => 'Tentar Novamente';

  @override
  String get memberSince => 'Membro Desde';

  @override
  String get lastActivity => 'Última Atividade';

  @override
  String get likesReceived => 'Curtidas Recebidas';

  @override
  String get likesGiven => 'Curtidas Dadas';

  @override
  String get failedToSaveMessage => 'Falha ao salvar mensagem';

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
  String get moreOptions => 'Mais opções';

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
  String get dismiss => 'Dispensar';

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
  String get enterUsernameToSearch => 'Digite o nome de usuário para buscar...';

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
  String get handleThreads => 'Gerenciar tópicos';

  @override
  String get moveOrDeleteThreadsBasedOnAdminSettings =>
      'Mover ou excluir tópicos com base nas configurações do administrador';

  @override
  String get deleteMessages => 'Excluir mensagens';

  @override
  String get deleteConversations => 'Excluir conversas';

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
  String get enterKeywordsToSearchTopics =>
      'Digite palavras-chave para buscar tópicos...';

  @override
  String get pleaseFillInAllRequiredFields =>
      'Por favor, preencha todos os campos obrigatórios';

  @override
  String get undelete => 'Restaurar';

  @override
  String get signInToViewUnreadTopics =>
      'Faça login para ver tópicos não lidos';

  @override
  String get youNeedToBeSignedInToViewUnreadTopics =>
      'Você precisa estar conectado para ver seus tópicos não lidos';

  @override
  String get signInToViewSubscribedTopics =>
      'Faça login para ver tópicos inscritos';

  @override
  String get youNeedToBeSignedInToViewSubscribedTopics =>
      'Você precisa estar conectado para ver seus tópicos inscritos';

  @override
  String get signInToViewParticipatedTopics =>
      'Faça login para ver tópicos participados';

  @override
  String get youNeedToBeSignedInToViewParticipatedTopics =>
      'Você precisa estar conectado para ver tópicos em que participou';

  @override
  String get signInToViewLatestTopics => 'Faça login para ver tópicos recentes';

  @override
  String get youNeedToBeSignedInToViewLatestTopics =>
      'Você precisa estar conectado para ver tópicos recentes';

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
  String likesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count curtidas',
      one: '$count curtida',
    );
    return '$_temp0';
  }

  @override
  String reactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reações',
      one: '$count reação',
    );
    return '$_temp0';
  }

  @override
  String get showWhoReacted => 'Toque para ver quem reagiu.';

  @override
  String get react => 'Reagir';

  @override
  String get changeYourReaction => 'Alterar sua reação';

  @override
  String get reactionsAll => 'Todas';

  @override
  String get reactionYou => 'Você';

  @override
  String reactionFilterSemantics(String reaction, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$reaction, $count pessoas',
      one: '$reaction, $count pessoa',
    );
    return '$_temp0';
  }

  @override
  String viewProfileOfUser(String username) {
    return 'Ver o perfil de $username';
  }

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
  String get language => 'Idioma';

  @override
  String get systemDefault => 'Padrão do sistema';

  @override
  String get followSystemLanguage => 'Seguir o idioma do sistema';

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
  String get spamCleaner => 'Limpeza de Spam';

  @override
  String get unableToLoadProfile => 'Não foi possível carregar o perfil';

  @override
  String get banned => 'BANIDO';

  @override
  String get sendMessage => 'Enviar mensagem';

  @override
  String get showMore => 'Mostrar mais';

  @override
  String get reportUser => 'Denunciar usuário';

  @override
  String get submitReport => 'Enviar denúncia';

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
  String get softDelete => 'Exclusão suave';

  @override
  String get topicCanBeRestoredLater =>
      'O tópico pode ser restaurado mais tarde';

  @override
  String get hardDelete => 'Exclusão permanente';

  @override
  String get topicWillBePermanentlyDeleted =>
      'O tópico será excluído permanentemente';

  @override
  String get reasonForDeletion => 'Motivo da exclusão';

  @override
  String get enterReasonForDeletingTopic =>
      'Digite o motivo para excluir este tópico';

  @override
  String get pleaseEnterReasonForDeletion =>
      'Por favor, digite um motivo para a exclusão';

  @override
  String get pleaseSelectEndDate => 'Por favor, selecione uma data de término';

  @override
  String get banUser => 'Banir usuário';

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
  String get cleanSpam => 'Limpar spam';

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
  String get signInToViewMessages => 'Faça login para ver mensagens';

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
  String get failedToSaveConversation => 'Falha ao salvar conversa';

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
  String get showLikes => 'Mostrar curtidas';

  @override
  String get quotePost => 'Citar publicação';

  @override
  String get attachFile => 'Anexar Arquivo';

  @override
  String get uploadImage => 'Enviar Imagem';

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

  @override
  String get discardPostQuestion => 'Você deseja excluir sua postagem?';

  @override
  String get discardChangesQuestion => 'Você deseja descartar suas alterações?';

  @override
  String get discard => 'Descartar';

  @override
  String get discardChanges => 'Descartar alterações';

  @override
  String get notificationsTab => 'Avisos';

  @override
  String get postAwaitingApproval =>
      'Sua postagem aparecerá quando um moderador aprová-la.';

  @override
  String get reactionHoldHint => 'Pressione e segure para mais reações';

  @override
  String get turnOnNotifications => 'Ativar notificações';

  @override
  String get notNow => 'Agora não';

  @override
  String neverMissAReplyOn(Object forumName) {
    return 'Não perca nenhuma resposta em $forumName';
  }

  @override
  String get notificationPreviewNow => 'agora';

  @override
  String get notificationPreviewEarlier => 'há 5 min';

  @override
  String get notificationPreviewReply =>
      'Jane respondeu você: Bem-vindo! Que bom que você nos encontrou.';

  @override
  String get notificationPreviewMessage =>
      'Sam enviou uma mensagem: Você vem na sexta?';

  @override
  String get notificationsAreTurnedOffForThisApp =>
      'As notificações estão desativadas para este app';

  @override
  String get deviceWillNotShowAlertsUntilAllowedInSettings =>
      'O seu dispositivo não mostrará alertas até que permita as notificações em Configurações.';

  @override
  String get openSettings => 'Abrir configurações';

  @override
  String get notificationsPitchForum =>
      'Respostas, menções e mensagens diretas na tela de bloqueio assim que chegam.';

  @override
  String get viewProfile => 'Ver perfil';

  @override
  String get settings => 'Configurações';

  @override
  String get signOut => 'Sair';

  @override
  String get changeEmail => 'Alterar e-mail';

  @override
  String get changePassword => 'Alterar senha';

  @override
  String get save => 'Salvar';

  @override
  String get currentPassword => 'Senha atual';

  @override
  String get newPassword => 'Nova senha';

  @override
  String get confirmNewPassword => 'Confirme a nova senha';

  @override
  String get newEmailAddress => 'Novo endereço de e-mail';

  @override
  String get emailChanged => 'Endereço de e-mail alterado';

  @override
  String get emailChangeConfirm =>
      'Verifique sua caixa de entrada: o novo endereço passa a valer quando você confirmar.';

  @override
  String get passwordChanged => 'Senha alterada';

  @override
  String get account => 'Conta';

  @override
  String get pleaseEnterEmail => 'Digite seu e-mail';

  @override
  String get pleaseEnterValidEmail => 'Digite um e-mail válido';

  @override
  String get passwordsDoNotMatch => 'As senhas não coincidem';

  @override
  String get connectionErrorTitle => 'Erro de conexão';

  @override
  String get authenticationErrorTitle => 'Erro de autenticação';

  @override
  String get permissionErrorTitle => 'Erro de permissão';

  @override
  String get errorNoConnection =>
      'Sem conexão com a internet. Verifique suas configurações de rede.';

  @override
  String get errorTimeout => 'A solicitação expirou. Tente novamente.';

  @override
  String get errorServer =>
      'Ocorreu um erro no servidor. Tente novamente mais tarde.';

  @override
  String get errorNetwork => 'Ocorreu um erro de rede. Tente novamente.';

  @override
  String get errorInvalidCredentials => 'Nome de usuário ou senha inválidos.';

  @override
  String get errorSessionExpired => 'Sua sessão expirou. Faça login novamente.';

  @override
  String get errorAccountLocked =>
      'Sua conta foi bloqueada. Entre em contato com o suporte.';

  @override
  String get errorAuthFailed => 'Falha na autenticação. Tente novamente.';

  @override
  String get errorForumNotFound => 'Fórum não encontrado.';

  @override
  String get errorForumAccessDenied =>
      'Você não tem permissão para acessar este fórum.';

  @override
  String get errorForumUnavailable =>
      'O fórum está indisponível no momento. Tente novamente mais tarde.';

  @override
  String get errorForumGeneric => 'Ocorreu um erro no fórum. Tente novamente.';

  @override
  String get errorDataNotFound => 'Os dados solicitados não foram encontrados.';

  @override
  String get errorDataCorrupted =>
      'Os dados parecem estar corrompidos. Atualize a página.';

  @override
  String get errorCache =>
      'Falha ao carregar os dados em cache. Tente novamente.';

  @override
  String get errorInvalidInput => 'Algo que você digitou não é válido.';

  @override
  String get errorRequiredField => 'Preencha todos os campos obrigatórios.';

  @override
  String get errorPermissionDenied => 'Você não tem permissão para fazer isso.';

  @override
  String errorFeatureNotAvailable(String feature) {
    return '$feature não está disponível neste fórum.';
  }

  @override
  String get errorStorageFull =>
      'O armazenamento está cheio. Libere algum espaço.';

  @override
  String get errorStorageAccessDenied =>
      'Acesso ao armazenamento negado. Verifique as permissões do app.';

  @override
  String get loginInfo => 'Informações de login';

  @override
  String get loginFailed => 'Falha no login';

  @override
  String get topicAnnouncement => 'Anúncio';

  @override
  String get topicPinned => 'Fixado';

  @override
  String get topicLocked => 'Trancado';

  @override
  String get topicPoll => 'Enquete';

  @override
  String get deletedBadge => 'EXCLUÍDO';

  @override
  String get protectedBadge => 'Protegido';

  @override
  String get lockTopic => 'Trancar tópico';

  @override
  String get unlockTopic => 'Destrancar tópico';

  @override
  String get lockTopicConfirm =>
      'Tem certeza de que deseja trancar este tópico? Outros usuários não poderão responder nem interagir com ele.';

  @override
  String get unlockTopicConfirm =>
      'Tem certeza de que deseja destrancar este tópico? Outros usuários poderão responder e interagir com ele novamente.';

  @override
  String get stickTopic => 'Fixar tópico';

  @override
  String get unstickTopic => 'Desafixar tópico';

  @override
  String get stickTopicConfirm =>
      'Tem certeza de que deseja fixar este tópico? Ele aparecerá no topo do fórum para todos os usuários.';

  @override
  String get unstickTopicConfirm =>
      'Tem certeza de que deseja desafixar este tópico? Ele não aparecerá mais no topo do fórum.';

  @override
  String get undeleteTopic => 'Restaurar tópico';

  @override
  String get undeleteTopicConfirm =>
      'Tem certeza de que deseja restaurar este tópico? Ele ficará visível para outros usuários novamente.';

  @override
  String get additionalInformation => 'Informações adicionais';

  @override
  String get dateOfBirth => 'Data de nascimento';

  @override
  String get selectDateOfBirth => 'Selecione a data de nascimento';

  @override
  String minimumAge(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: 'Idade mínima: $age anos',
      one: 'Idade mínima: $age ano',
    );
    return '$_temp0';
  }

  @override
  String get locationIsRequired => 'A localização é obrigatória';

  @override
  String get receiveSiteMailings => 'Receber e-mails do site';

  @override
  String iAcceptTheDocument(String document) {
    return 'Eu aceito os $document';
  }

  @override
  String get termsOfService => 'Termos de Serviço';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get imageExceedsUploadLimits =>
      'Esta imagem excede os limites de envio e precisa ser otimizada:';

  @override
  String get originalSize => 'Tamanho original';

  @override
  String get originalDimensions => 'Dimensões originais';

  @override
  String get optimizationsToBeApplied => 'Otimizações que serão aplicadas:';

  @override
  String get resizeImage => 'Redimensionar';

  @override
  String get convertFormat => 'Converter formato';

  @override
  String get smallerFileSize => 'arquivo menor';

  @override
  String get formatNotSupported => 'formato não suportado';

  @override
  String get convertToJpgReason =>
      'Converter para JPG (formato não suportado ou para reduzir o tamanho)';

  @override
  String get compressImage => 'Comprimir';

  @override
  String compressQuality(int quality) {
    return 'Qualidade: $quality% para atender ao limite de tamanho';
  }

  @override
  String get estimatedFinalSize => 'Tamanho final estimado';

  @override
  String sizeReduction(String percent) {
    return 'Redução: $percent%';
  }

  @override
  String get pleaseLoginToCreateTopic => 'Faça login para criar um novo tópico';

  @override
  String get pleaseLoginToSubscribeForums =>
      'Faça login para se inscrever em fóruns';

  @override
  String get pleaseLoginToUnsubscribeForums =>
      'Faça login para cancelar a inscrição em fóruns';

  @override
  String errorLoadingContent(String error) {
    return 'Erro ao carregar o conteúdo: $error';
  }

  @override
  String get noPermissionToViewSubforumTopics =>
      'Você não tem permissão para ver os tópicos deste subfórum.';

  @override
  String get noDiscussionsYet => 'Ainda não há discussões.';

  @override
  String get unableToLoadForums => 'Não foi possível carregar os fóruns';

  @override
  String get noForumsAvailable => 'Nenhum fórum disponível';

  @override
  String get noForumsToDisplay =>
      'Não há fóruns para exibir. Isso pode ocorrer por causa das permissões ou da estrutura do fórum.';

  @override
  String get subscribedForums => 'Fóruns inscritos';

  @override
  String get allForumTopicsMarkedRead =>
      'Todos os tópicos do fórum foram marcados como lidos';

  @override
  String postsCountFormatted(String count) {
    return '$count posts';
  }

  @override
  String get jumpToPost => 'Ir para a postagem';

  @override
  String get jump => 'Ir';

  @override
  String get endOfDiscussion => 'Fim da discussão';

  @override
  String refreshFailed(String error) {
    return 'Falha ao atualizar: $error';
  }

  @override
  String get topicDeletedHidden =>
      'Este tópico foi excluído e está oculto para outros usuários';

  @override
  String get topicClosedNoReplies =>
      'Este tópico está fechado e não aceita mais respostas';

  @override
  String get youAreSubscribedToTopic => 'Você está inscrito neste tópico';

  @override
  String get refreshing => 'Atualizando...';

  @override
  String get unableToLoadForumsTryAgain =>
      'Não foi possível carregar os fóruns. Tente novamente.';

  @override
  String get noPostableForums => 'Não há fóruns em que você possa publicar.';

  @override
  String get changeForumQuestion => 'Mudar de fórum?';

  @override
  String get changeForumRemovesAttachments =>
      'Mudar de fórum removerá os anexos enviados, porque os anexos estão vinculados ao fórum selecionado.';

  @override
  String get changeForum => 'Mudar de fórum';

  @override
  String get chooseForumBeforePosting => 'Escolha um fórum antes de publicar';

  @override
  String get accountCannotUploadAttachments =>
      'Sua conta não pode enviar anexos neste site.';

  @override
  String get forumNoAttachments => 'Este fórum não permite anexos.';

  @override
  String get forumNoAttachmentsChooseAnother =>
      'Este fórum não permite anexos. Escolha outro fórum para enviar os arquivos compartilhados.';

  @override
  String get forumNoAttachmentsSharedPending =>
      'Este fórum não permite anexos. Os arquivos compartilhados ficarão pendentes até você escolher outro fórum.';

  @override
  String get tapToChangeForum => 'Toque para mudar de fórum';

  @override
  String get chooseWhichForum => 'Escolha em qual fórum publicar';

  @override
  String get selectAForum => 'Selecione um fórum';

  @override
  String get unableToLoadForumsNow =>
      'Não é possível carregar os fóruns agora.';

  @override
  String get pickForumBeforeUploading =>
      'Escolha um fórum antes de enviar anexos ou publicar.';

  @override
  String get uploadingSharedFiles => 'Enviando arquivos compartilhados...';

  @override
  String get selectForum => 'Selecionar fórum';

  @override
  String get noForumsMatchSearch => 'Nenhum fórum corresponde à sua pesquisa.';

  @override
  String get unknown => 'Desconhecido';

  @override
  String get closeConversationConfirm =>
      'Tem certeza de que deseja fechar esta conversa? Não será possível enviar novas respostas.';

  @override
  String get openConversationConfirm =>
      'Tem certeza de que deseja abrir esta conversa? Será possível enviar novas respostas.';

  @override
  String get leaveConversationConfirm =>
      'Tem certeza de que deseja sair desta conversa? Ela será ocultada da sua caixa de entrada.';

  @override
  String get close => 'Fechar';

  @override
  String get open => 'Abrir';

  @override
  String get leave => 'Sair';

  @override
  String errorLoadingConversation(String error) {
    return 'Erro ao carregar a conversa: $error';
  }

  @override
  String get conversationNotFound => 'Conversa não encontrada';

  @override
  String get conversationClosedNoReplies =>
      'Esta conversa está fechada e não aceita mais respostas';

  @override
  String get noMessagesFound => 'Nenhuma mensagem encontrada';

  @override
  String get endOfConversation => 'Fim da conversa';

  @override
  String get jumpToMessage => 'Ir para a mensagem';

  @override
  String get jumpToFirstMessage => 'Ir para a primeira mensagem';

  @override
  String get jumpToLastMessage => 'Ir para a última mensagem';

  @override
  String messagePositionOf(int position, int total) {
    return 'Mensagem $position de $total';
  }

  @override
  String get tapToJumpToMessage => 'Toque para ir a uma mensagem específica';

  @override
  String failedToReact(String error) {
    return 'Falha ao reagir: $error';
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
  String get noImagesToDisplay => 'Nenhuma imagem para exibir.';

  @override
  String get pleaseLoginToViewAttachment => 'Faça login para ver este anexo';

  @override
  String get inbox => 'Caixa de entrada';

  @override
  String get sent => 'Enviadas';

  @override
  String errorLoadingMessages(String error) {
    return 'Erro ao carregar as mensagens: $error';
  }

  @override
  String get noInboxMessages => 'Nenhuma mensagem recebida';

  @override
  String get noSentMessages => 'Nenhuma mensagem enviada';

  @override
  String get unknownDate => 'Data desconhecida';

  @override
  String get searchForTopics => 'Pesquisar tópicos';

  @override
  String get noTopicsFound => 'Nenhum tópico encontrado';

  @override
  String get noPostsFound => 'Nenhuma postagem encontrada';

  @override
  String get trySearchingDifferentKeywords =>
      'Tente pesquisar com outras palavras-chave';

  @override
  String errorLoadingSettings(String error) {
    return 'Erro ao carregar as configurações: $error';
  }

  @override
  String get pleaseEnterValidNumber => 'Digite um número válido';

  @override
  String valueMustBeAtLeast(String min) {
    return 'O valor deve ser pelo menos $min';
  }

  @override
  String valueMustBeAtMost(String max) {
    return 'O valor deve ser no máximo $max';
  }

  @override
  String maximumLengthCharacters(int max) {
    return 'O tamanho máximo é de $max caracteres';
  }

  @override
  String get invalidFormat => 'Formato inválido';

  @override
  String get shareToForumCopilot => 'Compartilhar no Forum Copilot';

  @override
  String get noSavedForumAccounts => 'Nenhuma conta de fórum salva encontrada.';

  @override
  String get addForumAccountFirst =>
      'Primeiro adicione uma conta de fórum no Forum Copilot e depois tente compartilhar novamente.';

  @override
  String filesReadyToAttach(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos prontos para anexar',
      one: '$count arquivo pronto para anexar',
    );
    return '$_temp0';
  }

  @override
  String get sharedTextWillBePrefilled =>
      'O texto compartilhado será preenchido';

  @override
  String errorSearchingForums(String error) {
    return 'Erro ao pesquisar fóruns: $error';
  }

  @override
  String failedToLoadUserInfo(String error) {
    return 'Falha ao carregar as informações do usuário: $error';
  }

  @override
  String areYouSureUnban(String username) {
    return 'Tem certeza de que deseja desbanir $username?';
  }

  @override
  String get deletePostsProfilePostsComments =>
      'Excluir postagens, mensagens de perfil e comentários';

  @override
  String areYouSureSpamClean(String username) {
    return 'Tem certeza de que deseja limpar o spam de $username?';
  }

  @override
  String successfullyCleanedSpamFor(String username) {
    return 'O spam de $username foi limpo';
  }

  @override
  String get failedToCleanSpam => 'Falha ao limpar o spam';

  @override
  String imagesCount(int count) {
    return 'Imagens ($count)';
  }

  @override
  String get pleaseLoginToViewProfiles =>
      'Faça login para ver os perfis de usuários.';

  @override
  String get tapToOpen => 'Toque para abrir';

  @override
  String get imageNotAvailable => 'Imagem indisponível';

  @override
  String get tapToViewFullSizeImage =>
      'Toque para ver a imagem em tamanho real';

  @override
  String get loadingImage => 'Carregando imagem...';

  @override
  String loadingImageFrom(String host) {
    return 'Carregando imagem de $host';
  }

  @override
  String get tapToReveal => '(toque para revelar)';

  @override
  String get inlineAttachments => 'Anexos incorporados';

  @override
  String get thisFieldIsRequired => 'Este campo é obrigatório';

  @override
  String get pleaseEnterValidPhoneNumber =>
      'Digite um número de telefone válido';

  @override
  String get pleaseEnterValidUrl => 'Digite um URL válido';

  @override
  String get permissionDeniedToSaveImage =>
      'Sem permissão para salvar a imagem';

  @override
  String get postNotFound => 'Postagem não encontrada.';

  @override
  String get failedToUploadFileTryAgain =>
      'Falha ao enviar o arquivo. Tente novamente.';

  @override
  String get failedToPickFile => 'Falha ao selecionar o arquivo';

  @override
  String onlyMoreAttachmentsAllowed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Só são permitidos mais $count anexos. As primeiras $count imagens serão usadas.',
      one: 'Só é permitido mais 1 anexo. A primeira imagem será usada.',
    );
    return '$_temp0';
  }

  @override
  String get attachmentLimitReachedSkipping =>
      'Limite de anexos atingido. As imagens restantes serão ignoradas.';

  @override
  String get imageValidationFailed => 'Falha na validação da imagem';

  @override
  String get imageUploadFailed => 'Falha ao enviar a imagem';

  @override
  String get failedToUploadImageTryAgain =>
      'Falha ao enviar a imagem. Tente novamente.';

  @override
  String get failedToPickImage => 'Falha ao selecionar a imagem';

  @override
  String get prefix => 'Prefixo';

  @override
  String get failedToLoadPrefixes => 'Falha ao carregar os prefixos';

  @override
  String get attachFileHint => 'Anexar um arquivo a esta mensagem';

  @override
  String get uploadImageHint => 'Enviar uma imagem para esta mensagem';

  @override
  String get openFormattingOptions => 'Abrir opções de formatação';

  @override
  String get failedToPostReply =>
      'Falha ao publicar a resposta. Tente novamente.';

  @override
  String get failedToUpdatePost =>
      'Falha ao atualizar a postagem. Tente novamente.';

  @override
  String get postDeletedSuccessfully => 'Postagem excluída';

  @override
  String failedToDeletePost(String error) {
    return 'Falha ao excluir a postagem: $error';
  }

  @override
  String get noPermissionToUploadAvatars =>
      'Você não tem permissão para enviar avatares';

  @override
  String get avatarUploadedSuccessfully => 'Avatar enviado';

  @override
  String get unknownTopic => 'Tópico desconhecido';

  @override
  String get connectionTimeoutTitle => 'Tempo de conexão esgotado';

  @override
  String connectionTimedOutTo(String siteName) {
    return 'A conexão com $siteName expirou. Verifique sua conexão com a internet e tente novamente.';
  }

  @override
  String failedToConnectCheckPlugin(String siteName) {
    return 'Falha ao conectar a $siteName. Verifique se o fórum está disponível e se o plugin está instalado.';
  }

  @override
  String get voteFailedTryAgain => 'Falha ao votar. Tente novamente.';

  @override
  String get noUserSpecified => 'Nenhum usuário especificado';

  @override
  String get failedToLoadRecentPosts =>
      'Falha ao carregar as postagens recentes';

  @override
  String failedToLoadPreview(String error) {
    return 'Falha ao carregar a prévia: $error';
  }

  @override
  String thanksCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Agradecido por $count pessoas',
      one: 'Agradecido por $count pessoa',
    );
    return '$_temp0';
  }

  @override
  String get thankedBy => 'Agradecido por';

  @override
  String maximumAttachmentsAllowed(int count) {
    return 'Máximo de $count anexo(s) permitido(s)';
  }

  @override
  String get toLabel => 'Para';

  @override
  String get closeConversation => 'Fechar conversa';

  @override
  String get openConversation => 'Abrir conversa';

  @override
  String get loginSucceeded => 'Login realizado';

  @override
  String get verificationErrorTryAgain =>
      'Ocorreu um erro durante a verificação. Tente novamente.';

  @override
  String get passkeyChallengeFailed =>
      'Não foi possível iniciar o login com chave de acesso.';

  @override
  String get passkeyNotSetUp =>
      'Este fórum ainda não está configurado para chaves de acesso neste app. Faça login com seu nome de usuário e senha.';

  @override
  String get noPasskeyForForum =>
      'Nenhuma chave de acesso encontrada para este fórum. Faça login com sua senha ou crie primeiro uma chave de acesso no site do fórum.';

  @override
  String get pushNotificationsNotReady =>
      'As notificações push ainda não estão prontas';

  @override
  String pushEnabledFor(String siteName) {
    return 'Notificações push ativadas para $siteName';
  }

  @override
  String get failedToEnablePush => 'Falha ao ativar as notificações push';

  @override
  String get failedToRegisterPush => 'Falha ao registrar as notificações push';

  @override
  String translatedFromTo(String source, String target) {
    return 'Traduzido de $source para $target';
  }

  @override
  String get unableToOpenNotification => 'Não foi possível abrir a notificação';

  @override
  String get notificationMissingInfo => 'Faltam informações nesta notificação.';

  @override
  String get couldNotOpenForum => 'Não foi possível abrir o fórum.';

  @override
  String get notificationChannelName => 'Notificações do Forum Copilot';

  @override
  String get notificationChannelDescription =>
      'Notificações do app Forum Copilot';

  @override
  String fileTypeNotAllowed(String extension, String allowed) {
    return 'O tipo de arquivo .$extension não é permitido. Tipos permitidos: $allowed';
  }

  @override
  String fileSizeExceedsMaximum(String size, String max) {
    return 'O tamanho do arquivo ($size) excede o máximo de $max';
  }

  @override
  String get fileTypeAudio => 'Áudio';

  @override
  String get fileTypeText => 'Texto';

  @override
  String get fileTypeArchive => 'Arquivo compactado';

  @override
  String get fileTypeFile => 'Arquivo';

  @override
  String get imageFileNotFound =>
      'Arquivo de imagem não encontrado. Ele pode ter sido movido ou excluído.';

  @override
  String get imagePermissionDenied =>
      'Permissão negada. Não é possível ler o arquivo de imagem.';

  @override
  String get imageInsufficientSpace =>
      'Espaço em disco insuficiente para otimizar a imagem.';

  @override
  String cannotAccessImageFile(String error) {
    return 'Não é possível acessar o arquivo de imagem: $error';
  }

  @override
  String get imageFormatUnsupported =>
      'O formato da imagem está corrompido ou não é suportado. Tente outra imagem.';

  @override
  String get failedToResizeImage =>
      'Falha ao redimensionar a imagem. Ela pode estar corrompida ou em um formato não suportado.';

  @override
  String get failedToConvertImageToJpg =>
      'Falha ao converter a imagem para JPG. Ela pode estar corrompida.';

  @override
  String get failedToCompressImage =>
      'Falha ao compactar a imagem. Pode faltar espaço em disco ou a imagem está corrompida.';

  @override
  String get cannotDecodeImage =>
      'Não é possível decodificar a imagem. O arquivo pode estar corrompido ou em um formato não suportado.';

  @override
  String get cannotReadImageFile =>
      'Não é possível ler o arquivo de imagem. Ele pode ter sido movido ou excluído.';

  @override
  String failedToOptimizeImage(String error) {
    return 'Falha ao otimizar a imagem: $error';
  }

  @override
  String emailCopiedToClipboard(String email) {
    return 'Email copiado para a area de transferencia: $email';
  }

  @override
  String couldNotOpenEmail(String email) {
    return 'Nao foi possivel abrir o email: $email';
  }

  @override
  String get editPost => 'Editar post';

  @override
  String get thisTopicIsPinnedToTopOfForum =>
      'Este topico esta fixado no topo do forum';

  @override
  String get editConversation => 'Editar conversa';

  @override
  String get failedToLoadConversation => 'Falha ao carregar conversa';

  @override
  String get cannotEditConversation => 'Não é possível editar esta conversa';

  @override
  String get titleLabel => 'Título';

  @override
  String get options => 'Opções';

  @override
  String get openInvite => 'Convite aberto';

  @override
  String get allowAnyParticipantToInviteOthers =>
      'Permitir que qualquer participante convide outras pessoas';

  @override
  String get conversationOpen => 'Conversa aberta';

  @override
  String failedToCreateConversation(String error) {
    return 'Falha ao criar conversa: $error';
  }

  @override
  String get lockConversation => 'Bloquear conversa';

  @override
  String get createConversationAsClosed =>
      'Criar conversa como fechada (respostas não permitidas)';

  @override
  String get deleteAccount => 'Excluir conta';

  @override
  String get deleteAccountDescription => 'Remova sua conta deste fórum.';

  @override
  String get deleteAccountContactForumMessage =>
      'Sua conta é gerenciada pelo fórum. Entre em contato diretamente com o fórum para remover a conta. Use o botão \"Fale conosco\" no rodapé da página inicial do fórum.';

  @override
  String get forumUrlUnavailable => 'A URL do fórum não está disponível.';

  @override
  String get couldNotOpenForumUrl => 'Não foi possível abrir a URL do fórum.';

  @override
  String get noActionUrlAvailableForThisNotificationType =>
      'Nenhuma URL de ação disponível para este tipo de notificação.';

  @override
  String get signInToViewNotifications => 'Faça login para ver notificações';

  @override
  String get youNeedToBeSignedInToViewYourNotifications =>
      'Você precisa estar conectado para ver suas notificações.';

  @override
  String get errorLoadingNotifications => 'Erro ao carregar notificações';

  @override
  String get pullDownToRefresh => 'Puxe para baixo para atualizar';

  @override
  String get youHaveNoNewNotificationsCheckBackLater =>
      'Você não tem novas notificações. Volte mais tarde para atualizações.';

  @override
  String get signInToViewProfile => 'Faca login para ver o perfil';

  @override
  String get youNeedToBeSignedInToViewYourProfile =>
      'Voce precisa estar conectado para ver seu perfil.';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get confirmPasswordLabel => 'Confirmar senha';

  @override
  String get protectedForum => 'Forum protegido';

  @override
  String forumIsPasswordProtected(String forumName) {
    return '$forumName esta protegido por senha.';
  }

  @override
  String get enterButton => 'Entrar';

  @override
  String get recentPosts => 'Posts recentes';

  @override
  String passkeyNotAvailableInForum(int code) {
    return 'Passkey não está disponível neste fórum no momento (código: $code)';
  }

  @override
  String get initializingForum => 'Iniciando o fórum…';

  @override
  String get retryConnection => 'Tentar conectar de novo';

  @override
  String get pleaseConfirmPassword => 'Confirme sua senha';

  @override
  String get pleaseEnterTheForumPassword => 'Digite a senha do forum';

  @override
  String get editYourPost => 'Edite seu post...';

  @override
  String get topicIdIsMissingCannotNavigateToThePost =>
      'ID do tópico ausente. Não é possível abrir a postagem.';

  @override
  String get conversationIsOpenForReplies =>
      'A conversa está aberta para respostas';

  @override
  String get conversationIsClosedNoRepliesAllowed =>
      'A conversa está fechada (respostas não permitidas)';

  @override
  String get pleaseEnterAUsername => 'Digite um nome de usuário';

  @override
  String usernameMinLength(int count) {
    return 'O nome de usuário deve ter pelo menos $count caracteres';
  }

  @override
  String get pleaseEnterAPassword => 'Digite uma senha';

  @override
  String passwordMinLength(int count) {
    return 'A senha deve ter pelo menos $count caracteres';
  }

  @override
  String get writeYourTopicTitle => 'Escreva o título do tópico...';

  @override
  String get writeYourTopicContent => 'Escreva o conteúdo do tópico...';

  @override
  String pushDisabledFor(String siteName) {
    return 'Notificações push desativadas para $siteName';
  }

  @override
  String get failedToDisablePush => 'Falha ao desativar as notificações push';

  @override
  String get thisForum => 'este fórum';

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
      other: '$countString membros',
      one: '$countString membro',
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
      other: '$countString tópicos',
      one: '$countString tópico',
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
      other: '$countString mensagens',
      one: '$countString mensagem',
    );
    return '$_temp0';
  }

  @override
  String searchForumName(String forumName) {
    return 'Pesquisar em $forumName';
  }

  @override
  String get copyLink => 'Copiar link';

  @override
  String get linkCopied => 'Link copiado';

  @override
  String sharedFilesAttached(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos compartilhados anexados.',
      one: '1 arquivo compartilhado anexado.',
    );
    return '$_temp0';
  }

  @override
  String sharedFilesPartlyAttached(int count, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos anexados. Não anexados: $names',
      one: '1 arquivo anexado. Não anexados: $names',
    );
    return '$_temp0';
  }

  @override
  String get notificationChannelMessages => 'Mensagens';

  @override
  String get notificationChannelMessagesDescription =>
      'Novas mensagens diretas e respostas';

  @override
  String get notificationChannelReplies => 'Respostas e menções';

  @override
  String get notificationChannelRepliesDescription =>
      'Respostas em tópicos que você segue, citações e menções';

  @override
  String get notificationChannelReactions => 'Curtidas e reações';

  @override
  String get notificationChannelReactionsDescription =>
      'Curtidas e reações às suas mensagens';

  @override
  String get notificationChannelOther => 'Outras notificações';

  @override
  String get notificationChannelOtherDescription =>
      'Seguidores, troféus e outros alertas do fórum';

  @override
  String get deleteAccountConfirmTitle => 'Excluir sua conta?';

  @override
  String deleteAccountConfirmMessage(String forumName) {
    return 'Sua conta em $forumName será excluída, com seu perfil e suas configurações. Suas mensagens permanecem, com seu nome. Isso não pode ser desfeito.';
  }

  @override
  String get deleteAccountNoPassword =>
      'Sem senha? Confirme com seu nome de usuário';

  @override
  String get deleteAccountUsePassword => 'Confirmar com sua senha';

  @override
  String get accountDeleted => 'Sua conta foi excluída.';

  @override
  String get signInOnWebsite => 'Entrar pelo site do fórum';

  @override
  String get signInOnWebsiteHint =>
      'Para Google, Facebook e as outras formas de entrar lá';

  @override
  String get browserLoginFailed =>
      'Não foi possível entrar pelo site. Tente novamente.';

  @override
  String get subForums => 'Subfóruns';

  @override
  String postPositionOf(int position, int total) {
    return 'Publicação $position de $total';
  }

  @override
  String get tapToJumpToPost => 'Toque para ir a uma publicação específica';

  @override
  String get jumpToFirstPost => 'Ir para a primeira publicação';

  @override
  String get jumpToLastPost => 'Ir para a última publicação';

  @override
  String get send => 'Enviar';

  @override
  String get postAction => 'Publicar';

  @override
  String messageCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mensagens',
      one: '$count mensagem',
    );
    return '$_temp0';
  }

  @override
  String replyCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count respostas',
      one: '$count resposta',
    );
    return '$_temp0';
  }

  @override
  String subForumCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subfóruns',
      one: '$count subfórum',
    );
    return '$_temp0';
  }

  @override
  String get trustThisDevice => 'Confiar neste dispositivo';

  @override
  String get trustThisDeviceHint =>
      'Não pedir um código na próxima vez que você entrar neste dispositivo';

  @override
  String get passkeyNotOnThisDevice =>
      'Não há chave de acesso para este fórum neste dispositivo. Escolha outro método ou adicione primeiro uma chave de acesso no site do fórum.';

  @override
  String get passkeyStepNotSetUp =>
      'Este fórum ainda não está configurado para chaves de acesso neste app. Escolha outro método.';
}
