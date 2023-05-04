import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../global_widgets/grid_item_view.dart';
import '../controllers/products_controller.dart';
import '../widgets/slide_wedget.dart';
import '../widgets/waiting_dialog.dart';
import '../widgets/wallet_transactions_loading_list_widget.dart';
import 'contact_us_view.dart';

class ProductView extends GetView<ProductsController> {
  const ProductView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              )),
          IconButton(
              onPressed: () {
                Get.to(()=>ContactUs());
              },
              icon: Icon(
                Icons.contact_support_rounded,
                color: Colors.black38,
              )),
          // IconButton(
          //     onPressed: () {
          //       Get.toNamed(Routes.BOOK_E_SERVICE);
          //     },
          //     icon: Icon(
          //       Icons.sensor_occupied_rounded,
          //       color: Colors.black38,
          //     )),
          IconButton(
              onPressed: () {
                Get.toNamed(Routes.BOOK_E_SERVICE);
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.black38,
              )),
          Obx(()=>
          (controller.user.value.auth??false)?
          IconButton(
              onPressed: () {
                 showGeneralDialog(
                barrierColor: Colors.black.withOpacity(0.5),
                transitionBuilder: (context, a1, a2, widget) {
                  final curvedValue = Curves.easeInOut.transform(a1.value) -
                      1.0; //easeInOutBack.transform(a1.value) -   1.0;
                  return Transform(
                    transform: Matrix4.translationValues( curvedValue * 200,20.0, 0.0),
                    // scale: a1.value,
                    child: Opacity(
                        opacity: a1.value, child: WaitingDialog()
                      // AlertDialog(
                      //   shape: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(16.0)),
                      //   title: Text('Hello!!'),
                      //   content: Text('How are you?'),
                      // ),
                    ),
                  );
                },
                transitionDuration: Duration(milliseconds: 500),
                barrierDismissible: true,
                barrierLabel: '',
                context: context,
                pageBuilder: (context, animation1, animation2) {
                  // return supportDialog(callback: callback);
                });
              },
              icon: Icon(
                Icons.person,
                color: Colors.black38,
              )): IconButton(
              onPressed: () {
                 Get.toNamed(Routes.LOGIN);
              },
              icon: Icon(
                Icons.login,
                color: Colors.black38,
              ))),
        ],
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.getDiary();
            await controller.getAdv();
          },
          child: Column(
            children: [
              SizedBox(
                // height: 150 ,
                child: Slivess(),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 10.0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.stretch,
              //     children: const [
              //       Text(
              //         'This week\'s latest 😍😋',
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           fontSize: 20,
              //         ),
              //       ),
              //       Text(
              //         'Shop for the most amazing items 2023 needs!',
              //         style: TextStyle(
              //           color: Colors.grey,
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              Obx(
                () => Expanded(
                  child: ListView(
                    children: [
                      controller.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.deepOrange,
                              ),
                            )
                          : GridItemView(
                              controller.products,
                            ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Slivess() {
    return Obx(() {
      if (controller.eAdvItem.isEmpty)
        return WalletTransactionsLoadingListWidgetMain(
          count: 1,
        );
      return Stack(
        alignment: controller.eAdvItem.isEmpty
            ? AlignmentDirectional.topCenter
            : AlignmentDirectional.bottomEnd,
        // Ui.getAlignmentDirectional("bottom_end"),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 0,
            ),
            child: CarouselSlider(
              options: CarouselOptions(
                // aspectRatio: 2,

                autoPlay: true,
                autoPlayInterval: Duration(seconds: 5),
                height: 170,
                viewportFraction: 1.0,
                // aspectRatio: 1,
                // enlargeStrategy: CenterPageEnlargeStrategy.height,
                // disableCenter: true,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  controller.currentSlide2.value = index;
                },
              ),
              items: controller.eAdvItem.map((String slide) {
                return InkWell(
                    onTap: () {
                      // print("--- ${slide.web}");
                    },
                    child: SlideItemWidget2(slide: slide));
              }).toList(),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: controller.eAdvItem.map((String slide) {
                return Container(
                  width: 7.0,
                  height: 7.0,
                  // margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: controller.currentSlide2.value !=
                          controller.eAdvItem.indexOf(slide)
                          ? Colors.orange.withOpacity(0.2)
                          : Colors.orange.withOpacity(0.6)),
                );
              }).toList(),
            ),
          ),
        ],
      );
    });
    // ).marginOnly(bottom: 42);
  }
}
