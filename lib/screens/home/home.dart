import 'package:ecommerce_flutter/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_flutter/components/product_card.dart';
import 'package:ecommerce_flutter/model/popular.dart';
import 'package:ecommerce_flutter/screens/detail/detail_screen.dart';
import 'package:ecommerce_flutter/screens/home/hearder.dart';
import 'package:ecommerce_flutter/screens/home/most_popular.dart';
import 'package:ecommerce_flutter/screens/home/search_field.dart';
import 'package:ecommerce_flutter/screens/home/special_offer.dart';
import 'package:ecommerce_flutter/screens/mostpopular/most_popular_screen.dart';
import 'package:ecommerce_flutter/screens/special_offers/special_offers_screen.dart';
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
  Widget build(BuildContext context) {
    const padding = EdgeInsets.fromLTRB(24, 24, 24, 0);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          // const SliverPadding(
          //   padding: EdgeInsets.only(top: 24),
          //   sliver: SliverAppBar(
          //     pinned: true,
          //     flexibleSpace: HomeAppBar(),
          //   ),
          // ),
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
          const SliverAppBar(flexibleSpace: SizedBox(height: 24))
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        const SearchField(),
        const SizedBox(height: 24),
        SpecialOffers(onTapSeeAll: () => _onTapSpecialOffersSeeAll(context)),
        const SizedBox(height: 24),
        MostPopularTitle(onTapseeAll: () => _onTapMostPopularSeeAll(context)),
        const SizedBox(height: 24),
        const MostPupularCategory(),
      ],
    );
  }

  Widget _buildPopulars() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 185,
        mainAxisSpacing: 24,
        crossAxisSpacing: 16,
        mainAxisExtent: 300,
      ),
      delegate: SliverChildBuilderDelegate(_buildPopularItem, childCount: 30),
    );
  }

 Widget _buildPopularItem(BuildContext context, int index) {
  final data = controller.homePopularProducts[
    index % controller.homePopularProducts.length
  ];

  return ProductCard(
  data: data,
  ontap: (product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShopDetailScreen(product: product),
      ),
    );
  },
);}



  void _onTapMostPopularSeeAll(BuildContext context) {
    Navigator.pushNamed(context, MostPopularScreen.route());
  }

  void _onTapSpecialOffersSeeAll(BuildContext context) {
    Navigator.pushNamed(context, SpecialOfferScreen.route());
  }
}
