import '../../common/uuid.dart';
import 'media_model.dart';
import 'parents/model.dart';

class User extends Model {
  String name;
  String email;
  String password;
  Media avatar;
  String apiToken;
  String deviceToken;
  String phone;
  bool verifiedPhone;
  String verificationId;
  String address;
  String bio;

  bool auth;

  String code;

  User({this.name, this.email, this.password,this.code="+966", this.apiToken, this.deviceToken, this.phone, this.verifiedPhone, this.verificationId, this.address, this.bio, this.avatar});

  User.fromJson(Map<String, dynamic> json) {
    name = stringFromJson(json, 'name');
    email = stringFromJson(json, 'email');
    apiToken = stringFromJson(json, 'api_token');
    deviceToken = stringFromJson(json, 'device_token');
    phone = stringFromJson(json, 'phone_number');
    verifiedPhone = boolFromJson(json, 'phone_verified_at');
    avatar = mediaFromJson(json, 'avatar');
    auth = boolFromJson(json, 'auth');
    try {
      address = json['custom_fields']['address']['view'];
    } catch (e) {
      address = stringFromJson(json, 'address');
    }
    try {
      bio = json['custom_fields']['bio']['view'];
    } catch (e) {
      bio = stringFromJson(json, 'bio');
    }
    code= json['phone'].toString().startsWith("+")?json['phone'].toString().substring(1,5):json["code"];

    super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    if (password != null && password != '') {
      data['password'] = this.password;
    }
    data['api_token'] = this.apiToken;
    if (deviceToken != null) {
      data["device_token"] = deviceToken;
    }
    data["phone_number"] = phone;
    if (verifiedPhone != null && verifiedPhone) {
      data["phone_verified_at"] = DateTime.now().toLocal().toString();
    }
    data["address"] = address;
    data["bio"] = bio;
    if (this.avatar != null && Uuid.isUuid(avatar.id)) {
      data['avatar'] = this.avatar.id;
    }
    if (avatar != null) {
      data["media"] = [avatar.toJson()];
    }
    data['auth'] = this.auth;
    return data;
  }

  Map toRestrictMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["thumb"] = avatar.thumb;
    map["device_token"] = deviceToken;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      super == other &&
      other is User &&
      runtimeType == other.runtimeType &&
      name == other.name &&
      email == other.email &&
      password == other.password &&
      avatar == other.avatar &&
      apiToken == other.apiToken &&
      deviceToken == other.deviceToken &&
      phone == other.phone &&
      verifiedPhone == other.verifiedPhone &&
      verificationId == other.verificationId &&
      address == other.address &&
      bio == other.bio &&
      auth == other.auth;

  @override
  int get hashCode =>
      super.hashCode ^
      name.hashCode ^
      email.hashCode ^
      password.hashCode ^
      avatar.hashCode ^
      apiToken.hashCode ^
      deviceToken.hashCode ^
      phone.hashCode ^
      verifiedPhone.hashCode ^
      verificationId.hashCode ^
      address.hashCode ^
      bio.hashCode ^
      auth.hashCode;
}
