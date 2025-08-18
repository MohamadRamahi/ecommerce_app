import 'package:ecommerce/cubit/cart_cubit.dart';
import 'package:ecommerce/cubit/location_cubit.dart';
import 'package:ecommerce/cubit/payment_state.dart';
import 'package:ecommerce/cubit/paymnet_cubit.dart';
import 'package:ecommerce/model/card_payment_model.dart';
import 'package:ecommerce/model/saved_address.dart';
import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/screens/address_screen.dart';
import 'package:ecommerce/view/screens/edit_payment_screen.dart';
import 'package:ecommerce/view/screens/track_order_screen.dart';
import 'package:ecommerce/view/widget/location_title_widget.dart';
import 'package:ecommerce/view/widget/notification_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Create an enum for payment methods
enum PaymentMethod { card, cash, pay }


class CheckoutScreen extends StatefulWidget {
  final LatLng? userLocation;

  const CheckoutScreen({super.key, this.userLocation});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedAddressTitle = "No location selected";
  PaymentMethod selectedMethod = PaymentMethod.card;
  CardModel? selectedCard;

  @override
  void initState() {
    super.initState();
    _convertCoordinatesToAddress(widget.userLocation);
  }

  Future<void> _convertCoordinatesToAddress(LatLng? location) async {
    if (location != null) {
      try {
        final placemarks = await placemarkFromCoordinates(
            location.latitude, location.longitude);
        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          setState(() {
            selectedAddressTitle =
            "${placemark.street}, ${placemark.locality}, ${placemark.country}";
          });
        }
      } catch (e) {
        print("Error getting address: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = context.watch<CartCubit>().state;
    final subTotal = cartItems.fold(
        0.0, (sum, item) => sum + (item.product.price * item.quantity));
    final shippingFee = 10.0;
    final vat = 0.0;
    final total = subTotal + shippingFee + vat;
    final TextEditingController promoCodeController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: responsiveHeight(context, 16),
            horizontal: responsiveWidth(context, 24),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BackButton(),
                    Text(
                      "Checkout",
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

                // Address section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delivery Address',
                      style: TextStyle(
                        fontSize: responsiveWidth(context, 16),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final savedAddress =
                        await Navigator.push<SavedAddress>(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddressScreen()),
                        );

                        if (savedAddress != null) {
                          setState(() {
                            selectedAddressTitle = savedAddress.address;
                          });

                          final newLocation = LatLng(
                              savedAddress.latitude, savedAddress.longitude);
                          context.read<LocationCubit>().saveLocation(newLocation);
                        }
                      },
                      child: const Text(
                        'Change',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
                SizedBox(height: responsiveHeight(context, 16)),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.grey),
                    SizedBox(width: responsiveWidth(context, 10)),
                    Expanded(child: LocationTitleWidget()),
                  ],
                ),
                const Divider(color: Color(0xffE6E6E6)),
                // ... باقي الكود لم يتغير ...

                SizedBox(height: responsiveHeight(context, 20)),

                // Payment method selection
                Text(
                  'Payment Method',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: responsiveWidth(context, 16),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: responsiveHeight(context, 16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SelectablePaymentButton(
                      isSelected: selectedMethod == PaymentMethod.card,
                      onTap: () {
                        setState(() {
                          selectedMethod = PaymentMethod.card;
                        });
                      },
                      text: "Card",
                      icon: Icons.credit_card,
                    ),
                    SelectablePaymentButton(
                      isSelected: selectedMethod == PaymentMethod.cash,
                      onTap: () {
                        setState(() {
                          selectedMethod = PaymentMethod.cash;
                        });
                      },
                      text: "Cash",
                      icon: Icons.money,
                    ),
                    SelectablePaymentButton(
                      isSelected: selectedMethod == PaymentMethod.pay,
                      onTap: () {
                        setState(() {
                          selectedMethod = PaymentMethod.pay;
                        });
                      },
                      text: "Pay",
                      icon: Icons.apple,
                    ),
                  ],
                ),
                SizedBox(height: responsiveHeight(context, 16)),

                // Card input (if selected)
                if (selectedCard != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        top: BorderSide(color: Color(0xffE6E6E6)),
                        bottom: BorderSide(color: Color(0xffE6E6E6)),
                        right: BorderSide(color: Color(0xffE6E6E6)),
                        left: BorderSide(color: Color(0xffE6E6E6)),
                      )

                    ),

                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/visa2.png',
                          width: 40,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("**** **** **** ${selectedCard!.number.substring(selectedCard!.number.length - 4)}"),
                            Text("Exp: ${selectedCard!.expiryDate}"),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EditPaymentScreen(),
                              ),
                            );
                            if (result != null && result is CardModel) {
                              setState(() {
                                selectedCard = result;
                              });
                            }
                          },
                        )
                      ],
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                        elevation: 0,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(10),
                     )
                      ),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditPaymentScreen(),
                          ),
                        );
                        if (result != null && result is CardModel) {
                          setState(() {
                            selectedCard = result;
                          });
                        }
                      },
                      child: const Text("Add Card",style: TextStyle(
                        color: Colors.black87
                      ),),
                    ),
                  ),
                SizedBox(height: responsiveHeight(context, 20)),
                const Divider(color: Color(0xffE6E6E6)),
                SizedBox(height: responsiveHeight(context, 20)),

                // Order Summary
                Text(
                  'Order Summary',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: responsiveHeight(context, 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Subtotal",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.grey)),
                    Text("\$${subTotal.toStringAsFixed(2)}"),
                  ],
                ),
                SizedBox(height: responsiveHeight(context, 4)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Shipping",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.grey)),
                    Text("\$${shippingFee.toStringAsFixed(2)}"),
                  ],
                ),
                SizedBox(height: responsiveHeight(context, 4)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("VAT",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.grey)),
                    Text("\$${vat.toStringAsFixed(2)}"),
                  ],
                ),
                Divider(
                  height: responsiveHeight(context, 24),
                  thickness: 1,
                  color: const Color(0xffE6E6E6),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: responsiveWidth(context, 18))),
                    Text("\$${total.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: responsiveHeight(context, 20)),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: responsiveHeight(context, 54),
                        child: TextField(
                          controller: promoCodeController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xffE6E6E6),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: Icon(Icons.discount_outlined),
                            hintText: 'Enter promo code',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: responsiveWidth(context, 10)),
                    SizedBox(
                      height: responsiveHeight(context, 54),

                      child: ElevatedButton(
                        onPressed: () {
                          final code = promoCodeController.text.trim();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Applied promo code: $code')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: responsiveWidth(context, 16),
                            vertical: responsiveHeight(context, 14),
                          ),
                        ),
                        child: const Text('Add', style: TextStyle(color: Colors.white)),
                      ),
                    )
                  ],
                ),

                SizedBox(
                  height: responsiveHeight(context, 54),
                ),

      SizedBox(
        width: double.infinity,
        height: responsiveHeight(context, 54),
        child: ElevatedButton(
          onPressed: () {
            showDialog(context: (context),
                builder: (context)=>AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle,
                          color: Colors.green,
                          size: 60
                      ),
                      SizedBox(height: responsiveHeight(context, 8),),

                      Text(
                        'Congratulations!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: responsiveHeight(context, 8),),
                      Text(
                        'Your order has been placed.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  actions: [
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: responsiveHeight(context, 54),
                        child: ElevatedButton(
                            onPressed: (){
                              Navigator.push(context,
                                MaterialPageRoute(
                                  builder: (context)=>TrackOrderScreen(),
                                ),

                              );

                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text('Track your order',
                              style: TextStyle(
                                  color: Colors.white
                              ),)),
                      ),
                    )
                  ],
                )
            );
            /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context)=>AddressScreen()));*/
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text(
            "Place Order",
            style: TextStyle(color: Colors.white),
          ),
        ),
      )

              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Payment Method Button
class SelectablePaymentButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String text;
  final IconData icon;

  const SelectablePaymentButton({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final double buttonHeight = responsiveHeight(context, 40);
    final double buttonWidth = responsiveWidth(context, 120);

    return SizedBox(
      height: buttonHeight,
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.black : Colors.white,
          elevation: isSelected ? 4 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isSelected ? Colors.white : Colors.black, size: 16),
            SizedBox(width: responsiveWidth(context, 4)),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}