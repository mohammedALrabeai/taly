import 'package:get/get.dart';

import '../models/address_model.dart';
import '../models/setting_model.dart';
import '../providers/laravel_provider.dart';

class SettingRepository {
  LaravelApiClient _laravelApiClient;

  SettingRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<Setting> get() {
    return _laravelApiClient.getSettings();
  }
  get2() {
// Color(0xff000000);
    return Setting.fromJson({
      "app_name": "ذبيحة",
      "app_short_description": " Mobile Application",
      "enable_stripe": "1",
      "default_tax": "10",
      "default_currency": "ريال سعودي",
      "fcm_key":"AAAA4h5Dexk:APA91bEzUNHCmnEZmPUwemVpL1Ynpm41cjBJ1EkS8UJHvDl2hQHA0NQTldmLJI6a_NMQaOSEFakRjxvqG0epa8TLL9hMznVqL-vg1QTYQiQFiKgJ5wayctMuFJx_Lld0FOOkqIlwqin-",
      "enable_paypal": "1",
      // "main_color": "#F4841F",
      "main_color": "#FF000000",
      "main_dark_color": "#F4841F",
      "second_color": "#FF000000",
      "second_dark_color": "#CCCCDD",
      // "accent_color": "#6E3102",
      "accent_color": "#000000FF",
      "accent_dark_color": "#9999AA",
      "scaffold_dark_color": "#2C2C2C",
      "scaffold_color": "#FAFAFA",
      // "google_maps_key": "AIzaSyCyXcDd3oPMJQZAqw0FkXtsDhKY_oCaPXk",
      "google_maps_key": "AIzaSyAN0IC7Zww2bmBNDdx8Iuapgjb0gPvBf3Y",
      // "google_maps_key": "AIzaSyA-tFd1yUoNbc8n64Mpd0ISTHB4cm9O5_Q",
      "mobile_language": "ar",
      "app_version": "1.0.0",
      "enable_version": "1",
      "default_currency_decimal_digits": "0",
      "currency_right": "1",
      "distance_unit": "km",
      "default_theme": "light",
      "default_country_code": "DE",
      "app_logo":"https://home-services.smartersvision.com/images/logo_default.png"
    });
  }

  Future<List<Address>> getAddresses() {
    return _laravelApiClient.getAddresses();
  }
}
