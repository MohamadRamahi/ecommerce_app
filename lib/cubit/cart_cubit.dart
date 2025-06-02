import 'package:ecommerce/model/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItem {
  final ProductModel product;
  final int quantity;
  final String size; // 👈 new field

  CartItem({
    required this.product,
    required this.quantity,
    required this.size,
  });

  CartItem copyWith({
    ProductModel? product,
    int? quantity,
    String? size,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CartItem &&
              runtimeType == other.runtimeType &&
              product.name == other.product.name &&
              size == other.size; // 👈 compare by size too

  @override
  int get hashCode => product.name.hashCode ^ size.hashCode;
}

class CartCubit extends Cubit<List<CartItem>> {
  CartCubit() : super([]);

  Future<void> addToCart({
    required ProductModel product,
    required int quantity,
    required String size, // 👈 new parameter
  }) async {
    final index = state.indexWhere(
          (item) => item.product.name == product.name && item.size == size,
    );

    if (index != -1) {
      final updatedItem = state[index].copyWith(
        quantity: state[index].quantity + quantity,
      );
      final updatedList = List<CartItem>.from(state);
      updatedList[index] = updatedItem;
      emit(updatedList);
    } else {
      emit([
        ...state,
        CartItem(product: product, quantity: quantity, size: size),
      ]);
    }
  }


  void removeFromCart(CartItem itemToRemove) {
    emit(state.where((item) => item != itemToRemove).toList());
  }

  void clearCart() {
    emit([]);
  }

  void updateQuantity(CartItem item, int newQuantity) {
    if (newQuantity > 0) {
      final updatedItems = [...state];
      final index = updatedItems.indexOf(item);
      if (index != -1) {
        updatedItems[index] = item.copyWith(quantity: newQuantity);
        emit(updatedItems);
      }
    }
  }


  double get subTotal {
    return state.fold(
      0.0,
          (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  double totalWithCharges({double deliveryCharge = 3.0, double discount = 2.0}) {
    return subTotal + deliveryCharge - discount;
  }
}
