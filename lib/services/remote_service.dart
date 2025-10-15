import 'dart:convert';
import 'dart:math';
import 'dart:math' as Math;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../constant/constant.dart';
import '../model/model.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import 'api.dart';

class RemoteService {

  static const String apiKey = "";

  static Future<List<CoinModel>> fetchCoinsList() async {
    final uri = Uri.parse("${Apis.baseApi} + ${Apis.coinListApi}");

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      print("Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print("Fetched ${data.length} coins");
        return data.map((e) => CoinModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load coins: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchCoinPrices(String coinIds) async {
    final uri = Uri.parse(
      "${Apis.baseApi}/simple/price?ids=$coinIds&vs_currencies=usd",
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      else {
        throw Exception("Failed to load prices: ${response.statusCode}");
      }
    } catch (e) {
      print("error: $e");
      rethrow;
    }
  }

}


