import 'dart:convert';

import 'package:market/models/offer.dart';
import 'package:market/models/offer_type.dart';


class Order{
  int id;
  double quantity;
  double price;
  String? address;
  int offerId;
  String buyerId;
  String sellerId;
  String status;
  DateTime? dateOrdered;
  DateTime? dateDelivered;
  String title;
  int? billingDetailsId;
  int offerTypeId;
  OfferType? offerType;
  Offer? offer;

  Order({ this.id=0,  this.quantity=0, this.price=0,
     this.address, required this.offerId,
    required this.buyerId, required this.sellerId, required this.offerTypeId, this.dateOrdered, this.title = "none", required this.status, this.dateDelivered,this.billingDetailsId, this.offer, this.offerType});

  factory Order.fromJson(Map<String, dynamic> json) {
    print("Parsing order");

    print(json);
    print("price");
    print(double.parse(json['price'].toString()));

    Order res = Order(
      id: json['id'] as int,
      quantity: json['quantity']+.0 as double,
      price: json['price']+.0 as double,
      address: json['address'] as String,
      offerId: json['offerId'] as int,
      buyerId: json['buyerId'] as String,
      offer: json['offer'] != null ? Offer.fromJson(json['offer']) : null,
      billingDetailsId: json['billingDetailsId'] as int?,
      status: json['status'] as String,
      sellerId: json['sellerId'] as String,
      dateOrdered: DateTime.parse(json['dateOrdered']),
      dateDelivered: json['dateDelivered'] != null ? DateTime.parse(json['dateDelivered']) : null,
      title: json['title'] as String,
      offerTypeId: json['offerType']['id'] as int,
      offerType: OfferType.fromJson(json['offerType']),
    );

    print("DONE");

    return res;
  }

  factory Order.fromStorageJson(Map<String, dynamic> json) {
    print(json);
    Order res = Order(
      id: json['id'] as int,
      quantity: json['quantity']+.0 as double,
      price: json['price']+.0 as double,
      offerId: json['offerId'] as int,
      buyerId: json['buyerId'] as String,
      sellerId: json['sellerId'] as String,
      title: json['title'] as String,
      offer: Offer.fromJson(json['offer']),
      offerTypeId: json['offerType']['id'] as int,
      offerType: OfferType.fromJson(json['offerType']),
      status: json['status'] as String,
    );
    print("done");
    return res;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'price': price,
      'address': address,
      'offerId': offerId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'title': title,
      'offer': offer?.toJson(),
      'offerType': offerType?.toJson(),
      'offerTypeId': offerTypeId,
      'status': status,
      //'offerType': offerType,
    };
  }
}