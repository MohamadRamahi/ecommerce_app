/*import 'package:ecommerce/responsive.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/model/product_model.dart';
import 'package:ecommerce/view/widget/product_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductSearchDelegate extends SearchDelegate {
  final List<ProductModel> allProducts;
  List<String> recentSearches = [];

  ProductSearchDelegate({required this.allProducts}) {
    _loadRecentSearches();
  }
  void _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    recentSearches = prefs.getStringList('recentSearches') ?? [];
    // تحديث واجهة البحث بعد تحميل البيانات
    // بس ما نقدر نستخدم setState هنا مباشرة لانه SearchDelegate مش StatefulWidget
    // فنستخدم this.showSuggestions(context); أو similar workaround
  }
  void _saveSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    if (query.isEmpty) return;
    // إزالة إذا موجود سابقًا (لتجنب التكرار)
    recentSearches.remove(query);
    // أضف البحث في البداية
    recentSearches.insert(0, query);
    // احتفظ فقط بآخر 10 نتائج
    if (recentSearches.length > 10) {
      recentSearches = recentSearches.sublist(0, 10);
    }
    await prefs.setStringList('recentSearches', recentSearches);
  }
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
         showSuggestions(context);

        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = allProducts.where((product) =>
        product.name.toLowerCase().contains(query.toLowerCase())).toList();
    _saveSearch(query);

    return results.isEmpty
        ? Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search,size: responsiveWidth(context, 64),
            color: Colors.grey,
          ),
          SizedBox(height: responsiveHeight(context, 18),),
          Text('No Results Found!',style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          ),
          SizedBox(height: responsiveHeight(context, 18),),
        Align(
          alignment: Alignment.center,
          child: Text('Try a similar word or something more general.',
            style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
          ),
        )
        ],
      )
    )
        : ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return ProductCard(product: product);
      },
    );
  }

  @override
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      // عرض recent searches عند حقل البحث فارغ
      if (recentSearches.isEmpty) {
        return Center(
            child: Text(
                'No recent searches.'
            ),
        );
      }
      return ListView.builder(
        itemCount: recentSearches.length,
        itemBuilder: (context, index) {
          final recent = recentSearches[index];
          return ListTile(
            leading: Icon(Icons.history, color: Colors.grey),
            title: Text(recent),
            onTap: () {
              query = recent;
              showResults(context);
            },
            trailing: IconButton(
              icon: Icon(Icons.clear, size: 20),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                recentSearches.removeAt(index);
                await prefs.setStringList('recentSearches', recentSearches);
                // إعادة عرض الاقتراحات بدون العنصر المحذوف
                showSuggestions(context);
              },
            ),
          );
        },
      );
    } else {
      // عرض اقتراحات من المنتجات بناء على البحث
      final suggestions = allProducts.where((product) =>
          product.name.toLowerCase().contains(query.toLowerCase())).toList();

      return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final product = suggestions[index];
          return ListTile(
            title: Text(product.name),
            onTap: () {
              query = product.name;
              showResults(context);
            },
          );
        },
      );
    }
  }

}*/
