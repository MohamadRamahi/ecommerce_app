import 'package:ecommerce/model/product_model.dart';
import 'package:ecommerce/model/product_searche_delegate.dart';
import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/screens/search_screen.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final List<ProductModel> allProducts;

  const SearchWidget({super.key, required this.allProducts});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context)=>SearchScreen(
                    allProducts: allProducts
                ),
            ),
        );
      },
      child: Container(
        height: responsiveHeight(context, 52),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 10),
            Text(
              'Search...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
