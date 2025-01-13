import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/services/user_service.dart';

import '../models/token.dart';

class DioClient {
  // Private static instance
  static final DioClient _instance = DioClient._internal();

  // Dio instance
  final Dio _dio = Dio();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Private constructor
  DioClient._internal() {
    // Add interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final String? jwt = await storage.read(key: "jwt");
          if(jwt != null)
          {
            final Token token = Token.fromJson(jsonDecode(jwt));
            options.headers['Authorization'] = 'Bearer ${token.accessToken}';
          }

          return handler.next(options); // Continue the request
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            //refresh token
            final String? jwt = await storage.read(key: "jwt");
            if(jwt != null)
            {
              Token token = Token.fromJson(jsonDecode(jwt));
              String url = "https://farmers-api.runasp.net/api/auth/refresh";
              var response = await _dio.post(url, data: jsonEncode(token.refreshToken));
              await storage.write(key: "jwt", value: jsonEncode(response.data["token"]));
            }
            else{
              navigatorKey.currentState!.pushReplacementNamed("/LoginForm");
            }

          }
          return handler.next(error);
        },
      ),
    );
  }

  factory DioClient() {
    return _instance;
  }

  // Getter for Dio instance
  Dio get dio => _dio;
}
