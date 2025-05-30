import 'package:ecommerce/model/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class FavoriteProductsCubit extends Cubit<List<ProductModel>> {
  FavoriteProductsCubit() : super([]);

  void addToFavorites(ProductModel product) {
    List<ProductModel> updatedFavorites = List.from(state);
    updatedFavorites.add(product);
    emit(updatedFavorites);
  }

  void removeFromFavorites(ProductModel product) {
    print("Removing product: ${product.name}");
    List<ProductModel> updatedFavorites = List.from(state);
    updatedFavorites.remove(product);
    print("Updated favorites after removal: $updatedFavorites");
    emit(updatedFavorites);  // إصدار الحالة الجديدة
  }
}
