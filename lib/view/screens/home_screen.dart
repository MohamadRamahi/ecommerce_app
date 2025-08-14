import 'package:ecommerce/cubit/category_navigation_cubit.dart';
import 'package:ecommerce/model/all_product.dart'; // مفترض يحتوي allProducts
import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/widget/category_bar_widget.dart';
import 'package:ecommerce/view/widget/filter_widget.dart';
import 'package:ecommerce/view/widget/notification_icon_widget.dart';
import 'package:ecommerce/view/widget/product_widget.dart';
import 'package:ecommerce/view/widget/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/model/product_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🧭 Header Row
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: responsiveWidth(context, 24),
                    vertical: responsiveHeight(context, 16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Discover',
                      style: TextStyle(
                        fontSize: responsiveWidth(context, 32),
                        color: const Color(0xff1A1A1A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    NotificationIcon(),
                  ],
                ),
              ),

              SizedBox(height: responsiveHeight(context, 16)),

              /// 🔍 Search Widget
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsiveWidth(context, 24),
                ),
                child: Row(
                  children: [
                    Expanded(child: SearchWidget(allProducts: allProducts)),  // هنا
                    SizedBox(width: responsiveWidth(context, 8)),
                    FilterWidget(
                      onApplyFilter: (filters) {

                      },
                    )
                  ],
                ),
              ),

              SizedBox(height: responsiveHeight(context, 16)),

              /// 📂 Category Bar
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsiveWidth(context, 24),),
                child: CategoryBarWidget(),
              ),

              SizedBox(height: responsiveHeight(context, 24)),

              /// 🛍️ Filtered Products List
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: responsiveWidth(context, 24),
                    vertical: responsiveHeight(context, 16)),
                child: BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    final products = state.filteredProducts;
                    if (products.isEmpty) {
                      return Center(
                        child: Text(
                          'No products found in this category.',
                          style: TextStyle(
                            fontSize: responsiveWidth(context, 16),
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: responsiveHeight(context, 16),
                        crossAxisSpacing: responsiveWidth(context, 16),
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(product: product);
                      },
                    );

                  },
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }
}
