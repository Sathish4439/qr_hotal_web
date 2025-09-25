import 'package:ecommerce_flutter/core/common_wid/widget.dart';
import 'package:ecommerce_flutter/core/theme/app_color.dart';
import 'package:ecommerce_flutter/core/theme/app_font.dart';
import 'package:ecommerce_flutter/feature/home/controller/order_controller.dart';
import 'package:ecommerce_flutter/feature/home/model/menu_item.dart';
import 'package:ecommerce_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef ProductCardOnTaped = void Function(MenuItem data);

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.data, this.ontap});

  final MenuItem data;
  final ProductCardOnTaped? ontap;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final controller = Get.put(OrderController());
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.ontap?.call(widget.data),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: KborderRadius,
          border: Border.all(color: AppColors.secondaryLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: getHeight(0.18),
              decoration: const BoxDecoration(
                borderRadius: KborderRadius,
                color: Color(0xFFeeeeee),
              ),
              child: loadImage(widget.data.imageUrl, height: 50, width: 50),
            ),
            Text(
              widget.data.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppFonts.subHeadingStyle(color: Colors.black),
            ),
            SizedBox(
              width: getWidth(0.34),
              child: Text(
                widget.data.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppFonts.captionStyle(color: AppColors.textSecondary),
              ),
            ),
            Text(
              "Rs. ${widget.data.price}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppFonts.headingStyle(color: AppColors.textBlack),
            ),
            CustomeButton(
              text: "Add to Cart",
              isLoading: isLoading,
              onTap: () async {
                setState(() => isLoading = true);

                await controller.addToCart(
                  widget.data,
                  controller.quantity.value,
                  controller.selectedOptions,
                  controller.totalPrice.value,
                );

                setState(() => isLoading = false);
              },
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
