import 'dart:ui';

import 'package:ecommerce_flutter/core/common_wid/widget.dart';
import 'package:ecommerce_flutter/core/theme/app_color.dart';
import 'package:ecommerce_flutter/core/theme/app_font.dart';
import 'package:ecommerce_flutter/feature/home/controller/order_controller.dart';
import 'package:ecommerce_flutter/feature/home/model/menu_item.dart';
import 'package:ecommerce_flutter/feature/home/view/cart_screen.dart';
import 'package:ecommerce_flutter/feature/home/view/widgets/app_bar.dart';
import 'package:ecommerce_flutter/utils/size_config.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopDetailScreen extends StatefulWidget {
  final MenuItem product;
  const ShopDetailScreen({super.key, required this.product});

  static String route() => '/shop_detail';

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  final controller = Get.put(OrderController());
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    controller.calculatePrice(double.parse(widget.product.price));

    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.offset > 100) {
          _appBarOpacity = 1.0;
        } else {
          _appBarOpacity = _scrollController.offset / 100;
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: FRAppBar.defaultAppBar(
        context,
        title: 'Details',
        actions: [
          GestureDetector(
              onTap: () {
                Get.to(() => CartScreen());
              },
              child: GradientIcon(
                Icons.shopping_bag_rounded,
                size: 40,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.secondary,
                    AppColors.secondaryLight,
                  ],
                ),
              ))
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                // App Bar with collapsing image
                SliverAppBar(
                  pinned: true,
                  snap: false,
                  floating: false,
                  expandedHeight: 350,
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8 * _appBarOpacity),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back,
                          color: _appBarOpacity > 0.5
                              ? Colors.black
                              : Colors.white),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Stack(
                      children: [
                        // Product image with gradient overlay
                        Container(
                          child: Center(
                            child: loadImage(product.imageUrl,
                                height: 250, width: 250),
                          ),
                        ),
                        // Gradient overlay at bottom of image
                        // Container(
                        //   decoration: BoxDecoration(
                        //     gradient: LinearGradient(
                        //       begin: Alignment.bottomCenter,
                        //       end: Alignment.topCenter,
                        //       colors: [
                        //         Colors.white,
                        //         Colors.white.withOpacity(0.8),
                        //         Colors.transparent,
                        //       ],
                        //       stops: const [0.0, 0.5, 1.0],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),

                // Product details
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category tag
                        if (product.category != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryLight.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              product.category!,
                              style: AppFonts.captionStyle(
                                  color: AppColors.secondaryLight),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildNameWithPrice(product.name, product.price),
                            _buildQuantity(product),
                            //  const SizedBox(height: 150),
                          ],
                        ),

                        // Rating and reviews
                        const SizedBox(height: 12),
                        _buildRatingSection(),

                        const SizedBox(height: 16),
                        _buildDivider(),
                        const SizedBox(height: 16),

                        ..._buildDescription(product.description),
                        const SizedBox(height: 24),

                        _buildOptionWidget(product),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Custom app bar that appears on scroll
            //  _buildAppBar(product),

            // Fixed bottom bar
            _buildBottomBar(product),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(MenuItem product) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        backgroundColor: Colors.white.withOpacity(_appBarOpacity),
        elevation: _appBarOpacity > 0.5 ? 2 : 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back,
              color: _appBarOpacity > 0.5 ? Colors.black : Colors.white),
        ),
        title: _appBarOpacity > 0.5
            ? Text(product.name,
                style: AppFonts.subHeadingStyle(color: AppColors.textBlack),
                overflow: TextOverflow.ellipsis)
            : const SizedBox.shrink(),
        centerTitle: true,
        actions: [
          GestureDetector(
              onTap: () {
                Get.to(() => CartScreen());
              },
              child: GradientIcon(
                Icons.shopping_bag_rounded,
                size: 40,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.secondary,
                    AppColors.secondaryLight,
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildNameWithPrice(String name, String price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: AppFonts.headingStyle(
            color: AppColors.textBlack,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Rs $price",
                style: AppFonts.headingStyle(
                  color: AppColors.secondaryLight,
                )),
            // Favorite button
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite_border, size: 28),
              color: AppColors.secondaryLight,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Row(
      children: [
        // Star rating
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text('4.8', style: AppFonts.bodyStyle()),
            const SizedBox(width: 4),
            Text('(128 reviews)', style: AppFonts.captionStyle()),
          ],
        ),
        const Spacer(),
        // Share button
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.share, size: 22),
          color: AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildDivider() => Divider(height: 1, color: Colors.grey[200]);

  List<Widget> _buildDescription(String description) => [
        Text('Description',
            style: AppFonts.subHeadingStyle(
              color: AppColors.textBlack,
            )),
        const SizedBox(height: 12),
        ExpandableText(
          description,
          expandText: 'Show more',
          collapseText: 'Show less',
          linkStyle: AppFonts.bodyStyle(color: AppColors.secondaryLight),
          style: AppFonts.bodyStyle(
            color: AppColors.textSecondary,
          ),
          maxLines: 3,
        ),
      ];

  Widget _buildOptionWidget(MenuItem product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Customize your order',
            style: AppFonts.subHeadingStyle(
              color: AppColors.textBlack,
            )),
        const SizedBox(height: 12),
        Text('Select options (optional)',
            style: AppFonts.captionStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 16),
        ...product.options.map((option) {
          return Obx(() {
            bool isSelected = controller.selectedOptions.contains(option);
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.secondaryLight.withOpacity(0.1)
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isSelected ? AppColors.secondaryLight : Colors.grey[200]!,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: CheckboxListTile(
                checkColor: Colors.white,
                activeColor: AppColors.secondaryLight,
                contentPadding: const EdgeInsets.only(left: 8, right: 16),
                title: Text(option.name,
                    style: AppFonts.bodyStyle(
                      color: AppColors.textBlack,
                    )),
                secondary: Text("+Rs ${option.extraPrice}",
                    style: AppFonts.bodyStyle(color: AppColors.secondaryLight)),
                value: isSelected,
                onChanged: (val) {
                  controller.toggleOption(option, double.parse(product.price));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          });
        }).toList(),
      ],
    );
  }

  Widget _buildQuantity(MenuItem product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[50],
            border: Border.all(color: Colors.grey[200]!),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quantity',
                  style: AppFonts.bodyStyle(color: AppColors.textBlack)),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.quantity.value > 1
                              ? AppColors.secondaryLight.withOpacity(0.3)
                              : Colors.grey[100],
                        ),
                        child: Icon(Icons.remove,
                            size: 18,
                            color: controller.quantity.value > 1
                                ? AppColors.secondaryLight
                                : Colors.grey),
                      ),
                      onTap: () {
                        if (controller.quantity.value > 1) {
                          controller.quantity.value--;
                          controller
                              .calculatePrice(double.parse(product.price));
                        }
                      },
                    ),
                    const SizedBox(width: 16),
                    Obx(() => Text('${controller.quantity.value}',
                        style: AppFonts.bodyStyle())),
                    const SizedBox(width: 16),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.textSecondary,
                        ),
                        child: const Icon(Icons.add,
                            size: 18, color: Colors.white),
                      ),
                      onTap: () {
                        controller.quantity.value++;
                        controller.calculatePrice(double.parse(product.price));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(MenuItem product) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              _buildDivider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total price',
                          style: AppFonts.captionStyle(
                              color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Obx(() => Text(
                            'Rs ${controller.totalPrice.value.toStringAsFixed(2)}',
                            style: AppFonts.headingStyle(
                              color: AppColors.textBlack,
                            ),
                          )),
                    ],
                  ),
                  _buildAddToCartButton()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddToCartButton() {
    return SizedBox(
      width: 180,
      child: ElevatedButton(
        onPressed: () {
          controller.addToCart(widget.product);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryLight,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_outlined, size: 20),
            const SizedBox(width: 8),
            Text('Add to Cart', style: AppFonts.bodyStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
