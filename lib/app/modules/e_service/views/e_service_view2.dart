import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../../models/media_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/e_service_controller.dart';
import '../widgets/e_provider_item_widget.dart';
import '../widgets/e_service_til_widget.dart';
import '../widgets/e_service_title_bar_widget.dart';
import '../widgets/option_group_item_widget.dart';
Color mcolor=Color(0xff575757);
Color scolor=Color(0xfff8f5f2);
class EServiceView extends GetView<EServiceController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var _eService = controller.eService.value;
      if (_eService.hasData) {
        return Scaffold(
          body: CircularLoadingWidget(height: Get.height),
        );
      } else {
        return Scaffold(
          // backgroundColor: Colors.white,
          // backgroundColor: Color(0xffE3CB81),
          // bottomNavigationBar: buildBottomWidget(_eService),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  // color: Color(0xffF4841F),
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Color(0xffE3CC82),
                          Color(0xffE8D588),
                          // Color(0xffF4841F),
                          // Color(0xffF4841F),
                          // Color(0xffee9d54),
                          // Color(0xfff5af72),

                          Color(0xffE9D287),
                        ]),
             ),
              ),
              // Image.asset("assets/img/background.jpg",fit: BoxFit.fill,),
              SafeArea(
                child: Column(
                mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset("assets/icon/icon4.png",height: 150,).paddingSymmetric(horizontal: 20,vertical: 20),
                    CupertinoActivityIndicator(radius: 20,),
                    // SizedBox(height: 10),
                    // buildCategories(_eService),
                    // Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: <Widget>[
                    //     const SizedBox(width: 20.0, height: 0.0),
                    //      Text(
                    //       'Welcome to'.tr,
                    //       style: TextStyle(fontSize: 18.0,color: mcolor),
                    //     ),
                    //     const SizedBox(width: 20.0, height: 0.0),
                    //     DefaultTextStyle(
                    //       style:  TextStyle(
                    //         fontSize: 20.0,
                    //         color: mcolor,
                    //         fontWeight: FontWeight.w900,
                    //         // fontFamily: 'Horizon',
                    //       ),
                    //       child: AnimatedTextKit(
                    //         repeatForever: true,
                    //         isRepeatingAnimation: false,
                    //         animatedTexts: [
                    //           RotateAnimatedText('تطبيق ذبيحة',rotateOut: false),
                    //
                    //         ],
                    //         onTap: () {
                    //           print("Tap Event");
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // EServiceTilWidget(
                    //   decore: false,
                    //   title: Text("التطبيق الأفضل لطلب اللحوم الطازجة".tr, style: Get.textTheme.subtitle2.copyWith(color: scolor)),
                    //   content: SizedBox(
                    //     height: 20,
                    //     child: DefaultTextStyle(
                    //       style:  TextStyle(
                    //         fontSize: 15.0,
                    //         color: scolor,
                    //         // fontFamily: 'Bobbers',
                    //       ),
                    //       child: AnimatedTextKit(
                    //         pause: Duration(seconds: 2),
                    //         animatedTexts: [
                    //           TypewriterAnimatedText('لحوم طازجة عالية الجودة',speed: Duration(milliseconds: 100)),
                    //           TypewriterAnimatedText('منح خيارات غير محدودة من اللحوم والقطع',speed: Duration(milliseconds: 100)),
                    //           TypewriterAnimatedText('سهولة الطلب',speed: Duration(milliseconds: 100)),
                    //           TypewriterAnimatedText('مباشرة حدد طلبك واحجز من مكانك',speed: Duration(milliseconds: 100)),
                    //           TypewriterAnimatedText('لحم بلدي طازج',speed: Duration(milliseconds: 100)),
                    //           TypewriterAnimatedText('الذبح والتغليف مسحوب الهواء',speed: Duration(milliseconds: 100)),
                    //           TypewriterAnimatedText('لحوم طازجة عالية الجودة',speed: Duration(milliseconds: 100)),
                    //         ],
                    //         onTap: () {
                    //           print("Tap Event");
                    //         },
                    //       ),
                    //     ),
                    //   )
                    //   // content: Ui.applyHtml(_eService.description, style: Get.textTheme.bodyText1),
                    // ),
                    //
                    // ListTile(
                    //   title: Text(
                    //     "مزايا الطلب معنا  ",
                    //     style: TextStyle(
                    //         color: mcolor,
                    //         fontWeight: FontWeight.w900,
                    //         fontSize: 17),
                    //   ),
                    // ),
                    //
                    // ListTile(
                    //   leading: Icon(Icons.check_circle_rounded,color: Colors.green,),
                    //   title: Text(
                    //     "لحوم طازجة عالية الجودة ",
                    //     style: TextStyle(
                    //         color: mcolor,
                    //         fontWeight: FontWeight.w900,
                    //         fontSize: 16),
                    //   ),
                    //   subtitle: Text(
                    //     "منح خيارات غير محدودة من اللحوم والقطع.",
                    //     // "اطلب اللحوم الطازجة  من خلال التوصيل السريع للباب.",
                    //     style: Get.textTheme.caption
                    //         .merge(TextStyle(color: scolor, fontSize: 15)),
                    //   ),
                    // ),
                    //
                    // //رؤية لتوفير لحوم طازجة عالية الجودة
                    // // ، ومنح الناس خيارات غير محدودة من اللحوم والقطع  مباشرة من منازلهم المريحة .
                    // ListTile(
                    //   leading: Icon(Icons.electric_bolt_outlined,color: Colors.orange,),
                    //   title: Text(
                    //     "سهولة الطلب ",
                    //     style: TextStyle(
                    //         color: mcolor,
                    //         fontWeight: FontWeight.w900,
                    //         fontSize: 16),
                    //   ),
                    //   subtitle: Text(
                    //     "مباشرة حدد طلبك واحجز من مكانك. ",
                    //     style: Get.textTheme.caption
                    //         .merge(TextStyle(color: scolor, fontSize: 15)),
                    //   ),
                    // ),
                    // ListTile(
                    //   leading: Icon(Icons.health_and_safety,color: Colors.blue[800],),
                    //   title: Text(
                    //     "لحم بلدي طازج  ",
                    //     style: TextStyle(
                    //         color: mcolor,
                    //         fontWeight: FontWeight.w900,
                    //         fontSize: 16),
                    //   ),
                    //   subtitle: Text(
                    //     "الذبح والتغليف مسحوب الهواء  ",
                    //     style: Get.textTheme.caption
                    //         .merge(TextStyle(color: scolor, fontSize: 15)),
                    //   ),
                    // ),
                    SizedBox(
                      height: 19,
                    ),

                  ],
                ),
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child:buildBottomWidget(_eService),
              // )
            ],
          ),
        );
      }
    });
  }













  Widget buildBottomWidget(EService _eService) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        // boxShadow: [
        //   BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
        // ],
      ),
      child: Row(
        children: [


          Expanded(
            child: BlockButtonWidget(
                text: Container(
                  height: 24,
                  alignment: Alignment.center,
                  child: Text(
                    "Start buying".tr,
                    textAlign: TextAlign.center,
                    style: Get.textTheme.headline6.merge(
                      TextStyle(color: Get.theme.primaryColor),
                    ),
                  ),
                ),
                // color: Get.theme.accentColor,
                color: mcolor,
                onPressed: () {
                  if(!Get.find<AuthService>().isAuth) {
                    Get.toNamed(Routes.SETTINGS_ADDRESS_PICKER);
                  }else{
                    Get.toNamed(Routes.BOOK_E_SERVICE);
                  }
                  // Get.toNamed(Routes.BOOK_E_SERVICE, arguments: {'eService': _eService, 'options': controller.getCheckedOptions(), 'quantity': controller.quantity.value});
                }),
          ),
          IconButton(onPressed: (){
            Get.toNamed(Routes.SETTINGS_LANGUAGE);
          }, icon: Icon(Icons.language,color: Colors.white,))
        ],
      ).paddingOnly(right: 20, left: 20),
    );
  }
}
