import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import '../constant/constant.dart';
import 'dart:async';
import '../../controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  static const pageId = "/SplashScreen";

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: const Center(
        child: _AnimatedLogo(),
      ),
    );
  }
}

class _AnimatedLogo extends StatefulWidget {
  const _AnimatedLogo();

  @override
  State<_AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<_AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      Get.find<SplashController>().goToNext();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.currency_bitcoin,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              "Crypto Tracker",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Track your portfolio in real-time",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
