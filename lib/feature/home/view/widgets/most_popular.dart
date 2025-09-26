import 'package:ecommerce_flutter/core/theme/app_color.dart';
import 'package:ecommerce_flutter/feature/home/controller/home_controller.dart';
import 'package:ecommerce_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MostPupularCategory extends StatefulWidget {
  const MostPupularCategory({super.key});

  @override
  State<MostPupularCategory> createState() => _MostPupularCategoryState();
}

class _MostPupularCategoryState extends State<MostPupularCategory> {
  var controller = Get.put(HomeController());

  // Get unique categories from menu list
  List<String> get uniqueCategories {
    final categories =
        controller.menuList.map((item) => item.category).toSet().toList();
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildBody(),
      ],
    );
  }

  Widget _buildBody() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        itemCount: uniqueCategories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: _buildItem,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 12);
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final category = uniqueCategories[index];
    return Obx(() => Container(
          decoration: BoxDecoration(
            borderRadius: KborderRadius,
            border: Border.all(color: AppColors.textWhite, width: 2),
            gradient: controller.selectIndex.value == index
                ? LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.secondary, // dark left
                      AppColors.secondaryLight, // lighter right
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFFFFF), // pure white
                      Color(0xFFF5F5F5), // soft gray
                    ],
                  ),
          ),
          alignment: Alignment.center,
          child: InkWell(
            borderRadius: KborderRadius,
            onTap: () => _onTapItem(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              child: Text(
                category,
                style: TextStyle(
                  color: controller.selectIndex.value == index
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xFF101010),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ));
  }

  // user interact the item of special offers.
  void _onTapItem(int index) {
    controller.selectIndex.value = index;
  }
}

class MostPopularTitle extends StatelessWidget {
  const MostPopularTitle({
    Key? key,
    required this.onTapseeAll,
  }) : super(key: key);

  final Function onTapseeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Most Popular',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF212121))),
        TextButton(
          onPressed: () => onTapseeAll(),
          child: const Text(
            'See All',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF212121),
            ),
          ),
        ),
      ],
    );
  }
}
