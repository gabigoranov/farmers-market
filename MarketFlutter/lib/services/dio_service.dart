import 'dart:convert';

import'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market/services/user_service.dart';

import '../models/token.dart';

/// A wrapper class for the Dio HTTP client, providing authentication and error handling.
class DioClient {
  /// Singleton instance of the DioClient.
  static final DioClient _instance = DioClient._internal();

  /// Factory constructor to access the singleton instance.
  factory DioClient() {
    return _instance;
  }

  /// The underlying Dio instance.
  final Dio _dio = Dio();

  /// Navigator key for navigating to the login screen on authentication errors.
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Private constructor to initialize Dio and add interceptors.
  DioClient._internal() {
    // Add an interceptor to handle authentication and error handling.
    _dio.interceptors.add(
      InterceptorsWrapper(
        // Intercept requests to add the Authorization header if a JWT token is present.
        onRequest: (options, handler) async {
          final String? jwt = await storage.read(key: "jwt");

          if (jwt != null) {
            final Token token = Token.fromJson(jsonDecode(jwt));
            options.headers['Authorization'] = 'Bearer ${token.accessToken}';
          }

          return handler.next(options); // Continue the request
        },
        // Intercept errors to handle 401 Unauthorized errors by refreshing the token or navigating to the login screen.
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            // Refresh token if possible.
            final String? jwt = await storage.read(key: "jwt");
            if (jwt != null) {
              Token token = Token.fromJson(jsonDecode(jwt));
              String url = "https://api.freshly-groceries.com/api/auth/refresh";
              var response =
              await _dio.post(url, data: jsonEncode(token.refreshToken));
              await storage.write(
                  key: "jwt", value: jsonEncode(response.data["token"]));
            } else {
              // Navigate to the login screen if token refresh fails or no token is present.
              navigatorKey.currentState!.pushReplacementNamed("/LoginForm");
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  /// Getter for the Dio instance.
  Dio get dio => _dio;
}