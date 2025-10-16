import 'package:crypto_coin/controller/bash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/model.dart';
import '../services/service.dart';
import '../utils/utils.dart';
import '../services/remote_service.dart';


// class HomeController extends BaseController {
//
//   RxList<CoinModel> coins = <CoinModel>[].obs;
//   RxList<CoinModel> displayedCoins = <CoinModel>[].obs;
//   RxList<PortfolioItem> portfolio = <PortfolioItem>[].obs;
//   RxString searchQuery = ''.obs;
//
//   RxBool isLoadingMore = false.obs;
//   RxBool hasMoreCoins = true.obs;
//   RxDouble totalPortfolioValue = 0.0.obs;
//
//
//   static const int pageSize = 30;
//   int currentPage = 0;
//   List<CoinModel> allCoins = [];
//   late ScrollController scrollController;
//
//   Map<String, CoinModel> coinMap = {};
//
//   @override
//   void onInit() {
//     super.onInit();
//     scrollController = ScrollController();
//     scrollController.addListener(onScroll);
//     initialize();
//   }
//
//   @override
//   void onClose() {
//     scrollController.dispose();
//     super.onClose();
//   }
//
//   Future<void> initialize() async {
//     try {
//       isLoading.value = true;
//
//       final savedPortfolio = await SharedPreferencesHelper.loadPortfolio();
//       portfolio.value = savedPortfolio;
//
//       List<CoinModel> loadedCoins = await SharedPreferencesHelper.loadCoinsList();
//
//       if (loadedCoins.isEmpty) {
//         loadedCoins = await RemoteService.fetchCoinsList();
//         await SharedPreferencesHelper.saveCoinsList(loadedCoins);
//       }
//
//       allCoins = loadedCoins;
//       coins.value = loadedCoins;
//
//       for (var coin in allCoins) {
//         coinMap[coin.id.toLowerCase()] = coin;
//         coinMap[coin.symbol.toLowerCase()] = coin;
//         coinMap[coin.name.toLowerCase()] = coin;
//       }
//
//       currentPage = 0;
//       displayedCoins.clear();
//       _loadNextPage();
//
//       if (portfolio.isNotEmpty) {
//         await fetchPricesForPortfolio();
//       }
//
//       print("Loaded ${coins.length} coins successfully...");
//     } catch (e) {
//       print("Error on initializing: $e");
//       Get.snackbar("Error", "$e",
//           snackPosition: SnackPosition.BOTTOM);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void _loadNextPage() {
//     if (isLoadingMore.value) return;
//
//     int startIndex = currentPage * pageSize;
//     int endIndex = startIndex + pageSize;
//
//     if (startIndex >= allCoins.length) {
//       hasMoreCoins.value = false;
//       return;
//     }
//
//     isLoadingMore.value = true;
//
//     Future.delayed(const Duration(milliseconds: 300), () {
//       if (endIndex > allCoins.length) {
//         endIndex = allCoins.length;
//       }
//
//       final newCoins = allCoins.sublist(startIndex, endIndex);
//       displayedCoins.addAll(newCoins);
//
//       currentPage++;
//       hasMoreCoins.value = endIndex < allCoins.length;
//       isLoadingMore.value = false;
//     });
//   }
//
//   void onScroll() {
//     if (scrollController.position.pixels >=
//         scrollController.position.maxScrollExtent - 500) {
//       if (hasMoreCoins.value && !isLoadingMore.value && searchQuery.isEmpty) {
//         _loadNextPage();
//       }
//     }
//   }
//
//   void filterCoins(String query) {
//     searchQuery.value = query;
//
//     if (query.isEmpty) {
//       displayedCoins.clear();
//       currentPage = 0;
//       _loadNextPage();
//     }
//     else {
//       final lowercaseQuery = query.toLowerCase();
//       displayedCoins.value = allCoins
//           .where((coin) =>
//       coin.name.toLowerCase().contains(lowercaseQuery) ||
//           coin.symbol.toLowerCase().contains(lowercaseQuery) || coin.id.toLowerCase().contains(lowercaseQuery))
//           .toList();
//     }
//   }
//
//   Future<void> fetchPricesForPortfolio() async {
//     if (portfolio.isEmpty) {
//       totalPortfolioValue.value = 0.0;
//       return;
//     }
//
//     try {
//       final coinIds = portfolio.map((item) => item.coinId).join(",");
//       print("Coin ID---: $coinIds");
//
//       final prices = await RemoteService.fetchCoinPrices(coinIds);
//       print("API Response----: $prices");
//
//
//       bool pricesUpdated = false;
//       for (var item in portfolio) {
//        var priceData = prices[item.coinId];
//
//         if (priceData == null) {
//           priceData = prices[item.coinId.toLowerCase()];
//         }
//
//         if (priceData != null) {
//           print("Price ---: $priceData");
//
//           if (priceData is Map && priceData.containsKey('usd')) {
//             final usdPrice = priceData['usd'];
//             print("USD value----: $usdPrice");
//
//             item.price = (usdPrice as num).toDouble();
//             pricesUpdated = true;
//             print("Successfully updated ${item.coinId}: \$${item.price}");
//           } else {
//             print("not found price");
//           }
//         } else {
//           print("No price ----: ${item.coinId}");
//           if (item.price == null) {
//             item.price = 0.0;
//           }
//         }
//       }
//
//      await SharedPreferencesHelper.savePortfolio(portfolio);
//       portfolio.refresh();
//       _calculateTotalValue();
//
//       print("=== PRICE FETCH COMPLETE ===");
//       print("Total portfolio value: \$${totalPortfolioValue.value}");
//     }
//     catch (e) {
//       print("Error: $e");
//       Get.snackbar(
//         "Error",
//         "Failed to update prices: ${e.toString()}",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red[100],
//       );
//     }
//   }
//
//   void _calculateTotalValue() {
//     totalPortfolioValue.value = portfolio.fold(
//         0.0,
//             (sum, item) => sum + item.totalValue
//     );
//     print("Total portfolio-----: \$${totalPortfolioValue.value}");
//   }
//
//   Future<void> addToPortfolio({
//     required String coinId,
//     required String coinName,
//     required String symbol,
//     required double quantity,
//     required double price,
//     bool showSnackbar = true,
//   }) async {
//     try {
//       final existingIndex = portfolio.indexWhere((item) => item.coinId == coinId);
//       if (existingIndex != -1) {
//
//         portfolio[existingIndex].quantity += quantity;
//
//         if (price != null && price > 0) {
//           portfolio[existingIndex].price = price;
//         }
//       } else {
//        portfolio.add(PortfolioItem(
//           coinId: coinId,
//           coinName: coinName,
//           symbol: symbol,
//           quantity: quantity,
//           price: price,
//         ));
//       }
//
//       await SharedPreferencesHelper.savePortfolio(portfolio);
//       await fetchPricesForPortfolio();
//
//       if (showSnackbar) {
//         Get.snackbar(
//           "Success",
//           "$coinName add to portfolio",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green[100],
//         );
//       }
//     } catch (e) {
//       print("Error add to portfolio: $e");
//       Get.snackbar(
//         "Error",
//         "Failed to add: ${e.toString()}",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red[100],
//       );
//       rethrow;
//     }
//   }
//
//   Future<void> refreshPrices() async {
//     try {
//       await fetchPricesForPortfolio();
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "Failed to refresh",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red[100],
//       );
//     }
//   }
//
//   Future<void> removeFromPortfolio(String coinId) async {
//     final removedCoin = portfolio.firstWhere((item) => item.coinId == coinId);
//     portfolio.removeWhere((item) => item.coinId == coinId);
//
//     await SharedPreferencesHelper.savePortfolio(portfolio);
//     portfolio.refresh();
//     _calculateTotalValue();
//
//     Get.snackbar(
//       "Removed",
//       "${removedCoin.coinName} removed from portfolio",
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
// }


