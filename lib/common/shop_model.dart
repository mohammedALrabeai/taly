// To parse this JSON data, do
//
//     final shop = shopFromJson(jsonString);

import 'dart:convert';

import '../app/models/media_model.dart';

Shop shopFromJson(String str) => Shop.fromJson(json.decode(str));

String shopToJson(Shop data) => json.encode(data.toJson());

class Shop {
  Media image;

  String img;

  String id;

  Shop({
    this.sellerName,
    this.vaTnumber,
    this.storeName,
    this.storeCity,
    this.storeAddress,
    this.logo,
    this.storePhone,
    this.tax=0,
  });

  String sellerName;
  String logo;
  String vaTnumber;
  String storeName;
  String storeCity;
  String storeAddress;
  String storePhone;
  num tax;

  Shop copyWith({
    String sellerName,
    String vaTnumber,
    String storeName,
    String storeCity,
    String storeAddress,
    String storePhone,
    String tax,
  }) =>
      Shop(
        sellerName: sellerName ?? this.sellerName,
        vaTnumber: vaTnumber ?? this.vaTnumber,
        storeName: storeName ?? this.storeName,
        storeCity: storeCity ?? this.storeCity,
        storeAddress: storeAddress ?? this.storeAddress,
        storePhone: storePhone ?? this.storePhone,
        tax: tax ?? this.tax,
      );

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
    sellerName: json["sellerName"] == null ? null : json["sellerName"],
    vaTnumber: json["VATnumber"] == null ? null : json["VATnumber"],
    storeName: json["storeName"] == null ? null : json["storeName"],
    logo: json["logo"] == null ? null : json["logo"],
    storeCity: json["storeCity"] == null ? null : json["storeCity"],
    storeAddress: json["storeAddress"] == null ? null : json["storeAddress"],
    storePhone: json["storePhone"] == null ? null : json["storePhone"],
    tax: json["tax"] == null ? null : json["tax"],
  );

  Map<String, dynamic> toJson() => {
    "sellerName": sellerName == null ? null : sellerName,
    "VATnumber": vaTnumber == null ? null : vaTnumber,
    "storeName": storeName == null ? null : storeName,
    "logo": logo == null ? null : logo,
    "storeCity": storeCity == null ? null : storeCity,
    "storeAddress": storeAddress == null ? null : storeAddress,
    "storePhone": storePhone == null ? null : storePhone,
    "tax": tax == null ? null : tax,
  };
}
