import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bg.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
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
    Locale('bg'),
    Locale('en')
  ];

  /// The current Language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// Text used in the search bar
  ///
  /// In en, this message translates to:
  /// **'Search something here'**
  String get search;

  /// Text used in a discover category
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get vegetables;

  /// Text used in a discover category
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get fruits;

  /// Text used in a discover category
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get dairy;

  /// Text used in a discover category
  ///
  /// In en, this message translates to:
  /// **'Meat'**
  String get meat;

  /// Text used the recent orders space
  ///
  /// In en, this message translates to:
  /// **'Recent Orders:'**
  String get recent_orders;

  /// Text used for the order history page title
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get order_history;

  /// Text used in profile details
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// Text used in dropdown menu
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Text used in dropdown menu
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get change_lang;

  /// Text used edit profile button
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// Text used in onboarding
  ///
  /// In en, this message translates to:
  /// **'Order fresh groceries'**
  String get onboarding_1_title;

  /// Text used in onboarding
  ///
  /// In en, this message translates to:
  /// **'Support your community!'**
  String get onboarding_2_title;

  /// Text used in onboarding
  ///
  /// In en, this message translates to:
  /// **'Are you a farmer?'**
  String get onboarding_3_title;

  /// Text used in onboarding description
  ///
  /// In en, this message translates to:
  /// **'Easily order from anywhere'**
  String get onboarding_1_description;

  /// Text used in onboarding description
  ///
  /// In en, this message translates to:
  /// **'Order groceries from your local farmers, butchers and other sellers to support your community.'**
  String get onboarding_2_description;

  /// Text used in onboarding description
  ///
  /// In en, this message translates to:
  /// **'Sign up on our website, take advantage of our tools for sellers and start selling your produce today!'**
  String get onboarding_3_description;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Email form text
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password form text
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Discover navigation text
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// Home navigation text
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// History navigation text
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Profile navigation text
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Publish button text
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// Review form text
  ///
  /// In en, this message translates to:
  /// **'Write your review'**
  String get review_cta;

  /// Order Now form text
  ///
  /// In en, this message translates to:
  /// **'Order Now'**
  String get order_now;

  /// Landing title text
  ///
  /// In en, this message translates to:
  /// **'Farmers Market'**
  String get landing_title;

  /// Landing description text
  ///
  /// In en, this message translates to:
  /// **'Order with ease, speed and comfort!'**
  String get landing_description;

  /// Login page error message text.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email.'**
  String get enter_valid_email;

  /// Login page error message text.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password.'**
  String get enter_password;

  /// Login page error message text.
  ///
  /// In en, this message translates to:
  /// **'You cannot log in with a seller account.'**
  String get cannot_login_with_seller;

  /// Login page error message text.
  ///
  /// In en, this message translates to:
  /// **'User not found. Please check your email and password.'**
  String get user_not_found;

  /// Login page text for visiting website.
  ///
  /// In en, this message translates to:
  /// **'Visit our website'**
  String get visit_website;

  /// Login page text for creating an account link.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get create_account;

  /// Offer view text for viewing info about the seller.
  ///
  /// In en, this message translates to:
  /// **'View seller\'s info'**
  String get seller_info;

  /// Error loading data message text.
  ///
  /// In en, this message translates to:
  /// **'An error has occurred while loading the data. Please try again later.'**
  String get error_loading_data;

  /// Seller info text.
  ///
  /// In en, this message translates to:
  /// **'All offers:'**
  String get seller_offers;

  /// Chats view app bar text.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get chats;

  /// Title for the shopping list view app bar.
  ///
  /// In en, this message translates to:
  /// **'Shopping List'**
  String get shopping_list;

  /// Title for the shopping list add view app bar.
  ///
  /// In en, this message translates to:
  /// **'Add Products'**
  String get shopping_list_add;

  /// Add button text.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Edit shopping list item form field text.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// Edit shopping list item form field label for the title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// Edit shopping list item form field label for the quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// Button text to save changes in the edit shopping list item form.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Button or label text to edit a shopping list item.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Validation error message for required fields.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// Validation error message for invalid quantity values.
  ///
  /// In en, this message translates to:
  /// **'Invalid quantity'**
  String get invalid_quantity;

  /// Validation error message when the title field is empty.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get title_required;

  /// Validation error message when the title field is already used.
  ///
  /// In en, this message translates to:
  /// **'Title is already used'**
  String get title_used;

  /// Text for shopping list button
  ///
  /// In en, this message translates to:
  /// **'Create a custom item'**
  String get custom_item;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['bg', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bg': return AppLocalizationsBg();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
