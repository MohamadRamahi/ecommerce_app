import 'package:ecommerce/const.dart';
import 'package:ecommerce/cubit/cart_cubit.dart';
import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/widget/notification_icon_widget.dart';
import 'package:ecommerce/view/widget/selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItems = context.watch<CartCubit>().state;
    final subTotal = cartItems.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
    final shippingFee = 10.0;
    final vat = 0.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: responsiveHeight(context, 16),
            horizontal: responsiveWidth(context, 24),
          ),
          child: Column(
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(),
                       Text(
                      "My Cart",
                      style: TextStyle(
                        fontSize: responsiveWidth(context, 24),
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                NotificationIcon(),

                ],
              ),
              SizedBox(height: responsiveHeight(context, 16)),

              // Cart Content
              Expanded(
                child: cartItems.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border_rounded,
                        size: responsiveWidth(context, 56),
                        color: Colors.grey,
                      ),
                      SizedBox(height: responsiveHeight(context, 24)),
                      Text(
                        'Your Cart is Empty',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: responsiveWidth(context, 20),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: responsiveHeight(context, 12)),
                      Text(
                        'When you add products, they’ll\nappear here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: responsiveWidth(context, 16),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  padding: EdgeInsets.only(top: responsiveHeight(context, 8)),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: responsiveHeight(context, 16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  item.product.image,
                                  width: responsiveWidth(context, 80),
                                  height: responsiveWidth(context, 80),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(width: responsiveWidth(context, 12)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.product.name,
                                            style: TextStyle(
                                              fontSize: responsiveWidth(context, 15),
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red, size: responsiveWidth(context, 20)),
                                          onPressed: () {
                                            context.read<CartCubit>().removeFromCart(item);
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Size: ${item.size}',
                                      style: TextStyle(
                                        fontSize: responsiveWidth(context, 13),
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: responsiveHeight(context, 12)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "\$${(item.product.price * item.quantity).toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontSize: responsiveWidth(context, 16),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        QuantitySelector(
                                          quantity: item.quantity,
                                          onIncrease: (newQuantity) {
                                            context.read<CartCubit>().updateQuantity(item, newQuantity);
                                          },
                                          onDecrease: (newQuantity) {
                                            context.read<CartCubit>().updateQuantity(item, newQuantity);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (cartItems.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: responsiveHeight(context, 8)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Subtotal",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                color: Colors.grey
                              )),
                          Text("\$${subTotal.toStringAsFixed(2)}"),
                        ],
                      ),
                      SizedBox(height: responsiveHeight(context, 4)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Shipping",
                              style: TextStyle(fontWeight: FontWeight.w600,
                                  color: Colors.grey)),
                          Text("\$${shippingFee.toStringAsFixed(2)}"),
                        ],
                      ),
                      SizedBox(height: responsiveHeight(context, 4)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("VAT",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey
                              )),
                          Text("\$${vat.toStringAsFixed(2)}"),
                        ],
                      ),
                      Divider(height: responsiveHeight(context, 24), thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total", style: TextStyle(
                              fontWeight: FontWeight.bold,
                          color: Colors.grey,
                              fontSize: responsiveWidth(context, 18))),
                          Text("\$${(subTotal + shippingFee + vat).toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: responsiveHeight(context, 16)),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle checkout
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: KbuttonColor,
                            padding: EdgeInsets.symmetric(vertical: responsiveHeight(context, 14)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Go To Checkout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsiveWidth(context, 16),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: responsiveWidth(context, 10),),
                              Icon(Icons.arrow_forward,color: Colors.white,)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
