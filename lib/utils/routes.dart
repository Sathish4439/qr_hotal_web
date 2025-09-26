import 'package:flutter/material.dart';
import 'package:ecommerce_flutter/feature/home/view/home_page.dart';
import 'package:ecommerce_flutter/feature/home/view/most_popular_screen.dart';
import 'package:ecommerce_flutter/feature/home/view/profile_screen.dart';
import 'package:ecommerce_flutter/feature/home/view/special_offers_screen.dart';
import 'package:ecommerce_flutter/feature/home/view/test_screen.dart';

final Map<String, WidgetBuilder> routes = {
  HomeScreen.route(): (context) => const HomeScreen(title: '123'),
  MostPopularScreen.route(): (context) => const MostPopularScreen(),
  SpecialOfferScreen.route(): (context) => const SpecialOfferScreen(),
  ProfileScreen.route(): (context) => const ProfileScreen(),
  // ShopDetailScreen.route(): (context) =>  ShopDetailScreen(
    
  //   product: MenuItem.nullMenuItem,
  // ),
  TestScreen.route(): (context) => const TestScreen(),
};
