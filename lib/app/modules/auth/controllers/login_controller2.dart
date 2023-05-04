import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';



import '../../../../common/ui.dart';
import '../../../models/user_khrof_model.dart';
import '../../../repositories/user_repository.dart';

import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../root/controllers/root_controller.dart';
List<Code> codes = [
  // Code("+967","🇾🇪", "اليمن"),
  Code("+966","🇸🇦", "السعودية"),
];
class Code {
  String id;
  String icon;
  String name;

  Code([this.id,this.icon, this.name]);

  get hasData => id != null && name != null;
}
class LoginController2 extends GetxController {
  //TODO: Implement LoginController
  final UserRepository _userRepository = UserRepository();
  final currentUser = Get.find<AuthService>().user;


  final oldPassword = "".obs;
  final newPassword = "".obs;
  final confirmPassword = "".obs;
  final loading = false.obs;
  final smsSent = ''.obs;
  // final loading = false.obs;
  final sending = false.obs;
  final send_done = false.obs;
  final error = false.obs;
  RxBool valuee = false.obs;
  RxBool auth = true.obs;
  final re_send = true.obs;
  RxInt steps = 1.obs;
  LoginController2() {
    // _userRepository=UserRepository();
  }
  var formKey = GlobalKey<FormState>();
  var form2Key = GlobalKey<FormState>();
  var form3Key = GlobalKey<FormState>();
  GlobalKey<FormState> phoneFormKey;
  GlobalKey<FormState> phoneReserFormKey;
  @override
  void onInit() {
    Get.find<AuthService>().selectedCode.value=codes.first;
    currentUser.value.code=Get.find<AuthService>().selectedCode.value.id;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }



  void login2() async {
    Get.focusScope.unfocus();
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      loading.value = true;
      try {
        await Get.find<FireBaseMessagingService>().setDeviceToken();
        currentUser.value = await _userRepository.login(currentUser.value);

        // await _userRepository.signInWithEmailAndPassword(currentUser.value.email, currentUser.value.apiToken);
        loading.value = false;
        await Get.offAllNamed(Routes.ROOT, arguments: 0);
      } catch (e) {
        log(e.toString());
        if (e.toString().contains("Dio") || e.toString().contains("timeout")) {
          Get.showSnackbar(
              Ui.ErrorSnackBar(message: "تاكد من اتصالك بالانترنت"));
        } else {
          Get.showSnackbar(Ui.ErrorSnackBar(message: "تاكد من صحة البيانات"));
        }
      } finally {
        auth.value = true;
        loading.value = false;
      }
    } else {
      auth.value = true;
    }
  }

  mainLogin() {
    if (steps.value == 1) {
      chekType((bool outh) async {
        if (outh) {
          UserRepository _userRepository=UserRepository();
          User_Khrof user = await _userRepository.searchUser(currentUser.value.phone);
          loading.value = false;
          steps.value = 3;
          // await Get.find<RootController>().changePage(0);
          // Get.toNamed(Routes.REGESTER);
          Get.back(result: true);
        }
      });
    }else if(steps.value == 2){
      login2();
    }
  }

  chekType(Function(bool) onauth) async {
    Get.focusScope.unfocus();
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      loading.value = true;
      try {

          re_send.value = false;
          Future.delayed(const Duration(minutes: 2), () {
            re_send.value = true;
          });
          await _userRepository.sendCodeToPhone2(onauth);
          Get.snackbar("sending sms", "يرجى ادخال كود التحقق ");
          steps.value = 3;


        // await Get.toNamed(Routes.PHONE_VERIFICATION);
      } catch (e) {
        re_send.value = true;
        Get.showSnackbar(Ui.ErrorSnackBar(message: "تاكد من اتصالك بالانترنت"));
      } finally {
        auth.value = true;
        loading.value = false;
      }
    } else {
      auth.value = true;
    }
  }

  void sendcode(Function(bool) onauth) async {
    sending.value = false;
    Get.focusScope.unfocus();
    if (phoneReserFormKey.currentState.validate()) {
      phoneReserFormKey.currentState.save();
      loading.value = true;
      try {
        // bool used=    await _userRepository.getUsed(currentUser.value);
        if (!true) {
          Get.showSnackbar(Ui.ErrorSnackBar(message: "الرقم ليس مشترك من قبل"));
          return;
        }

        await _userRepository.sendCodeToPhone2(onauth);

        loading.value = false;
        sending.value = true;
        // await Get.toNamed(Routes.PHONE_VERIFICATION);
      } catch (e) {
        Get.showSnackbar(
            Ui.ErrorSnackBar(message: "خطأ ", title: "حاول مرة اخرى"));
      } finally {
        loading.value = false;
      }
    }
  }

  Future<void> verifyPhone2() async {
    try {
      loading.value = true;
      await _userRepository.verifyPhone(smsSent.value);
      User_Khrof user = await _userRepository.searchUser(currentUser.value.phone);
      // await Get.find<FireBaseMessagingService>().setDeviceToken2();
      // currentUser.value = await _userRepository.register2(currentUser.value);
      // await _userRepository.signUpWithEmailAndPassword(currentUser.value.email, currentUser.value.apiToken);
      // await Get.find<AuthService>().removeCurrentUser();
      loading.value = false;
      currentUser.value.auth=true;
      currentUser.refresh();
      steps.value = 3;
    Get.back(result: true);
    } catch (e) {
      loading.value = false;
      log(e.toString());
      // Get.toNamed(Routes.REGISTER2);
      // Get.back();
      if (e.toString().contains("timeout")) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "تاكد من اتصالك بالانترنت"));
      } else {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "ادخل الكود الصحيح"));
      }
    } finally {
      loading.value = false;
    }
  }

  Future<void> verifyPhone3() async {
    try {
      loading.value = true;
      await _userRepository.verifyPhone(smsSent.value);
      // await Get.find<FireBaseMessagingService>().setDeviceToken();
      // currentUser.value = await _userRepository.register2(currentUser.value);
      // Get.to(Regester());
      // Get.offAndToNamed(Routes.RESET2);
      // Get.to(() => ResetPass2View());
      // await _userRepository.signUpWithEmailAndPassword(currentUser.value.email, currentUser.value.apiToken);
      // await Get.find<RootController>().changePage(0);
    } catch (e) {
      // Get.back();\
      if (e.toString().contains("timeout")) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "تاكد من اتصالك بالانترنت"));
      } else {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "ادخل الكود الصحيح"));
      }
    } finally {
      loading.value = false;
    }
  }





  // checkEmail() async {
  //   Get.focusScope!.unfocus();
  //   if (form2Key.currentState!.validate()) {
  //     form2Key.currentState!.save();
  //     try{
  //       User login = await dataBase.getUser(currentUser.value);
  //       log(login.toJson().toString());
  //       if (login.hasData) {
  //         log(login.toJson().toString());
  //         Get.toNamed(Routes.RESET2,arguments: login);
  //       }
  //     }catch(e){
  //       log(e.toString());
  //       Get.showSnackbar(Ui.ErrorSnackBar(title: "Email Not Exist ",message: "Enter valid email"));
  //     }}
  // }
}
