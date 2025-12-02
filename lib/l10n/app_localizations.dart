import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @welcomeTitlePrefix.
  ///
  /// In en, this message translates to:
  /// **''**
  String get welcomeTitlePrefix;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Sudokats'**
  String get appName;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to '**
  String get welcomeTitle;

  /// No description provided for @welcomeTitlePunctuation.
  ///
  /// In en, this message translates to:
  /// **'!'**
  String get welcomeTitlePunctuation;

  /// Indicates the number of games played by the user.
  ///
  /// In en, this message translates to:
  /// **'Games played: {count}'**
  String statsGamesPlayed(Object count);

  /// Indicates the number of perfect games completed by the user.
  ///
  /// In en, this message translates to:
  /// **'Perfect games: {count}'**
  String statsPerfectGames(Object count);

  /// Indicates the average time taken to complete games.
  ///
  /// In en, this message translates to:
  /// **'Average time: {time}'**
  String statsAverageTime(Object time);

  /// No description provided for @statsNoData.
  ///
  /// In en, this message translates to:
  /// **'No statistics available.'**
  String get statsNoData;

  /// No description provided for @homeGameInProgress.
  ///
  /// In en, this message translates to:
  /// **'Game in progress'**
  String get homeGameInProgress;

  /// No description provided for @homeContinueGamePrompt.
  ///
  /// In en, this message translates to:
  /// **'Would you like to continue your previous game?'**
  String get homeContinueGamePrompt;

  /// No description provided for @homeButtonContinueGameButton.
  ///
  /// In en, this message translates to:
  /// **'Continue game'**
  String get homeButtonContinueGameButton;

  /// No description provided for @homeStartNewGameButton.
  ///
  /// In en, this message translates to:
  /// **'Start new game'**
  String get homeStartNewGameButton;

  /// No description provided for @homeStartNewGamePrompt.
  ///
  /// In en, this message translates to:
  /// **'Starting a new game will erase your current progress. Are you sure you want to continue?'**
  String get homeStartNewGamePrompt;

  /// No description provided for @homeSelectDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Select Difficulty'**
  String get homeSelectDifficulty;

  /// Indicates the number of incorrect cells in the current game.
  ///
  /// In en, this message translates to:
  /// **'There are {count} incorrect cells.'**
  String gameIncorrectCellsAmount(Object count);

  /// No description provided for @gameMistakesExisted.
  ///
  /// In en, this message translates to:
  /// **'There are mistakes in the puzzle.'**
  String get gameMistakesExisted;

  /// No description provided for @gameCongratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get gameCongratulations;

  /// Message displayed when the game is completed, showing the time taken
  ///
  /// In en, this message translates to:
  /// **'You\'ve completed the puzzle in {time}.'**
  String gameCompletedMessage(Object time);

  /// No description provided for @gameButtonExit.
  ///
  /// In en, this message translates to:
  /// **'Wohoo!'**
  String get gameButtonExit;

  /// No description provided for @resetTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Reset'**
  String get resetTitle;

  /// No description provided for @resetContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset the puzzle? This action cannot be undone.'**
  String get resetContent;

  /// No description provided for @verifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Lose Perfect Game?'**
  String get verifyTitle;

  /// No description provided for @verifyContent.
  ///
  /// In en, this message translates to:
  /// **'Verifying will forfeit your chance at a perfect game. Do you want to proceed?'**
  String get verifyContent;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
