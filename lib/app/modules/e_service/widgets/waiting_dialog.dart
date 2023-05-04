import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../services/auth_service.dart';


class WaitingDialog extends StatefulWidget {
  const WaitingDialog({Key key}) : super(key: key);

  @override
  State<WaitingDialog> createState() => _WaitingDialogState();
}

class _WaitingDialogState extends State<WaitingDialog> {
  var windowWidth;

  bool value = false;
  bool auth = true;
  // var windowHeight;

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<AuthService>();
    // if(widget.mainS) plus=20;
    windowWidth = MediaQuery.of(context).size.width;
    // windowHeight = MediaQuery.of(context).size.height;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 25,
      backgroundColor: Colors.transparent,
      child: Container(
        width: windowWidth,
        height: 290,
        padding: EdgeInsets.only(
          left: 10,
          top: 10,
          right: 10,
        ),
        margin: EdgeInsets.only(top: 45, bottom: 45),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black, offset: Offset(0, 5), blurRadius: 10),
            ]),
        child: Column(
          children: [
            SizedBox(
              width: windowWidth - 20,
              child: Obx(
                () => ListTile(

                        onTap: () {},
                        // leading: Text("Phone Number".tr),
                        title: Text("Phone Number".tr,textAlign: TextAlign.center,),
                        subtitle: Text(
                                        controller.user.value.phone??"..",
                                        style: Get.textTheme.headline3,
                          textAlign: TextAlign.center,
                                      ),
                        // trailing: Container(
                        //   height: 80,
                        //   width: 105,
                        //   decoration: BoxDecoration(shape: BoxShape.circle),
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.circular(50),
                        //     child: ElevatedButton(onPressed: (){
                        //       controller.removeCurrentUser();
                        //       Get.back();
                        //     }, child: Text("Logout".tr,textAlign: TextAlign.center,),
                        //     ),
                        //   ),
                        // ),
                      ),
              ),
            ),
            SizedBox(
              width: windowWidth - 20,
              child: Container(
                height: 60,
                width: 105,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: ElevatedButton(onPressed: (){
                    controller.removeCurrentUser();
                    Get.back();
                  }, child: Text("Logout".tr,textAlign: TextAlign.center,),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: windowWidth - 20,
              child: Container(
                height: 60,
                width: 105,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.redAccent)),
                    onPressed: (){
                    controller.removeCurrentUser();
                    Get.back();
                  }, child: Text("Delete Account".tr,textAlign: TextAlign.center,),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
