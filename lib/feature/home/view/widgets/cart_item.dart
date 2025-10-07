import 'package:ecommerce_flutter/core/common_wid/widget.dart';
import 'package:ecommerce_flutter/core/theme/app_color.dart';
import 'package:ecommerce_flutter/feature/home/model/cartModel.dart';
import 'package:flutter/material.dart';

class CartItemWid extends StatelessWidget {
  final CartItem cartItem;
  final Function(int)? onQuantityChanged;

  const CartItemWid({
    super.key,
    required this.cartItem,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Food Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: loadImage(
                cartItem.menuItem.imageUrl,
                height: 60,
                width: 60,
              ),
            ),
            const SizedBox(width: 12),

            // Food Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.menuItem.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₹${(double.tryParse(cartItem.menuItem.price) ?? 0.0).toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                  if (cartItem.options.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      "${cartItem.options.length} add-ons",
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Quantity Controls
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Decrease Button
                  InkWell(
                    onTap: () {
                      if (cartItem.quantity > 1) {
                        onQuantityChanged?.call(cartItem.quantity - 1);
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.remove,
                        size: 18,
                        color: cartItem.quantity > 1
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),

                  // Quantity
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      cartItem.quantity.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  // Increase Button
                  InkWell(
                    onTap: () {
                      onQuantityChanged?.call(cartItem.quantity + 1);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.add,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
