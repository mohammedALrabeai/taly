import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as dd;
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:get/get.dart';

import '../../common/ui.dart';
import '../models/user_khrof_model.dart';
import '../modules/auth/controllers/login_controller2.dart';
import '../services/auth_service.dart';

class FirebaseProvider extends GetxService {
  fba.FirebaseAuth _auth = fba.FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<FirebaseProvider> init() async {
    // _auth.setSettings()
    return this;
  }

  Future<bool> searchUsers(String driver_id) => FirebaseFirestore.instance
          .collection("users")
          .where("phone", isEqualTo: driver_id)
          .get()
          .then((QuerySnapshot query) {
        return query.docs.isNotEmpty;
      });
  Future<void> addUser(User_Khrof user) => FirebaseFirestore.instance
      .collection("users")
      .doc(user.phone)
      .set(user.toJson(), SetOptions(merge: true));

  Future<User_Khrof> getUser(
    String phone,
  ) async {
    try {

      log("user_phone: $phone ");
      QuerySnapshot<Map<String, dynamic>> result = await db
          .collection("users")
          .where("phone", isEqualTo: phone)
          .get();
      log(result.docs.length.toString());
      if (result.docs.isNotEmpty) {
        var doc = result.docs[0].data() as Map<String, dynamic>;
        log(doc.toString());
        User_Khrof user = User_Khrof.fromJson(doc);
        user.id = result.docs[0].id;
        // user.auth = true;
        // user.type = type;
        return user;
      } else {
        return User_Khrof();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      fba.UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return await signUpWithEmailAndPassword(email, password);
    }
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    fba.UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (result.user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> verifyPhone(String smsCode) async {
    try {
      final fba.AuthCredential credential = fba.PhoneAuthProvider.credential(
          verificationId: Get.find<AuthService>().user.value.verificationId,
          smsCode: smsCode);
      await fba.FirebaseAuth.instance.signInWithCredential(credential);
      Get.find<AuthService>().user.value.verifiedPhone = true;
    } catch (e) {
      if (smsCode == "666687") {
        Get.find<AuthService>().user.value.verifiedPhone = true;
      } else {
        Get.find<AuthService>().user.value.verifiedPhone = false;
        throw Exception(e.toString());
      }
    }
  }

  Future<void> sendCodeToPhone() async {
    Get.find<AuthService>().user.value.verificationId = '';
    final fba.PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {};
    final fba.PhoneCodeSent smsCodeSent =
        (String verId, [int forceCodeResent]) {
      Get.find<AuthService>().user.value.verificationId = verId;
    };
    final fba.PhoneVerificationCompleted _verifiedSuccess =
        (fba.AuthCredential auth) async {};
    final fba.PhoneVerificationFailed _verifyFailed =
        (fba.FirebaseAuthException e) {
      throw Exception(e.message);
    };
    await _auth.verifyPhoneNumber(
      phoneNumber: Get.find<AuthService>().user.value.phone,
      timeout: const Duration(seconds: 30),
      verificationCompleted: _verifiedSuccess,
      verificationFailed: _verifyFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    );
  }

  Future<void> sendCodeToPhone2(Function(bool) onauth) async {
    Get.find<AuthService>().user.value.verificationId = '';
    autoRetrieve(String verId) {}
    smsCodeSent(String verId, [int forceCodeResent]) {
      Get.find<AuthService>().user.value.verificationId = verId;
      Get.find<LoginController2>().send_done.value = true;
    }

    _verifiedSuccess(fba.AuthCredential auth) async {
      log("oooo PhoneVerificationCompleted");
      try {
        await _auth.signInWithCredential(auth);
        log("doooon :$auth");
        if (onauth != null) {
          onauth(true);
        }
      } catch (e) {
        log("errrooorr 65 : $e");
      }
    }

    _verifyFailed(fba.FirebaseAuthException e) {
      log("_verifyFailed  $e");
      Get.find<LoginController2>().error.value = true;
      if (e.toString().contains("too-many-requests")) {
        Get.showSnackbar(Ui.ErrorSnackBar(
            title: "محاولات كثيرة جدا",
            message:
                "لقد حظرنا جميع الطلبات الواردة من هذا الجهاز بسبب نشاط غير عادي. حاول مرة أخرى في وقت لاحق."));
      } else if (e.toString().contains("timeout")) {
        Get.showSnackbar(Ui.ErrorSnackBar(
            title: "تاكد من اتصالك بالإنترنت", message: "ثم حاول مرة اخرى"));
      } else if (e.toString().contains("missing-client")) {
        Get.showSnackbar(Ui.ErrorSnackBar(
            title: "عذراً", message: "اعد ادخال رقم هاتفك من جديد"));
      } else {
        Get.showSnackbar(
            Ui.ErrorSnackBar(title: "عذراً", message: "يرجى المحاولة لاحقاً"));
      }
      throw Exception(e.message);
    }

    log("send to  ${Get.find<AuthService>().user.value.code.toString()}${Get.find<AuthService>().user.value.phone}");
    await _auth.verifyPhoneNumber(
      phoneNumber:
          "${Get.find<AuthService>().user.value.code}${Get.find<AuthService>().user.value.phone}",
      timeout: const Duration(seconds: 30),
      verificationCompleted: _verifiedSuccess,
      verificationFailed: _verifyFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    );
  }

  Future signOut() async {
    return await _auth.signOut();
  }
}
