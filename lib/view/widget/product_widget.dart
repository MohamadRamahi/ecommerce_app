import 'package:ecommerce/cubit/favorite_cubit.dart';
import 'package:ecommerce/model/product_model.dart';
import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;


  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(responsiveWidth(context, 12)),
          color: Colors.grey[50],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: EdgeInsets.all(responsiveWidth(context, 8)),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🎯 Custom image size
                SizedBox(
                  width: double.infinity,
                  height: responsiveHeight(context, 160), // <-- adjust height here
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(responsiveWidth(context, 12)),
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: responsiveHeight(context, 6)),
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: responsiveWidth(context, 18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: responsiveHeight(context, 4)),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: responsiveWidth(context, 16),
                    color: const Color(0xff808080),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // ❤️ Favorite Icon Button
            Positioned(
              top: 0,
              right: 0,
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
    );
  }
}
