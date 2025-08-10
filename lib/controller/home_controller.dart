import 'package:ecommerce_flutter/model/category.dart';
import 'package:ecommerce_flutter/model/popular.dart';
import 'package:ecommerce_flutter/model/special_offer.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {


var selectIndex = 0.obs;
var selectOfferIndex = 0.obs;

  final homePopularCategories = [
  PopularCategory(category: 'All', id: 1),
  PopularCategory(category: 'Chair', id: 2),
  PopularCategory(category: 'Kitchen', id: 3),
  PopularCategory(category: 'Table', id: 4),
  PopularCategory(category: 'Lamp', id: 5),
  PopularCategory(category: 'Cupboard', id: 6),
  PopularCategory(category: 'Vase', id: 7),
  PopularCategory(category: 'Others', id: 8),
];

final homePopularProducts = [
  Product(
    title: 'Foam Padded Chair',
    description: 'Comfortable foam padded chair perfect for long sitting hours.',
    star: '4.5',
    sold: '8374',
    price: '120.00',
    icon: 'assets/icons/products/foam_padded_chair@2x.png',
    id: 1,
  ),
  Product(
    title: 'Small Bookcase',
    description: 'Compact wooden bookcase ideal for small spaces.',
    star: '4.7',
    sold: '7483',
    price: '145.40',
    icon: 'assets/icons/products/book_case@2x.png',
    id: 2,
  ),
  Product(
    title: 'Glass Lamp',
    description: 'Stylish glass lamp to brighten your room with elegance.',
    star: '4.3',
    sold: '6937',
    price: '40.00',
    icon: 'assets/icons/products/lamp.png',
    id: 3,
  ),
  Product(
    title: 'Glass Package',
    description: 'Elegant glassware package for dining or decorative use.',
    star: '4.9',
    sold: '8174',
    price: '55.00',
    icon: 'assets/icons/products/class_package@2x.png',
    id: 4,
  ),
  Product(
    title: 'Plastic Chair',
    description: 'Durable and lightweight plastic chair for indoor and outdoor use.',
    star: '4.6',
    sold: '6843',
    price: '65.00',
    icon: 'assets/icons/products/plastic_chair@2x.png',
    id: 5,
  ),
  Product(
    title: 'Wooden Chairs',
    description: 'Classic wooden chairs to add charm to your dining area.',
    star: '4.5',
    sold: '7758',
    price: '69.00',
    icon: 'assets/icons/products/wooden_chairs.png',
    id: 6,
  ),
];


final homeCategories = <Category>[
  const Category(icon: 'assets/icons/category_sofa@2x.png', title: 'Sofa', id: 'sofa'),
  const Category(icon: 'assets/icons/category_chair@2x.png', title: 'Chair', id: 'chair'),
  const Category(icon: 'assets/icons/category_table@2x.png', title: 'Table', id: 'table'),
  const Category(icon: 'assets/icons/category_kitchen@2x.png', title: 'Kitchen', id: 'kitchen'),
  const Category(icon: 'assets/icons/category_lamp@2x.png', title: 'Lamp', id: 'lamp'),
  const Category(icon: 'assets/icons/category_cupboard@2x.png', title: 'Cupboard', id: 'cupboard'),
  const Category(icon: 'assets/icons/category_vase@2x.png', title: 'Vase', id: 'vase'),
  const Category(icon: 'assets/icons/category_others@2x.png', title: 'Others', id: 'others'),
];


final homeSpecialOffers = <SpecialOffer>[
  const SpecialOffer(
    discount: '25%',
    title: "Today’s Special!",
    detail: 'Get a discount on every order — valid only for today.',
    icon: 'assets/icons/products/sofa.png',
  ),
  const SpecialOffer(
    discount: '35%',
    title: "Tomorrow Will Be Better!",
    detail: 'Please support us with a star!',
    icon: 'assets/icons/products/shiny_chair.png',
  ),
  const SpecialOffer(
    discount: '100%',
    title: "Free for You Today!",
    detail: 'If you have any problem, contact us.',
    icon: 'assets/icons/products/lamp.png',
  ),
  const SpecialOffer(
    discount: '75%',
    title: "It’s for You!",
    detail: 'Wishing you a fun and joyful time.',
    icon: 'assets/icons/products/plastic_chair@2x.png',
  ),
  const SpecialOffer(
    discount: '65%',
    title: "Make Yourself at Home!",
    detail: 'If you have any confusion, let us know.',
    icon: 'assets/icons/products/book_case@2x.png',
  ),
];

  
}