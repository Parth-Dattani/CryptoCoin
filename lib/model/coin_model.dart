
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

// class PortfolioItem {
//   final String coinId;
//   final String coinName;
//   final String symbol;
//   double quantity;
//   double price; // Nullable price
//
//   PortfolioItem({
//     required this.coinId,
//     required this.coinName,
//     required this.symbol,
//     required this.quantity,
//     required this.price, // Optional price
//   });
//
//   // Safe calculation with null check
//   double get totalValue => quantity * (price ?? 0);
//
//   factory PortfolioItem.fromJson(Map<String, dynamic> json) {
//     return PortfolioItem(
//       coinId: json['coinId'] ?? '',
//       coinName: json['coinName'] ?? '',
//       symbol: json['symbol'] ?? '',
//       quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
//       price: (json['price'] as num?)?.toDouble() ?? 0.0, // Load saved price if exists
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'coinId': coinId,
//     'coinName': coinName,
//     'symbol': symbol,
//     'quantity': quantity,
//     'price': price, // Save price to persistence
//   };
// }

///
class PortfolioItem {
  final String coinId;
  final String coinName;
  final String symbol;
  double quantity;
  double? price;
  double? purchasePrice;
  double? previousPrice; // NEW: Track previous price for change indication

  PortfolioItem({
    required this.coinId,
    required this.coinName,
    required this.symbol,
    required this.quantity,
    this.price,
    this.purchasePrice,
    this.previousPrice,
  });

  // Calculate total value of this holding
  double get totalValue {
    if (price == null || price! <= 0) return 0.0;
    return price! * quantity;
  }

  // Calculate total investment
  double get totalInvestment {
    if (purchasePrice == null || purchasePrice! <= 0) return 0.0;
    return purchasePrice! * quantity;
  }

  // Calculate profit/loss
  double get profitLoss {
    if (price == null || price! <= 0 || purchasePrice == null || purchasePrice! <= 0) {
      return 0.0;
    }
    return totalValue - totalInvestment;
  }

  // Calculate profit/loss percentage
  double get profitLossPercentage {
    if (purchasePrice == null || purchasePrice! <= 0) return 0.0;
    if (price == null || price! <= 0) return 0.0;
    return ((price! - purchasePrice!) / purchasePrice!) * 100;
  }

  // Check if in profit
  bool get isProfit => profitLoss >= 0;

  // NEW: Calculate price change from previous price
  double get priceChange {
    if (price == null || previousPrice == null || previousPrice! <= 0) return 0.0;
    return price! - previousPrice!;
  }

  // NEW: Calculate price change percentage
  double get priceChangePercentage {
    if (previousPrice == null || previousPrice! <= 0) return 0.0;
    if (price == null) return 0.0;
    return ((price! - previousPrice!) / previousPrice!) * 100;
  }

  // NEW: Check if price went up
  bool get isPriceUp => priceChange > 0;

  // NEW: Check if price went down
  bool get isPriceDown => priceChange < 0;

  // NEW: Check if price changed
  bool get hasPriceChanged => priceChange != 0;

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'coinId': coinId,
      'coinName': coinName,
      'symbol': symbol,
      'quantity': quantity,
      'price': price,
      'purchasePrice': purchasePrice,
      'previousPrice': previousPrice, // NEW
    };
  }

  // Create from JSON
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
          : null, // NEW
    );
  }

  // Create a copy with updated values
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