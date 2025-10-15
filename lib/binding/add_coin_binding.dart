
import 'package:get/get.dart';

import '../controller/controller.dart';

class AddCoinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddCoinController>(() => AddCoinController());
  }
}

