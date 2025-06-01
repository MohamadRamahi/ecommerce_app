import 'package:ecommerce/model/product_searche_delegate.dart';
import 'package:ecommerce/responsive.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final mockProductList = [
          'Apple',
          'Banana',
          'Bread',
          'Milk',
          'Cheese',
          'Chicken',
          'Orange Juice',
        ];
        showSearch(
          context: context,
          delegate: ProductSearchDelegate(allProducts: mockProductList),
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
