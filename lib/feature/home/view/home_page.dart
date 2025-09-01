import 'package:ecommerce_flutter/core/theme/app_color.dart';
import 'package:ecommerce_flutter/feature/home/controller/home_controller.dart';
import 'package:ecommerce_flutter/feature/home/model/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_flutter/feature/home/view/widgets/product_card.dart';
import 'package:ecommerce_flutter/feature/home/view/detail_screen.dart';
import 'package:ecommerce_flutter/feature/home/view/widgets/hearder.dart';
import 'package:ecommerce_flutter/feature/home/view/widgets/most_popular.dart';
import 'package:ecommerce_flutter/feature/home/view/widgets/search_field.dart';
import 'package:ecommerce_flutter/feature/home/view/widgets/special_offer.dart';
import 'package:ecommerce_flutter/feature/home/view/most_popular_screen.dart';
import 'package:ecommerce_flutter/feature/home/view/special_offers_screen.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  static String route() => '/home';

  const HomeScreen({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var controller = Get.put(HomeController());

  @override
  void initState() {
    callMethods();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.fromLTRB(24, 24, 24, 0);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: padding,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                ((context, index) => _buildBody(context)),
                childCount: 1,
              ),
            ),
          ),
          SliverPadding(
            padding: padding,
            sliver: _buildPopulars(),
          ),
          //  const SliverAppBar(flexibleSpace: SizedBox(height: 24))
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),

        SpecialOffers(onTapSeeAll: () => _onTapSpecialOffersSeeAll(context)),
        //const SizedBox(height: 24),
        MostPopularTitle(onTapseeAll: () => _onTapMostPopularSeeAll(context)),
        //  const SizedBox(height: 24),
        const MostPupularCategory(),
      ],
    );
  }

  Widget _buildPopulars() {
    return Obx(() => SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 185,
            mainAxisSpacing: 24,
            crossAxisSpacing: 16,
            mainAxisExtent: 300,
          ),
          delegate: SliverChildBuilderDelegate(_buildPopularItem,
              childCount: controller.menuList.length),
        ));
  }

  Widget _buildPopularItem(BuildContext context, int index) {
    final data = controller.menuList[index % controller.menuList.length];

    return ProductCard(
      data: data,
      ontap: (MenuItem) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShopDetailScreen(product: data),
          ),
        );
      },
    );
  }

  void _onTapMostPopularSeeAll(BuildContext context) {
    Navigator.pushNamed(context, MostPopularScreen.route());
  }

  void _onTapSpecialOffersSeeAll(BuildContext context) {
    Navigator.pushNamed(context, SpecialOfferScreen.route());
  }

  void callMethods() async {
    controller.fetchMenu();
    controller.filteredList.assignAll(controller.menuList);

    print("menuList lenghth ${controller.menuList.length}");
  }
}
