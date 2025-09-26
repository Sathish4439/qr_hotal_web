import 'dart:ui';

import 'package:ecommerce_flutter/core/common_wid/widget.dart';
import 'package:ecommerce_flutter/core/theme/app_color.dart';
import 'package:ecommerce_flutter/core/theme/app_font.dart';
import 'package:ecommerce_flutter/feature/home/controller/home_controller.dart';
import 'package:ecommerce_flutter/feature/home/view/widgets/search_field.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce_flutter/feature/home/view/most_popular_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

typedef SpecialOffersOnTapSeeAll = void Function();

class SpecialOffers extends StatefulWidget {
  final SpecialOffersOnTapSeeAll? onTapSeeAll;
  const SpecialOffers({
    super.key,
    this.onTapSeeAll,
  });

  @override
  State<SpecialOffers> createState() => _SpecialOffersState();
}

class _SpecialOffersState extends State<SpecialOffers> {
  var controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(),
        const SizedBox(height: 24),
        Stack(children: [
          Container(
            height: 210,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.secondary, // left color
                  AppColors.secondaryLight, // right faded color
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row (title + weather)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left texts
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome to",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Dot Restaurant",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Table Number 3",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    // Weather info placeholder
                  ],
                ),

                Spacer(),

                // Search field
                SearchField(),
              ],
            ),
          )
        ]),
        const SizedBox(height: 24),
        Obx(() => controller.loadMenu.value
            ? CircularProgressIndicator()
            : GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.categories.length,
                scrollDirection: Axis.vertical,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisExtent: 100,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  maxCrossAxisExtent: 77,
                ),
                itemBuilder: ((context, index) {
                  final data = controller.categories[index];

                  return CategoryWid(data: data);
                  //  CategoryWid(data: data);
                }),
              ))
      ],
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Hii...',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF212121)),
        ),
      ],
    );
  }
}

class CategoryWid extends StatelessWidget {
  const CategoryWid({
    super.key,
    required this.data,
  });

  final String data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, MostPopularScreen.route()),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                // glass background
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.secondaryLight,
                  width: 1.2,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: loadImage(
                data,
                height: 24,
                width: 24,
              ),
            ),
          ),
          const SizedBox(height: 12),
          FittedBox(
            child: Text(data,
                style: AppFonts.captionStyle(color: AppColors.textBlack)),
          ),
        ],
      ),
    );
  }
}
