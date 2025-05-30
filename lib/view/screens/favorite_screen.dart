import 'package:ecommerce/cubit/favorite_cubit.dart';
import 'package:ecommerce/model/product_model.dart';
import 'package:ecommerce/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        centerTitle: true,
      ),
      body: BlocBuilder<FavoriteProductsCubit, List<ProductModel>>(
        builder: (context, favoriteProducts) {
          if (favoriteProducts.isEmpty) {
            return const Center(
              child: Text(
                "No favorite products yet!",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: favoriteProducts.length,
            padding: EdgeInsets.all(responsiveWidth(context, 12)),
            itemBuilder: (context, index) {
              final product = favoriteProducts[index];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.only(bottom: responsiveHeight(context, 12)),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      product.image,
                      width: responsiveWidth(context, 50),
                      height: responsiveWidth(context, 50),
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<FavoriteProductsCubit>().removeFromFavorites(product);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
