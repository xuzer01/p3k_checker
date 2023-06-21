import 'package:get/get.dart';

class InitialController extends GetxController {
  login(String value) {
    if (value != 'TPSM3') {
      Get.defaultDialog(title: 'Gagal', middleText: 'Password tidak sesuai');
      return;
    }
    Get.offAllNamed('/');
  }
}
