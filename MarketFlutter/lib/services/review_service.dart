import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:market/models/review.dart';
import 'package:market/services/user_service.dart';

import 'dio_service.dart';

/// Singleton instance of Dio for HTTP requests.
final dio = DioClient().dio;

/// A service class for handling reviews in the application.
final class ReviewService {
  /// Factory constructor to enforce singleton pattern.
  factory ReviewService() {
    return instance;
  }

  /// Private internal constructor for singleton implementation.
  ReviewService._internal();

  /// Singleton instance of `ReviewService`.
  static final ReviewService instance = ReviewService._internal();

  /// Publishes a new review by sending it to the API.
  ///
  /// - [model]: The `Review` object containing the review details.
  /// - Returns: A `String` response from the API.
  Future<String> publish(Review model) async {
    const url = 'https://api.freshly-groceries.com/api/reviews';

    // Send a POST request with the review data.
    Response<dynamic> response = await dio.post(url, data: jsonEncode(model));

    // Refresh the user data to update the review list.
    UserService.instance.refresh();

    // Return the response data from the API.
    return response.data;
  }
}
