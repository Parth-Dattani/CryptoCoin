import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/model.dart';
import '../utils/utils.dart';
import 'controller.dart';


class AddCoinController extends GetxController with GetSingleTickerProviderStateMixin {
  late final HomeController homeController;

  final TextEditingController searchController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  Rx<CoinModel?> selectedCoin = Rx<CoinModel?>(null);
  RxList<CoinModel> displayedCoins = <CoinModel>[].obs;
  RxString searchQuery = ''.obs;
  RxBool isAdding = false.obs;

  late AnimationController fadeController;
  late Animation<double> fadeAnimation;

  @override
  void onInit() {
    super.onInit();
    fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: fadeController,
          curve: Curves.easeInOut),
    );

    fadeController.forward();

    try {
      homeController = Get.find<HomeController>();
      initializeCoins();
    } catch (e) {
      print("Error finding HomeController: $e");
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    quantityController.dispose();
    fadeController.dispose();
    super.onClose();
  }

  void initializeCoins() {
    if (homeController.coins.isNotEmpty) {
      displayedCoins.value = homeController.coins.take(30).toList();
    }
  }

  double? getCoinPrice(CoinModel coin) {
    return null;
  }

  String getPriceDisplay(CoinModel coin) {
    final price = getCoinPrice(coin);
    if (price != null) {
      return "\$${price.toStringAsFixed(2)}";
    }
    return "Price not found";
  }

  void searchCoin(String value) {
    searchQuery.value = value;

    if (value.isEmpty) {
      displayedCoins.value = homeController.coins.take(30).toList();
    }
    else {
      final lowercaseQuery = value.toLowerCase();
      displayedCoins.value = homeController.coins
          .where((coin) =>
      coin.name.toLowerCase().contains(lowercaseQuery) ||
          coin.symbol.toLowerCase().contains(lowercaseQuery) ||
          coin.id.toLowerCase().contains(lowercaseQuery))
          .toList();
    }
  }

  void clearSearch() {
    searchController.clear();
    searchCoin('');
  }

  void selectCoin(CoinModel coin) {
    selectedCoin.value = coin;
  }

  void deselectCoin() {
    selectedCoin.value = null;
    quantityController.clear();
  }

  Future<void> addToPortfolio() async {
    if (selectedCoin.value == null) {
      Get.snackbar(
        "Error",
        "Please select a coin",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF4444),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    final quantity = double.tryParse(quantityController.text);
    if (quantity == null || quantity <= 0) {
      Get.snackbar(
        "Error",
        "Enter valid quantity",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF4444),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    try {
      isAdding.value = true;

      final price = getCoinPrice(selectedCoin.value!);
      final coinName = selectedCoin.value!.name;

      await addToHome(
        coinId: selectedCoin.value!.id,
        coinName: coinName,
        symbol: selectedCoin.value!.symbol,
        quantity: quantity,
        price: price ?? 0.0,
      );

      selectedCoin.value = null;
      quantityController.clear();
      searchController.clear();
      searchQuery.value = '';

      Get.back(result: true);

      await Future.delayed(const Duration(milliseconds: 100));

      Get.snackbar(
        "Success",
        "$coinName added to portfolio",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF00C853),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );

    } catch (e) {
      print("Error add to portfolio: $e");
      Get.snackbar(
        "Error",
        "Failed to add: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF4444),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isAdding.value = false;
    }
  }

  Future<void> addToHome({
    required String coinId,
    required String coinName,
    required String symbol,
    required double quantity,
    required double price,
  }) async {
    try {
      final existingIndex = homeController.portfolio.indexWhere((item) => item.coinId == coinId);

      if (existingIndex != -1) {
        final existing = homeController.portfolio[existingIndex];
        final existingCoin = (existing.purchasePrice ?? 0) * existing.quantity;
        final newInvestment = price * quantity;
        final totalQuantity = existing.quantity + quantity;
        final averagePurchasePrice = (existingCoin + newInvestment) / totalQuantity;

        homeController.portfolio[existingIndex].quantity = totalQuantity;
        homeController.portfolio[existingIndex].purchasePrice = averagePurchasePrice;

        if (price > 0) {
          homeController.portfolio[existingIndex].price = price;
        }
      } else {
        homeController.portfolio.add(PortfolioItem(
          coinId: coinId,
          coinName: coinName,
          symbol: symbol,
          quantity: quantity,
          price: price,
          purchasePrice: price,
        ));
      }

      await SharedPreferencesHelper.savePortfolio(homeController.portfolio);
      await homeController.fetchPricesForPortfolio();

    } catch (e) {
      print("Error adding to portfolio: $e");
      rethrow;
    }
  }
}