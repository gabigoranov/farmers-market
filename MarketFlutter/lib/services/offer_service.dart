import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/models/offer.dart';
import 'package:market/models/review.dart';
import 'package:market/services/user_service.dart';

import '../components/offer_item_component.dart';
import 'dio_service.dart';

// Secure storage instance for persisting sensitive data.
const storage = FlutterSecureStorage();

// Dio client for making HTTP requests.
final dio = DioClient().dio;

/// A service for managing offers, including CRUD operations,
/// fetching offer data, and dynamically creating offer widgets.
final class OfferService {
  // Factory constructor to enforce the singleton pattern.
  factory OfferService() {
    return instance;
  }

  // Private internal constructor for singleton implementation.
  OfferService._internal();

  // Singleton instance of the OfferService.
  static final OfferService instance = OfferService._internal();

  // List to store loaded offers fetched from the API.
  List<Offer> loadedOffers = [];

  // List of widgets dynamically created for offers.
  List<Widget> offerWidgets = [];

  /// Deletes an offer by its [id].
  /// - Sends a DELETE request to the API.
  /// - Refreshes the user data after successful deletion.
  /// - Returns the response data from the API.
  Future<String> delete(int id) async {
    final url = 'https://api.freshly-groceries.com/api/offers/$id';
    Response<dynamic> response = await dio.delete(url);
    UserService.instance.refresh(); // Refresh user data after deletion.
    return response.data; // Return the API response.
  }

  /// Edits an existing offer.
  /// - Sends a PUT request with the updated [offer] data to the API.
  /// - Returns the response data from the API.
  Future<String> edit(Offer offer) async {
    String url = 'https://api.freshly-groceries.com/api/offer/${offer.id}';
    Response<dynamic> response = await dio.put(url, data: jsonEncode(offer));
    return response.data;
  }

  /// Fetches all offers from the API and populates the [loadedOffers] list.
  /// - Sends a GET request to fetch offers data.
  /// - Parses the API response and converts it into a list of [Offer] objects.
  /// - Calls [loadOfferComponents] to update the offer widgets.
  Future<void> getOffersData() async {
    loadedOffers = []; // Clear the existing offers list.
    String url = 'https://api.freshly-groceries.com/api/offers';
    Response<dynamic> response = await dio.get(url);

    // Parse and add offers to the loadedOffers list.
    for (int i = 0; i < response.data.length; i++) {
      loadedOffers.add(Offer.fromJson(response.data[i]));
    }

    // Load widgets for the fetched offers.
    loadOfferComponents();
  }

  /// Generates widgets for the offers in [loadedOffers].
  /// - Creates a list of [OfferItemComponent] for each offer.
  void loadOfferComponents() {
    offerWidgets = []; // Clear the existing offer widgets list.

    // Generate a widget for each loaded offer.
    for (int i = 0; i < OfferService.instance.loadedOffers.length; i++) {
      offerWidgets.add(
        OfferItemComponent(offer: OfferService.instance.loadedOffers[i]),
      );
    }
  }

  /// Fetches reviews for a specific [offer] and updates the offer's review list.
  /// - Sends a GET request to fetch reviews for the given offer.
  /// - Parses the API response and converts it into a list of [Review] objects.
  /// - Updates the reviews for the corresponding offer in [loadedOffers].
  /// - Returns the list of reviews for the offer.
  Future<List<Review>> loadOfferReviews(Offer offer) async {
    String url =
        'https://api.freshly-groceries.com/api/reviews/by-offer/${offer.id}';
    Response<dynamic> response = await dio.get(url);

    List<Review> res = [];

    // Parse and add reviews to the result list if the API response contains data.
    if (response.data.length > 0) {
      for (int i = 0; i < response.data.length; i++) {
        res.add(Review.fromJson(response.data[i]));
      }
    }

    // Find the index of the corresponding offer and update its reviews.
    int index = loadedOffers.indexOf(
      loadedOffers.firstWhere((x) => x.id == offer.id),
    );
    loadedOffers[index].reviews = res;

    return res; // Return the list of reviews.
  }
}
