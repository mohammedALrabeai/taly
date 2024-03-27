
import 'package:cloud_firestore/cloud_firestore.dart';

class Kitchen{
  String id;
  GeoPoint latlong;
  String name;
  String description;
  String address;
  Kitchen({this.id, this.latlong, this.name,this.description, this.address});
  factory Kitchen.fromJson(Map<String, dynamic> json) => Kitchen(
    id: json["id"] == null ? null : json["id"],
    latlong: json["latlong"] == null ? null : json["latlong"],
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    address: json["address"] == null ? null : json["address"],
  );

  get hasData => id!=null;

  Map<String, dynamic> toJson() =>
      {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "latlong": latlong == null ? null : latlong,
        "address": address == null ? null : address,
      };
}