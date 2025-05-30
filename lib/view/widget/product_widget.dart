import 'package:ecommerce/model/product_model.dart';
import 'package:ecommerce/responsive.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  const ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsiveWidth(context, 12)),
        color: Colors.grey[50],
      ),
      padding: EdgeInsets.all(responsiveWidth(context, 8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  responsiveWidth(context, 12)),
              child: Image.asset(
                product.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: responsiveHeight(context, 8)),
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
              color: Color(0xff808080),
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}
