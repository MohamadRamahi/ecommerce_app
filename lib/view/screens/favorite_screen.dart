import 'package:ecommerce/cubit/favorite_cubit.dart';
import 'package:ecommerce/model/product_model.dart';
import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/widget/notification_icon_widget.dart';
import 'package:ecommerce/view/widget/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: responsiveWidth(context, 24),
                  vertical: responsiveHeight(context, 16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BackButton(),
                  Text(
                    "Saved Items",
                    style: TextStyle(
                      fontSize: responsiveWidth(context, 24),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                   NotificationIcon(),
                ],
              ),
            ),
            SizedBox(height: responsiveHeight(context, 16)),

            // Favorite Items Section
            Expanded(
              child: BlocBuilder<FavoriteProductsCubit, List<ProductModel>>(
                builder: (context, favoriteProducts) {
                  if (favoriteProducts.isEmpty) {
                    // Centered "No Saved Items"
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border_rounded,
                            size: responsiveWidth(context, 56),
                            color: Colors.grey,
                          ),
                          SizedBox(height: responsiveHeight(context, 24)),
                          Text(
                            'No Saved Items!',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: responsiveWidth(context, 20),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: responsiveHeight(context, 12)),
                          Text(
                            'You don\'t have any saved items.\nGo to home and add some.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: responsiveWidth(context, 16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Grid of favorite products
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: responsiveWidth(context, 24),
                        vertical: responsiveHeight(context, 16)),
                    child: GridView.builder(
                      padding: EdgeInsets.only(
                          top: responsiveHeight(context, 8)),
                      itemCount: favoriteProducts.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: responsiveHeight(context, 16),
                        crossAxisSpacing: responsiveWidth(context, 16),
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        final product = favoriteProducts[index];
                        return ProductCard(product: product);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
