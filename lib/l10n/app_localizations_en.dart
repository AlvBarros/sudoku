// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get welcomeTitlePrefix => '';

  @override
  String get appName => 'Sudokats';

  @override
  String get welcomeTitle => 'Welcome to ';

  @override
  String get welcomeTitlePunctuation => '!';

  @override
  String statsGamesPlayed(Object count) {
    return 'Games played: $count';
  }

  @override
  String statsPerfectGames(Object count) {
    return 'Perfect games: $count';
  }

  @override
  String statsAverageTime(Object time) {
    return 'Average time: $time';
  }

  @override
  String get statsNoData => 'No statistics available.';

  @override
  String get homeGameInProgress => 'Game in progress';

  @override
  String get homeContinueGamePrompt =>
      'Would you like to continue your previous game?';

  @override
  String get homeButtonContinueGameButton => 'Continue game';

  @override
  String get homeStartNewGameButton => 'Start new game';

  @override
  String get homeStartNewGamePrompt =>
      'Starting a new game will erase your current progress. Are you sure you want to continue?';

  @override
  String get homeSelectDifficulty => 'Select Difficulty';

  @override
  String gameIncorrectCellsAmount(Object count) {
    return 'There are $count incorrect cells.';
  }

  @override
  String get gameMistakesExisted => 'There are mistakes in the puzzle.';

  @override
  String get gameCongratulations => 'Congratulations!';

  @override
  String gameCompletedMessage(Object time) {
    return 'You\'ve completed the puzzle in $time.';
  }

  @override
  String get gameButtonExit => 'Wohoo!';

  @override
  String get resetTitle => 'Confirm Reset';

  @override
  String get resetContent =>
      'Are you sure you want to reset the puzzle? This action cannot be undone.';

  @override
  String get verifyTitle => 'Lose Perfect Game?';

  @override
  String get verifyContent =>
      'Verifying will forfeit your chance at a perfect game. Do you want to proceed?';
}