class HomeController extends BaseController {
  RxList<CoinModel> coins = <CoinModel>[].obs;
  RxList<CoinModel> displayedCoins = <CoinModel>[].obs;
  RxList<PortfolioItem> portfolio = <PortfolioItem>[].obs;
  RxString searchQuery = ''.obs;

  RxBool isLoadingMore = false.obs;
  RxBool hasMoreCoins = true.obs;
  RxDouble totalPortfolioValue = 0.0.obs;

  static const int pageSize = 30;
  int currentPage = 0;
  int apiPage = 1; // ✅ NEW: Track API page
  List<CoinModel> allCoins = [];
  late ScrollController scrollController;

  Map<String, CoinModel> coinMap = {};

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(onScroll);
    initialize();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> initialize() async {
    try {
      isLoading.value = true;

      // Load saved portfolio
      final savedPortfolio = await SharedPreferencesHelper.loadPortfolio();
      portfolio.value = savedPortfolio;

      List<CoinModel> loadedCoins = await SharedPreferencesHelper.loadCoinsList();

      if (loadedCoins.isEmpty || !_hasMarketData(loadedCoins)) {
        print("Loading fresh data from API...");
        loadedCoins = await RemoteService.fetchCoinsListWithMarketData(
          page: 1,
          perPage: 100,
        );
        await SharedPreferencesHelper.saveCoinsList(loadedCoins);
      }

      allCoins = loadedCoins;
      coins.value = loadedCoins;

      for (var coin in allCoins) {
        coinMap[coin.id.toLowerCase()] = coin;
        coinMap[coin.symbol.toLowerCase()] = coin;
        coinMap[coin.name.toLowerCase()] = coin;
      }

      currentPage = 0;
      displayedCoins.clear();
      _loadNextPage();

      if (portfolio.isNotEmpty) {
        await _updatePortfolioPricesFromCoins();
      }

      print("Loaded ${coins.length} coins successfully");
    } catch (e) {
      print("Error initializing: $e");
      Get.snackbar("Error", "$e", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  bool _hasMarketData(List<CoinModel> coins) {
    if (coins.isEmpty) return false;
    return coins.first.currentPrice != null;
  }

  void _loadNextPage() {
    if (isLoadingMore.value) return;

    int startIndex = currentPage * pageSize;
    int endIndex = startIndex + pageSize;

    if (startIndex >= allCoins.length) {
      _loadMoreFromAPI();
      return;
    }

    isLoadingMore.value = true;

    Future.delayed(const Duration(milliseconds: 300), () {
      if (endIndex > allCoins.length) {
        endIndex = allCoins.length;
      }

      final newCoins = allCoins.sublist(startIndex, endIndex);
      displayedCoins.addAll(newCoins);

      currentPage++;
      hasMoreCoins.value = endIndex < allCoins.length || apiPage < 10;
      isLoadingMore.value = false;
    });
  }

  Future<void> _loadMoreFromAPI() async {
    if (isLoadingMore.value) return;

    isLoadingMore.value = true;
    apiPage++;

    try {
      final newCoins = await RemoteService.fetchCoinsListWithMarketData(
        page: apiPage,
        perPage: 100,
      );

      allCoins.addAll(newCoins);
      coins.value = allCoins;

      // Update coin map
      for (var coin in newCoins) {
        coinMap[coin.id.toLowerCase()] = coin;
        coinMap[coin.symbol.toLowerCase()] = coin;
        coinMap[coin.name.toLowerCase()] = coin;
      }

      await SharedPreferencesHelper.saveCoinsList(allCoins);

      _loadNextPage();
    } catch (e) {
      print("Error loading more coins: $e");
      hasMoreCoins.value = false;
    } finally {
      isLoadingMore.value = false;
    }
  }

  void onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 500) {
      if (hasMoreCoins.value && !isLoadingMore.value && searchQuery.isEmpty) {
        _loadNextPage();
      }
    }
  }

  void filterCoins(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      displayedCoins.clear();
      currentPage = 0;
      _loadNextPage();
    } else {
      final lowercaseQuery = query.toLowerCase();
      displayedCoins.value = allCoins
          .where((coin) =>
      coin.name.toLowerCase().contains(lowercaseQuery) ||
          coin.symbol.toLowerCase().contains(lowercaseQuery) ||
          coin.id.toLowerCase().contains(lowercaseQuery))
          .toList();
    }
  }

