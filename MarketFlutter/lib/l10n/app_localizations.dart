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
  /// **'Freshly Groceries'**
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

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @in_progress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get in_progress;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @purchase_id.
  ///
  /// In en, this message translates to:
  /// **'Purchase ID:'**
  String get purchase_id;

  /// No description provided for @view_details_billing_details.
  ///
  /// In en, this message translates to:
  /// **'View details about the billing details, address and contact information specified for this purchase'**
  String get view_details_billing_details;

  /// No description provided for @purchase_details.
  ///
  /// In en, this message translates to:
  /// **'Purchase Details'**
  String get purchase_details;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @hide_details.
  ///
  /// In en, this message translates to:
  /// **'Hide Details'**
  String get hide_details;

  /// No description provided for @show_details.
  ///
  /// In en, this message translates to:
  /// **'Show Details'**
  String get show_details;

  /// No description provided for @delivery_address.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get delivery_address;

  /// No description provided for @no_address_provided.
  ///
  /// In en, this message translates to:
  /// **'No Address Provided'**
  String get no_address_provided;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @delivered_items.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered_items;

  /// No description provided for @cart_app_bar.
  ///
  /// In en, this message translates to:
  /// **'Items in your cart'**
  String get cart_app_bar;

  /// No description provided for @purchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchase;

  /// No description provided for @select_or_create_billing_details.
  ///
  /// In en, this message translates to:
  /// **'Select or Create Billing Details'**
  String get select_or_create_billing_details;

  /// No description provided for @select_billing_details.
  ///
  /// In en, this message translates to:
  /// **'Select Billing Details'**
  String get select_billing_details;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @postal_code.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get postal_code;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @create_billing_details.
  ///
  /// In en, this message translates to:
  /// **'Create Billing Details'**
  String get create_billing_details;

  /// No description provided for @delete_billing_details.
  ///
  /// In en, this message translates to:
  /// **'Delete Billing Details'**
  String get delete_billing_details;

  /// No description provided for @update_billing_details.
  ///
  /// In en, this message translates to:
  /// **'Update Billing Details'**
  String get update_billing_details;

  /// No description provided for @finalize_purchase.
  ///
  /// In en, this message translates to:
  /// **'Finalize Purchase'**
  String get finalize_purchase;

  /// No description provided for @select_your_billing_details.
  ///
  /// In en, this message translates to:
  /// **'Select your billing details.'**
  String get select_your_billing_details;

  /// No description provided for @please_enter.
  ///
  /// In en, this message translates to:
  /// **'Please enter {field}'**
  String please_enter(Object field);

  /// No description provided for @billing_details_created.
  ///
  /// In en, this message translates to:
  /// **'Billing details created successfully!'**
  String get billing_details_created;

  /// No description provided for @billing_details_updated.
  ///
  /// In en, this message translates to:
  /// **'Billing details updated successfully!'**
  String get billing_details_updated;

  /// No description provided for @billing_details_deleted.
  ///
  /// In en, this message translates to:
  /// **'Billing details deleted successfully!'**
  String get billing_details_deleted;

  /// No description provided for @accept_terms_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Privacy Policy and Terms of Service'**
  String get accept_terms_privacy_policy;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @agree_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Privacy Policy'**
  String get agree_privacy_policy;

  /// No description provided for @terms_of_service.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get terms_of_service;

  /// No description provided for @agree_terms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms of Service'**
  String get agree_terms;

  /// No description provided for @in_stock.
  ///
  /// In en, this message translates to:
  /// **'KG In Stock'**
  String get in_stock;

  /// No description provided for @shopping_list_add.
  ///
  /// In en, this message translates to:
  /// **'Add to Shopping List'**
  String get shopping_list_add;

  /// No description provided for @custom_item.
  ///
  /// In en, this message translates to:
  /// **'Custom Item'**
  String get custom_item;

  /// No description provided for @add_item.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get add_item;

  /// No description provided for @suggested_items.
  ///
  /// In en, this message translates to:
  /// **'Suggested Items'**
  String get suggested_items;

  /// No description provided for @no_items_available.
  ///
  /// In en, this message translates to:
  /// **'No suggested items available'**
  String get no_items_available;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @upload_profile_picture.
  ///
  /// In en, this message translates to:
  /// **'Upload Profile Picture'**
  String get upload_profile_picture;

  /// No description provided for @no_image_selected.
  ///
  /// In en, this message translates to:
  /// **'No image selected, default will be used.'**
  String get no_image_selected;

  /// No description provided for @first_name.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get first_name;

  /// No description provided for @last_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get last_name;

  /// No description provided for @enter_valid_name.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid name!'**
  String get enter_valid_name;

  /// No description provided for @max_length_12.
  ///
  /// In en, this message translates to:
  /// **'Max length is 12'**
  String get max_length_12;

  /// No description provided for @max_length_250.
  ///
  /// In en, this message translates to:
  /// **'Max length is 250'**
  String get max_length_250;

  /// No description provided for @birth_date.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birth_date;

  /// No description provided for @enter_valid_birth_date.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid birth date!'**
  String get enter_valid_birth_date;

  /// No description provided for @must_be_18.
  ///
  /// In en, this message translates to:
  /// **'Must be at least 18 years old!'**
  String get must_be_18;

  /// No description provided for @enter_valid_phone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number!'**
  String get enter_valid_phone;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @enter_valid_description.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid description!'**
  String get enter_valid_description;

  /// No description provided for @town.
  ///
  /// In en, this message translates to:
  /// **'Town'**
  String get town;

  /// No description provided for @enter_valid_town.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid town!'**
  String get enter_valid_town;

  /// No description provided for @enter_valid_password.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid password!'**
  String get enter_valid_password;

  /// No description provided for @password_min_length.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters!'**
  String get password_min_length;

  /// No description provided for @empty_cart.
  ///
  /// In en, this message translates to:
  /// **'No items in cart'**
  String get empty_cart;

  /// No description provided for @denied.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get denied;
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
