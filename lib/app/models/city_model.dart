
import 'package:cloud_firestore/cloud_firestore.dart';

class City{
  String id;
  GeoPoint latlong;
  String name;
  num area;
  String address;

  City({this.id, this.latlong, this.name,this.area, this.address});
   factory City.fromJson(Map<String, dynamic> json) => City(
     id: json["id"] == null ? null : json["id"],
     latlong: json["latlong"] == null ? null : json["latlong"],
     name: json["name"] == null ? null : json["name"],
     area: json["area"] == null ? null : json["area"],
     address: json["address"] == null ? null : json["address"],
  );

  get hasData => id!=null;

  Map<String, dynamic> toJson() =>
      {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "area": area == null ? null : area,
        "latlong": latlong == null ? null : latlong,
        "address": address == null ? null : address,
      };
}