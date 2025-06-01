import 'package:ecommerce/cubit/cart_cubit.dart';
import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/widget/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartItems = context.watch<CartCubit>().state;
    final subTotal = cartItems.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
    final deliveryCharge = 3.0;
    final discount = 2.0;

    return Scaffold(
      backgroundColor: Colors.white,

      body: cartItems.isEmpty
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: responsiveHeight(context, 51)),
            Text(
              'Cart Empty',
              style: TextStyle(
                fontSize: responsiveWidth(context, 32),
                color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
              ),
            ),
            SizedBox(height: responsiveHeight(context, 16)),
            Text(
              'You don’t have add any foods in cart at this time',
              style: TextStyle(
                fontSize: responsiveWidth(context, 16),
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: responsiveWidth(context, 16),
                  vertical: responsiveHeight(context, 16),
                ),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == cartItems.length - 1 ? 0 : responsiveHeight(context, 20),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    item.product.image,
                                    width: responsiveWidth(context, 58),
                                    height: responsiveWidth(context, 58),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: responsiveWidth(context, 12)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.name,
                                        style: TextStyle(
                                          fontSize: responsiveWidth(context, 15),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: responsiveHeight(context, 4)),
                                      Text(
                                        '1kg, Price',
                                        style: TextStyle(
                                          fontSize: responsiveWidth(context, 13),
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: responsiveHeight(context, 12)),
                                      Row(
                                        children: [

                                          const Spacer(),
                                          Text(
                                            "\$${(item.product.price * item.quantity).toStringAsFixed(2)}",
                                            style: TextStyle(
                                              fontSize: responsiveWidth(context, 16),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.close, color: Colors.grey, size: responsiveWidth(context, 20)),
                                onPressed: () {
                                  context.read<CartCubit>().removeFromCart(item);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: responsiveHeight(context, 12)),
                        Divider(color: Colors.grey.shade300, thickness: 1),
                        SizedBox(height: responsiveHeight(context, 12)),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: buildCheckoutSection(
                context,
                subTotal,
              ),
            ),
          ],
        ),
      ),
    );
  }


}
