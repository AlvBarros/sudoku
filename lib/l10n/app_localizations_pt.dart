// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get welcomeTitlePrefix => '';

  @override
  String get appName => 'Sudokats';

  @override
  String get welcomeTitle => 'Bem-vindo(a) ao ';

  @override
  String get welcomeTitlePunctuation => '!';

  @override
  String statsGamesPlayed(Object count) {
    return 'Jogos jogados: $count';
  }

  @override
  String statsPerfectGames(Object count) {
    return 'Jogos perfeitos: $count';
  }

  @override
  String statsAverageTime(Object time) {
    return 'Tempo médio: $time';
  }

  @override
  String get statsNoData => 'Nenhum dado disponível.';

  @override
  String get homeGameInProgress => 'Jogo em andamento';

  @override
  String get homeContinueGamePrompt =>
      'Você gostaria de continuar seu jogo anterior?';

  @override
  String get homeButtonContinueGameButton => 'Continuar jogo';

  @override
  String get homeStartNewGameButton => 'Iniciar novo jogo';

  @override
  String get homeStartNewGamePrompt =>
      'Iniciar um novo jogo apagará seu progresso atual. Tem certeza de que deseja continuar?';

  @override
  String get homeSelectDifficulty => 'Selecionar dificuldade';

  @override
  String gameIncorrectCellsAmount(Object count) {
    return 'Há $count células incorretas.';
  }

  @override
  String get gameMistakesExisted => 'Há erros no quebra-cabeça.';

  @override
  String get gameCongratulations => 'Parabéns!';

  @override
  String gameCompletedMessage(Object time) {
    return 'Você completou o quebra-cabeça em $time.';
  }

  @override
  String get gameButtonExit => 'Wohoo!';

  @override
  String get resetTitle => 'Confirmar reinício';

  @override
  String get resetContent =>
      'Tem certeza de que deseja reiniciar o quebra-cabeça? Esta ação não pode ser desfeita.';

  @override
  String get verifyTitle => 'Perder jogo perfeito?';

  @override
  String get verifyContent =>
      'Verificar fará com que você perca a chance de um jogo perfeito. Deseja continuar?';
}
