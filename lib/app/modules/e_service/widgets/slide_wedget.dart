import 'dart:developer';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';
// import 'package:home_services/app/models/food_model.dart';
// import 'package:home_services/app/models/tahseel_model.dart';
// import 'package:home_services/app/module/clothes/controller/clothes_controller.dart';
// import 'package:home_services/app/module/home/widgets/recommended_carousel_widget.dart';
// import 'package:home_services/app/models/ataa_models/daemataaModel.dart';

import '../../../../common/ui.dart';
// import '../../../models/slide_model.dart';
// import '../../../../whatsapp.dart';

import 'ICard20FileCaching.dart';

class SlideItemWidget2 extends StatelessWidget {
  // final Food2 slide;
  final String slide;

  const SlideItemWidget2({
    this.slide,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Transform(
        //   alignment: Alignment.center,
        //   transform: Matrix4.rotationY(Directionality.of(context) == TextDirection.rtl ? math.pi : 0),
        //   child: CachedNetworkImage(
        //     width: double.infinity,
        //     height: 310,
        //     fit: Ui.getBoxFit("cover"),
        //     imageUrl: getimgUrl( slide.img,1),
        //     placeholder: (context, url) => Image.asset(
        //       'assets/img/loading.gif',
        //       fit: BoxFit.cover,
        //       width: double.infinity,
        //     ),
        //     errorWidget: (context, url, error) => Icon(Icons.error_outline),
        //   ),
        // ),
        // ICard20FileCaching(
        //   shadow: 40,
        //   radius: 15,
        //   color: Colors.grey.shade100,
        //   direction: TextDirection.rtl,
        //   colorProgressBar: Colors.blueAccent,
        //   text: "${slide.name}",
        //   text2: "${slide.des}",
        //   cost:slide.cost,
        //   old:slide.old,
        //   text3: "_dist",
        //   width: Get.width-40,
        //   height: 200,
        //   image: getimgUrl(slide.img, 1),
        //   // colorRoute: theme.colorPrimary,
        //   id: slide.id,
        //   // title: theme.text18boldPrimaryUI,
        //   // body: theme.text16UI,
        //   callback: _onRestaurantClick,
        //   callbackNavigateIcon: _onTopRestaurantNavigateIconClick,
        // ),
        ICard20FileCaching(
          shadow: 100,
          radius: 10,
          color: Colors.grey.shade100,
          direction: TextDirection.rtl,
          colorProgressBar: Colors.blueAccent,
          text: "",
          text2: "",
          // cost:slide.cost,
          // old:slide.old,
          text3: "",
          width: Get.width,
          // height: 200,
          image: getimgUrlImage(slide),
          // colorRoute: theme.colorPrimary,
          id: "",
          // title: theme.text18boldPrimaryUI,
          // body: theme.text16UI,
          callback: _onRestaurantClick,
          callbackNavigateIcon: _onTopRestaurantNavigateIconClick,
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.all(10.0),
        //       child: Container(
        //         decoration: Ui.getBoxDecoration(
        //           radius: 14,
        //           border: Border.all(width: 5, color: Get.theme.primaryColor),
        //         ),
        //
        //         child: ClipRRect(
        //           borderRadius: BorderRadius.all(Radius.circular(10)),
        //           child: CachedNetworkImage(
        //             height: 100,
        //             width: 100,
        //             fit: BoxFit.cover,
        //             imageUrl: "http://www.daem-ataa.net/frontend/images/placeholder/profile-2.webp",
        //             placeholder: (context, url) => Image.asset(
        //               "assets/img/profile-2.webp",
        //               fit: BoxFit.cover,
        //               width: double.infinity,
        //               height: 100,
        //             ),
        //             errorWidget: (context, url, error) => Icon(Icons.error_outline),
        //           ),
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.only(top: 18.0),
        //       child: SizedBox(width: 7,height:80 , child: Container(color: Color.fromRGBO(77, 77, 77, 0.6),),),
        //     ),
        //
        //   ],
        // ),

      ],
    );
  }

  _onRestaurantClick(BuildContext context,String id, String hero, String p1) {
    // print("--- ${slide.web}");
    // if(slide.web!=null&&slide.web!="0"&&slide.web!=""&&slide.web.length>4)
    //   launchUrl(Uri.parse("${slide.web}"),mode: LaunchMode.externalApplication);
  }
  _onTopRestaurantNavigateIconClick(String id) {
  }

}

getimgUrl(String s) {
  // Uri getApiBaseUri3(String s) {
    var u="https://njaze.com/njaz/";
    // https://njaze.com/njaz/users/‏‏read.php?start=0&end=10&token=wjeiwenwejwkejwke98w9e8wewnew8wehwenj232jh32j3h2jzzxx
    return u+s;

}
getimgUrlImage(String s) {
  // Uri getApiBaseUri3(String s) {
    var u="";

    // https://njaze.com/njaz/users/‏‏read.php?start=0&end=10&token=wjeiwenwejwkejwke98w9e8wewnew8wehwenj232jh32j3h2jzzxx
    return u+s;
}
