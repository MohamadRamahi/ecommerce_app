import 'package:flutter/material.dart';
import 'package:ecommerce/responsive.dart';

class SizeSelector extends StatelessWidget {
  final String selectedSize;
  final ValueChanged<String> onSizeSelected;

  const SizeSelector({
    super.key,
    required this.selectedSize,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final sizes = ['S', 'M', 'L'];

    return Row(
      children: sizes.map((size) {
        final isSelected = size == selectedSize;
        return GestureDetector(
          onTap: () => onSizeSelected(size),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: responsiveWidth(context, 8)),
            padding: EdgeInsets.symmetric(
              horizontal: responsiveWidth(context, 16),
              vertical: responsiveHeight(context, 10),
            ),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              size,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: responsiveWidth(context, 16),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
