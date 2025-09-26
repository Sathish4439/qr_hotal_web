import 'package:ecommerce_flutter/feature/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_flutter/feature/home/view/widgets/app_bar.dart';
import 'package:ecommerce_flutter/feature/home/view/widgets/product_card.dart';
import 'package:ecommerce_flutter/feature/home/view/widgets/most_popular.dart';
import 'package:get/get.dart';

class MostPopularScreen extends StatefulWidget {
  const MostPopularScreen({super.key});

  static String route() => '/most_popular';

  @override
  State<MostPopularScreen> createState() => _MostPopularScreenState();
}

class _MostPopularScreenState extends State<MostPopularScreen> {
  var controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    // Listen to category changes to refresh the UI
    controller.selectIndex.listen((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // Clean up listeners
    super.dispose();
  }

  // Get filtered menu items based on selected category
  List<dynamic> get filteredMenuItems {
    if (controller.menuList.isEmpty) return [];

    // Get unique categories
    final uniqueCategories =
        controller.menuList.map((item) => item.category).toSet().toList();

    // If no category selected or invalid index, show all items
    if (controller.selectIndex.value >= uniqueCategories.length) {
      return controller.menuList;
    }

    // Filter by selected category
    final selectedCategory = uniqueCategories[controller.selectIndex.value];
    return controller.menuList
        .where((item) => item.category == selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.fromLTRB(24, 24, 24, 0);
    return Scaffold(
      appBar: FRAppBar.defaultAppBar(
        context,
        title: 'Most Popular',
        actions: [
          IconButton(
            icon: Image.asset('assets/icons/search@2x.png', scale: 2.0),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(slivers: [
        SliverPadding(
          padding: padding,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              ((context, index) => const MostPupularCategory()),
              childCount: 1,
            ),
          ),
        ),

      //  Divider(),
        SliverPadding(
          padding: padding,
          sliver: _buildPopulars(),
        ),
        //  const SliverAppBar(flexibleSpace: SizedBox(height: 24))
      ]),
    );
  }

  Widget _buildPopulars() {
    return Obx(() {
      final items = filteredMenuItems;

      if (items.isEmpty) {
        return SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant_menu,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No items found for this category',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try selecting a different category',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 185,
          mainAxisSpacing: 24,
          crossAxisSpacing: 16,
          mainAxisExtent: 300,
        ),
        delegate: SliverChildBuilderDelegate(
          _buildPopularItem,
          childCount: items.length,
        ),
      );
    });
  }

  Widget _buildPopularItem(BuildContext context, int index) {
    final items = filteredMenuItems;
    if (index >= items.length) return const SizedBox.shrink();

    final data = items[index];
    return ProductCard(
      data: data,
    );
  }
}
