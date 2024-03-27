

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../models/booking_model.dart';
import '../../../models/category_model.dart';
import '../../../models/coupon_model.dart';
import '../../../models/products_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import 'package:geolocator/geolocator.dart';

class ProductsController extends GetxController {
  final sizeoptionlist = <SizeObtion>[].obs;

  final hasSizeList = false.obs;

  final cutoptionlist = <CutObtion>[].obs;
  final hasCutList = false.obs;
  final select = "1".obs;
  final selectCut = "1".obs;
  var isLoading = true.obs;
  var isLoading2 = true.obs;
  var products = <Product>[].obs;
  var parts = <Parts>[].obs;

  List<String> cuts = [];
  var selectPart = Parts().obs;

  var selectProduct = Product().obs;
   final  user=Get.find<AuthService>().user;

  final currentSlide2 = 0.obs;
  final eAdvItem = <String>[].obs;
Position get myLocation => Get.find<SettingsService>().myLocation;
  var currentSizeId = SizeObtion().obs;

  var currentCutId = CutObtion().obs;
  @override
  void onInit() async {
    super.onInit();

    getDiary();
    getAdv();
    if(myLocation==null)
      Get.find<SettingsService>().getCurrent();
  }

  getAdv() {
    eAdvItem.clear();
    isLoading2.value = true;
    log("fitching");
    FirebaseFirestore.instance
        .collection('adv')
    // .where('created_by', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      log("advs length : "+value.docs.length.toString());
      int uu=0;
      eAdvItem.value = value.docs.map((e) {
        log("${uu++}"+"\n");
        log(e.data().toString());
        Map<String,dynamic> data=e.data() as Map<String,dynamic>;
        String r = data['url'];
        return r;
      }).toList();
      isLoading2.value = false;
      eAdvItem.refresh();


      // notifyListeners();
      return;
    }).catchError((e) {
      log("kk253:"+e.toString());
    });
  }
  getDiary() {
    products.clear();
    isLoading.value = true;
    log("fitching");
    FirebaseFirestore.instance
        .collection('product')
    .where("enabled",isEqualTo: true)
    // .where('created_by', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
          log("products length : "+value.docs.length.toString());
          int uu=0;
      products.value = value.docs.map((e) {
        log("${uu++}"+"\n");
        log(e.data().toString());
        var r = Product.fromJson(e.data());
        r.id = e.id;
        return r;
      }).toList();
          isLoading.value = false;
      selectProduct.value=products.first;
      selectPart.value=selectProduct.value.parts?.first??Parts();
      selectCut.value=selectProduct.value.cuts?.first??null;
      products.refresh();


      // notifyListeners();
      return;
    }).catchError((e) {
      log("kk25:"+e.toString());
    });
  }




}