  Future<void> _updatePortfolioPricesFromCoins() async {
    bool pricesUpdated = false;

    for (var item in portfolio) {
      final coin = coinMap[item.coinId.toLowerCase()];

      if (coin != null && coin.currentPrice != null) {
        item.previousPrice = item.price;
        item.price = coin.currentPrice;
        pricesUpdated = true;
        print("Updated ${item.coinId}: \$${item.price}");
      } else {
        print("No price found for ${item.coinId}");
        if (item.price == null) {
          item.price = 0.0;
        }
      }
    }

    if (pricesUpdated) {
      await SharedPreferencesHelper.savePortfolio(portfolio);
      portfolio.refresh();
      _calculateTotalValue();
    }
  }

  Future<void> fetchPricesForPortfolio() async {
    if (portfolio.isEmpty) {
      totalPortfolioValue.value = 0.0;
      return;
    }

    try {
      final coinIds = portfolio.map((item) => item.coinId).join(",");
      print("Fetching price: $coinIds");

      await _updatePortfolioPricesFromCoins();

      final missingPrices = portfolio.where((item) =>
      item.price == null || item.price! <= 0
      ).toList();

      if (missingPrices.isNotEmpty) {
        final missingIds = missingPrices.map((item) => item.coinId).join(",");
        final prices = await RemoteService.fetchCoinPrices(missingIds);

        for (var item in missingPrices) {
          var priceData = prices[item.coinId] ?? prices[item.coinId.toLowerCase()];

          if (priceData != null && priceData is Map && priceData.containsKey('usd')) {
            item.previousPrice = item.price;
            item.price = (priceData['usd'] as num).toDouble();
            print("price ----: ${item.coinId}: \$${item.price}");
          }
        }
      }

      await SharedPreferencesHelper.savePortfolio(portfolio);
      portfolio.refresh();
      _calculateTotalValue();

      print("Portfolio value: \$${totalPortfolioValue.value}");
    } catch (e) {
      print("Error fetching prices: $e");
      Get.snackbar(
        "Error",
        "Failed to update prices: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
    }
  }

  void _calculateTotalValue() {
    totalPortfolioValue.value = portfolio.fold(
      0.0,
          (sum, item) => sum + item.totalValue,
    );
    print("Total portfolio: \$${totalPortfolioValue.value}");
  }

  Future<void> addToPortfolio({
    required String coinId,
    required String coinName,
    required String symbol,
    required double quantity,
    required double price,
    bool showSnackbar = true,
  }) async {
    try {
      final existingIndex = portfolio.indexWhere((item) => item.coinId == coinId);

      if (existingIndex != -1) {
        portfolio[existingIndex].quantity += quantity;
        if (price > 0) {
          portfolio[existingIndex].price = price;
        }
      } else {
        final coin = coinMap[coinId.toLowerCase()];
        final currentPrice = coin?.currentPrice ?? price;

        portfolio.add(PortfolioItem(
          coinId: coinId,
          coinName: coinName,
          symbol: symbol,
          quantity: quantity,
          price: currentPrice,
          purchasePrice: price, // Store original purchase price
        ));
      }

      await SharedPreferencesHelper.savePortfolio(portfolio);
      await fetchPricesForPortfolio();

      if (showSnackbar) {
        Get.snackbar(
          "Success",
          "$coinName added to portfolio",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
        );
      }
    } catch (e) {
      print("Error adding to portfolio: $e");
      Get.snackbar(
        "Error",
        "Failed to add: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
      rethrow;
    }
  }

  Future<void> refreshPrices() async {
    try {
      final freshCoins = await RemoteService.fetchCoinsListWithMarketData(
        page: 1,
        perPage: 100,
      );

      if (freshCoins.isNotEmpty) {
        for (int i = 0; i < freshCoins.length && i < allCoins.length; i++) {
          allCoins[i] = freshCoins[i];
        }
        coins.value = allCoins;

        for (var coin in freshCoins) {
          coinMap[coin.id.toLowerCase()] = coin;
          coinMap[coin.symbol.toLowerCase()] = coin;
          coinMap[coin.name.toLowerCase()] = coin;
        }
      }

      await fetchPricesForPortfolio();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to refresh prices",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
    }
  }

  Future<void> removeFromPortfolio(String coinId) async {
    final removedCoin = portfolio.firstWhere((item) => item.coinId == coinId);
    portfolio.removeWhere((item) => item.coinId == coinId);

    await SharedPreferencesHelper.savePortfolio(portfolio);
    portfolio.refresh();
    _calculateTotalValue();

    Get.snackbar(
      "Removed",
      "${removedCoin.coinName} removed from portfolio",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}