import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('pt')
  ];

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Select type of
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get select_type;

  /// No description provided for @spending_plan.
  ///
  /// In en, this message translates to:
  /// **'Spending Plan'**
  String get spending_plan;

  /// No description provided for @a_plan_to_spend_an_amount_of_money.
  ///
  /// In en, this message translates to:
  /// **'A plan to spend an amount of money'**
  String get a_plan_to_spend_an_amount_of_money;

  /// No description provided for @wish.
  ///
  /// In en, this message translates to:
  /// **'Wish'**
  String get wish;

  /// No description provided for @something_that_you_plan_to_buy_will_be_added_to_your_wishlist.
  ///
  /// In en, this message translates to:
  /// **'Something that you plan to buy, will be added to your wishlist'**
  String get something_that_you_plan_to_buy_will_be_added_to_your_wishlist;

  /// No description provided for @select_option.
  ///
  /// In en, this message translates to:
  /// **'Select option'**
  String get select_option;

  /// No description provided for @export_pdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get export_pdf;

  /// No description provided for @share_list_as_a_document.
  ///
  /// In en, this message translates to:
  /// **'Share list as a document'**
  String get share_list_as_a_document;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @save_as_spending_plan.
  ///
  /// In en, this message translates to:
  /// **'Save as Spending plan'**
  String get save_as_spending_plan;

  /// No description provided for @edit_spending_plan.
  ///
  /// In en, this message translates to:
  /// **'Edit Spending Plan'**
  String get edit_spending_plan;

  /// No description provided for @create_spending_plan.
  ///
  /// In en, this message translates to:
  /// **'Create Spending plan'**
  String get create_spending_plan;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @john_s_birthday.
  ///
  /// In en, this message translates to:
  /// **'John\'s Birthday'**
  String get john_s_birthday;

  /// No description provided for @title_is_required.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get title_is_required;

  /// No description provided for @edit_list.
  ///
  /// In en, this message translates to:
  /// **'Edit list'**
  String get edit_list;

  /// No description provided for @expense_s_in_list.
  ///
  /// In en, this message translates to:
  /// **'{length} expense(s) in list'**
  String expense_s_in_list(String length);

  /// No description provided for @add_at_least_one_expense.
  ///
  /// In en, this message translates to:
  /// **'Add at least one expense'**
  String get add_at_least_one_expense;

  /// No description provided for @set_reminder.
  ///
  /// In en, this message translates to:
  /// **'Set Reminder'**
  String get set_reminder;

  /// No description provided for @get_notified_to_purchase_this_item.
  ///
  /// In en, this message translates to:
  /// **'Get notified to purchase this item'**
  String get get_notified_to_purchase_this_item;

  /// No description provided for @target_purchase_date.
  ///
  /// In en, this message translates to:
  /// **'Target Purchase Date'**
  String get target_purchase_date;

  /// No description provided for @reminders_need_to_be_a_minimum_of_5_minutes_from_now.
  ///
  /// In en, this message translates to:
  /// **'Reminders need to be a minimum of 5 minutes from now'**
  String get reminders_need_to_be_a_minimum_of_5_minutes_from_now;

  /// No description provided for @spending_list_fulfilment.
  ///
  /// In en, this message translates to:
  /// **'Spending list fulfilment'**
  String get spending_list_fulfilment;

  /// No description provided for @remember_to_fulfil_buddy.
  ///
  /// In en, this message translates to:
  /// **'Remember to fulfil {title}  Buddy!'**
  String remember_to_fulfil_buddy(String title);

  /// No description provided for @sorry_there_was_an_error.
  ///
  /// In en, this message translates to:
  /// **'Sorry, there was an error!'**
  String get sorry_there_was_an_error;

  /// No description provided for @notifications_disabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications disabled'**
  String get notifications_disabled;

  /// No description provided for @please_enable_notifications_in_settings_to_use_reminders.
  ///
  /// In en, this message translates to:
  /// **'Please enable notifications in settings to use reminders.'**
  String get please_enable_notifications_in_settings_to_use_reminders;

  /// No description provided for @open_settings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get open_settings;

  /// No description provided for @edit_wish.
  ///
  /// In en, this message translates to:
  /// **'Edit Wish'**
  String get edit_wish;

  /// No description provided for @add_new_wish.
  ///
  /// In en, this message translates to:
  /// **'Add New Wish'**
  String get add_new_wish;

  /// No description provided for @item_name.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get item_name;

  /// No description provided for @air_jordans.
  ///
  /// In en, this message translates to:
  /// **'Air Jordans'**
  String get air_jordans;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @save_wish.
  ///
  /// In en, this message translates to:
  /// **'Save Wish'**
  String get save_wish;

  /// No description provided for @reminder_must_be_at_least_5_minutes_from_now.
  ///
  /// In en, this message translates to:
  /// **'Reminder must be at least 5 minutes from now'**
  String get reminder_must_be_at_least_5_minutes_from_now;

  /// No description provided for @wish_fulfilment.
  ///
  /// In en, this message translates to:
  /// **'Wish fulfilment'**
  String get wish_fulfilment;

  /// No description provided for @don_t_forget_your.
  ///
  /// In en, this message translates to:
  /// **'Don\\\'t forget your {name}!'**
  String don_t_forget_your(String name);

  /// No description provided for @error_saving_wish.
  ///
  /// In en, this message translates to:
  /// **'Error saving wish'**
  String get error_saving_wish;

  /// No description provided for @quick_spending_plan.
  ///
  /// In en, this message translates to:
  /// **'Quick Spending Plan'**
  String get quick_spending_plan;

  /// No description provided for @balance_remaining.
  ///
  /// In en, this message translates to:
  /// **'Balance Remaining'**
  String get balance_remaining;

  /// No description provided for @estimated_total.
  ///
  /// In en, this message translates to:
  /// **'Estimated Total'**
  String get estimated_total;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @quick_add_fill_fields_and_tap_or_press_enter.
  ///
  /// In en, this message translates to:
  /// **'Quick-add: fill fields and tap + or press enter'**
  String get quick_add_fill_fields_and_tap_or_press_enter;

  /// No description provided for @quick_plan.
  ///
  /// In en, this message translates to:
  /// **'Quick Plan'**
  String get quick_plan;

  /// No description provided for @set_budget_limit.
  ///
  /// In en, this message translates to:
  /// **'Set Budget Limit'**
  String get set_budget_limit;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @reverse_mode.
  ///
  /// In en, this message translates to:
  /// **'Reverse Mode'**
  String get reverse_mode;

  /// No description provided for @specify_a_budget_and_each_item_will_deduct_from_that_total.
  ///
  /// In en, this message translates to:
  /// **'Specify a budget, and each item will deduct from that total.'**
  String get specify_a_budget_and_each_item_will_deduct_from_that_total;

  /// No description provided for @got_it.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get got_it;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// No description provided for @spending_plans.
  ///
  /// In en, this message translates to:
  /// **'Spending Plans'**
  String get spending_plans;

  /// No description provided for @wishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// No description provided for @plans.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get plans;

  /// No description provided for @quicklist.
  ///
  /// In en, this message translates to:
  /// **'QuickList'**
  String get quicklist;

  /// No description provided for @preview_pdf.
  ///
  /// In en, this message translates to:
  /// **'Preview PDF'**
  String get preview_pdf;

  /// No description provided for @remove_watermark.
  ///
  /// In en, this message translates to:
  /// **'Remove Watermark'**
  String get remove_watermark;

  /// No description provided for @watch_ad_to_remove_watermark.
  ///
  /// In en, this message translates to:
  /// **'Watch Ad to remove watermark?'**
  String get watch_ad_to_remove_watermark;

  /// No description provided for @watch.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get watch;

  /// No description provided for @watch_ad.
  ///
  /// In en, this message translates to:
  /// **'Watch Ad'**
  String get watch_ad;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @change_currency.
  ///
  /// In en, this message translates to:
  /// **'Change Currency'**
  String get change_currency;

  /// No description provided for @set_your_primary_spending_currency.
  ///
  /// In en, this message translates to:
  /// **'Set your primary spending currency'**
  String get set_your_primary_spending_currency;

  /// No description provided for @support_info.
  ///
  /// In en, this message translates to:
  /// **'Support & Info'**
  String get support_info;

  /// No description provided for @help_contact.
  ///
  /// In en, this message translates to:
  /// **'Help & Contact'**
  String get help_contact;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @rate_app.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rate_app;

  /// No description provided for @love_the_app_let_us_know_on_the_play_store.
  ///
  /// In en, this message translates to:
  /// **'Love the app? Let us know on the Play Store'**
  String get love_the_app_let_us_know_on_the_play_store;

  /// No description provided for @could_not_open_link.
  ///
  /// In en, this message translates to:
  /// **'Could not open link'**
  String get could_not_open_link;

  /// No description provided for @app_version.
  ///
  /// In en, this message translates to:
  /// **'App Version: {version}'**
  String app_version(String version);

  /// No description provided for @delete_this_spending_plan_permanently.
  ///
  /// In en, this message translates to:
  /// **'Delete this Spending plan permanently?'**
  String get delete_this_spending_plan_permanently;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit_plan.
  ///
  /// In en, this message translates to:
  /// **'Edit Plan'**
  String get edit_plan;

  /// No description provided for @reminder_set.
  ///
  /// In en, this message translates to:
  /// **'Reminder Set'**
  String get reminder_set;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @total_cost.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get total_cost;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @plan_not_found.
  ///
  /// In en, this message translates to:
  /// **'Plan not found'**
  String get plan_not_found;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error(String error);

  /// No description provided for @delete_this_wish_from_your_list.
  ///
  /// In en, this message translates to:
  /// **'Delete this wish from your list?'**
  String get delete_this_wish_from_your_list;

  /// No description provided for @reminder_status.
  ///
  /// In en, this message translates to:
  /// **'Reminder Status'**
  String get reminder_status;

  /// No description provided for @notification_active.
  ///
  /// In en, this message translates to:
  /// **'Notification active'**
  String get notification_active;

  /// No description provided for @wish_created.
  ///
  /// In en, this message translates to:
  /// **'Wish Created'**
  String get wish_created;

  /// No description provided for @estimated_price.
  ///
  /// In en, this message translates to:
  /// **'Estimated Price'**
  String get estimated_price;

  /// No description provided for @wish_not_found.
  ///
  /// In en, this message translates to:
  /// **'Wish not found'**
  String get wish_not_found;

  /// No description provided for @no_spending_plans_yet.
  ///
  /// In en, this message translates to:
  /// **'No Spending plans yet'**
  String get no_spending_plans_yet;

  /// No description provided for @creat_one.
  ///
  /// In en, this message translates to:
  /// **'CREAT ONE'**
  String get creat_one;

  /// No description provided for @added_on_datestr.
  ///
  /// In en, this message translates to:
  /// **'Added on {dateStr}'**
  String added_on_datestr(String dateStr);

  /// No description provided for @welcome_to_spenditize.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Spenditize'**
  String get welcome_to_spenditize;

  /// No description provided for @the_smart_way_to_track_your_spending_and_achieve_your_financial_goals.
  ///
  /// In en, this message translates to:
  /// **'The smart way to track your spending and achieve your financial goals.'**
  String get the_smart_way_to_track_your_spending_and_achieve_your_financial_goals;

  /// No description provided for @quick_spending_lists.
  ///
  /// In en, this message translates to:
  /// **'Quick Spending Lists'**
  String get quick_spending_lists;

  /// No description provided for @create_lists_on_the_fly_while_shopping_to_stay_within_your_budget.
  ///
  /// In en, this message translates to:
  /// **'Create lists on the fly while shopping to stay within your budget.'**
  String get create_lists_on_the_fly_while_shopping_to_stay_within_your_budget;

  /// No description provided for @remember_for_life.
  ///
  /// In en, this message translates to:
  /// **'Remember for Life'**
  String get remember_for_life;

  /// No description provided for @we_will_remind_you_when_to_fulfil_your_purchase.
  ///
  /// In en, this message translates to:
  /// **'We will remind you when to fulfil your purchase'**
  String get we_will_remind_you_when_to_fulfil_your_purchase;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @get_started.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get get_started;

  /// No description provided for @no_wishes_yet.
  ///
  /// In en, this message translates to:
  /// **'No Wishes yet'**
  String get no_wishes_yet;

  /// No description provided for @spending_plan_saved.
  ///
  /// In en, this message translates to:
  /// **'Spending plan saved!'**
  String get spending_plan_saved;

  /// No description provided for @an_error_occurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred!'**
  String get an_error_occurred;

  /// No description provided for @spending_plan_deleted.
  ///
  /// In en, this message translates to:
  /// **'Spending plan deleted!'**
  String get spending_plan_deleted;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @unit_price_currency.
  ///
  /// In en, this message translates to:
  /// **'Unit Price({currency})'**
  String unit_price_currency(String currency);

  /// No description provided for @subtotal_currency.
  ///
  /// In en, this message translates to:
  /// **'Subtotal({currency})'**
  String subtotal_currency(String currency);

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @wish_saved.
  ///
  /// In en, this message translates to:
  /// **'Wish saved!'**
  String get wish_saved;

  /// No description provided for @wish_deleted.
  ///
  /// In en, this message translates to:
  /// **'Wish deleted!'**
  String get wish_deleted;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'fr', 'hi', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'hi': return AppLocalizationsHi();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
