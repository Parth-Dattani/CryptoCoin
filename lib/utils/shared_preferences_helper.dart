import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/model.dart';

class SharedPreferencesHelper {
  static const String portfolioKey = 'crypto_portfolio';
  static const String coinsListKey = 'crypto_coins_list';

  static Future<void> savePortfolio(List<PortfolioItem> portfolio) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = portfolio.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(portfolioKey, jsonList);
  }

  static Future<List<PortfolioItem>> loadPortfolio() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(portfolioKey) ?? [];
    return jsonList
        .map((item) => PortfolioItem.fromJson(jsonDecode(item)))
        .toList();
  }

  static Future<void> saveCoinsList(List<CoinModel> coins) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = coins.map((coin) => jsonEncode(coin.toJson())).toList();
    await prefs.setStringList(coinsListKey, jsonList);
  }

  static Future<List<CoinModel>> loadCoinsList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(coinsListKey) ?? [];
    return jsonList
        .map((coin) => CoinModel.fromJson(jsonDecode(coin)))
        .toList();
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(portfolioKey);
    await prefs.remove(coinsListKey);
  }
}