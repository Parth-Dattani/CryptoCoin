
class CoinModel {
  final String id;
  final String symbol;
  final String name;
  final String? image;
  final double? currentPrice;
  final double? marketCap;
  final int? marketCapRank;
  final double? priceChange24h;
  final double? priceChangePercentage24h;
  final double? high24h;
  final double? low24h;

  CoinModel({
    required this.id,
    required this.symbol,
    required this.name,
    this.image,
    this.currentPrice,
    this.marketCap,
    this.marketCapRank,
    this.priceChange24h,
    this.priceChangePercentage24h,
    this.high24h,
    this.low24h,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      image: json['image'],
      currentPrice: json['current_price'] != null
          ? (json['current_price'] as num).toDouble()
          : null,
      marketCap: json['market_cap'] != null
          ? (json['market_cap'] as num).toDouble()
          : null,
      marketCapRank: json['market_cap_rank'],
      priceChange24h: json['price_change_24h'] != null
          ? (json['price_change_24h'] as num).toDouble()
          : null,
      priceChangePercentage24h: json['price_change_percentage_24h'] != null
          ? (json['price_change_percentage_24h'] as num).toDouble()
          : null,
      high24h: json['high_24h'] != null
          ? (json['high_24h'] as num).toDouble()
          : null,
      low24h: json['low_24h'] != null
          ? (json['low_24h'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': image,
      'current_price': currentPrice,
      'market_cap': marketCap,
      'market_cap_rank': marketCapRank,
      'price_change_24h': priceChange24h,
      'price_change_percentage_24h': priceChangePercentage24h,
      'high_24h': high24h,
      'low_24h': low24h,
    };
  }

  CoinModel copyWith({
    String? id,
    String? symbol,
    String? name,
    String? image,
    double? currentPrice,
    double? marketCap,
    int? marketCapRank,
    double? priceChange24h,
    double? priceChangePercentage24h,
    double? high24h,
    double? low24h,
  }) {
    return CoinModel(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      image: image ?? this.image,
      currentPrice: currentPrice ?? this.currentPrice,
      marketCap: marketCap ?? this.marketCap,
      marketCapRank: marketCapRank ?? this.marketCapRank,
      priceChange24h: priceChange24h ?? this.priceChange24h,
      priceChangePercentage24h: priceChangePercentage24h ?? this.priceChangePercentage24h,
      high24h: high24h ?? this.high24h,
      low24h: low24h ?? this.low24h,
    );
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