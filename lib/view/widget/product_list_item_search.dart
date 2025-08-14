import 'package:ecommerce/cubit/favorite_cubit.dart';
import 'package:ecommerce/model/product_model.dart';
import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductListItem extends StatelessWidget {
  final ProductModel product;
  final List<ProductModel> allProducts;
  const ProductListItem({
    super.key,
    required this.product,
    required this.allProducts
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: responsiveWidth(context, 8),
        vertical: responsiveHeight(context, 6),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(product: product),
          ),
        );
      },

      // 📌 الصورة على الشمال
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(responsiveWidth(context, 8)),
        child: Image.asset(
          product.image,
          width: responsiveWidth(context, 60),
          height: responsiveHeight(context, 60),
          fit: BoxFit.cover,
        ),
      ),

      // 📌 اسم المنتج والسعر تحت بعض
      title: Text(
        product.name,
        style: TextStyle(
          fontSize: responsiveWidth(context, 16),
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        "\$${product.price.toStringAsFixed(2)}",
        style: TextStyle(
          fontSize: responsiveWidth(context, 14),
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),

      trailing: IconButton(
        icon: const Icon(FontAwesomeIcons.arrowUpRightFromSquare),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetailsScreen(product: product)));
        },
      ),
    );
  }
}