import 'package:ecommerce/responsive.dart';
import 'package:flutter/material.dart';

class CustomToggleButton extends StatefulWidget {
  final List<String> options;
  final ValueChanged<int> onSelected;
  final int initialIndex;

  const CustomToggleButton({
    Key? key,
    required this.options,
    required this.onSelected,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<CustomToggleButton> createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.options.length, (index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onSelected(index);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: responsiveWidth(context, 5)),
              padding: EdgeInsets.symmetric(
                vertical: responsiveHeight(context, 10),
                horizontal: responsiveWidth(context, 20),
              ),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xff1A1A1A) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Text(
                widget.options[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: responsiveWidth(context, 14),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
