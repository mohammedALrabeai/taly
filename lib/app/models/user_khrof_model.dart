import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class User_Khrof{
 bool active;
 GeoPoint address;
 Timestamp create_at;
 String phone;
 String token;
 String id;

 User_Khrof({this.active=true, this.address, this.create_at, this.phone, this.token, this.id=""});
 factory User_Khrof.fromJson(Map<String, dynamic> json) => User_Khrof(
 active: json["active"] == null ? null : json["active"],
 address: json["address"] == null ? null : json["address"],
 create_at: json["create_at"] == null ? null : json["create_at"],
 phone: json["phone"] == null ? null : json["phone"],
   token: json["token"] == null ? null : json["token"],
 id: json["id"] == null ? null : json["id"],
 );

 Map<String, dynamic> toJson() =>
     {
       "active": active == null ? null : active,
       "address": address == null ? null : address,
       "create_at": create_at == null ? null : create_at,
       "phone": phone == null ? null : phone,
       "token": token == null ? null : token,
       "id": id == null ? null : id,
     };

  getLatLng() {
    return LatLng(address.latitude, address.longitude)         ;
  }

}