import 'package:ecommerce/cubit/category_navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final List<String> categories = ['All', 'T-Shirt', 'Jeans', 'Shoes'];

class CategoryBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final category = categories[index];
          return BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, state) {
              final isSelected = state.selectedCategory == category;

              return GestureDetector(
                onTap: () => context.read<CategoryCubit>().selectCategory(category),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.2),
                      width: isSelected ? 0 : 1,
                    ),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
