import 'package:ecommerce/responsive.dart';
import 'package:flutter/material.dart';

class ConfermPasswordWidget extends StatefulWidget {
  final TextEditingController confirempasswordEditingController;
  final FormFieldValidator<String>? validator;

  const ConfermPasswordWidget({
    super.key,
    required this.confirempasswordEditingController,
    this.validator,
  });

  @override
  State<ConfermPasswordWidget> createState() => _ConfermPasswordWidgetState();
}

class _ConfermPasswordWidgetState extends State<ConfermPasswordWidget> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.confirempasswordEditingController,
      obscureText: obscureText,
      validator: widget.validator,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: responsiveWidth(context, 16),
      ),
      decoration: InputDecoration(
        labelText: "Confirm password",
        hintText: "Enter confirm password",
        labelStyle: TextStyle(
          fontSize: responsiveWidth(context, 16),
          color: Colors.grey[700],
        ),
        hintStyle: TextStyle(
          fontSize: responsiveWidth(context, 16),
          color: Colors.grey[600],
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          vertical: responsiveHeight(context, 12),
          horizontal: responsiveWidth(context, 12),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
            size: responsiveWidth(context, 22),
          ),
          onPressed: () {
            setState(() => obscureText = !obscureText);
          },
        ),
      ),
    );
  }
}
