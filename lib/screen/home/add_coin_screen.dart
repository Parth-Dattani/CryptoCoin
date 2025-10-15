import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/constant.dart';
import '../../controller/controller.dart';


class AddCoinScreen extends GetView<AddCoinController> {
  static const pageId = "/AddCoinScreen";

  const AddCoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.darkBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Add Cryptocurrency",
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.lightBlue,
            padding: const EdgeInsets.all(16),
            child: Obx(() => TextField(
              controller: controller.searchController,
              onChanged: controller.searchCoin,
              style: TextStyle(color: AppColors.whiteColor),
              decoration: InputDecoration(
                hintText: "Search coins...",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.7)),
                suffixIcon: controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.close, color: Colors.white.withOpacity(0.7)),
                  onPressed: controller.clearSearch,
                )
                    : null,
                filled: true,
                fillColor: const Color(0xFF0A0E27),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF6366F1),
                    width: 2,
                  ),
                ),
              ),
            )),
          ),

          Expanded(
            child: Obx(() {
              if (controller.displayedCoins.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                 Color(0xFF6366F1).withOpacity(0.2),
                                 Color(0xFF8B5CF6).withOpacity(0.2),
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No coins found",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: controller.displayedCoins.length,
                itemBuilder: (context, index) {
                  final coin = controller.displayedCoins[index];

                  return Obx(() {
                    final isSelected = controller.selectedCoin.value?.id == coin.id;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ?  LinearGradient(
                          colors: [
                            Color(0xFF6366F1),
                            Color(0xFF8B5CF6),
                          ],
                        )
                            : LinearGradient(
                          colors: [
                            const Color(0xFF1A1F3A),
                            const Color(0xFF1A1F3A).withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF6366F1)
                              : Colors.white.withOpacity(0.1),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                            : null,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: isSelected
                                  ? [
                                Colors.white.withOpacity(0.3),
                                Colors.white.withOpacity(0.2),
                              ]
                                  : [
                                 Color(0xFF6366F1).withOpacity(0.8),
                                 Color(0xFF8B5CF6).withOpacity(0.8),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              coin.symbol.isNotEmpty
                                  ? coin.symbol.substring(0, 1).toUpperCase()
                                  : '?',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          coin.name,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                            fontSize: 15,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              coin.symbol.toUpperCase(),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              controller.getPriceDisplay(coin),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? Colors.white.withOpacity(0.9)
                                    : Color(0xFF6366F1),
                              ),
                            ),
                          ],
                        ),
                        trailing: isSelected
                            ? Icon(
                          Icons.check_circle,
                          color: AppColors.whiteColor,
                          size: 28,
                        )
                            : null,
                        onTap: () => controller.selectCoin(coin),
                      ),
                    );
                  });
                },
              );
            }),
          ),

          Obx(() {
            if (controller.selectedCoin.value == null) {
              return const SizedBox.shrink();
            }

            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1F3A),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Selected Coin Display
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF6366F1),
                          Color(0xFF8B5CF6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF6366F1).withOpacity(0.3),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: Center(
                            child: Text(
                              controller.selectedCoin.value!.symbol.isNotEmpty
                                  ? controller.selectedCoin.value!.symbol
                                  .substring(0, 1)
                                  .toUpperCase()
                                  : '?',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
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
                                controller.selectedCoin.value!.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.selectedCoin.value!.symbol.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Price: ${controller.getPriceDisplay(controller.selectedCoin.value!)}",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: AppColors.whiteColor,),
                          onPressed: controller.deselectCoin,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quantity Input
                  TextField(
                    controller: controller.quantityController,
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(color: AppColors.whiteColor,),
                    decoration: InputDecoration(
                      hintText: "Enter quantity",
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                      prefixIcon: Icon(Icons.numbers, color: Colors.white.withOpacity(0.7)),
                      filled: true,
                      fillColor: const Color(0xFF0A0E27),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color(0xFF6366F1),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Add Button
                  Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isAdding.value
                          ? null
                          : controller.addToPortfolio,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        disabledBackgroundColor: const Color(0xFF1A1F3A),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                        shadowColor: const Color(0xFF6366F1).withOpacity(0.5),
                      ),
                      child: controller.isAdding.value
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white),
                        ),
                      )
                          : Text(
                        "Add to Portfolio",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}