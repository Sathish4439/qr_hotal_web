import 'package:ecommerce_flutter/model/popular.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_flutter/screens/detail/detail_screen.dart';
import 'package:ecommerce_flutter/screens/home/home.dart';
import 'package:ecommerce_flutter/screens/mostpopular/most_popular_screen.dart';
import 'package:ecommerce_flutter/screens/profile/profile_screen.dart';
import 'package:ecommerce_flutter/screens/special_offers/special_offers_screen.dart';
import 'package:ecommerce_flutter/screens/test/test_screen.dart';

final Map<String, WidgetBuilder> routes = {
  HomeScreen.route(): (context) => const HomeScreen(title: '123'),
  MostPopularScreen.route(): (context) => const MostPopularScreen(),
  SpecialOfferScreen.route(): (context) => const SpecialOfferScreen(),
  ProfileScreen.route(): (context) => const ProfileScreen(),
  ShopDetailScreen.route(): (context) =>  ShopDetailScreen(
    
    product: Product.nullProduct,
  ),
  TestScreen.route(): (context) => const TestScreen(),
};
