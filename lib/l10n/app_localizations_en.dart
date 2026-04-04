// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Branch & ATM Locator';

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get search => 'Search';

  @override
  String get branches => 'Branches';

  @override
  String get atms => 'ATMs';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';
}
