import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../models/booking_model.dart';
import '../../../models/category_model.dart';
import '../../../models/city_model.dart';
import '../../../models/coupon_model.dart';
import '../../../models/kitchen.dart';
import '../../../models/my_order_model.dart';
import '../../../models/products_model.dart';
import '../../../providers/helper_provider.dart';
import '../../../services/auth_service.dart';
import '../../../services/geolocator.dart';
import '../../../services/settings_service.dart';
import 'package:geolocator/geolocator.dart';

class ProductDetailController extends GetxController {
  final sizeoptionlist = <SizeObtion>[].obs;
  Position get myLocation => Get.find<SettingsService>().myLocation;
  RxList<City> get cities => Get.find<SettingsService>().cities;
  RxList<Kitchen> get kitchens => Get.find<SettingsService>().kitchens;
  final hasSizeList = false.obs;

  final cutoptionlist = <CutObtion>[].obs;
  final hasCutList = false.obs;
  final select = "1".obs;
  final selectCut = "1".obs;
  var isLoading = true.obs;
  var products = <Product>[].obs;
  var parts = <Parts>[].obs;
  List<String> cuts = [];
  RxInt quantity = 1.obs;
  var radval = 2.obs;
  var selectPart = Parts().obs;
  var productDetails = Product().obs;
  final booking = Booking().obs;
  var currentSizeId = SizeObtion().obs;

  var currentCutId = CutObtion().obs;
  @override
  void onInit() async {
    super.onInit();
    productDetails.value = Get.arguments as Product;
    setPrts(productDetails.value);
    this.booking.value = Booking(
      bookingAt: DateTime.now(),
      // address: currentAddress,
      // eService: _eService,
      // eProvider: _eService.eProvider,
      // taxes: _eService.eProvider.taxes,
      // options: _options,
      duration: 1,
      quantity: quantity.value,
      user: Get.find<AuthService>().user.value,
      coupon: new Coupon(),
    );
    if (myLocation == null) Get.find<SettingsService>().getCurrent();
  }

  DataBase db = DataBase();
  saveOrder2(MyOrder category) async {
    MyOrder res = await db.searchItem(category);
    if (res.id != null) {
      res.much =
          (int.tryParse(res.much) + int.tryParse(category.much)).toString();
      await db.updateMyOrder(res);
    } else {
      await db.saveMyOrder(category);
    }
    // await getThisOrder("1",false);
  }

  void setPrts(Product category) {
    // selectProduct.value=category;
    if (category.parts != null && category.parts.isNotEmpty) {
      selectPart.value = productDetails.value.parts?.first ?? Parts();
      selectCut.value =
          productDetails.value.cuts == null || productDetails.value.cuts.isEmpty
              ? "0"
              : productDetails.value.cuts?.first ?? "";
    } else {
      selectPart.value = Parts();
      selectCut.value = null;
    }
  }

  void incrementQuantity2() {
    quantity.value < 1000 ? quantity.value++ : null;
    this.booking.value.quantity = quantity.value;
  }

  void decrementQuantity2() {
    quantity.value > 1 ? quantity.value-- : null;
    this.booking.value.quantity = quantity.value;
  }

  MyLocation2 location2 = MyLocation2();
  num getprice(Parts value) {
    log(selectPart.value.toJson().toString() +
        " :: " +
        cities.length.toString());
    num res = selectPart.value.price;
    if (myLocation != null) {
      var locs = cities.where((p0) {
        var dest = location2.distanceBetween(myLocation.latitude,
            myLocation.longitude, p0.latlong.latitude, p0.latlong.longitude);
        log("d:" + dest.toString());
        return dest <= p0.area;
      }).toList();
      log("lllll= " + locs.length.toString());
      if (locs != null && locs.isNotEmpty) if (selectPart.value.c_price !=
              null &&
          selectPart.value.c_price.isNotEmpty) {
        selectPart.value.c_price.forEach((element) {
          var c = locs.firstWhereOrNull(
              (l) => l.id == element.place_id && element.price != null);
          if (c != null) {
            res = element.price;
          }
        });
      }
    } else {
      res = selectPart.value.price;
    }
    return res * quantity.value;
  }
}
