// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get welcomeTitlePrefix => '¡';

  @override
  String get appName => 'Sudokats';

  @override
  String get welcomeTitle => 'Bienvenido(a) a ';

  @override
  String get welcomeTitlePunctuation => '!';

  @override
  String statsGamesPlayed(Object count) {
    return 'Juegos jugados: $count';
  }

  @override
  String statsPerfectGames(Object count) {
    return 'Juegos perfectos: $count';
  }

  @override
  String statsAverageTime(Object time) {
    return 'Tiempo promedio: $time';
  }

  @override
  String get statsNoData => 'No hay estadísticas disponibles.';

  @override
  String get homeGameInProgress => 'Juego en progreso';

  @override
  String get homeContinueGamePrompt =>
      '¿Te gustaría continuar tu juego anterior?';

  @override
  String get homeButtonContinueGameButton => 'Continuar juego';

  @override
  String get homeStartNewGameButton => 'Iniciar nuevo juego';

  @override
  String get homeStartNewGamePrompt =>
      'Iniciar un nuevo juego borrará tu progreso actual. ¿Estás seguro de que quieres continuar?';

  @override
  String get homeSelectDifficulty => 'Seleccionar dificultad';

  @override
  String gameIncorrectCellsAmount(Object count) {
    return 'Hay $count celdas incorrectas.';
  }

  @override
  String get gameMistakesExisted => 'Hay errores en el rompecabezas.';

  @override
  String get gameCongratulations => '¡Felicidades!';

  @override
  String gameCompletedMessage(Object time) {
    return 'Has completado el rompecabezas en $time.';
  }

  @override
  String get gameButtonExit => 'Wohoo!';

  @override
  String get resetTitle => 'Confirmar reinicio';

  @override
  String get resetContent =>
      '¿Estás seguro de que quieres reiniciar el rompecabezas? Esta acción no se puede deshacer.';

  @override
  String get verifyTitle => '¿Perder juego perfecto?';

  @override
  String get verifyContent =>
      'Verificar hará que pierdas la oportunidad de un juego perfecto. ¿Quieres continuar?';
}
