import 'package:ecommerce/responsive.dart';
import 'package:flutter/material.dart';

class PasswordWidget extends StatefulWidget {
  final TextEditingController passwordEditingController;
  final String? errorText;

  const PasswordWidget({
    super.key,
    required this.passwordEditingController,
    this.errorText,
  });

  @override
  State<PasswordWidget> createState() => _PasswordWidgetState();
}

class _PasswordWidgetState extends State<PasswordWidget> {
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    widget.passwordEditingController.addListener(() {
      setState(() {}); // rebuild when the text changes
    });
  }

  Color _getBorderColor(bool hasError, bool hasInput) {
    if (hasError) return Colors.red;
    if (hasInput) return Colors.green;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final bool hasInput = widget.passwordEditingController.text.isNotEmpty;
    final bool hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 2,
                spreadRadius: 0,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TextField(
            controller: widget.passwordEditingController,
            obscureText: obscureText,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: responsiveWidth(context, 16),
            ),
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
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
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _getBorderColor(hasError, hasInput),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _getBorderColor(hasError, hasInput),
                  width: 2,
                ),
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasInput)
                    Padding(
                      padding: EdgeInsets.only(right: responsiveWidth(context, 4)),
                      child: Icon(
                        hasError ? Icons.error_outline : Icons.check_circle_outline,
                        color: hasError ? Colors.red : Colors.green,
                        size: responsiveWidth(context, 20),
                      ),
                    ),
                  IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey[600],
                      size: responsiveWidth(context, 22),
                    ),
                    onPressed: () {
                      setState(() => obscureText = !obscureText);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: EdgeInsets.only(
              left: responsiveWidth(context, 8),
              top: responsiveHeight(context, 6),
            ),
            child: Text(
              widget.errorText!,
              style: TextStyle(
                color: Colors.red,
                fontSize: responsiveWidth(context, 14),
              ),
            ),
          ),
      ],
    );
  }
}
