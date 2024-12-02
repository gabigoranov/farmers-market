import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/models/offer.dart';
import 'package:market/services/user_service.dart';

import '../components/offer_component.dart';

final storage = FlutterSecureStorage();
final dio = Dio();

final class OfferService {
  factory OfferService() {
    return instance;
  }
  OfferService._internal();
  List<Offer> loadedOffers = [];
  List<Widget> offerWidgets = [];
  static final OfferService instance = OfferService._internal();


  Future<String> delete(int id) async{
    final url = 'https://farmers-api.runasp.net/api/Offers/delete?id=$id';
    Response<dynamic> response = await dio.delete(url);
    UserService.instance.reload();
    return response.data;
  }

  Future<String> edit(Offer offer) async{
    const url = 'https://farmers-api.runasp.net/api/edit/';
    Response<dynamic> response = await dio.post(url, data: jsonEncode(offer));
    return response.data;
  }

  Future<void> loadOffers() async{
    loadedOffers = [];
    String url = 'https://farmers-api.runasp.net/api/Offers/getAll';
    Response<dynamic> response = await dio.get(url);
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
