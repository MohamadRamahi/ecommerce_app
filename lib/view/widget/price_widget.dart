import 'package:ecommerce/const.dart';
import 'package:ecommerce/responsive.dart';
import 'package:flutter/material.dart';

Widget buildCheckoutSection(
    BuildContext context,
    double totalAmount,
    double shippingfee,
    double Vat,
    ) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.all(responsiveWidth(context, 16)),
    child: Container(
          height: responsiveHeight(context, 64),
          decoration: BoxDecoration(
            color: KbuttonColor,
            borderRadius: BorderRadius.circular(19),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsiveWidth(context, 20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Go to Checkout",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsiveWidth(context, 18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsiveWidth(context, 12),
                    vertical: responsiveHeight(context, 8),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF489E67),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "\$${totalAmount.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: responsiveWidth(context, 16),
                    ),
                  ),
                ),
              ],
            ),
          ),



    ),
  );
}
