import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/models/category_model.dart';
import 'package:home_services/app/models/media_model.dart';

import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../models/booking_model.dart';
import '../../../models/coupon_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/my_order_model.dart';
import '../../../models/option_model.dart';
import '../../../models/products_model.dart';
import '../../../providers/helper_provider.dart';
import '../../../repositories/booking_repository.dart';
import '../../../repositories/setting_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../bookings/controllers/bookings_controller.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/tab_bar_widget.dart';

class BookEServiceController extends GetxController {
  final scheduled = false.obs;

  final booking = Booking().obs;
  final addresses = <Address>[].obs;
  BookingRepository _bookingRepository;
  SettingRepository _settingRepository;
  final categories = <Category>[].obs;
  final sizeoptionlist = <SizeObtion>[].obs;

  final hasSizeList = false.obs;

  final cutoptionlist = <CutObtion>[].obs;
  final hasCutList = false.obs;
  final select = "1".obs;
  final selectCut = "1".obs;
  RxInt quantity = 1.obs;
  DataBase db;
  var isLoading = true.obs;

  // var main=<ItemCategory>[].obs;
  var products = <Product>[].obs;
  var parts = <Parts>[].obs;
  List<String> cuts = [];
  var selectPart = Parts().obs;
  var selectProduct = Product().obs;

  var currentSizeId = SizeObtion().obs;

  var currentCutId = CutObtion().obs;

  var radval = 1.obs;

  var show = false.obs;

  final edit = false.obs;
  RxDouble total = (0.0).obs;

  final oneCart3 = <MyOrder>[].obs;

  final step = 1.obs;

  var request = false.obs;
  Address get currentAddress => Get.find<SettingsService>().address.value;

  BookEServiceController() {
    _bookingRepository = BookingRepository();
    _settingRepository = SettingRepository();
    db = DataBase();
  }

  // List<String> get optionlist => null;

