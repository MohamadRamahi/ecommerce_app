import 'package:ecommerce/model/all_product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/model/product_model.dart';

class CategoryState {
  final String selectedCategory;
  final List<ProductModel> filteredProducts;

  CategoryState({
    required this.selectedCategory,
    required this.filteredProducts,
  });
}

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit()
      : super(CategoryState(
    selectedCategory: 'All',
    filteredProducts: allProducts,
  ));

  void selectCategory(String category) {
    if (category == 'All') {
      emit(CategoryState(selectedCategory: 'All', filteredProducts: allProducts));
    } else {
      final filtered = allProducts.where((p) => p.category == category).toList();
      emit(CategoryState(selectedCategory: category, filteredProducts: filtered));
    }
  }
}
