// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Spenditize';

  @override
  String get welcomeMessage => 'Plan it. Wish it. Spenditize it.';

  @override
  String get addWish => 'Add to Wishlist';

  @override
  String get spendingPlan => 'Spending Plan';
}
