import 'media_model.dart';
import 'parents/model.dart';

class Product {
  String id;
  bool enabled = true;
  String name;
  String img;
  String sub_name;
  List<Parts> parts = <Parts>[];
  List<String> cuts = [];

  Media image = Media();

  Product(
      {this.cuts,
      this.enabled,
      this.name,
      this.img,
      this.sub_name,
      this.parts});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json["name"] == null ? null : json["name"],
        img: json["img"] == null ? null : json["img"],
        sub_name: json["sub_name"] == null ? null : json["sub_name"],
        enabled: json["enabled"] == null ? true : json["enabled"],
        cuts: json["cuts"] == null
            ? []
            : List<String>.from(json["cuts"].map((x) => x)),
        parts: json["parts"] == null
            ? []
            : List<Parts>.from(json["parts"].map((x) => Parts.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "sub_name": sub_name == null ? null : sub_name,
        "img": img == null ? null : img,
        "enabled": enabled == null ? true : enabled,
        "cuts": cuts == null ? null : cuts,
        "parts": parts == null
            ? null
            : List<dynamic>.from(parts.map((x) => x.toJson())),
      };
  @override
  bool operator ==(dynamic other) {
    return other.id == this.id &&
        other.name == this.name &&
        other.sub_name == this.sub_name;
  }

  @override
  int get hashCode =>
      this.id.hashCode ^ this.name.hashCode ^ this.sub_name.hashCode;
}

class Parts {
  String name_part;
  bool enabled = true;
  int price;
  List<CustomPrice> c_price = <CustomPrice>[];

  Parts({this.name_part, this.enabled = true, this.price, this.c_price});
  factory Parts.fromJson(Map<String, dynamic> json) => Parts(
        name_part: json["name_part"] == null ? null : json["name_part"],
        enabled: json["enabled"] == null ? null : json["enabled"],
        price: json["price"] == null ? null : json["price"],
    c_price: json["c_price"] == null
        ? []
        : List<CustomPrice>.from(
        json["c_price"].map((x) => CustomPrice.fromJson(x))),
  );

  bool get hasData => name_part != null && price != null && enabled != false;

  Map<String, dynamic> toJson() => {
        "name_part": name_part == null ? null : name_part,
        "enabled": enabled == null ? true : enabled,
        "price": price == null ? null : price,
    "c_price": c_price == null
        ? null
        : List<dynamic>.from(c_price.map((x) => x.toJson())),
      };
  @override
  bool operator ==(dynamic other) {
    return other.name_part == this.name_part && other.price == this.price;
  }

  @override
  int get hashCode => this.name_part.hashCode ^ this.price.hashCode;
}

class CustomPrice {
  String place_id;
  bool enabled = true;
  int price;

  CustomPrice({this.place_id, this.enabled = true, this.price});
  factory CustomPrice.fromJson(Map<String, dynamic> json) => CustomPrice(
    place_id: json["place_id"] == null ? null : json["place_id"],
    enabled: json["enabled"] == null ? null : json["enabled"],
    price: json["price"] == null ? null : json["price"],
  );

  Map<String, dynamic> toJson() => {
    "place_id": place_id == null ? null : place_id,
    "enabled": enabled == null ? true : enabled,
    "price": price == null ? null : price,
  };
}