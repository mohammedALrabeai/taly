// To parse this JSON data, do
//
//     final prodItem = prodItemFromJson(jsonString);

import 'dart:convert';

ProdItem prodItemFromJson(String str) => ProdItem.fromJson(json.decode(str));

String prodItemToJson(ProdItem data) => json.encode(data.toJson());

class ProdItem {
  ProdItem({
    this.name,
    this.count,
    this.price,
  });

  String name;
  int count;
  double price;

  ProdItem copyWith({
    String name,
    int count,
    double price,
  }) =>
      ProdItem(
        name: name ?? this.name,
        count: count ?? this.count,
        price: price ?? this.price,
      );

  factory ProdItem.fromJson(Map<String, dynamic> json) => ProdItem(
    name: json["name"] == null ? null : json["name"],
    count: json["count"] == null ? null : json["count"],
    price: json["price"] == null ? null : json["price"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "count": count == null ? null : count,
    "price": price == null ? null : price,
  };
}
