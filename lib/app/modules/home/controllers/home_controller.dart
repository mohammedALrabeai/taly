import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:home_services/app/models/media_model.dart';

import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../models/category_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/products_model.dart';
import '../../../models/slide_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../repositories/slider_repository.dart';
import '../../../services/settings_service.dart';
import '../../root/controllers/root_controller.dart';

class HomeController extends GetxController {
  SliderRepository _sliderRepo;
  CategoryRepository _categoryRepository;
  EServiceRepository _eServiceRepository;

  final addresses = <Address>[].obs;
  final slider = <Slide>[].obs;
  final currentSlide = 0.obs;

  final eServices = <EService>[].obs;
  final categories = <Category>[].obs;
  final featured = <Category>[].obs;

  HomeController() {
    _sliderRepo = new SliderRepository();
    categories.add(Category(id:"1",name: "عجل",description: "عجل بلدي ",image: Media(id: "1",url: "https://media.zid.store/cdn-cgi/image/f=auto/https://media.zid.store/9919dbbb-cb6f-4ed3-8975-250de1fd125a/02351910-5c5c-4524-9969-c27b3e13e093.png"),featured: true));
    categories.add(Category(id:"2",name: "حاشي",description: "حاشي بلدي ",image: Media(id: "2",url: "https://cdn.salla.sa/wtMpG4HNbwCQG6FfikyJHUZwetHlTnPJPXEqywcT.jpeg"),featured: true));

    _categoryRepository = new CategoryRepository();
    _eServiceRepository = new EServiceRepository();
  }
  var isLoading=true.obs;

  // var main=<ItemCategory>[].obs;
  var products=<Product>[].obs;
  getDiary() {
    products.clear();
    isLoading.value = true;
    FirebaseFirestore.instance
        .collection('product')
    // .where('created_by', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      products.value = value.docs.map((e) {
        log(e.data().toString());
        var r=  Product.fromJson(e.data());
        r.id=e.id;
        return r;
      }).toList();
      products.refresh();

      isLoading.value = false;
      // notifyListeners();
      return;
    }).catchError((e) {
      log(e.toString());
    });
  }

  @override
  Future<void> onInit() async {
    categories.add(Category(id:"1",name: "عجل",description: "عجل بلدي ",image: Media(id: "1",url: "https://media.zid.store/cdn-cgi/image/f=auto/https://media.zid.store/9919dbbb-cb6f-4ed3-8975-250de1fd125a/02351910-5c5c-4524-9969-c27b3e13e093.png"),featured: true));
    categories.add(Category(id:"2",name: "حاشي",description: "حاشي بلدي ",image: Media(id: "2",url: "https://cdn.salla.sa/wtMpG4HNbwCQG6FfikyJHUZwetHlTnPJPXEqywcT.jpeg"),featured: true));
    await refreshHome();
    super.onInit();
  }

  Future refreshHome({bool showMessage = false}) async {
    if (products.isEmpty) {
      await getDiary();
    }
    await getSlider();
    await getCategories();
    await getFeatured();
    await getRecommendedEServices();
    Get.find<RootController>().getNotificationsCount();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Home page refreshed successfully".tr));
    }
  }

  Address get currentAddress {
    return Get.find<SettingsService>().address.value;
  }

  Future getSlider() async {
    try {
      slider.assignAll(await _sliderRepo.getHomeSlider());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

   getCategories() async {
    categories.value.add(Category(id:"1",name: "عجل",description: "عجل بلدي ",image: Media(id: "1",url: "https://media.zid.store/cdn-cgi/image/f=auto/https://media.zid.store/9919dbbb-cb6f-4ed3-8975-250de1fd125a/02351910-5c5c-4524-9969-c27b3e13e093.png"),featured: true));
    categories.value.add(Category(id:"2",name: "حاشي",description: "حاشي بلدي ",image: Media(id: "2",url: "https://cdn.salla.sa/wtMpG4HNbwCQG6FfikyJHUZwetHlTnPJPXEqywcT.jpeg"),featured: true));
refresh();
    // try {
    //   categories.assignAll(await _categoryRepository.getAllParents());
    // } catch (e) {
    //   Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    // }
  }

  Future getFeatured() async {
    try {
      featured.assignAll(await _categoryRepository.getFeatured());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getRecommendedEServices() async {
    try {
      eServices.assignAll(await _eServiceRepository.getRecommended());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
