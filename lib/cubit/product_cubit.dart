import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/product_model.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductState(allProducts: _demoProducts));

  static final List<ProductModel> _demoProducts = [
    ProductModel(
      id: '1',
      name: 'White T-Shirt',
      description: 'Comfy cotton tee',
      image: '',
      price: 19.99,
      rating: 4.5,
      category: 'Tshirts',
    ),
    ProductModel(
      id: '2',
      name: 'Blue Jeans',
      description: 'Classic denim',
      image: '',
      price: 49.99,
      rating: 4.3,
      category: 'Jeans',
    ),
    ProductModel(
      id: '3',
      name: 'Running Shoes',
      description: 'Perfect for running',
      image: '',
      price: 89.99,
      rating: 4.7,
      category: 'Shoes',
    ),
  ];
}
