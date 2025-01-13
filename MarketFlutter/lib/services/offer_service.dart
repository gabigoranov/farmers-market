import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/models/offer.dart';
import 'package:market/services/user_service.dart';

import '../components/offer_component.dart';
import 'dio_service.dart';

const storage = FlutterSecureStorage();
final dio = DioClient().dio;

final class OfferService {
  factory OfferService() {
    return instance;
  }
  OfferService._internal();
  List<Offer> loadedOffers = [];
  List<Widget> offerWidgets = [];
  static final OfferService instance = OfferService._internal();


  Future<String> delete(int id) async{
    final url = 'https://farmers-api.runasp.net/api/offers/$id';
    Response<dynamic> response = await dio.delete(url);
    UserService.instance.reload();
    return response.data;
  }

  Future<String> edit(Offer offer) async{
    String url = 'https://farmers-api.runasp.net/api/offer/${offer.id}';
    Response<dynamic> response = await dio.put(url, data: jsonEncode(offer));
    return response.data;
  }

  Future<void> loadOffers() async{
    loadedOffers = [];
    String url = 'https://farmers-api.runasp.net/api/offers';
    Response<dynamic> response = await dio.get(url, options: Options(
      headers: {
        'Authorization': 'Bearer ${await UserService.instance.getToken()}',
      },
    ),);
    for(int i = 0; i < response.data.length; i++){
      loadedOffers.add(Offer.fromJson(response.data[i]));
    }
    getData();
  }

  void getData() {
    offerWidgets = [];
    for(int i = 0; i < OfferService.instance.loadedOffers.length; i++){
      offerWidgets.add(OfferComponent(offer: OfferService.instance.loadedOffers[i]));
    }
  }
}
