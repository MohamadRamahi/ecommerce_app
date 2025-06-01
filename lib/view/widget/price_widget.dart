import 'package:ecommerce/const.dart';
import 'package:ecommerce/cubit/cart_cubit.dart';
import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/screens/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buildCheckoutSection(BuildContext context, double totalAmount) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.all(responsiveWidth(context, 16)),
    child: GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          isScrollControlled: true,
          builder: (context) => SizedBox(
            height: responsiveHeight(context, 550),
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsiveWidth(context, 20),
                vertical: responsiveHeight(context, 20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: responsiveWidth(context, 24),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          color: Color(0xff181725),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: responsiveHeight(context, 18)),
                  Divider(),
                  SizedBox(height: responsiveHeight(context, 18)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivery',
                        style: TextStyle(
                          fontSize: responsiveWidth(context, 18),
                          fontWeight: FontWeight.bold,
                          color: Color(0xff7C7C7C),
                        ),
                      ),
                      Row(
                        children: [
                          Text('Select Method'),
                          SizedBox(width: responsiveWidth(context, 8)),
                          Icon(Icons.arrow_forward_ios, size: responsiveWidth(context, 16)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: responsiveHeight(context, 18)),
                  Divider(),
                  SizedBox(height: responsiveHeight(context, 18)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment',
                        style: TextStyle(
                          fontSize: responsiveWidth(context, 18),
                          fontWeight: FontWeight.bold,
                          color: Color(0xff7C7C7C),
                        ),
                      ),
                      Row(
                        children: [
                          Text('Select Method'),
                          SizedBox(width: responsiveWidth(context, 8)),
                          Icon(Icons.arrow_forward_ios, size: responsiveWidth(context, 16)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: responsiveHeight(context, 18)),
                  Divider(),
                  SizedBox(height: responsiveHeight(context, 18)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Promo Code',
                        style: TextStyle(
                          fontSize: responsiveWidth(context, 18),
                          fontWeight: FontWeight.bold,
                          color: Color(0xff7C7C7C),
                        ),
                      ),
                      Row(
                        children: [
                          Text('Select Method'),
                          SizedBox(width: responsiveWidth(context, 8)),
                          Icon(Icons.arrow_forward_ios, size: responsiveWidth(context, 16)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: responsiveHeight(context, 18)),
                  Divider(),
                  SizedBox(height: responsiveHeight(context, 18)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Cost',
                        style: TextStyle(
                          fontSize: responsiveWidth(context, 18),
                          fontWeight: FontWeight.bold,
                          color: Color(0xff7C7C7C),
                        ),
                      ),
                      Row(
                        children: [
                          Text(' \$${totalAmount.toStringAsFixed(2)}'),
                          SizedBox(width: responsiveWidth(context, 8)),
                          Icon(Icons.arrow_forward_ios, size: responsiveWidth(context, 16)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: responsiveHeight(context, 20)),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CartCubit>().clearCart();
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SuccessScreen())); // Close BottomSheet

                      Future.delayed(Duration(milliseconds: 300), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SuccessScreen()),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Order placed successfully!"),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KbuttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: responsiveHeight(context, 67),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsiveWidth(context, 24),
                          vertical: responsiveHeight(context, 12),
                        ),
                        child: Center(
                          child: Text(
                            'Place Order',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: responsiveWidth(context, 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
    ),
  );
}