  @override
  void onInit() async {
    super.onInit();
    // final _eService = (Get.arguments['eService'] as EService);
    // final _options = (Get.arguments['options'] as List<Option>);
    // final _quantity = (Get.arguments['quantity'] as int);
    categories.value.add(Category(
        id: "1",
        name: "عجل",
        description: "عجل بلدي ",
        color: Colors.white,
        sizeObtions: [
          SizeObtion(id: "1", name: "مفروم 5 كيلو", price: 357),
          SizeObtion(id: "2", name: "قطع(أوصال) 5 كيلو ", price: 420),
          SizeObtion(id: "3", name: "ستيك 5 كيلو", price: 420),
          SizeObtion(id: "4", name: "هريس 5 كيلو", price: 420)
        ],
        image: Media(
            id: "1",
            url:
                "https://media.zid.store/cdn-cgi/image/f=auto/https://media.zid.store/9919dbbb-cb6f-4ed3-8975-250de1fd125a/02351910-5c5c-4524-9969-c27b3e13e093.png"),
        featured: true));
    categories.value.add(Category(
        id: "2",
        name: "حاشي",
        description: "حاشي بلدي ",
        color: Colors.white,
        sizeObtions: [
          SizeObtion(id: "1", name: "5 كيلو", price: 357),
          SizeObtion(id: "2", name: "5 كيلو حوار", price: 420),
          SizeObtion(id: "3", name: "10 كيلو", price: 693)
        ],
        image: Media(
            id: "2",
            url:
                "https://cdn.salla.sa/wtMpG4HNbwCQG6FfikyJHUZwetHlTnPJPXEqywcT.jpeg"),
        featured: true));
    categories.value.add(Category(
        id: "3",
        name: "نعيمي",
        description: "نعيمي ",
        color: Colors.white,
        sizeObtions: [
          SizeObtion(id: "1", name: "لباني 9-12 كيلو", price: 1218),
          SizeObtion(id: "2", name: "صغير 12-15 كيلو", price: 1323),
          SizeObtion(id: "3", name: "وسط 15-17 كيلو", price: 1428),
          SizeObtion(id: "4", name: "جذع وسط 17-20 كيلو", price: 1533),
          SizeObtion(id: "5", name: "جذع طيب 20-25 كيلو", price: 1638),
          SizeObtion(id: "6", name: "عقيقة 20-25 كيلو", price: 1638),
        ],
        cutObtions: [
          CutObtion(id: "1", name: "ثلاجة", price: 1218),
          CutObtion(id: "2", name: "تفصيل حضرمي 32 قطعة", price: 1323),
          CutObtion(id: "3", name: "تفصيل حضرمي 8 قطعة", price: 1428),
          CutObtion(id: "4", name: "ارباع", price: 1533),
          CutObtion(id: "5", name: "انصاف", price: 1638),
          CutObtion(id: "6", name: "مفطح", price: 1638),
          CutObtion(id: "7", name: "كاملة", price: 1638),
        ],
        image: Media(
            id: "3",
            url:
                "https://cdn.salla.sa/ozQqr/SQWSM8lmV5xzE8Yr3ejnkmWdBt5QYRz6fE3GLEim.jpg"),
        featured: true));
    categories.value.add(Category(
        id: "4",
        name: "تيس عارضي",
        description: "تيس عارضي ",
        color: Colors.white,
        sizeObtions: [SizeObtion(id: "1", name: "صغير 10-8 كيلو", price: 1050)],
        cutObtions: [
          CutObtion(id: "1", name: "ثلاجة", price: 1218),
          CutObtion(id: "2", name: "تفصيل حضرمي 32 قطعة", price: 1323),
          CutObtion(id: "3", name: "تفصيل حضرمي 8 قطعة", price: 1428),
          CutObtion(id: "4", name: "ارباع", price: 1533),
          CutObtion(id: "5", name: "انصاف", price: 1638),
          CutObtion(id: "6", name: "مفطح", price: 1638),
          CutObtion(id: "7", name: "كاملة", price: 1638),
          CutObtion(id: "8", name: "حي", price: 1638),
        ],
        image: Media(
            id: "3",
            url:
                "https://cdn.salla.sa/rWelSuGmMGpEIU9vMbB3a0Ehbtuv3ohQlzJN4sVc.jpeg"),
        featured: true));
    categories.value.add(Category(
        id: "5",
        name: "ربع او نصف",
        description: "ربع او نصف ",
        color: Colors.white,
        sizeObtions: [
          SizeObtion(id: "1", name: "ربع نعيمي5-4 كيلو", price: 462),
          SizeObtion(id: "2", name: "نصف نعيمي10-8 كيلو", price: 861),
        ],
        image: Media(
            id: "4",
            url:
                "https://e7.pngegg.com/pngimages/153/865/png-clipart-lamb-and-mutton-goat-ham-veal-sarma-goat-food-animals-thumbnail.png"),
        featured: true));

    this.booking.value = Booking(
      bookingAt: DateTime.now(),
      address: currentAddress,
      // eService: _eService,
      // eProvider: _eService.eProvider,
      // taxes: _eService.eProvider.taxes,
      // options: _options,
      duration: 1,
      quantity: quantity.value,
      user: Get.find<AuthService>().user.value,
      coupon: new Coupon(),
    );
    setOptions("1");
    await refreshHome();
  }

  refreshHome() async {
    await getDiary();
    await getAddress();
    await getThisOrder("1", false);
  }

