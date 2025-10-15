import 'package:crypto_coin/screen/home/home_screen.dart';
import 'package:get/get.dart';
import '../utils/utils.dart';
import 'bash_controller.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  void goToNext() {
    Get.offAllNamed(HomeScreen.pageId);
  }
}



