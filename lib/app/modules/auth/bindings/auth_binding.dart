import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/login_controller2.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(),
    ); Get.lazyPut<LoginController2>(
      () => LoginController2(),
    );
  }
}
