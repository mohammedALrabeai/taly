import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../common/ui.dart';
import '../../../models/my_order_model.dart';
import '../../../models/products_model.dart';
import '../../../routes/app_routes.dart';
import '../../book_e_service/views/book_e_service_view.dart';
import '../controllers/product_detail_controller.dart';

// ignore: use_key_in_widget_constructors

class ProductDetails extends GetView<ProductDetailController> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    showImageModal(context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: const EdgeInsets.all(12),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                    width: double.infinity,
                    fit: BoxFit.cover,
                    image: NetworkImage(controller.productDetails.value.img),
                  ),
                ),
                Positioned(
                  right: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(controller.productDetails.value.name),
                          const SizedBox(width: 5),
                          // Text(
                          //   '\$${controller.productDetails.value.price}',
                          //   style: const TextStyle(
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                )
              ]),
            ),
          );
        },
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            // IconButton(
            //   icon: Icon(
            //     controller.productDetails.value.isItemOnFavorite(productDetails)
            //         ? CupertinoIcons.heart_fill
            //         : CupertinoIcons.heart,
            //     color: Colors.deepOrange,
            //   ),
            //   onPressed: () => setState(
            //     () {
            //       productData
            //           .toggleItemtoFavirite(productDetails);
            //     },
            //   ),
            // ),
          ]),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Hero(
              tag: controller.productDetails.value.id,
              child: GestureDetector(
                onTap: () => showImageModal(context),
                child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.zero,
                      bottom: Radius.circular(100),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: controller.productDetails.value.img,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                    // Image.network(
                    //   productDetails.imageUrl,
                    //   fit: BoxFit.cover,
                    //   width: double.infinity,
                    // ),
                    ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      controller.productDetails.value.name,
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.deepOrange, size: 15),
                        Icon(Icons.star, color: Colors.deepOrange, size: 15),
                        Icon(Icons.star, color: Colors.deepOrange, size: 15),
                        Icon(Icons.star, color: Colors.deepOrange, size: 15),
                        Icon(Icons.star, color: Colors.deepOrange, size: 15),
                        SizedBox(width: 20),
                        Text(
                          controller.productDetails.value.sub_name,
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    count(),
                    const SizedBox(height: 5),
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
                                      items: _getIteem(controller
                                          .productDetails.value.parts),
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

                    Obx(() {
                      if (controller.productDetails.value.cuts?.isEmpty ?? true)
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
                                            .productDetails.value.cuts),
                                        onChanged: (value) {
                                          controller.selectCut.value = value;
                                          // controller.refresh();
                                        }),
                                  ),
                                ],
                              )),
                        );
                    }),
                    Row(
                      children: [
                        // Text(
                        //   '\$${productDetails.price.toString()}',
                        //   style: const TextStyle(
                        //     fontSize: 20,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        const SizedBox(width: 3),
                        // Text(
                        //   '\$${productDetails.previousPrice.toString()}',
                        //   style: const TextStyle(
                        //     fontSize: 15,
                        //     color: Colors.grey,
                        //     decoration: TextDecoration.lineThrough,
                        //   ),
                        // ),
                      ],
                    ),

                    // const SizedBox(height: 10),
                    Obx(() {
                      return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          // decoration: Ui.getBoxDecoration(),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "الكرش والمصران".tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
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
                                      child: Text(
                                    "Yes".tr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  )),

                                  Radio<int>(
                                    value: 2,
                                    groupValue: controller.radval.value,
                                    onChanged: (value) {
                                      controller.radval.value = value;
                                    },
                                  ),
                                  Expanded(
                                      child: Text(
                                    "No".tr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  )),
                                  SizedBox(width: 4),
                                  // MaterialButton(
                                  //   padding: EdgeInsets.symmetric(
                                  //       vertical: 10, horizontal: 14),
                                  //   onPressed: () {
                                  //     Get.toNamed(
                                  //         Routes.SETTINGS_ADDRESS_PICKER);
                                  //   },
                                  // )
                                ])
                              ]));
                    }),
                    const SizedBox(height: 10),

                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () async {
                        var product = controller.productDetails.value;
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
                        Get.showSnackbar(Ui.SuccessSnackBar(
                            message: "تمت الاضافة للسلة ".tr));
                        // await Get.toNamed(Routes.BOOKING_SUMMARY);
                      },
                      child:
                          Text(false ? 'Remove from Cart' : 'add to cart'.tr),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () => {Get.toNamed(Routes.BOOK_E_SERVICE)},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(false
                              ? 'Remove from Cart'
                              : 'الذهاب الى السلة'.tr),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.shopping_cart)
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget count() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [

        Container(
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
        ),
        Row(
          children: [
            Obx(()=> Text(
              '${controller.getprice(controller.selectPart.value)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            ),
            const SizedBox(
              width: 2,
            ),
            Text(
              "default_currency".tr,
              style: const TextStyle(
                // decoration: TextDecoration.lineThrough,
                fontSize: 11,
              ),
            )
          ],
        ),
      ],
    );
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
}
