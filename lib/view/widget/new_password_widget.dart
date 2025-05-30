import 'package:ecommerce/responsive.dart';
import 'package:flutter/material.dart';

class NewPasswordWidget extends StatefulWidget {
  final TextEditingController newPasswordEditingController;
  final FormFieldValidator<String>? validator;

  const NewPasswordWidget({
    super.key,
    required this.newPasswordEditingController,
    this.validator,
  });

  @override
  State<NewPasswordWidget> createState() => _NewPasswordWidgetState();
}

class _NewPasswordWidgetState extends State<NewPasswordWidget> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.newPasswordEditingController,
      obscureText: obscureText,
      validator: widget.validator,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: responsiveWidth(context, 16),
      ),
      decoration: InputDecoration(
        labelText: "New password",
        hintText: "Enter New password",
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
