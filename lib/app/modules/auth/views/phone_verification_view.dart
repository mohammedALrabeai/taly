import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../models/setting_model.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';

class PhoneVerificationView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;

  @override
  Widget build(BuildContext context) {
    controller.sendCodeFormKey = new GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Phone Verification".tr,
              style: Get.textTheme.headline6.merge(TextStyle(color: context.theme.primaryColor)),
            ),
            centerTitle: true,
            backgroundColor: Get.theme.accentColor,
            automaticallyImplyLeading: false,
            elevation: 0,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
              onPressed: () => {Get.back()},
            ),
          ),
          body: Form(
            key: controller.sendCodeFormKey,
            child: ListView(
              primary: true,
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Container(
                      height: 180,
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: Get.theme.accentColor,
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(color: Get.theme.focusColor.withOpacity(0.2), blurRadius: 10, offset: Offset(0, 5)),
                        ],
                      ),
                      margin: EdgeInsets.only(bottom: 50),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              "اطلب من ذبيحة",
                              style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor, fontSize: 24)),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "مرحبا بكم .......!".tr,
                              style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor)),
                              textAlign: TextAlign.center,
                            ),
                            // Text("Fill the following credentials to login your account", style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: Ui.getBoxDecoration(
                        radius: 14,
                        border: Border.all(width: 5, color: Get.theme.primaryColor),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Image.asset(
                          'assets/icon/icon.png',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  ],
                ),
                Obx(() {
                  if (controller.loading.isTrue) {
                    return CircularLoadingWidget(height: 300);
                  } else {
                    return Directionality(
                      textDirection: TextDirection.ltr,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "ادخل رقم الهاتف".tr,
                            style: Get.textTheme.bodyText1,
                            textAlign: TextAlign.center,
                          ).paddingSymmetric(horizontal: 20, vertical: 20),
                          // TextFieldWidget(
                          //   labelText: "your number".tr,
                          //   hintText: "- - - - - -".tr,
                          //   style: Get.textTheme.headline4.merge(TextStyle(letterSpacing: 8)),
                          //   textAlign: TextAlign.center,
                          //   keyboardType: TextInputType.number,
                          //   onChanged: (input) => controller.smsSent.value = input,
                          //   // iconData: Icons.add_to_home_screen_outlined,
                          // ),
                          TextFieldWidget(
                            labelText: "Phone Number".tr,
                            hintText: "+1 223 665 7896".tr,
                            initialValue: controller.currentUser?.value?.phone,
                            onSaved: (input) {
                              if (input.startsWith("00")) {
                                input = "+" + input.substring(2);
                              }
                              return controller.currentUser.value.phone = input;
                            },
                            validator: (input) {
                              return !input.startsWith('\+') && !input.startsWith('00') ? "Should be valid mobile number with country code" : null;
                            },
                            iconData: Icons.phone_android_outlined,
                            keyboardType: TextInputType.phone,
                            isLast: false,
                            isFirst: false,
                            suffixIcon: TextButton(
                              onPressed: () {
                                // controller.sendcod();
                                controller.resendOTPCode();
                              },
                              // color: Theme.of(context).focusColor,
                              // icon: Icon(controller.hidePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                              child: Text("ارسل كود"),
                            ),
                          ),
                          // BlockButtonWidget(
                          //   onPressed: () async {
                          //     await controller.verifyPhone();
                          //   },
                          //   color: Get.theme.accentColor,
                          //   text: Text(
                          //     "Verify".tr,
                          //     style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                          //   ),
                          // ).paddingSymmetric(vertical: 30, horizontal: 20),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     TextButton(
                          //       onPressed: () {
                          //         controller.resendOTPCode();
                          //       },
                          //       child: Text("Resend the OTP Code Again".tr),
                          //     ),
                          //   ],
                          // )
                        ],
                      ),
                    );
                  }
                }),
                Obx(() {
                  if (controller.loading.isTrue) {
                    return CircularLoadingWidget(height: 300);
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Text(
                        //   "We sent the OTP code to your phone, please check it and enter below".tr,
                        //   style: Get.textTheme.bodyText1,
                        //   textAlign: TextAlign.center,
                        // ).paddingSymmetric(horizontal: 20, vertical: 20),
                        TextFieldWidget(
                          labelText: "OTP Code".tr,
                          hintText: "- - - - - -".tr,
                          style: Get.textTheme.headline4.merge(TextStyle(letterSpacing: 8)),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          onChanged: (input) => controller.smsSent.value = input,
                          // iconData: Icons.add_to_home_screen_outlined,
                        ),
                        BlockButtonWidget(
                          onPressed: () async {
                            print("ddddddddddddddddd");
                            await controller.verifyPhone();
                          },
                          color: Get.theme.accentColor,
                          text: Text(
                            "Verify".tr,
                            style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                          ),
                        ).paddingSymmetric(vertical: 30, horizontal: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                controller.resendOTPCode();
                              },
                              child: Text("Resend the OTP Code Again".tr),
                            ),
                          ],
                        )
                      ],
                    );
                  }
                })
              ],
            ),
          )),
    );
  }

}
