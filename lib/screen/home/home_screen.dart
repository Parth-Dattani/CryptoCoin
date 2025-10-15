import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import '../../binding/bindings.dart';
import '../../constant/constant.dart';
import '../../controller/controller.dart';
import '../../model/model.dart';
import '../screen.dart';


class HomeScreen extends GetView<HomeController> {
  static const pageId = "/HomeScreen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1A1F3A),
        title: const Text(
          "My Portfolio",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Obx(() => AnimatedRotation(
            turns: controller.isLoading.value ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.refreshPrices(),
            ),
          )),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.refreshPrices(),
        color: const Color(0xFF6366F1),
        backgroundColor: const Color(0xFF1A1F3A),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 1500),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: 0.8 + (value * 0.2),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF6366F1).withOpacity(value),
                                Color(0xFF8B5CF6).withOpacity(value),
                              ],
                            ),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Loading Portfolio...",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            controller: controller.scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Portfolio Value Card with Animation
              // Replace the Portfolio Value Card section in your HomeScreen's CustomScrollView with this:

// Portfolio Value Card with Animation
              SliverToBoxAdapter(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 30 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: child,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withOpacity(0.5),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Total Portfolio Value",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TweenAnimationBuilder<double>(
                            tween: Tween(
                              begin: 0.0,
                              end: controller.totalPortfolioValue.value,
                            ),
                            duration: const Duration(milliseconds: 1000),
                            builder: (context, value, child) {
                              return Text(
                                "\$${value.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -1,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "${controller.portfolio.length} Holdings",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Portfolio Items
              if (controller.portfolio.isEmpty)
                SliverToBoxAdapter(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Opacity(
                          opacity: value,
                          child: child,
                        ),
                      );
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF6366F1).withOpacity(0.2),
                                    const Color(0xFF8B5CF6).withOpacity(0.2),
                                  ],
                                ),
                              ),
                              child: Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 80,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              "No holdings yet",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Tap + to add coins to your portfolio",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final item = controller.portfolio[index];

                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 400 + (index * 100)),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(30 * (1 - value), 0),
                            child: Opacity(
                              opacity: value,
                              child: child,
                            ),
                          );
                        },
                        child: Dismissible(
                          key: Key(item.coinId),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF4444), Color(0xFFCC0000)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.delete_outline,
                                    color: Colors.white, size: 32),
                                const SizedBox(height: 4),
                                Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onDismissed: (_) {
                            controller.removeFromPortfolio(item.coinId);
                          },
                          child: PortfolioItemCard(
                            item: item,
                            portfolio: controller.portfolio,
                          ),
                        ),
                      );
                    },
                    childCount: controller.portfolio.length,
                  ),
                ),

              // Bottom Padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          );
        }),
      ),
      floatingActionButton:
      FloatingActionButton.extended(
          onPressed: () async {
            final result = await Get.to(
                  () => const AddCoinScreen(),
              binding: AddCoinBinding(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 300),
            );

            if (result == true) {
              await controller.refreshPrices();
            }
          },
          backgroundColor: const Color(0xFF6366F1),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "Add Coin",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 8,
        ),

    );
  }
}

class PortfolioItemCard extends StatelessWidget {
  final PortfolioItem item;
  final RxList<PortfolioItem> portfolio;

  const PortfolioItemCard({
    required this.item,
    required this.portfolio,
    super.key,
  });

