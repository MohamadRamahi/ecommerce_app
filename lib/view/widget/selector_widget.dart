import 'package:ecommerce/responsive.dart';
import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onIncrease;
  final ValueChanged<int> onDecrease;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Decrease button
        GestureDetector(
          onTap: () => onDecrease(quantity - 1),
          child: Container(
            height: responsiveHeight(context, 24),
            width: responsiveWidth(context, 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xffCCCCCC),
                width: 1,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.remove,
                color: const Color(0xff1A1A1A),
                size: responsiveWidth(context, 16),
              ),
            ),
          ),
        ),
        SizedBox(width: 20), // Spacer between buttons and quantity text

        // Quantity text
        Text(
          '$quantity',
          style: TextStyle(
            fontSize: responsiveWidth(context, 22),
            fontWeight: FontWeight.bold, // Make the quantity text bold
            color: Colors.black,
          ),
        ),

        SizedBox(
            width: responsiveWidth(context, 20)), // Spacer between buttons and quantity text

        // Increase button
        GestureDetector(
          onTap: () => onIncrease(quantity + 1),
          child: Container(
            height: responsiveHeight(context, 24),
            width: responsiveWidth(context, 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xffCCCCCC),
                width: 1,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.add,
                color: const Color(0xff1A1A1A),
                size: responsiveWidth(context, 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


