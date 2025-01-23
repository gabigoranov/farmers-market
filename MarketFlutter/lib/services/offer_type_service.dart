import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A service class to manage offer types, their associated icons, colors,
/// and categories for use in the app.
class OfferTypeService {
  /// Factory constructor to enforce the singleton pattern.
  factory OfferTypeService() {
    return instance;
  }

  /// Private internal constructor for singleton implementation.
  OfferTypeService._internal();

  /// Singleton instance of the `OfferTypeService`.
  static final OfferTypeService instance = OfferTypeService._internal();

  // Maps to hold icons, colors, and categories for each offer type.

  /// Map of offer types to their corresponding SVG icons.
  final Map<String, Widget> _icons = {
    "Apples": SvgPicture.asset(
      'assets/icons/apple.svg',
      width: 30,
      height: 30,
      color: Colors.white,
    ),
    "Lemons": SvgPicture.asset(
      'assets/icons/lemon.svg',
      width: 30,
      height: 30,
      color: Colors.white,
    ),
    "Eggs": SvgPicture.asset(
      'assets/icons/eggs.svg',
      width: 30,
      height: 30,
      color: Colors.white,
    ),
    "Bananas": SvgPicture.asset(
      'assets/icons/bananas.svg',
      width: 30,
      height: 30,
      color: Colors.white,
    ),
    "Grapes": SvgPicture.asset(
      'assets/icons/grapes.svg',
      width: 30,
      height: 30,
      color: Colors.white,
    ),
    "Oranges": SvgPicture.asset(
      'assets/icons/oranges.svg',
      width: 30,
      height: 30,
      color: Colors.white,
    ),
    "Carrots": SvgPicture.asset(
      'assets/icons/carrot.svg',
      width: 30,
      height: 30,
      color: Colors.white,
    ),
    "Cucumbers": SvgPicture.asset(
      'assets/icons/cucumber.svg',
      width: 30,
      height: 30,
      color: Colors.white,
    ),
    "Lettuce": SvgPicture.asset(
      'assets/icons/lettuce.svg',
      width: 30,
      height: 30,
      color: Colors.white,
    ),
    "Onions": SvgPicture.asset(
      'assets/icons/onion.svg',
      width: 30,
      height: 30,
      color: Colors.white,
    ),
    "Peppers": SvgPicture.asset(
      'assets/icons/pepper.svg',
      width: 30,
      height: 30,
      color: Colors.white,
    ),
    "Potatoes": SvgPicture.asset(
      'assets/icons/potato.svg',
      width: 30,
      height: 30,
      color: Colors.white,
    ),
    "Strawberries": SvgPicture.asset(
      'assets/icons/strawberry.svg',
      width: 30,
      height: 30,
      color: Colors.white,
    ),
    "Tomatoes": SvgPicture.asset(
      'assets/icons/tomato.svg',
      width: 30,
      height: 30,
      color: Colors.white,
    ),
    "Steak": SvgPicture.asset(
      'assets/icons/steak.svg',
      width: 30,
      height: 30,
      color: Colors.white,
    ),
    "Cheese": SvgPicture.asset(
      'assets/icons/cheese.svg',
      width: 30,
      height: 30,
      color: Colors.white,
    )
  };

  /// Map of offer types to their corresponding colors.
  final Map<String, Color> _colors = {
    "Apples": const Color(0xffF67979),
    "Lemons": const Color(0xffFFE380),
    "Eggs": const Color(0xffF3E1A3),
    "Bananas": const Color(0xffF6EA79),
    "Grapes": const Color(0xff6A4382),
    "Oranges": const Color(0xffFFB763),
    "Cucumbers": const Color(0xff67ab05),
    "Lettuce": const Color(0xff93c560),
    "Onions": const Color(0xff62121b),
    "Peppers": const Color(0xff578c42),
    "Potatoes": const Color(0xffffc284),
    "Strawberries": const Color(0xfffb2943),
    "Carrots": const Color(0xffed9121),
    "Tomatoes": const Color(0xffff6347),
    "Steak": const Color(0xffff7f7f),
    "Cheese": const Color(0xfff7c028),
  };

  /// Map of offer types to their corresponding categories.
  final Map<String, String> _typeToCategory = {
    'Apples': 'Fruits',
    'Lemons': 'Fruits',
    'Eggs': 'Dairy',
    'Bananas': 'Fruits',
    'Grapes': 'Fruits',
    'Oranges': 'Fruits',
    'Cucumbers': 'Vegetables',
    'Lettuce': 'Vegetables',
    'Onions': 'Vegetables',
    'Peppers': 'Vegetables',
    'Potatoes': 'Vegetables',
    'Strawberries': 'Fruits',
    'Carrots': 'Vegetables',
    'Tomatoes': 'Vegetables',
    'Steak': 'Meat',
    'Cheese': 'Dairy',
  };

  /// Retrieves the color associated with a given [key].
  Color getColor(String key) {
    return _colors[key]!;
  }

  /// Retrieves the icon associated with a given [key].
  Widget getIcon(String key) {
    return _icons[key]!;
  }

  /// Retrieves the category for a given offer [type].
  String getCategoryFromType(String type) {
    return _typeToCategory[type]!;
  }

  /// Retrieves a list of all offer type names.
  List<String> getOfferTypeNames() {
    return _typeToCategory.keys.toList();
  }
}
