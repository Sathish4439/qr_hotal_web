import 'package:ecommerce_flutter/core/common_wid/widget.dart';
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
    return ExpansionTile(
      tilePadding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.transparent)),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: loadImage(
          cartItem.menuItem.imageUrl,
          height: 50,
          width: 50,
        ),
      ),
      title: Text(
        cartItem.menuItem.name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        "₹${cartItem.totalPrice.toStringAsFixed(2)}",
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove, size: 18),
              onPressed: () {
                if (cartItem.quantity > 1) {
                  onQuantityChanged?.call(cartItem.quantity - 1);
                }
              },
            ),
            Text(
              cartItem.quantity.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add, size: 18),
              onPressed: () {
                onQuantityChanged?.call(cartItem.quantity + 1);
              },
            ),
          ],
        ),
      ),

      // 👇 Expansion content
      children: [
        if (cartItem.options.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Selected Options:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                ...cartItem.options.map((opt) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(opt.name),
                        Text(
                          "+ ₹${opt.extraPrice}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    )),
              ],
            ),
          ),
      ],
    );
  }
}
