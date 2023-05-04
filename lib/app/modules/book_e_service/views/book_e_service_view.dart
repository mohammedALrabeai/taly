import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:home_services/app/models/category_model.dart';
import 'package:home_services/app/modules/bookings/widgets/booking_row_widget.dart';
import 'package:home_services/app/modules/home/widgets/categories_carousel_widget.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/prod_items.dart';
import '../../../../common/shop_model.dart';
import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/firebase_order_model.dart';
import '../../../models/my_order_model.dart';
import '../../../models/products_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../../services/settings_service.dart';
import '../../bookings/widgets/booking_til_widget.dart';
import '../../fatoora/view/fatoora_view.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/tab_bar_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../global_widgets/text_news.dart';
import '../../settings/views/address_picker_view.dart';
import '../controllers/book_e_service_controller.dart';

class BookEServiceView extends GetView<BookEServiceController> {
  @override
  Widget build(BuildContext context) {
    controller.step.value = 2;
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
        if (controller.step.value == 1) {
          return Future.value(true);
        } else {
          controller.step.value = 1;
          return Future.value(false);
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "اطلب من ذبيحة".tr,
              style: context.textTheme.headline6,
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.SETTINGS_LANGUAGE);
                  },
                  icon: Icon(
                    Icons.language,
                    color: Colors.black38,
                  ))
            ],
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
              onPressed: () => Get.back(),
            ),
            elevation: 0,
          ),
          bottomNavigationBar: Obx(() => controller.step.value == 2
              ? buildBlockButtonWidget2(controller.booking.value)
              : buildBlockButtonWidget(controller.booking.value)),
          body: RefreshIndicator(
            onRefresh: () async {
              await controller.refreshHome();
            },
            child: Obx(
              () => ListView(
                children: [
                  if (controller.step.value != 1)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Delivery Address".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 19),
                      ),
                    ),
                  if (controller.step.value != 1)
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 0),
                      color: Colors.transparent,
                      // decoration:
                      // Ui.getBoxDecoration(color: Colors.grey.shade200),
                      child: Stack(
                        children: [
                          Obx(
                            () => CachedNetworkImage(
                              // imageUrl: "http://via.placeholder.com/200x150",
                              imageUrl:
                                  "${controller.getMapImage(Get.find<SettingsService>().address.value)}",
                              imageBuilder: (context, imageProvider) =>
                                  AnimatedContainer(
                                height: 250,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                      colorFilter:
                                          ColorFilter.srgbToLinearGamma()
                                      // mode(
                                      //                                       Colors.green
                                      //                                           .withOpacity(0.4),
                                      //                                       BlendMode.colorBurn)
                                      ),
                                ),
                                duration: const Duration(seconds: 1),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 0.001, sigmaY: 0.001),
                                  child: Container(
                                    width: Get.width,
                                    // decoration: new BoxDecoration(color: Get.theme.accentColor.withOpacity(0.25)),
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                  alignment: Alignment.center,
                                  child: const CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Image.asset("assets/icon/default.png"),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // SizedBox(width: 20),

                                  Expanded(
                                    child: Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Get.theme.accentColor
                                              .withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Icon(Icons.place_outlined,
                                                color: Get.theme.focusColor),
                                          ),
                                          Expanded(
                                            flex: 7,
                                            child: Obx(
                                              () => ScrollingText(
                                                // text: " hkkjhjh ljkhg ارتا نناتابنتوا ملمتانابنا hkkjhjh ljkhg ارتا نناتابنتوا ملمتانابنا ",
                                                text: controller.currentAddress
                                                        ?.address ??
                                                    "Loading...",
                                                textStyle: Get
                                                    .textTheme.subtitle1
                                                    .merge(const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    height: 30,
                                    width: 100,
                                    child: MaterialButton(
                                      height: 20,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 14),
                                      onPressed: () async {
                                        // Get.toNamed(Routes.SETTINGS_ADDRESS_PICKER)
                                        // if (!Get.isRegistered<
                                        //     LocationService>()) {
                                        //   await Get.putAsync(
                                        //           () => LocationService().init())
                                        //       .then((value) async {
                                        //     // Get.find<SplashService>().o9=true;
                                        //   });
                                        // } else {
                                        //   await Get.find<LocationService>()
                                        //       .intiLoc();
                                        // }
                                        //
                                        // if (Get.find<LocationService>()
                                        //     .locationData !=
                                        //     null) {
                                        //   Get.find<SettingsService>()
                                        //       .address
                                        //       .update((val) {
                                        //     val.description = "موقعي";
                                        //     val.address =
                                        //         Get.find<LocationService>()
                                        //             .locationData
                                        //             .provider;
                                        //     val.latitude =
                                        //         Get.find<LocationService>()
                                        //             .locationData
                                        //             .latitude;
                                        //     val.longitude =
                                        //         Get.find<LocationService>()
                                        //             .locationData
                                        //             .longitude;
                                        //     val.userId = Get.find<AuthService>()
                                        //         .user
                                        //         .value
                                        //         .id;
                                        //   });
                                        // }
                                        //
                                        // // controller.refreshHome();
                                        // await controller.getDestance(this.id);
                                        // if (controller.destance != null) {
                                        //   Get.find<SettingsService>()
                                        //       .address
                                        //       .update((val) {
                                        //     val.address =
                                        //         controller.destance.value.ad2;
                                        //   });
                                        // }
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      color: Get.theme.accentColor
                                          .withOpacity(0.5),
                                      elevation: 10,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        // crossAxisAlignment: WrapCrossAlignment.center,
                                        // spacing: 6,
                                        children: [
                                          Expanded(
                                            child: Text("My Loc".tr,
                                                style: Get.textTheme.subtitle1
                                                    .merge(const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15))),
                                          ),
                                          Icon(
                                            Icons.my_location,
                                            color: Get.theme.cardColor,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  SizedBox(
                                    height: 30,
                                    width: 80,
                                    child: MaterialButton(
                                      // height: 20,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 8),
                                      onPressed: () {
                                        Get.to(() =>
                                                AddressPickerView(back: true))
                                            .then((value) =>
                                                controller.getAddress());
                                        // Get.toNamed(
                                        //     Routes.SETTINGS_ADDRESS_PICKER)
                                        //     .then((value) {
                                        //   // controller.refreshHome();
                                        //   // controller.getDestance(id);
                                        // });
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      color: Get.theme.accentColor
                                          .withOpacity(0.5),
                                      elevation: 10,
                                      child: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.start,
                                        spacing: 6,
                                        children: [
                                          Text(
                                            "New".tr,
                                            style: Get.textTheme.subtitle1
                                                .merge(const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18)),
                                            textAlign: TextAlign.start,
                                          ),
                                          Icon(
                                            Icons.my_location,
                                            color: Get.theme.cardColor,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // const SizedBox(width: 20),
                                ],
                              ),
                              const SizedBox(height: 10),

                              const SizedBox(height: 15),
                              // Row(
                              //   children: [
                              //     SizedBox(width: 20),
                              //     Icon(Icons.place_outlined,
                              //         color: Get.theme.focusColor),
                              //     SizedBox(width: 15),
                              //     Expanded(
                              //       child: Obx(() {
                              //         return Column(
                              //           children: [
                              //             Text(
                              //                 controller
                              //                         .currentAddress?.description ??
                              //                     "Loading...".tr,
                              //                 style: Get.textTheme.bodyText2),
                              //             Text(
                              //                 controller.currentAddress?.address ??
                              //                     "Loading...".tr,
                              //                 style: Get.textTheme.bodyText2),
                              //           ],
                              //         );
                              //       }),
                              //     ),
                              //     SizedBox(width: 20),
                              //   ],
                              // ),
                              // Obx(() {
                              //   return (!controller.destance.value.hasData)?
                              //
                              //       Container()
                              //       :

                              Obx(
                                () => (!controller.show.value)
                                    ? Container()
                                    : Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: BookingTilWidget(
                                          title: Text("حذف عنوان",
                                              style: Get.textTheme.subtitle2),
                                          actions: [
                                            InkWell(
                                                onTap: () =>
                                                    controller.setShow(false),
                                                child: Text("اخفاء",
                                                    style: Get
                                                        .textTheme.subtitle2))
                                          ],
                                          content: Obx(
                                            () => Column(
                                              textDirection: TextDirection.ltr,
                                              children: controller.addresses
                                                  .map((element) {
                                                return Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(element.description),
                                                      IconButton(
                                                          onPressed: () async {
                                                            // print(
                                                            //     "nnn ${element.idd}");
                                                            int tt = await controller
                                                                .deletAddress(
                                                                    element
                                                                        .address);
                                                            controller
                                                                .getAddress();
                                                          },
                                                          icon: const Icon(Icons
                                                              .delete_forever))
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                // );
                                // }
                              ),
                              const SizedBox(
                                height: 140,
                              ),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Obx(() => Row(
                                      children: [
                                        if (controller.addresses.isNotEmpty)
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              color: Colors.white,
                                              height: 30,
                                              width: 10,
                                              child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  color: Colors.red,
                                                  onPressed: () {
                                                    controller.edit.value =
                                                        !controller.edit.value;
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete_forever,
                                                  )),
                                            ),
                                          ),
                                        Expanded(
                                          flex: 9,
                                          child: Obx(() {
                                            if (controller.addresses.isEmpty) {
                                              return Container();
                                            } else {
                                              return TabBarWidget(
                                                initialSelectedId:
                                                    controller.addresses.last,
                                                tag: 'addresses',
                                                tabs: List.generate(
                                                    controller.addresses.length,
                                                    (index) {
                                                  final _address = controller
                                                      .addresses
                                                      .elementAt(index);
                                                  return Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      ChipWidget(
                                                        dark: true,
                                                        hightt: 20,
                                                        tag: 'addresses',
                                                        text: "  " +
                                                            _address
                                                                .getDescription +
                                                            "  ",
                                                        id: index,
                                                        onSelected: (id) {
                                                          Get.find<
                                                                  SettingsService>()
                                                              .address
                                                              .update((val) {
                                                            val.description =
                                                                _address
                                                                    .description;
                                                            val.address =
                                                                _address
                                                                    .address;
                                                            val.latitude =
                                                                _address
                                                                    .latitude;
                                                            val.longitude =
                                                                _address
                                                                    .longitude;
                                                            val.userId = "1";
                                                          });
                                                          // controller.getDestance(
                                                          //     this.id);
                                                          // Get.find<SettingsService>().address.value =
                                                          //     _address;
                                                          // Get.find<SettingsService>().address.refresh();
                                                          //
                                                          // controller.refresh();
                                                        },
                                                      ),
                                                      if (controller.edit.value)
                                                        Positioned(
                                                          // top: -5,
                                                          bottom: 35,
                                                          width: 25,
                                                          height: 25,
                                                          right: 0,

                                                          child: InkWell(
                                                            onTap: () async {
                                                              // print(
                                                              //     "nnn ${_address.idd}");
                                                              int tt = await controller
                                                                  .deletAddress(
                                                                      _address
                                                                          .address);
                                                              controller
                                                                  .getAddress();
                                                            },
                                                            child: ClipOval(
                                                              // radius: 12,
                                                              // backgroundColor:
                                                              //  Colors.red.withAlpha(150),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .red
                                                                        .withAlpha(
                                                                            250),
                                                                    shape: BoxShape
                                                                        .circle),
                                                                child:
                                                                    const Icon(
                                                                  Icons.clear,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 15,
                                                                  // textDirection: TextDirection.ltr,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  );
                                                }),
                                              );
                                            }
                                          }),
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                          // Align(
                          //   alignment: Alignment.topCenter,
                          //   child:

                          // )
                        ],
                      ),
                    ),
                  if (controller.step.value != 1)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Cart details".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 19),
                      ),
                    ),
                  if (controller.step.value == 1 &&
                      controller.oneCart3.isNotEmpty)
                    MaterialButton(
                      color: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () {
                        controller.step.value = 2;
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "cart".tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                      ),
                    ).paddingSymmetric(horizontal: 50),
                  if (controller.step.value != 1)
                    SingleChildScrollView(
                      // flex: 5,
                      // fit: FlexFit.tight,
                      child: Container(
                        // constraints: BoxConstraints(
                        //   maxHeight: double.infinity,
                        // ),
                        // height: 270,
                        width: Get.width - 30,
                        // height: 110.0*controller.getItemList(id).length ,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent.withAlpha(50),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        // height: 500,
                        child: Obx(() {
                          return ListView.builder(
                              // padding: EdgeInsets.only(bottom: 10,top: 15),
                              // primary: false,
                              // shrinkWrap: false,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: controller.oneCart3.length,
                              itemBuilder: (_, index) {
                                var _service =
                                    controller.oneCart3.elementAt(index);
                                // prints("addd2 ${_service.distance}");
                                return GestureDetector(
                                  onTap: () {
                                    // Get.to(CheckOutView(_service.idRest));
                                    // Get.toNamed(Routes.RESTURENT_DETAIL, arguments: {'eService': _service, 'heroTag': 'resturent'});
                                  },
                                  child: Container(
                                    // padding: EdgeInsets.all(15),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    height: 120,
                                    width: double.infinity,
                                    child: Card(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () => controller
                                                    .incrementQuantity(
                                                        "1", index),
                                                child: Container(
                                                  height: 40,
                                                  width: 30,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Get.theme.accentColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4)),
                                                  child: const Text(
                                                    '+',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () =>
                                                    (_service.much == "1")
                                                        ? _showDeleteDialog2(
                                                            context,
                                                            index,
                                                            _service.food_name)
                                                        : controller
                                                            .decrementQuantity(
                                                                "1", index),
                                                child: Container(
                                                  height: 40,
                                                  width: 30,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: (_service.much ==
                                                              "1")
                                                          ? Colors.redAccent
                                                              .withAlpha(190)
                                                          : Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4)),
                                                  child: (_service.much == "1")
                                                      ? const Icon(Icons.delete)
                                                      : const Text('-',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 25),
                                                          textAlign:
                                                              TextAlign.center),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${_service.food_name}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Text(" الكمية : "),
                                                    Text(" ${_service.much} "),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Row(
                                                      // mainAxisAlignment:
                                                      //     MainAxisAlignment.spaceBetween,
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      children: [
                                                        if (_service.color_id !=
                                                                null &&
                                                            _service.color_id !=
                                                                "null" &&
                                                            _service.color_id !=
                                                                "0")
                                                          Text(
                                                              "${_service.color_name}"),
                                                        if (_service.part_id !=
                                                                null &&
                                                            _service.part_id !=
                                                                "null" &&
                                                            _service.part_id !=
                                                                "0")
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                    "${"Size".tr}: "),
                                                                Text(
                                                                    "${_service.part_name}"),
                                                                // SizedBox(
                                                                //   width: 15,
                                                                // ),
                                                              ],
                                                            ),
                                                          ),
                                                      ]),
                                                ),
                                                if (_service.size_id != null &&
                                                    _service.size_id !=
                                                        "null" &&
                                                    _service.size_id != "0")
                                                  Row(
                                                    children: [
                                                      Text(
                                                          " ${"shredder".tr}: "),
                                                      Text(
                                                          "${_service.size_name}"),
                                                    ],
                                                  ),
                                                // Text(
                                                //     "${id == "0" ? _service.description : _service.des}"),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  children: [
                                                    // Text("${_service.much}"),
                                                    // SizedBox(
                                                    //   width: 10,
                                                    // ),
                                                    Ui.getPrice(double.parse(
                                                        _service.price,
                                                        (e) => 0)),
                                                    const Text("1/"),
                                                  ],
                                                ),
                                                Ui.getPrice(double.parse(
                                                    "${controller.getSubtotal(_service)}")),
                                                // Text(
                                                //     "${controller.getSubtotal(_service)}"),
                                              ],
                                            ).paddingSymmetric(
                                                horizontal: 15, vertical: 10),
                                          ),
                                          Container(
                                            width: 94,
                                            height: 100,
                                            decoration: const BoxDecoration(
                                                // color: Colors.blue,
// border:,
// borderRadius: BorderRadius.circular(200),
                                                shape: BoxShape.circle),
                                            child: Hero(
                                              tag: 'resturent' +
                                                  _service.id.toString(),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: CachedNetworkImage(
                                                  // height: 180,
                                                  width: double.infinity,

                                                  fit: BoxFit.cover,
                                                  imageUrl: getimgUrl(
                                                      _service.url, 1),
                                                  placeholder: (context, url) =>
                                                      Image.asset(
                                                    'assets/img/loading.gif',
                                                    fit: BoxFit.cover,
                                                    width: 100,
                                                    height: 100,
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Image.asset(
                                                          "assets/icon/default.png"),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }),
                      ),
                    ),

                  if (controller.step.value != 1 && false)
                    BlockButtonWidget(
                      text: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              "طلب هذه السلة".tr,
                              textAlign: TextAlign.center,
                              style: Get.textTheme.headline6.merge(
                                TextStyle(color: Get.theme.primaryColor),
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              color: Get.theme.primaryColor, size: 20)
                        ],
                      ),
                      color: Get.theme.accentColor,
                      // onPressed: ()=>Get.toNamed(Routes.SETTINGS_ADDRESS_PICKER),
                      onPressed: () {
                        controller.step.value = 2;
                      },
                    ).paddingOnly(right: 20, left: 20),
                  SizedBox(
                    height: 20,
                  ),
                  if (controller.step.value == 1) CategoriesCarouselWidget2(),
                  // if (controller.step.value == 1)
                  //   line(1),
                  if (controller.step.value == 1)
                    SizedBox(
                      height: 20,
                    ),
                  if (controller.step.value == 1) count(),
                  // SizedBox(height: 15,),

                  //   line(1),
                  if (controller.step.value == 1)
                    SizedBox(
                      height: 20,
                    ),
                  if (controller.step.value == 1)
                    Obx(() {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            // height: 20,
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text("Size".tr)),
                                Expanded(
                                  flex: 5,
                                  child: CustomDropDown(
                                      hint: 'hint',
                                      errorText: '',
                                      // value: controller.currentValue.value,
                                      value: controller.selectPart.value,
                                      items: _getIteem(
                                          controller.selectProduct.value.parts),
                                      onChanged: (value) {
                                        controller.selectPart.value = value;
                                        // controller.refresh();
                                      }),
                                ),
                              ],
                            )),
                      );
                    }),
                  // SizedBox(height: 5,),
                  if (controller.step.value == 1)
                    Obx(() {
                      if (controller.selectProduct.value.cuts?.isEmpty ?? true)
                        return Container();
                      else
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              // height: 20,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Text("shredder".tr)),
                                  Expanded(
                                    flex: 5,
                                    child: CustomDropDown(
                                        hint: 'hint',
                                        errorText: '',
                                        value: controller.selectCut.value,
                                        items: _getIteem2(controller
                                            .selectProduct.value.cuts),
                                        onChanged: (value) {
                                          controller.selectCut.value = value;
                                          // controller.refresh();
                                        }),
                                  ),
                                ],
                              )),
                        );
                    }),
                  if (controller.step.value == 1) line(1),
                  if (controller.step.value == 1)
                    SizedBox(
                      height: 10,
                    ),
                  if (controller.step.value == 1)
                    Text(
                      "لحم بلدي طازج ",
                      textAlign: TextAlign.center,
                    ),
                  if (controller.step.value == 1)
                    Text(
                      "الذبح والتغليف مسحوب الهواء والتوصيل مجاني  ",
                      textAlign: TextAlign.center,
                    ),

                  if (controller.step.value == 1)
                    Obx(() {
                      return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          padding:
                              EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                          // decoration: Ui.getBoxDecoration(),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("الكرش والمصران".tr,
                                    style: Get.textTheme.bodyText1
                                        .merge(TextStyle(fontSize: 21))),
                                Row(children: [
                                  SizedBox(width: 20),
                                  // RadioListTile(value: controller.radval.value,groupValue: 1, onChanged: (value){}),
                                  Radio<int>(
                                    value: 1,
                                    groupValue: controller.radval.value,
                                    onChanged: (value) {
                                      controller.radval.value = value;
                                    },
                                    autofocus: true,
                                  ),
                                  Expanded(
                                      child: Text("Yes".tr,
                                          style: Get.textTheme.bodyText1
                                              .merge(TextStyle(fontSize: 21)))),

                                  Radio<int>(
                                    value: 2,
                                    groupValue: controller.radval.value,
                                    onChanged: (value) {
                                      controller.radval.value = value;
                                    },
                                  ),
                                  Expanded(
                                      child: Text("No".tr,
                                          style: Get.textTheme.bodyText1
                                              .merge(TextStyle(fontSize: 21)))),
                                  SizedBox(width: 4),
                                  MaterialButton(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 14),
                                    onPressed: () {
                                      Get.toNamed(
                                          Routes.SETTINGS_ADDRESS_PICKER);
                                    },
                                  )
                                ])
                              ]));
                    }),
                  // DropdownButton<int>(
                  //   // value: 1,
                  //     items: getitems()),
                  if (controller.step.value != 1)
                    Text("للخدمات الاخرى يرجى الكتابة في الملاحظات",textAlign: TextAlign.center,),
                  if (controller.step.value != 1)
                    TextFieldWidget(
                      onChanged: (input) =>
                          controller.booking.value.hint = input,
                      hintText: "اكتب ملاحظاتك هنا".tr,
                      labelText: "ملاحظات".tr,
                      iconData: Icons.description_outlined,
                    ),
                  // Obx(() {
                  //   return TextFieldWidget(
                  //     onChanged: (input) => controller.booking.value.coupon.code = input,
                  //     hintText: "COUPON01".tr,
                  //     labelText: "Coupon Code".tr,
                  //     errorText: controller.getValidationMessage(),
                  //     iconData: Icons.confirmation_number_outlined,
                  //     style: Get.textTheme.bodyText2.merge(TextStyle(color: controller.getValidationMessage() != null ? Colors.redAccent : Colors.green)),
                  //     suffixIcon: MaterialButton(
                  //       onPressed: () {
                  //         controller.validateCoupon();
                  //       },
                  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  //       color: Get.theme.focusColor.withOpacity(0.1),
                  //       child: Text("Apply".tr, style: Get.textTheme.bodyText1),
                  //       elevation: 0,
                  //     ).marginSymmetric(vertical: 4),
                  //   );
                  // }),
                  // RadioGroup(),
                  SizedBox(height: 20),
                  // if(controller.step.value!=1) Obx(() {
                  //   return Container(
                  //     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  //     decoration: Ui.getBoxDecoration(
                  //         color:
                  //             controller.getColor(!controller.scheduled.value)),
                  //     child: Theme(
                  //       data: ThemeData(
                  //         toggleableActiveColor: Get.theme.primaryColor,
                  //       ),
                  //       child: RadioListTile(
                  //         value: false,
                  //         groupValue: controller.scheduled.value,
                  //         onChanged: (value) {
                  //           controller.toggleScheduled(value);
                  //         },
                  //         title: Text("As Soon as Possible".tr,
                  //                 style: controller
                  //                     .getTextTheme(!controller.scheduled.value))
                  //             .paddingSymmetric(vertical: 20),
                  //       ),
                  //     ),
                  //   );
                  // }),
                  // if(controller.step.value!=1)   Obx(() {
                  //   return Container(
                  //     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  //     decoration: Ui.getBoxDecoration(
                  //         color: controller.getColor(controller.scheduled.value)),
                  //     child: Theme(
                  //       data: ThemeData(
                  //         toggleableActiveColor: Get.theme.primaryColor,
                  //       ),
                  //       child: RadioListTile(
                  //         value: true,
                  //         groupValue: controller.scheduled.value,
                  //         onChanged: (value) {
                  //           controller.toggleScheduled(value);
                  //         },
                  //         title: Text("Schedule an Order".tr,
                  //                 style: controller
                  //                     .getTextTheme(controller.scheduled.value))
                  //             .paddingSymmetric(vertical: 20),
                  //       ),
                  //     ),
                  //   );
                  // }),
                  // if(controller.step.value!=1)  Obx(() {
                  //   return AnimatedOpacity(
                  //     opacity: controller.scheduled.value ? 1 : 0,
                  //     duration: Duration(milliseconds: 300),
                  //     child: AnimatedContainer(
                  //       duration: Duration(milliseconds: 300),
                  //       margin: EdgeInsets.symmetric(
                  //           horizontal: 20,
                  //           vertical: controller.scheduled.value ? 20 : 0),
                  //       padding: EdgeInsets.symmetric(
                  //           horizontal: 20,
                  //           vertical: controller.scheduled.value ? 20 : 0),
                  //       decoration: Ui.getBoxDecoration(),
                  //       child: Column(
                  //         children: [
                  //           Row(
                  //             children: [
                  //               Expanded(
                  //                 child: Text(
                  //                     "When would you like us to come to your address?"
                  //                         .tr,
                  //                     style: Get.textTheme.bodyText1),
                  //               ),
                  //               SizedBox(width: 10),
                  //               MaterialButton(
                  //                 elevation: 0,
                  //                 onPressed: () {
                  //                   controller.showMyDatePicker(context);
                  //                 },
                  //                 shape: StadiumBorder(),
                  //                 color: Get.theme.accentColor.withOpacity(0.2),
                  //                 child: Text("Select a Date".tr,
                  //                     style: Get.textTheme.subtitle1),
                  //               ),
                  //             ],
                  //           ),
                  //           Divider(thickness: 1.3, height: 30),
                  //           Row(
                  //             children: [
                  //               Expanded(
                  //                 child: Text(
                  //                     "At What's time you are free in your address?"
                  //                         .tr,
                  //                     style: Get.textTheme.bodyText1),
                  //               ),
                  //               SizedBox(width: 10),
                  //               MaterialButton(
                  //                 onPressed: () {
                  //                   controller.showMyTimePicker(context);
                  //                 },
                  //                 shape: StadiumBorder(),
                  //                 color: Get.theme.accentColor.withOpacity(0.2),
                  //                 child: Text("Select a time".tr,
                  //                     style: Get.textTheme.subtitle1),
                  //                 elevation: 0,
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   );
                  // }),
                  // Obx(() {
                  //   return AnimatedContainer(
                  //     duration: Duration(milliseconds: 300),
                  //     transform: Matrix4.translationValues(0, controller.scheduled.value ? 0 : -110, 0),
                  //     child: Obx(() {
                  //       return Column(
                  //         children: [
                  //           Text("Requested Service on".tr).paddingSymmetric(vertical: 20),
                  //           Text('${DateFormat.yMMMMEEEEd(Get.locale.toString()).format(controller.booking.value.bookingAt)}', style: Get.textTheme.headline5),
                  //           Text('${DateFormat('HH:mm', Get.locale.toString()).format(controller.booking.value.bookingAt)}', style: Get.textTheme.headline3),
                  //           SizedBox(height: 20)
                  //         ],
                  //       );
                  //     }),
                  //   );
                  // })
                ],
              ),
            ),
          )),
    );
  }

  Widget buildBlockButtonWidget(Booking _booking) {
    // Get.theme.primaryColor=Colors.white;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Get.theme.accentColor.withOpacity(0.1),
        // color: Get.theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Get.theme.focusColor.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5)),
        ],
      ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, right: 20),
            child: Obx(() {
              if (!controller.selectPart.value.hasData)
                return Container();
              else
                return BookingRowWidget(
                  description: "Total Amount".tr,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Ui.getPrice(
                        controller.selectPart.value.price *
                            controller.quantity.value
                                .toDouble() /*_booking.getTotal()*/,
                        style: Get.textTheme.headline6),
                  ),
                );
            }),
          ),
          Obx(() {
            return BlockButtonWidget(
              text: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "add to cart".tr,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.headline6.merge(
                        TextStyle(color: Get.theme.primaryColor),
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      color: Get.theme.primaryColor, size: 20)
                ],
              ),
              color: Get.theme.accentColor,
              // onPressed: ()=>Get.toNamed(Routes.SETTINGS_ADDRESS_PICKER),
              onPressed: (!(Get.find<SettingsService>()
                              .address
                              .value
                              ?.isUnknown() ??
                          true)) &&
                      controller.selectPart.value.hasData
                  ? () async {
                      var product = controller.selectProduct.value;
                      var parts = controller.selectPart.value;
                      var cut = controller.selectCut.value;
                      controller.saveOrder2(MyOrder(
                          id_rest: "1",
                          rest_name: "ذبيحة",
                          id_food: product.id,
                          food_name: product.name,
                          size_id: cut ?? "0",
                          size_name: cut ?? "0",
                          color_id: "0",
                          color_name: "0",
                          total: controller.radval.value == 2 ? "0" : "1",
                          much: controller.quantity.value.toString(),
                          price: parts.price.toString(),
                          url: product.img,
                          part_id: parts.name_part,
                          part_name: parts.name_part));
                      Get.showSnackbar(
                          Ui.SuccessSnackBar(message: "تم الطلب بنجاح ".tr));
                      // await Get.toNamed(Routes.BOOKING_SUMMARY);
                    }
                  : null,
            ).paddingOnly(right: 20, left: 20);
          }),
        ],
      ),
    );
  }

  Widget buildBlockButtonWidget2(Booking _booking) {
    // Get.theme.primaryColor=Colors.white;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Get.theme.accentColor.withOpacity(0.1),
        // color: Get.theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Get.theme.focusColor.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5)),
        ],
      ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              children: [
                // SizedBox(
                //   height: 0,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Price".tr),
                    Obx(() {
                      return Text("${controller.total} ريال ");
                    }),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [Text("خصم"), Text("0.0 ريال ")],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Delivery price".tr), Text(" 0 ريال ")],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Price".tr,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                    ),
                    Obx(() => Text(
                          "${controller.total.value} ريال ",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ))
                  ],
                ),
              ],
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     // SizedBox(
          //     //   width: 20,
          //     // ),
          //     const Text("وقت التسليم "),
          //     Padding(
          //       padding: const EdgeInsets.only(bottom: 8.0, right: 20),
          //       child: Obx(() {
          //         if (!controller.Scadual.value)
          //           return Container(
          //             child: const Text("في اقرب وقت ممكن "),
          //           );
          //         else
          //           return Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Text(DateFormat.jm('ar').format(controller.dateinit),
          //                   style: Get.textTheme.headline2),
          //               const SizedBox(
          //                 width: 8,
          //               ),
          //               Text(
          //                   '${DateFormat.yMMMMEEEEd(Get.locale.toString()).format(controller.dateinit)}',
          //                   style: Get.textTheme.headline2),
          //             ],
          //           );
          //       }),
          //     ),
          //   ],
          // ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Obx(() {
                  return controller.request.value
                      ? CircularLoadingWidget(
                          height: 25,
                        )
                      : BlockButtonWidget(
                          text: Stack(
                            alignment: AlignmentDirectional.centerEnd,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  "Order execution".tr,
                                  textAlign: TextAlign.center,
                                  style: Get.textTheme.headline6.merge(
                                    TextStyle(color: Get.theme.primaryColor),
                                  ),
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios,
                                  color: Get.theme.primaryColor, size: 20)
                            ],
                          ),
                          color: Get.theme.accentColor,
                          // onPressed: ()=>Get.toNamed(Routes.SETTINGS_ADDRESS_PICKER),
                          onPressed: (!(Get.find<SettingsService>()
                                      .address
                                      .value
                                      ?.isUnknown() ??
                                  true))
                              ? () async {
                                  final authService = Get.find<AuthService>();
                                  bool auth = false;
                                  if (!authService.isAuth) {
                                    // auth=true;
                                    await Get.toNamed(Routes.LOGIN)
                                        .then((value) => auth = value);
                                  } else {
                                    auth = true;
                                  }
                                  if (auth == true) {
                                    controller.request.value = true;
                                    Shop shop = Get.find<AuthService>().shop.value;
                                    List<ProdItem> prods = [];
                                    try {
                                      FB_Order fb_order = FB_Order();
                                      fb_order.created_at = DateTime.now();
                                      fb_order.delevery_time =
                                          controller.dateinit;
                                      fb_order.total = controller.total.toInt();
                                      fb_order.tax=shop.tax;
                                      fb_order.totalWithTax=(controller.total.value+controller.total.value*shop.tax/100).toPrecision(2);
                                      fb_order.description =
                                          controller.booking.value.hint;
                                      fb_order.phone = authService.user.value.phone;
                                      fb_order.state = 1;
                                      fb_order.items =
                                          controller.oneCart3.map((element) {
                                        prods.add(ProdItem(
                                            name: element.food_name +
                                                    " / " +
                                                    element.part_name ??
                                                "",
                                            count: int.parse(element.much),
                                            price:
                                                double.parse(element.price)));
                                        return OItem(
                                            name_item: element.food_name,
                                            part: element.part_name,
                                            extra: int.parse(element.total) == 1
                                                ? true
                                                : false,
                                            price: int.parse(element.price),
                                            num: int.parse(element.much));
                                      }).toList();
                                      fb_order.token = await Get.find<
                                              FireBaseMessagingService>()
                                          .getToken();
                                      fb_order.location = Location(
                                          address: controller
                                              .currentAddress?.address,
                                          lat_lng: GeoPoint(
                                              controller
                                                  .currentAddress.latitude,
                                              controller
                                                  .currentAddress.longitude));
                                      // Get.to(() => FatoraView(prods));
                                      await FirebaseFirestore.instance
                                          .collection('orders')
                                          .add(fb_order.toJson())
                                          .catchError((e) {
                                        log("error 564 : " + e.toString());
                                      });
                                      // Shop shpp=Shop(sellerName: "محمد",vaTnumber: "142345378352432",storeName: "طلي",storeAddress: "ibb-street",storeCity: "yemen",storePhone: "+967772537707")
                                      Get.to(() => FatoraView(prods));
                                    } catch (e) {
                                      log("error 564 : " + e.toString());
                                    } finally {
                                      controller.request.value = false;
                                    }

                                    Get.showSnackbar(Ui.SuccessSnackBar(
                                        message: "تمت الاضافة للسلة ".tr));
                                    // await Get.toNamed(Routes.BOOKING_SUMMARY);
                                  } else {
                                    log("auth= false");
                                  }
                                }
                              : null,
                        ).paddingOnly(right: 20, left: 20);
                }),
              ),
              // Expanded(
              //   flex: 2,
              //   child: BlockButtonWidget(
              //     text: Container(
              //         height: 24,
              //         alignment: Alignment.center,
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Text(
              //               "جدولة   ",
              //               textAlign: TextAlign.center,
              //               style: Get.textTheme.headline6.merge(
              //                 TextStyle(color: Get.theme.cardColor),
              //               ),
              //             ),
              //             const Icon(Icons.timer_outlined),
              //           ],
              //         )),
              //     onPressed: () {
              //       controller.getScadual();
              //     },
              //     color: Get.theme.accentColor.withAlpha(150),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget count() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // color: Get.theme.accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        textDirection: TextDirection.ltr,
        children: [
          MaterialButton(
            height: 24,
            minWidth: 46,
            onPressed: controller.decrementQuantity2,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            color: Get.theme.accentColor,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(10))),
            child: Icon(Icons.remove, color: Get.theme.primaryColor, size: 28),
            elevation: 0,
          ),
          SizedBox(
            width: 38,
            child: Obx(() {
              return Text(
                controller.quantity.value.toString(),
                textAlign: TextAlign.center,
                style: Get.textTheme.subtitle2.merge(
                  TextStyle(color: Get.theme.accentColor),
                ),
              );
            }),
          ),
          MaterialButton(
            onPressed: controller.incrementQuantity2,
            height: 24,
            minWidth: 46,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            color: Get.theme.accentColor,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(10))),
            child: Icon(Icons.add, color: Get.theme.primaryColor, size: 28),
            elevation: 0,
          ),
          // Expanded(child: Container()),
          // Text("الكمية :"),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> getitems() {
    List<DropdownMenuItem<int>> r = List();
    r.add(DropdownMenuItem<int>(
      value: 1,
      child: Text("5 كيلو"),
    ));
    r.add(DropdownMenuItem<int>(
      value: 1,
      child: Text(" 5 كيلو حوار"),
    ));
    r.add(DropdownMenuItem<int>(
      value: 1,
      child: Text("10 كيلو"),
    ));
    return r;
  }

  _getIteem(List<Parts> option) {
    List<DropdownMenuItem<Parts>> list = [];
    if (option == null) return list;
    for (int r = 0; r < option.length; r++) {
      log(option[r].toJson().toString());
      list.add(DropdownMenuItem(
        // value: int.parse(build[r].B_id),
        value: option[r],
        child: Text(
          '    ${option[r].name_part}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ));
    }
    // list.add(DropdownMenuItem(
    //   value: build.length,
    //   child: Container(color: Colors.blueGrey.shade50,
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         children: [
    //           Icon(Icons.add_circle_rounded),
    //           Text('حجم آخر'),
    //         ],
    //       )),
    // ));
    return list;
  }

  _getIteem2(List<String> option) {
    List<DropdownMenuItem<String>> list = List();
    for (int r = 0; r < option.length; r++)
      list.add(DropdownMenuItem(
        // value: int.parse(build[r].B_id),
        value: option[r],
        child: Text(
          '     ${option[r]}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
      ));
    // list.add(DropdownMenuItem(
    //   value: build.length,
    //   child: Container(color: Colors.blueGrey.shade50,
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         children: [
    //           Icon(Icons.add_circle_rounded),
    //           Text('حجم آخر'),
    //         ],
    //       )),
    // ));
    return list;
  }

  void _showDeleteDialog2(BuildContext context2, int index, String namefood) {
    showDialog<void>(
      context: context2,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "حذف : " + namefood ?? "",
            style: const TextStyle(color: Colors.redAccent),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text("سيتم حذفه من السلة", style: Get.textTheme.bodyText1),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel".tr, style: Get.textTheme.bodyText1),
              onPressed: () {
                Navigator.pop(context);
                // Get.back();
              },
            ),
            TextButton(
              child: Text(
                "حذف".tr,
                style: const TextStyle(color: Colors.redAccent),
              ),
              onPressed: () async {
                Navigator.pop(context);
                // Get.back();
                await controller.deleteEFood(index);
                await controller.getThisOrder("1", false);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context2) {
    showDialog<void>(
      context: context2,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "حذف السلة".tr,
            style: const TextStyle(color: Colors.redAccent),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text("هل تريد ابقاء السلة للايام القادمة".tr,
                    style: Get.textTheme.bodyText1),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("ابقاء".tr, style: Get.textTheme.bodyText1),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context2);
                // Get.back();
                // Get.back();
              },
            ),
            TextButton(
              child: Text(
                "حذف".tr,
                style: const TextStyle(color: Colors.redAccent),
              ),
              onPressed: () async {
                int tt = await controller.deleteCart("1");
                // prints("----dd $tt");
                // Get.back();
                Navigator.pop(context);
                Navigator.pop(context2);
                // Get.back();
                // controller.deleteEService();
              },
            ),
          ],
        );
      },
    );
  }

  line(double i) => Container(
        width: Get.width - 40,
        height: i,
        color: Colors.grey.withAlpha(100),
      );
}

getimgUrl(String url, int i) {
  return url;
}

class CategoriesCarouselWidget2 extends GetWidget<BookEServiceController> {
  @override
  Widget build(BuildContext context) {
    controller.getCategories();
    return Container(
      height: 140,
      margin: EdgeInsets.only(bottom: 15),
      child: Obx(() {
        return ListView.builder(
            primary: false,
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemCount: controller.products.length,
            itemBuilder: (_, index) {
              var _category = controller.products.elementAt(index);
              return InkWell(
                onTap: () {
                  // Get.toNamed(Routes.CATEGORY, arguments: _category);
                  // controller.refreshveiw(_category.id);
                  controller.setOptions(_category.id);
                  controller.select.value = _category.id;
                  controller.setPrts(_category);

                  // controller.incrementQuantity();
                  // controller.decrementQuantity();
                  // controller.select.refresh();
                  // controller.currentSizeId.refresh();
                },
                child: Obx(() {
                  return Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsetsDirectional.only(
                        end: 20, start: index == 0 ? 20 : 0),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: new BoxDecoration(
                      border: (controller.select.value == _category.id)
                          ? Border.all(
                              width: 3,
                              color: Get.theme.focusColor.withOpacity(0.5),
                            )
                          : Border(),
                      gradient: new LinearGradient(
                          colors: [
                            Colors.blueAccent.withOpacity(0.7),
                            Colors.blueAccent.withOpacity(0.1)
                          ],
                          begin: AlignmentDirectional.topStart,
                          //const FractionalOffset(1, 0),
                          end: AlignmentDirectional.bottomEnd,
                          stops: [0.1, 0.9],
                          tileMode: TileMode.clamp),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(top: 30),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: (_category.img?.endsWith('.svg') ??
                                          false
                                      ? SvgPicture.network(
                                          _category.img,
                                          color: Colors.white,
                                        )
                                      : CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: _category.img,
                                          placeholder: (context, url) =>
                                              Image.asset(
                                            'assets/img/loading.gif',
                                            fit: BoxFit.cover,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error_outline),
                                        )),
                                ),
                              ),
                              Text(
                                _category.sub_name,
                                // maxLines: 2,
                                // style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 10, top: 0),
                          child: Text(
                            _category.name,
                            maxLines: 2,
                            style: Get.textTheme.headline6.merge(
                                TextStyle(color: Get.theme.primaryColor)),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              );
            });
      }),
    );
  }
}

class CustomDropDown extends StatelessWidget {
  final value;
  final String hint;
  final String errorText;
  final List<DropdownMenuItem<dynamic>> items;
  final Function onChanged;

  const CustomDropDown(
      {Key key,
      this.value,
      this.hint,
      this.items,
      this.onChanged,
      this.errorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              // color: Colors.grey[100],
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(10)),
          child: DropdownButton<dynamic>(
            // elevation: 10,
            value: value,
            hint: Text(
              hint,
              style: TextStyle(fontSize: 20),
              overflow: TextOverflow.ellipsis,
            ),
            style: Theme.of(context).textTheme.titleMedium,
            items: items,
            onChanged: (item) {
              onChanged(item);
            },
            underline: Container(),
            isExpanded: true,
            // underline: Container(),
            icon: Icon(Icons.keyboard_arrow_down),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(left: 30, top: 10),
            child: Text(
              errorText,
              style: TextStyle(fontSize: 12, color: Colors.red[800]),
            ),
          )
      ],
    );
  }
}

class RadioGroup extends StatefulWidget {
  @override
  RadioGroupWidget createState() => RadioGroupWidget();
}

class RadioGroupWidget extends State {
  // Default Radio Button Selected Item When App Starts.
  String radioButtonItem = 'Yes'.tr;

  // Group Value for Radio Button.
  int id = 1;

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(14.0),
            child: Text('الكرش والمصان  = ' + '$radioButtonItem',
                style: TextStyle(fontSize: 21))),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Radio(
              value: 1,
              groupValue: id,
              onChanged: (val) {
                setState(() {
                  radioButtonItem = 'ONE';
                  id = 1;
                });
              },
            ),
            Text(
              'ONE',
              style: new TextStyle(fontSize: 17.0),
            ),
            Radio(
              value: 2,
              groupValue: id,
              onChanged: (val) {
                setState(() {
                  radioButtonItem = 'TWO';
                  id = 2;
                });
              },
            ),
            Text(
              'TWO',
              style: new TextStyle(
                fontSize: 17.0,
              ),
            ),
            Radio(
              value: 3,
              groupValue: id,
              onChanged: (val) {
                setState(() {
                  radioButtonItem = 'THREE';
                  id = 3;
                });
              },
            ),
            Text(
              'THREE',
              style: new TextStyle(fontSize: 17.0),
            ),
          ],
        ),
      ],
    );
  }
}
