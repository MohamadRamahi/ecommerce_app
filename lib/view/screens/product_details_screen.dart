import 'package:ecommerce/cubit/cart_cubit.dart';
import 'package:ecommerce/cubit/favorite_cubit.dart';
import 'package:ecommerce/model/product_model.dart';
import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/screens/reviews_screen.dart';
import 'package:ecommerce/view/widget/notification_icon_widget.dart';
import 'package:ecommerce/view/widget/size_selctor_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;
  String selectedSize = 'L';

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: responsiveHeight(context, 16),
              horizontal: responsiveWidth(context, 24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BackButton(),
                    Text(
                      "Details",
                      style: TextStyle(
                        fontSize: responsiveWidth(context, 24),
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                     NotificationIcon(),
                  ],
                ),
                SizedBox(height: responsiveHeight(context, 24)),

                // Product Image + Favorite Button
                Container(
                  height: responsiveHeight(context, 360),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xffe7ecef),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          product.image,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: responsiveHeight(context, 16),
                        right: responsiveWidth(context, 16),
                        child: BlocBuilder<FavoriteProductsCubit, List<ProductModel>>(
                          builder: (context, favoriteProducts) {
                            final isFavorite = favoriteProducts.contains(product);
                            return Container(
                              height: responsiveHeight(context, 48),
                              width: responsiveWidth(context, 48),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 12),
                                    spreadRadius: 0,
                                    blurRadius: 14.12,
                                    color: const Color(0xff525252).withOpacity(0.25),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.black,
                                  size: responsiveWidth(context, 24),
                                ),
                                onPressed: () {
                                  final cubit = context.read<FavoriteProductsCubit>();
                                  if (isFavorite) {
                                    cubit.removeFromFavorites(product);
                                  } else {
                                    cubit.addToFavorites(product);
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: responsiveHeight(context, 12)),

                // Product Name
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: responsiveHeight(context, 12)),

                // Rating (Clickable)
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewsScreen(product: product),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: const Color(0xffFFA928),
                        size: responsiveWidth(context, 24),
                      ),
                      SizedBox(width: responsiveWidth(context, 6)),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: responsiveWidth(context, 20),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: responsiveHeight(context, 12)),

                // Description
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: responsiveHeight(context, 22),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: responsiveHeight(context, 12)),

                // Size Selector
                SizeSelector(
                  selectedSize: selectedSize,
                  onSizeSelected: (size) {
                    setState(() {
                      selectedSize = size;
                    });
                  },
                ),

                SizedBox(height: responsiveHeight(context, 12)),
                const Divider(color: Color(0xffE6E6E6)),
                SizedBox(height: responsiveHeight(context, 12)),

                // Price + Add to Cart Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price',
                          style: TextStyle(
                            color: const Color(0xff808080),
                            fontWeight: FontWeight.bold,
                            fontSize: responsiveWidth(context, 18),
                          ),
                        ),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: responsiveWidth(context, 24)),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<CartCubit>().addToCart(
                            product: product,
                            quantity: quantity,
                            size: selectedSize,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1A1A1A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.card_travel, color: Colors.white),
                            SizedBox(width: responsiveWidth(context, 10)),
                            Text(
                              'Add to cart',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: responsiveWidth(context, 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
