import 'package:ecommerce/responsive.dart';
import 'package:flutter/material.dart';

class SelectableCard extends StatefulWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableCard({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<SelectableCard> createState() => _SelectableCardState();
}

class _SelectableCardState extends State<SelectableCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(

        padding: EdgeInsets.symmetric(
          horizontal: responsiveWidth(context, 12), // تعديل العرض باستخدام responsiveWidth
          vertical: responsiveHeight(context, 12),  // تعديل الارتفاع باستخدام responsiveHeight
        ),
        decoration: BoxDecoration(
          color: widget.isSelected ? Colors.black : Colors.grey[200],
          borderRadius: BorderRadius.circular(responsiveWidth(context, 12)), // تعديل نصف القطر باستخدام responsiveWidth
        ),
        child: Text(
          widget.title,
          style: TextStyle(
            color: widget.isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: responsiveWidth(context, 18), // تعديل حجم الخط باستخدام responsiveWidth
          ),
        ),
      ),
    );
  }
}