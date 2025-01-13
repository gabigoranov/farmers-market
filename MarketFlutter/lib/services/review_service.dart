import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:market/models/review.dart';
import 'package:market/services/user_service.dart';

import 'dio_service.dart';

final dio = DioClient().dio;


final class ReviewService {
  factory ReviewService() {
    return instance;
  }
  ReviewService._internal();
  static final ReviewService instance = ReviewService._internal();


  Future<String> publish(Review model) async{
    const url = 'https://farmers-api.runasp.net/api/reviews';
    Response<dynamic> response = await dio.post(url, data: jsonEncode(model));
    UserService.instance.reload();
    return response.data;
  }

}
