// import 'package:flutter_bloc/flutter_bloc.dart';
//
// abstract class HomeState {}
//
// class HomeInitial extends HomeState {}
//
// class HomeCategorySelected extends HomeState {
//   final String category;
//   HomeCategorySelected(this.category);
// }
//
// class HomeSearchResults extends HomeState {
//   final List<Map<String, dynamic>> filteredProducts;
//   HomeSearchResults(this.filteredProducts);
// }
//
// class HomeCubit extends Cubit<HomeState> {
//   HomeCubit() : super(HomeInitial()) {
//     emit(HomeSearchResults(allProducts)); // إظهار جميع المنتجات عند البداية
//   }
//
//   final List<Map<String, dynamic>> allProducts = [
//     {
//       "name": "Chicken Burger",
//       "category": "Burger",
//       "rating": 3.8,
//       "price": 20.0,
//       "subtitle":"100 gr chicken + tomato + cheese  Lettuce",
//       "image": "assets/images/Chicken burger.png"
//     },
//     {
//       "name": "Cheese Burger",
//       "category": "Burger",
//       "rating": 4.5,
//       "price": 15.0,
//       "subtitle":"100 gr chicken + tomato + cheese  Lettuce",
//
//       "image": "assets/images/Chese burger.png"
//     },
//     {
//       "name": "Chicken Burger",
//       "rating": 3.8,
//       "price": 20.0,
//       "category": "Burger",
//       "subtitle":"100 gr chicken + tomato + cheese  Lettuce",
//
//       "image": "assets/images/Chicken burger.png"
//     },
//     {
//       "name": "Pizza ",
//       "rating": 4.5,
//       "price": 15.0,
//       "category": "Pizza",
//       "subtitle":"100 gr chicken + tomato + cheese  Lettuce",
//
//       "image": "assets/images/Chese burger.png"
//     },
//   ];
//
//   List<Map<String, dynamic>> filteredProducts = [];
//
//   void searchProducts(String query) {
//     if (query.isEmpty) {
//       emit(HomeSearchResults(allProducts));
//     } else {
//       filteredProducts = allProducts
//           .where((product) =>
//           product["name"].toLowerCase().contains(query.toLowerCase()))
//           .toList();
//       emit(HomeSearchResults(filteredProducts));
//     }
//   }
//
//   void selectCategory(String category) {
//     emit(HomeCategorySelected(category));
//     filterProductsByCategory(category);
//   }
//
//   List<Map<String, dynamic>> filterProductsByCategory(String category) {
//     if (category == "All") {
//       emit(HomeSearchResults(allProducts)); // عرض كل المنتجات
//       return allProducts;
//     } else {
//       List<Map<String, dynamic>> filtered = allProducts
//           .where((product) => product["name"].toLowerCase().contains(category.toLowerCase()))
//           .toList();
//       emit(HomeSearchResults(filtered));
//       return filtered;
//     }
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';

/// الحالة الأساسية
abstract class HomeState {}

class HomeInitial extends HomeState {}

/// الحالة التي تحدد التصنيف المحدد
class HomeCategorySelected extends HomeState {
  final String category;
  HomeCategorySelected(this.category);
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeCategorySelected("All")); // الحالة الافتراضية

  /// تغيير التصنيف
  void selectCategory(String category) {
    emit(HomeCategorySelected(category));
  }

  void searchProducts(String query) {}
}
