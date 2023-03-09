import 'package:cloud_firestore/cloud_firestore.dart';

import 'parents/model.dart';

class FB_Order {
  DateTime created_at;
  Timestamp created_at1;
  DateTime delevery_time;
  String description;
  String id;
  String phone;
  String token;
  Location location;
  List<OItem> items=[];
  int state;
  int total;


  FB_Order(
      {this.created_at,
      this.delevery_time,
      this.description,
      this.phone,
      this.token,
      this.location,
      this.items,
      this.total,
      this.state});

  factory FB_Order.fromJson(Map<String, dynamic> json) => FB_Order(
    created_at: json["created_at"] == null ? null : json["created_at"].toDate(),
    delevery_time: json["delevery_time"] == null ? null : json["delevery_time"].toDate(),
    description: json["description"] == null ? null : json["description"],
    phone: json["phone"] == null ? true : json["phone"],
    token: json["token"] == null ? true : json["token"],
    state: json["state"] == null ? true : json["state"],
    total: json["total"] == null ? true : json["total"],
    location: json["location"] == null ? true : Location.fromJson(json['location']),
    items: json["items"] == null
        ? []
        : List<OItem>.from(json["items"].map((x) => OItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "created_at": created_at == null ? null : created_at,
    "delevery_time": delevery_time == null ? null : delevery_time,
    "description": description == null ? null : description,
    "phone": phone == null ? null : phone,
    "state": state == null ? null : state,
    "total": total == null ? null : total,
    "location": location == null ? null : location.toJson(),
    "items": items == null
        ? null
        : List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class OItem {
  String name_item;
  String part;
  bool extra;
  int price;
  int num;


  OItem({this.name_item, this.part, this.extra, this.price, this.num});

  factory OItem.fromJson(Map<String, dynamic> json) => OItem(
    name_item: json["name_item"] == null ? null : json["name_item"],
    part: json["part"] == null ? null : json["part"],
    extra: json["extra"] == null ? null : json["extra"],
    price: json["price"] == null ? null : json["price"],
    num: json["num"] == null ? null : json["num"],
  );

  Map<String, dynamic> toJson() => {
    "name_item": name_item == null ? null : name_item,
    "extra": extra == null ? null : extra,
    "part": part == null ? null : part,
    "price": price == null ? null : price,
    "num": num == null ? null : num,
  };
}
class Location {
  String address;
  GeoPoint lat_lng;

  Location({this.address,
    this.lat_lng}); // new GeoPoint(longitude: 3.4, latitude: 4.5) })

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    address: json["address"] == null ? null : json["address"],
    lat_lng: json["lat_lng"] == null ? null : json["lat_lng"],
  );

  Map<String, dynamic> toJson() => {
    "address": address == null ? null : address,
    "lat_lng": lat_lng == null ? null : lat_lng,
  };
}
