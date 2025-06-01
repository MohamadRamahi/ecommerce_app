import 'package:flutter/material.dart';

class DropdownButtonCustom extends StatefulWidget {
  const DropdownButtonCustom({super.key});

  @override
  State<DropdownButtonCustom> createState() => _DropdownButtonCustomState();
}

class _DropdownButtonCustomState extends State<DropdownButtonCustom> {
  String selectedSize = 'L';
  final List<String> sizes = ['S', 'M', 'L', 'XL'];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedSize,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        onChanged: (value) {
          setState(() {
            selectedSize = value!;
          });
        },
        items: sizes.map((size) {
          return DropdownMenuItem(
            value: size,
            child: Text(size),
          );
        }).toList(),
      ),
    );
  }
}
