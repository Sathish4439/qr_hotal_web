import 'package:ecommerce_flutter/core/common_wid/widget.dart';
import 'package:ecommerce_flutter/core/theme/app_color.dart';
import 'package:ecommerce_flutter/core/theme/app_font.dart';
import 'package:ecommerce_flutter/feature/home/model/menu_item.dart';
import 'package:ecommerce_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef ProductCardOnTaped = void Function(MenuItem data);

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.data, this.ontap});

  final MenuItem data;
  final ProductCardOnTaped? ontap;

  @override
  Widget build(BuildContext context) {
    // final data = datas[index % datas.length];

    return GestureDetector(
      // borderRadius: KborderRadius,
      onTap: () => ontap?.call(data),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: KborderRadius,
          //color: AppColors.secondaryLight.withOpacity(0.4),
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
              child: loadImage(data.imageUrl, height: 50, width: 50),
            ),
            Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              data.name,
              style: AppFonts.subHeadingStyle(color: Colors.black),
            ),
            SizedBox(
              width: getWidth(0.34),
              child: Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                data.description,
                style: AppFonts.captionStyle(color: AppColors.textSecondary),
              ),
            ),
            // _buildSoldPoint(4.5, 6937),

            Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              "Rs. ${data.price}",
              style: AppFonts.headingStyle(color: AppColors.textBlack),
            ),
            CustomeButton(
              text: "Add to Cart",
              onTap: () {},
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
