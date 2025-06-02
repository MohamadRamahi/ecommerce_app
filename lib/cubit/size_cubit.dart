import 'package:flutter_bloc/flutter_bloc.dart';

class SizeCubit extends Cubit<String> {
  SizeCubit() : super('M'); // الحجم الافتراضي

  void selectSize(String size) => emit(size);
}