  PortfolioItem getCurrentItem() {
    try {
      return portfolio.firstWhere(
            (p) => p.coinId == item.coinId,
        orElse: () => item,
      );
    } catch (e) {
      return item;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx((){
      final currentItem = getCurrentItem();
     return GestureDetector(
       onLongPress: () {
         // Toggle price up/down for testing
         final currentItem = getCurrentItem();
         if (currentItem.price != null) {
           currentItem.previousPrice = currentItem.price;
           currentItem.price = currentItem.price! * 1.05; // +5%
           portfolio.refresh();


         }
       },
       onDoubleTap: () {
         // Decrease price
         final currentItem = getCurrentItem();
         if (currentItem.price != null) {
           currentItem.previousPrice = currentItem.price;
           currentItem.price = currentItem.price! * 0.95; // -5%
           portfolio.refresh();


         }
       },
       child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1A1F3A),
                const Color(0xFF1A1F3A).withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          // Coin Avatar
                          Hero(
                            tag: 'coin_${item.coinId}',
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF6366F1),
                                    Color(0xFF8B5CF6),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF6366F1).withOpacity(0.5),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  item.symbol.isNotEmpty
                                      ? item.symbol.substring(0, 1).toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.coinName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.symbol.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white.withOpacity(0.5),
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.clip
                                        ),
                                      ),
                                    ),
                                    // **NEW: Real-time price change badge**
                                    Obx(() {
                                      final currentItem = getCurrentItem();
                                      if (currentItem.hasPriceChanged) {
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 8),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: currentItem.isPriceUp
                                                  ? const Color(0xFF00C853).withOpacity(0.2)
                                                  : const Color(0xFFFF4444).withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  currentItem.isPriceUp
                                                      ? Icons.arrow_drop_up
                                                      : Icons.arrow_drop_down,
                                                  size: 12,
                                                  color: currentItem.isPriceUp
                                                      ? const Color(0xFF00C853)
                                                      : const Color(0xFFFF4444),
                                                ),
                                                Text(
                                                  "${currentItem.priceChangePercentage.abs().toStringAsFixed(2)}%",
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                    color: currentItem.isPriceUp
                                                        ? const Color(0xFF00C853)
                                                        : const Color(0xFFFF4444),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Total Value and Profit/Loss
                    Obx(() {
                      final currentItem = getCurrentItem();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (currentItem.price != null && currentItem.price! > 0)
                            TweenAnimationBuilder<double>(
                              key: ValueKey(currentItem.totalValue),
                              tween: Tween(
                                begin: currentItem.totalValue,
                                end: currentItem.totalValue,
                              ),
                              duration: const Duration(milliseconds: 800),
                              builder: (context, value, child) {
                                return Text(
                                  "\$${value.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            )
                          else
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF6366F1)),
                                ),
                              ),
                            ),

                          // Profit/Loss indicator (based on purchase price)
                          if (currentItem.price != null &&
                              currentItem.price! > 0 &&
                              currentItem.purchasePrice != null &&
                              currentItem.purchasePrice! > 0)
                            const SizedBox(height: 4),

                          if (currentItem.price != null &&
                              currentItem.price! > 0 &&
                              currentItem.purchasePrice != null &&
                              currentItem.purchasePrice! > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: currentItem.isProfit
                                    ? const Color(0xFF00C853).withOpacity(0.2)
                                    : const Color(0xFFFF4444).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    currentItem.isProfit
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    size: 12,
                                    color: currentItem.isProfit
                                        ? const Color(0xFF00C853)
                                        : const Color(0xFFFF4444),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${currentItem.profitLossPercentage.abs().toStringAsFixed(2)}%",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: currentItem.isProfit
                                          ? const Color(0xFF00C853)
                                          : const Color(0xFFFF4444),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 16),

                Divider(height: 1, color: Colors.white.withOpacity(0.1)),
                const SizedBox(height: 16),

                // Price and Quantity Row with GREEN/RED price change
                Row(
                  children: [
                    // Current Price with LIVE change indicator
                    Expanded(
                      child: Obx(() {
                        final currentItem = getCurrentItem();

                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            // **NEW: Background color changes based on price movement**
                            color: currentItem.hasPriceChanged
                                ? (currentItem.isPriceUp
                                ? const Color(0xFF00C853).withOpacity(0.1)
                                : const Color(0xFFFF4444).withOpacity(0.1))
                                : Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: currentItem.hasPriceChanged
                                ? Border.all(
                              color: currentItem.isPriceUp
                                  ? const Color(0xFF00C853).withOpacity(0.3)
                                  : const Color(0xFFFF4444).withOpacity(0.3),
                              width: 1.5,
                            )
                                : null,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Current Price",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white.withOpacity(0.5),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  // **NEW: Small indicator icon**
                                  if (currentItem.hasPriceChanged)
                                    Icon(
                                      currentItem.isPriceUp
                                          ? Icons.trending_up
                                          : Icons.trending_down,
                                      size: 14,
                                      color: currentItem.isPriceUp
                                          ? const Color(0xFF00C853)
                                          : const Color(0xFFFF4444),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              if (currentItem.price != null && currentItem.price! > 0) ...[
                                Text(
                                  "\$${currentItem.price!.toStringAsFixed(5)}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    // **NEW: Price text color changes**
                                    color: currentItem.hasPriceChanged
                                        ? (currentItem.isPriceUp
                                        ? const Color(0xFF00C853)
                                        : const Color(0xFFFF4444))
                                        : Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                // **NEW: Show actual price change amount**
                                if (currentItem.hasPriceChanged) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    "${currentItem.isPriceUp ? '+' : ''}\$${currentItem.priceChange.toStringAsFixed(5)}",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: currentItem.isPriceUp
                                          ? const Color(0xFF00C853)
                                          : const Color(0xFFFF4444),
                                    ),
                                  ),
                                ],
                              ] else
                                Text(
                                  "Loading...",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                    ),
                    const SizedBox(width: 8),

                    // Purchase Price
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Buy Price",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.5),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            if (item.purchasePrice != null && item.purchasePrice! > 0)
                              Text(
                                "\$${item.purchasePrice!.toStringAsFixed(5)}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              )
                            else
                              Text(
                                "N/A",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Quantity
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Quantity",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.5),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.quantity.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Profit/Loss Details (if available)
                Obx(() {
                  final currentItem = getCurrentItem();

                  if (currentItem.price == null ||
                      currentItem.price! <= 0 ||
                      currentItem.purchasePrice == null ||
                      currentItem.purchasePrice! <= 0) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: currentItem.isProfit
                                ? [
                              AppColors.greenColor.withOpacity(0.15),
                              AppColors.greenColor.withOpacity(0.05),
                            ]
                                : [
                              AppColors.errorColor.withOpacity(0.15),
                              AppColors.errorColor.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: currentItem.isProfit
                                ?  AppColors.greenColor.withOpacity(0.3)
                                : AppColors.errorColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  currentItem.isProfit
                                      ? Icons.trending_up
                                      : Icons.trending_down,
                                  color: currentItem.isProfit
                                      ? AppColors.greenColor
                                      : AppColors.errorColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentItem.isProfit ? "Profit" : "Loss",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white.withOpacity(0.7),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "${currentItem.isProfit ? '+' : ''}\$${currentItem.profitLoss.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: currentItem.isProfit
                                            ? AppColors.greenColor
                                            : AppColors.errorColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: currentItem.isProfit
                                    ? AppColors.greenColor
                                    : AppColors.errorColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${currentItem.isProfit ? '+' : ''}${currentItem.profitLossPercentage.toStringAsFixed(2)}%",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color:AppColors.whiteColor
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
     );
    });
  }
}


