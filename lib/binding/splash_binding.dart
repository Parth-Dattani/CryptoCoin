import 'package:get/get.dart';

import '../controller/controller.dart';

class SplashBinding extends Bindings{
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController(), permanent: false);
  }

}