  getDiary() {
    products.clear();
    isLoading.value = true;
    log("fitching");
    FirebaseFirestore.instance
        .collection('product')
        // .where('created_by', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      products.value = value.docs.map((e) {
        log(e.data().toString());
        var r = Product.fromJson(e.data());
        r.id = e.id;
        return r;
      }).toList();
      selectProduct.value = products.first;
      selectPart.value = selectProduct.value.parts?.first ?? Parts();
      selectCut.value = selectProduct.value.cuts?.first ?? null;
      products.refresh();

      isLoading.value = false;
      // notifyListeners();
      return;
    }).catchError((e) {
      log(e.toString());
    });
  }

  @override
  void update([ids, bool condition = true]) {
    print("fsdfsdf");
  }

  void toggleScheduled(value) {
    scheduled.value = value;
  }

  TextStyle getTextTheme(bool selected) {
    if (selected) {
      return Get.textTheme.bodyText2
          .merge(TextStyle(color: Get.theme.primaryColor));
    }
    return Get.textTheme.bodyText2;
  }

  Color getColor(bool selected) {
    if (selected) {
      return Get.theme.accentColor;
    }
    return null;
  }

  void createBooking() async {
    try {
      this.booking.value.address = currentAddress;
      Get.log(booking.value.toString());
      // await _bookingRepository.add(booking.value);
      // Get.find<BookingsController>().currentStatus.value =
      //     Get.find<BookingsController>().getStatusByOrder(1).id;
      // if (Get.isRegistered<TabBarController>(tag: 'bookings')) {
      //   Get.find<TabBarController>(tag: 'bookings').selectedId.value =
      //       Get.find<BookingsController>().getStatusByOrder(1).id;
      // }
      Get.find<SettingsService>().booking.value = this.booking.value;
      await Get.toNamed(
        Routes.PHONE_VERIFICATION,
      );
      // Get.toNamed(Routes.CONFIRMATION);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void validateCoupon() async {
    try {
      Coupon _coupon = await _bookingRepository.coupon(booking.value);
      booking.update((val) {
        val.coupon = _coupon;
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  String getValidationMessage() {
    if (booking.value.coupon?.id == null) {
      return null;
    } else {
      if (booking.value.coupon.id == '') {
        return "Invalid Coupon Code".tr;
      } else {
        return null;
      }
    }
  }

  Future<Null> showMyDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: booking.value.bookingAt.add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(2101),
      locale: Get.locale,
      builder: (BuildContext context, Widget child) {
        return child.paddingAll(10);
      },
    );
    if (picked != null) {
      booking.update((val) {
        val.bookingAt = DateTime(picked.year, picked.month, picked.day,
            val.bookingAt.hour, val.bookingAt.minute);
        ;
      });
    }
  }

  Future<Null> showMyTimePicker(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(booking.value.bookingAt),
      builder: (BuildContext context, Widget child) {
        return child.paddingAll(10);
      },
    );
    if (picked != null) {
      booking.update((val) {
        val.bookingAt = DateTime(booking.value.bookingAt.year,
                booking.value.bookingAt.month, booking.value.bookingAt.day)
            .add(Duration(minutes: picked.minute + picked.hour * 60));
      });
    }
  }

  void getCategories() {
//     if(categories.isNotEmpty){
//     categories.value.add(Category(id:"1",name: "عجل",description: "عجل بلدي ",color:Colors.white,image: Media(id: "1",url: "https://media.zid.store/cdn-cgi/image/f=auto/https://media.zid.store/9919dbbb-cb6f-4ed3-8975-250de1fd125a/02351910-5c5c-4524-9969-c27b3e13e093.png"),featured: true));
//     categories.value.add(Category(id:"2",name: "حاشي",description: "حاشي بلدي ",color:Colors.white,image: Media(id: "2",url: "https://cdn.salla.sa/wtMpG4HNbwCQG6FfikyJHUZwetHlTnPJPXEqywcT.jpeg"),featured: true));
//     categories.value.add(Category(id:"3",name: "نعيمي",description: "نعيمي ",color:Colors.white,image: Media(id: "3",url: "https://cdn.salla.sa/ozQqr/SQWSM8lmV5xzE8Yr3ejnkmWdBt5QYRz6fE3GLEim.jpg"),featured: true));
//     categories.value.add(Category(id:"4",name: "ربع او نصف",description: "ربع او نصف ",color:Colors.white,image: Media(id: "4",url: "https://e7.pngegg.com/pngimages/153/865/png-clipart-lamb-and-mutton-goat-ham-veal-sarma-goat-food-animals-thumbnail.png"),featured: true));
// }
  }

  void incrementQuantity(String id, int index) {
    // if(id=="0"){
    if (int.parse(oneCart3[index].much) < 1000) {
      total.value = total.value + double.parse(oneCart3[index].price);
      var tt = int.parse(oneCart3[index].much) + 1;
      oneCart3[index].much = tt.toString();
    }

    // }else{
    //   if( int.parse(oneCart1[index].old)<1000){
    //     total.value=total.value+double.parse(oneCart1[index].cost);
    //     var tt=  int.parse(oneCart1[index].old)+1;
    //     oneCart1[index].old=tt.toString();
    //   }
    // }
    oneCart3.refresh();
    // oneCart0.refresh();
    refresh();
    // quantity.value < 1000 ? quantity.value++ : null;
  }

  saveOrder2(MyOrder category) async {
    MyOrder res = await db.searchItem(category);
    if (res.id != null) {
      res.much =
          (int.tryParse(res.much) + int.tryParse(category.much)).toString();
      await db.updateMyOrder(res);
    } else {
      await db.saveMyOrder(category);
    }
    await getThisOrder("1", false);
  }

  void getThisOrder(String id, bool lastorder, {List<MyOrder> list}) async {
    total.value = 0;
    if (lastorder) {
      oneCart3.value = list;
    } else {
      oneCart3.value = await db.getItemMyOrderById(id);
    }
    for (int i = 0; i < oneCart3.length; i++) {
      // oneCart0.forEach((element) async {

      // prints("old: "+element.old);
      total.value = total.value +
          int.parse(oneCart3[i].much) * double.parse(oneCart3[i].price);
    }
    ;
  }

  void decrementQuantity(String id, int index) {
    // if(id=="0"){
    if (int.parse(oneCart3[index].much) > 1) {
      total.value = total.value - double.parse(oneCart3[index].price);
      var tt = int.parse(oneCart3[index].much) - 1;
      oneCart3[index].much = tt.toString();
    }
    //
    // }else{
    //   if( int.parse(oneCart1[index].old)>1){
    //     total.value=total.value-double.parse(oneCart1[index].cost);
    //     var tt=  int.parse(oneCart1[index].old)-1;
    //     oneCart1[index].old=tt.toString();
    //   }
    // }
    oneCart3.refresh();
    // oneCart0.refresh();
    refresh();
    // quantity.value > 1 ? quantity.value-- : null;
  }

  void incrementQuantity2() {
    quantity.value < 1000 ? quantity.value++ : null;
    this.booking.value.quantity = quantity.value;
  }

  void decrementQuantity2() {
    quantity.value > 1 ? quantity.value-- : null;
    this.booking.value.quantity = quantity.value;
  }

  void setOptions(String id) {
    currentSizeId = SizeObtion().obs;
    hasSizeList.value = false;
    hasCutList.value = false;
    for (var o in categories) {
      if (id == o.id) {
        if (o.sizeObtions.isNotEmpty) {
          currentSizeId.value = o.sizeObtions.first;
          sizeoptionlist.value = o.sizeObtions;

          currentSizeId.refresh();
          hasSizeList.value = true;
          // currentSizeId.update((val) {
          //   currentSizeId.value=val;
          // });
        }
        if (o.cutObtions != null) {
          cutoptionlist.value = o.cutObtions;

          currentCutId.value = o.cutObtions.first;
          hasCutList.value = true;
        }

        update();
      }
    }
    //
    // for (var o in categories) {
    //   if(id ==o.id) {
    //     cutoptionlist.value = o.cutObtions;
    //     hasCutList.value=true;
    //     update();
    //   }
    // }
  }

  void refreshveiw(String id) {
    setOptions(id);
  }

  getMapImage(Address value) {
    var lat = value.latitude;
    var long = value.longitude;
    return """https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&style=visibility:on&style=feature:water%7Celement:geometry%7Cvisibility:on&style=feature:landscape%7Celement:geometry%7Cvisibility:on&markers=anchor:topright%7Cicon:https://goo.gl/1oTJ9Y%7CSydney+NSW&maptype=
    terrain&zoom=17&size=800x400&key=AIzaSyAAZ90wzgTYiDpYeZf6uQbf_XcDhxD8VcY"""; //terrain || roadmap
  }

  void setShow(bool val) {
    show.value = val;
  }

  Future<int> deletAddress(String id) {
    return db.deletAddress(id);
  }

  Future getAddress() async {
    addresses.value = await db.getMylocathons();
    // try {
    //   featured.assignAll(await _categoryRepository.getFeatured());
    // } catch (e) {
    //   Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    // }
  }

  Future<void> deleteEFood(int index) async {
    // prints("===${oneCart3[index].id.toString()}");

    // // total.value=total.value-double.parse(booking.value.listItem[index].cost);
    await deleteFood(oneCart3[index].id.toString()).then((value) {
      total.value = total.value - double.parse(oneCart3[index].price);
      oneCart3.removeAt(index);

      oneCart3.refresh();
      if (oneCart3.isEmpty) {
        Get.back();
      }
    });
  }

  Future<int> deleteFood(String id) {
    return db.deletFood(id);
  }

  Future<int> deleteCart(String id) {
    return db.deletCart(id);
  }

  getSubtotal(MyOrder service) {
    return int.parse(service.much) * double.parse(service.price, (e) => 0);
  }

  void setPrts(Product category) {
    selectProduct.value = category;
    if (category.parts != null && category.parts.isNotEmpty) {
      selectPart.value = selectProduct.value.parts?.first ?? Parts();
      selectCut.value =
          selectProduct.value.cuts == null || selectProduct.value.cuts.isEmpty
              ? "0"
              : selectProduct.value.cuts?.first ?? "";
    } else {
      selectPart.value = Parts();
      selectCut.value = null;
    }
  }

  Future<void> getScadual() async {
    var time;
    var date;
    selectdDay.value = 0;
    dateinit = DateTime.now().add(const Duration(days: 0));
    // await showGeneralDialog(context: Get.context, pageBuilder: pageBuilder)
    await Get.defaultDialog(title: "جدولة", content: pageBuilder())
        // await showMyDatePicker2(Get.context)
        .then((value) async {
      if (value != null && value) {
        await showMyTimePicker2(Get.context).then((value2) {
          if (value2 != null && value2) {
            Scadual.value = true;
          }
        });
      }
    });
  }

  var dateinit = DateTime.now();
  var Scadual = false.obs;
  Future<bool> showMyDatePicker2(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: dateinit.add(const Duration(days: 0)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2101),
      locale: Get.locale,
      builder: (BuildContext context, Widget child) {
        return child.paddingAll(10);
      },
    );
    if (picked != null) {
      // dateinit.update((val) {
      dateinit = DateTime(picked.year, picked.month, picked.day, dateinit.hour,
          dateinit.minute);

      // });
      return true;
    } else {
      return false;
    }
  }

  Future<bool> showMyTimePicker2(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(dateinit),
      builder: (BuildContext context, Widget child) {
        return child.paddingAll(10);
      },
    );
    if (picked != null) {
      // travel.update((val) {
      dateinit = DateTime(dateinit.year, dateinit.month, dateinit.day)
          .add(Duration(minutes: picked.minute + picked.hour * 60));
      // });
      return true;
    } else {
      return false;
    }
  }

  var selectdDay = 0.obs;

  Widget pageBuilder() {
    return SizedBox(
      height: 400,
      width: 200,
      child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListWheelScrollView(
                    onSelectedItemChanged: (i) {
                      selectdDay.value = i;
                      dateinit = DateTime.now().add(Duration(days: i));
                    },
                    // renderChildrenOutsideViewport: true,
                    physics: const FixedExtentScrollPhysics(),
                    diameterRatio: 1.5,
                    // useMagnifier: true,
                    magnification: 1.2,
                    // squeeze: 0.9,
                    itemExtent: 145.5,
                    children: [
                      BlockButtonWidget(
                          text: Container(
                            height: 24,
                            alignment: Alignment.center,
                            child: Text(
                              "اليــوم",
                              textAlign: TextAlign.center,
                              style: Get.textTheme.headline6.merge(
                                TextStyle(color: Get.theme.cardColor),
                              ),
                            ),
                          ),
                          color: (selectdDay.value == 0)
                              ? Get.theme.accentColor
                              : Get.theme.accentColor.withOpacity(0.5),
                          onPressed:
                              () async {} // Get.toNamed(Routes.BOOK_E_SERVICE, arguments: {'eService': _eService, 'options': controller.getCheckedOptions(), 'quantity': controller.quantity.value});
                          ),
                      BlockButtonWidget(
                          text: Container(
                            height: 24,
                            alignment: Alignment.center,
                            child: Text(
                              "غـــدا",
                              textAlign: TextAlign.center,
                              style: Get.textTheme.headline6.merge(
                                TextStyle(color: Get.theme.cardColor),
                              ),
                            ),
                          ),
                          // color: Get.theme.accentColor,
                          color: (selectdDay.value == 1)
                              ? Get.theme.accentColor
                              : Get.theme.accentColor.withOpacity(0.5),
                          onPressed:
                              () async {} // Get.toNamed(Routes.BOOK_E_SERVICE, arguments: {'eService': _eService, 'options': controller.getCheckedOptions(), 'quantity': controller.quantity.value});
                          ),
                      BlockButtonWidget(
                          text: Container(
                            height: 24,
                            alignment: Alignment.center,
                            child: Text(
                              "بعـد غـد",
                              textAlign: TextAlign.center,
                              style: Get.textTheme.headline6.merge(
                                TextStyle(color: Get.theme.cardColor),
                              ),
                            ),
                          ),
                          // color: Get.theme.accentColor,
                          color: (selectdDay.value == 2)
                              ? Get.theme.accentColor
                              : Get.theme.accentColor.withOpacity(0.5),
                          onPressed:
                              () async {} // Get.toNamed(Routes.BOOK_E_SERVICE, arguments: {'eService': _eService, 'options': controller.getCheckedOptions(), 'quantity': controller.quantity.value});
                          ),
                    ]),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlockButtonWidget(
                      text: Container(
                        height: 24,
                        alignment: Alignment.center,
                        child: Text(
                          "موافق",
                          textAlign: TextAlign.center,
                          style: Get.textTheme.headline6.merge(
                            TextStyle(color: Get.theme.cardColor),
                          ),
                        ),
                      ),
                      color: Get.theme.accentColor,
                      onPressed: () {
                        Get.back(result: true);
                      } // Get.toNamed(Routes.BOOK_E_SERVICE, arguments: {'eService': _eService, 'options': controller.getCheckedOptions(), 'quantity': controller.quantity.value});
                      ),
                  BlockButtonWidget(
                      text: Container(
                        height: 24,
                        alignment: Alignment.center,
                        child: Text(
                          "الغاء",
                          textAlign: TextAlign.center,
                          style: Get.textTheme.headline6.merge(
                            TextStyle(color: Get.theme.cardColor),
                          ),
                        ),
                      ),
                      color: Get.theme.accentColor,
                      onPressed: () {
                        Get.back(result: false);
                      } // Get.toNamed(Routes.BOOK_E_SERVICE, arguments: {'eService': _eService, 'options': controller.getCheckedOptions(), 'quantity': controller.quantity.value});
                      ),
                ],
              )
            ],
          )),
    );
  }
}
