/*import 'package:bloc/bloc.dart';
import 'package:ecommerce/model/product_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final List<ProductModel> allProducts;

  SearchCubit({required this.allProducts}) : super(SearchInitial());

  void search(String query) {
    if (query.isEmpty) {
      emit(SearchInitial());
    } else {
      final results = allProducts
          .where((product) =>
          product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(SearchSuccess(results));
    }
  }

  void clearSearch() => emit(SearchInitial());
}
*/