
class CoinModel {
  final String id;
  final String symbol;
  final String name;

  CoinModel({
    required this.id,
    required this.symbol,
    required this.name,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
    };
  }
}

class PortfolioItem {
  final String coinId;
  final String coinName;
  final String symbol;
  double quantity;
  double? price;
  double? purchasePrice;
  double? previousPrice;

  PortfolioItem({
    required this.coinId,
    required this.coinName,
    required this.symbol,
    required this.quantity,
    this.price,
    this.purchasePrice,
    this.previousPrice,
  });


  double get totalValue {
    if (price == null || price! <= 0) return 0.0;
    return price! * quantity;
  }

  double get totalInvestment {
    if (purchasePrice == null || purchasePrice! <= 0) return 0.0;
    return purchasePrice! * quantity;
  }
  double get profitLoss {
    if (price == null || price! <= 0 || purchasePrice == null || purchasePrice! <= 0) {
      return 0.0;
    }
    return totalValue - totalInvestment;
  }
  double get profitLossPercentage {
    if (purchasePrice == null || purchasePrice! <= 0) return 0.0;
    if (price == null || price! <= 0) return 0.0;
    return ((price! - purchasePrice!) / purchasePrice!) * 100;
  }
  bool get isProfit => profitLoss >= 0;
  double get priceChange {
    if (price == null || previousPrice == null || previousPrice! <= 0) return 0.0;
    return price! - previousPrice!;
  }
  double get priceChangePercentage {
    if (previousPrice == null || previousPrice! <= 0) return 0.0;
    if (price == null) return 0.0;
    return ((price! - previousPrice!) / previousPrice!) * 100;
  }
  bool get isPriceUp => priceChange > 0;
  bool get isPriceDown => priceChange < 0;
  bool get hasPriceChanged => priceChange != 0;

  Map<String, dynamic> toJson() {
    return {
      'coinId': coinId,
      'coinName': coinName,
      'symbol': symbol,
      'quantity': quantity,
      'price': price,
      'purchasePrice': purchasePrice,
      'previousPrice': previousPrice,
    };
  }

  factory PortfolioItem.fromJson(Map<String, dynamic> json) {
    return PortfolioItem(
      coinId: json['coinId'] ?? '',
      coinName: json['coinName'] ?? '',
      symbol: json['symbol'] ?? '',
      quantity: (json['quantity'] ?? 0.0).toDouble(),
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      purchasePrice: json['purchasePrice'] != null
          ? (json['purchasePrice'] as num).toDouble()
          : null,
      previousPrice: json['previousPrice'] != null
          ? (json['previousPrice'] as num).toDouble()
          : null,
    );
  }

  PortfolioItem copyWith({
    String? coinId,
    String? coinName,
    String? symbol,
    double? quantity,
    double? price,
    double? purchasePrice,
    double? previousPrice,
  }) {
    return PortfolioItem(
      coinId: coinId ?? this.coinId,
      coinName: coinName ?? this.coinName,
      symbol: symbol ?? this.symbol,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      previousPrice: previousPrice ?? this.previousPrice,
    );
  }
}