import 'package:ecommerce/responsive.dart';
import 'package:flutter/material.dart';

class EmailWidget extends StatefulWidget {
  final TextEditingController emailEditingController;
  final String? errorText;

  const EmailWidget({
    super.key,
    required this.emailEditingController,
    this.errorText,
  });

  @override
  State<EmailWidget> createState() => _EmailWidgetState();
}

class _EmailWidgetState extends State<EmailWidget> {
  @override
  void initState() {
    super.initState();
    widget.emailEditingController.addListener(() {
      setState(() {}); // rebuild when text changes
    });
  }

  Color _getBorderColor(bool hasError, bool hasInput) {
    if (hasError) return Colors.red;
    if (hasInput) return Colors.green;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final bool hasInput = widget.emailEditingController.text.isNotEmpty;
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
            keyboardType: TextInputType.emailAddress,
            controller: widget.emailEditingController,
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Enter your email address",
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
              suffixIcon: hasInput
                  ? Icon(
                hasError ? Icons.error_outline : Icons.check_circle_outline,
                color: hasError ? Colors.red : Colors.green,
                size: responsiveWidth(context, 20),
              )
                  : null,
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
