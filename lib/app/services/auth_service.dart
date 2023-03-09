import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../common/shop_model.dart';
import '../models/user_model.dart';
import '../modules/auth/controllers/login_controller2.dart';
import '../repositories/user_repository.dart';
import 'settings_service.dart';

class AuthService extends GetxService {
  final user = User().obs;
  final shop = Shop().obs;
  final selectedCode = Code().obs;
  Uint8List logo;
  GetStorage _box;

  UserRepository _usersRepo;

  AuthService() {
    _usersRepo = new UserRepository();
    _box = new GetStorage();
  }

  Future<AuthService> init() async {
    user.listen((User _user) {
      if (Get.isRegistered<SettingsService>()) {
        Get.find<SettingsService>().address.value.userId = _user.id;
      }
      log(user.value.toJson().toString());
      _box.write('current_user', _user.toJson());
    });
    getshop();
    await getCurrentUser();
    return this;
  }
  getshop() {
    FirebaseFirestore.instance
        .collection('settings')
        .doc("1")
    // .where('created_by', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      log(value.data().toString());
      var r = Shop.fromJson(value.data());
      r.id = value.id;
      shop.value=r;
      // http.Response response = await http.get(
      //   Uri.parse('https://flutter.io/images/flutter-mark-square-100.png'),
      // );
      if(shop.value.logo!=null) {
        var response = _usersRepo.getImage(shop.value);
        var pat = shop.value.logo
            .split("/")
            .last;
        // Direc
        Directory path = await getApplicationDocumentsDirectory();
        var jj = join(path.path, pat);
        final file =  File(jj);
    logo=   await file.readAsBytes();
        log("ppath "+jj);
      }
      return;
    }).catchError((e) {
      log(e.toString());
    });
  }
  Future getCurrentUser() async {
    if (user.value.auth == null && _box.hasData('current_user')) {
      user.value = User.fromJson(await _box.read('current_user'));
      log(user.value.toString());
      user.value.auth = true;
    } else {
      user.value.auth = false;
    }
  }

  Future removeCurrentUser() async {
    user.value = new User();
    await _usersRepo.signOut();
    await _box.remove('current_user');
  }

  bool get isAuth => user.value.auth ?? false;

  String get apiToken => (user.value.auth ?? false) ? user.value.apiToken : '';
}
