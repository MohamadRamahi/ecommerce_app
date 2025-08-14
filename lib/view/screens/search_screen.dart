import 'package:ecommerce/view/screens/product_details_screen.dart';
import 'package:ecommerce/view/widget/notification_icon_widget.dart';
import 'package:ecommerce/view/widget/product_list_item_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce/model/product_model.dart';
import 'package:ecommerce/view/widget/product_widget.dart';
import 'package:ecommerce/responsive.dart';

class SearchScreen extends StatefulWidget {
  final List<ProductModel> allProducts;

  const SearchScreen({Key? key, required this.allProducts}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> recentSearches = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches = prefs.getStringList('recentSearches') ?? [];
    });
  }

  Future<void> _saveSearch(String query) async {
    if (query.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    recentSearches.remove(query);
    recentSearches.insert(0, query);
    if (recentSearches.length > 10) {
      recentSearches = recentSearches.sublist(0, 10);
    }
    await prefs.setStringList('recentSearches', recentSearches);
  }

  @override
  Widget build(BuildContext context) {
    final results = widget.allProducts
        .where((product) =>
        product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsiveWidth(context, 24),
            vertical: responsiveHeight(context, 16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BackButton(),
                  Text(
                    'Search',
                    style: TextStyle(
                      fontSize: responsiveWidth(context, 32),
                      color: const Color(0xff1A1A1A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   NotificationIcon(),
                ],
              ),
              SizedBox(height: responsiveHeight(context, 16)),
              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      query = value;
                    });
                  },
                  onSubmitted: (value) {
                    _saveSearch(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: query.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          query = '';
                        });
                      },
                    )
                        : null,
                  ),
                ),
              ),
              SizedBox(height: responsiveHeight(context, 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Search',style: TextStyle(
                    color: Colors.black,
                    fontSize: responsiveWidth(context, 22),
                    fontWeight: FontWeight.w500
                  ),
                  ),
                  TextButton(onPressed: ()async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('recentSearches'); // مسح من التخزين

                    setState(() {
                      recentSearches.clear();
                    });
                  },
                      child: Text('Clear all',style:TextStyle(
                        decoration: TextDecoration.underline,
                        decorationThickness: 1.5,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: responsiveWidth(context, 16)
                      ),)
                  ),
                ],
              ),


              // Content
              Expanded(
                child: query.isEmpty
                    ? _buildRecentSearches()
                    : results.isEmpty
                    ? _buildNoResults()
                    :ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final product = results[index];
                    return GestureDetector(
                      onTap: () async {
                        await _saveSearch(product.name); // حفظ في recent search
                        setState(() {
                          query = product.name;
                        });
                        // روح لصفحة التفاصيل
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(product: product),
                          ),
                        );
                      },
                      child: ProductListItem(product: product, allProducts: [],)
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

  Widget _buildRecentSearches() {
    if (recentSearches.isEmpty) {
      return const Center(child: Text('No recent searches.'));
    }
    return ListView.builder(
      itemCount: recentSearches.length,
      itemBuilder: (context, index) {
        final recent = recentSearches[index];
        return ListTile(
          leading: const Icon(Icons.history, color: Colors.grey),
          title: Text(recent),
          onTap: () {
            setState(() {
              query = recent;
            });
          },
          trailing: IconButton(
            icon: Icon(FontAwesomeIcons.xmarkCircle, size: 20,color: Colors.grey,),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              setState(() {
                recentSearches.removeAt(index);
              });
              await prefs.setStringList('recentSearches', recentSearches);
            },
          ),
        );
      },
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search,
              size: responsiveWidth(context, 64), color: Colors.grey),
          SizedBox(height: responsiveHeight(context, 18)),
          const Text('No Results Found!', style: TextStyle(fontSize: 18)),
          SizedBox(height: responsiveHeight(context, 18)),
          const Text(
            'Try a similar word or something more general.',
            style: TextStyle(color: Colors.grey, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
