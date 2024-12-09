import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  // Private static instance
  static final DioClient _instance = DioClient._internal();

  // Dio instance
  final Dio _dio = Dio();

  // Secure storage instance
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Private constructor
  DioClient._internal() {
    // Add interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Retrieve token from secure storage
          final token = await _storage.read(key: 'jwt_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options); // Continue the request
        },
        onError: (DioError error, handler) async {
          if (error.response?.statusCode == 401) {
            // Handle unauthorized errors (e.g., refresh token or redirect to login)
            // Example: Refresh token logic (if applicable)
          }
          return handler.next(error);
        },
      ),
    );
  }

  // Public factory constructor to return the singleton instance
  factory DioClient() {
    return _instance;
  }

  // Getter for Dio instance
  Dio get dio => _dio;
}
