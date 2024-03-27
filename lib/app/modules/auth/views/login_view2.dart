import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../services/auth_service.dart';
import '../../e_service/views/e_service_view2.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/login_controller2.dart';




class LoginView2 extends GetView<LoginController2> {
  const LoginView2({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80,),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: IconButton(
                      iconSize: 50,
                      onPressed: (){
                        Get.back();
                      }, icon: Container(
                    // height: 200,
                    // width: 150,
                    decoration: BoxDecoration(
                      color: Get.theme.primaryColor.withAlpha(50),
                        border: Border.all(),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.keyboard_arrow_left_outlined,),
                  )),
                ),

                 Text(
                  'Login'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(height: 20,),
                ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset("assets/icon/icon4.png",height: 150,)),
             SizedBox(height: 20,),
             Obx(() =>controller.steps.value==3? OtpView():  LoginV())
              ],
            ).paddingOnly(left: 10),

        ),
      ),
    );
  }
LoginV(){
    return Column(
      children: [
        // Row(
        //   children: const [
        //     Text(
        //       '*Enter Your Email ',
        //       style: TextStyle(fontSize: 20),
        //     ),
        //   ],
        // ),
        Obx(() => (controller.steps.value != 2)
            ? Text("يرجى إدخال رقم هاتفك   ".tr)
            : Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceAround,
              children: [
                Text(
                    "${controller.currentUser.value.phone}"),
                TextButton(
                    onPressed: () {
                      controller.steps.value = 1;
                    },
                    child: Text("استخدام رقم آخر".tr))
              ],
            ),
            Text("يرجى ادخال كلمة السر   ".tr),
          ],
        )),
        Obx(
              ()=> (controller.steps.value != 1)
              ? Container()
              : TextFieldWidget(
                // iconData: Icons.add,
                perffixIcon: dropCode(codes,Get.find<AuthService>().selectedCode.value,(cod){
                  Get.find<AuthService>().selectedCode.value=cod;
                  controller
                      .currentUser.value.code=cod.id;

                }),
            keyboardType: TextInputType.phone,
            onSaved: (input)=>controller.currentUser.value.phone=input,
            validator: (input)=>GetUtils.isPhoneNumber("${controller.currentUser.value.code}${input}")?null:"Invalid phone",
            textAlign: TextAlign.center,),
        ),
        const SizedBox(height: 20,),
        // Row(
        //   children: const [
        //     Text(
        //       '*Enter  Your Password ',
        //       textAlign: TextAlign.start,
        //       style: TextStyle(fontSize: 20),
        //     ),
        //   ],
        // ),


        const SizedBox(height: 20,),
        Obx(
              ()=>  BlockButtonWidget(
                  text: Container(
                    height: 24,
                    alignment: Alignment.center,
                    child: Text(
                      "LOGIN".tr,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.headline6.merge(
                        TextStyle(color: Get.theme.primaryColor),
                      ),
                    ),
                  ),
                  // color: Get.theme.accentColor,
                  color: mcolor,
                  onPressed: controller.loading.value? null:controller.mainLogin),
        ),
      ],
    );
}
  OtpView() {
    return  Obx(
          () => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                //   "اهلا بك في كابتن نجاز ",
                "التحقق من رقم الهاتف ".tr,
                style: TextStyle(
                    fontSize: 19, fontWeight: FontWeight.w900),
              ),
              TextButton(
                  onPressed: () {
                    controller.steps.value = 1;
                  },
                  child: Text("رجوع".tr))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("${controller.currentUser.value.phone}"),
              TextButton(
                  onPressed: () {
                    controller.steps.value = 1;
                  },
                  child: Text("استخدام رقم آخر".tr))
            ],
          ),
          if (!controller.send_done.value)
            Text(
                " جاري إرسال رمز التحقق الى هاتفك يرجى الانتظار ".tr),
          if (controller.send_done.value)
            Text(
              " لقد ارسلنا رمز الى الرقم ${Get.find<AuthService>().user.value.phone} يرجى التحقق من ذلك وكتابته ادناه, "
                  .tr,
              style: Get.textTheme.bodyText1,
              textAlign: TextAlign.center,
            ).paddingSymmetric(horizontal: 20, vertical: 20),

          if (!controller.send_done.value)
            CupertinoActivityIndicator(),
          if (controller.send_done.value)
            TextFormField(
              textAlign: TextAlign.center,
              maxLength: 6,

              onTap: () {
                // controller.foucse.value = true;
                // controller.foucse2.value = false;
              },
              //   toolbarOptions: ToolbarOptions(),
              onEditingComplete: () {
                // controller.foucse.value = false;
                // controller.foucse2.value = false;
                // Get.focusScope.unfocus();
              },

              keyboardType: TextInputType.number,
              onChanged: (input) {
                // if (input.startsWith("00")) {
                //   input = "+" + input.substring(2);
                // }
                 controller.smsSent.value = input;
              },
              onSaved: (input) {
                // if (input.startsWith("00")) {
                //   input = "+" + input.substring(2);
                // }
                 controller.smsSent.value = input;
              },
              validator: (input) {
                return input.length < 6
                    ? "يرجى ادخال كود صحيح"
                    : null;
              },
              style: Get.textTheme.headline4
                  .merge(TextStyle(letterSpacing: 8)),
              decoration: InputDecoration(
                  suffix: IconButton(
                      onPressed: () {
                        // controller.foucse.value = false;
                        // controller.foucse2.value = false;
                        // Get.focusScope.unfocus();
                      },
                      icon: Icon(
                        Icons.arrow_downward_outlined,
                        color: Colors.blue[800],
                      )),
                  prefixIcon: Icon(
                      Icons.add_to_home_screen_outlined),
                  label: Text("OTP Code".tr),
                  hintText: "- - - - - -".tr),
            ),

          // Obx(
          //       () => CheckboxListTile(
          //       title: Text(
          //           " أنا أوافك على إتفاقية الشراكة وألتزم بشروط وقواعد وبنود العمل فًي الأعلى  و أٌقَّر بأن كل بٌياناتًي المدخلة صحيحة   "),
          //       value: controller.value.value,
          //       onChanged: null),
          // ),
          Obx(
                () => SizedBox(
              width: Get.width,
              child: BlockButtonWidget(
                onPressed: (controller.auth.value &&
                    controller.send_done.value)
                    ? () async {
                  // setState(() {
                  // controller.auth.value = false;
                  // });
                  await controller.verifyPhone2();
                  // controller.login();
                  // widget.callback(5, context2);

                  //Get.offAllNamed(Routes.PHONE_VERIFICATION);
                }
                    : null,
                color: Get.theme.accentColor,
                text: Text(
                  "موافق",
                  style: Get.textTheme.headline6.merge(
                      TextStyle(color: Get.theme.primaryColor)),
                ),
              ).paddingOnly(
                  top: 15, bottom: 5, right: 20, left: 20),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }


}
dropCode(List<Code> items, Code selectedValue,
    Function(Code) onChang) {
  return DropdownButtonHideUnderline(
    child: DropdownButton2(
      isExpanded: true,
      hint: Row(
        children: const [
          Icon(
            Icons.list,
            size: 16,
            color: Colors.red,
          ),
          SizedBox(
            width: 4,
          ),
          Expanded(
            child: Text(
              'إختر الجنس',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      items: items
          .map((item) =>
          DropdownMenuItem<Code>(
            value: item,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0.0,

              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.id,

                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(item.name/*,textDirection: TextDirection.ltr,textAlign: TextAlign.end*/,maxLines: 1,)
                ],
              ),
              // subtitle: Text(item.name!/*,textDirection: TextDirection.ltr,textAlign: TextAlign.end*/,maxLines: 1,),
              leading: Text(item.icon),
            ),
          ))
          .toList(),
      value: selectedValue.hasData ? selectedValue : null,
      onChanged: (value) {
        onChang(value);
        // setState(() {
        //   selectedValue = value as String;
        // });
      },
      icon: const Icon(
        Icons.arrow_drop_down,
      ),
      iconSize: 14,
      iconEnabledColor: Colors.indigo,
      iconDisabledColor: Colors.grey,
      buttonHeight: 70,
      buttonWidth: 120,
      buttonPadding: const EdgeInsets.only(left: 0, right: 0),
      buttonDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        // border: Border.all(
        //   color: Colors.black26,
        // ),
        color: Colors.transparent,
      ),
      buttonElevation: 0,
      itemHeight: 50,
      itemPadding: const EdgeInsets.only(left: 0, right: 2),
      dropdownMaxHeight: 300,
      dropdownWidth: 200,
      dropdownPadding: null,
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Get.theme.cardColor,
      ),
      dropdownElevation: 8,
      scrollbarRadius: const Radius.circular(40),
      scrollbarThickness: 6,
      scrollbarAlwaysShow: true,
      offset: const Offset(-20, 0),
    ),
  );
}