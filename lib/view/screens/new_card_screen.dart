import 'package:ecommerce/cubit/paymnet_cubit.dart';
import 'package:ecommerce/model/card_payment_model.dart';
import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/screens/checkout_screen.dart';
import 'package:ecommerce/view/widget/congrats_dialog_widget.dart';
import 'package:ecommerce/view/widget/notification_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewCardScreen extends StatefulWidget {
  const NewCardScreen({super.key});

  @override
  State<NewCardScreen> createState() => _NewCardScreenState();
}

class _NewCardScreenState extends State<NewCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController securityCode = TextEditingController();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    numberController.addListener(_checkForm);
    expiryController.addListener(_checkForm);
    securityCode.addListener(_checkForm);
  }
  void _checkForm() {
    setState(() {
      isButtonEnabled =
          numberController.text.isNotEmpty &&
              expiryController.text.isNotEmpty &&
              securityCode.text.isNotEmpty;
    });
  }
  @override

  void dispose() {
    numberController.dispose();
    expiryController.dispose();
    securityCode.dispose();
    super.dispose();
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: responsiveHeight(context, 16),
              horizontal: responsiveWidth(context, 24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BackButton(),
                    Text(
                      "New Card",
                      style: TextStyle(
                        fontSize: responsiveWidth(context, 24),
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const NotificationIcon(),
                  ],
                ),

                SizedBox(height: responsiveHeight(context, 24)),

                Text(
                  'Add Debit or Credit Card',
                  style: TextStyle(
                    fontSize: responsiveWidth(context, 20),
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: responsiveHeight(context, 24)),

                /// Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      /// Card Number
                      TextFormField(
                        controller: numberController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter Card Number",hintStyle: TextStyle(
                          color: Color(0xff999999)
                        ),
                          labelText: "Card Number",
                          labelStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: responsiveWidth(context, 16),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xffE6E6E6),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xff999999),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty || val.length < 16) {
                            return "Enter valid card number";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      /// Expiry Date + CVV
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: expiryController,
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                hintText: "MM/YY",hintStyle: TextStyle(
                                  color: Color(0xff999999)
                              ),
                                labelText: "Expiry Date",
                                labelStyle: TextStyle(
                                  color: Colors.black87,
                                  fontSize: responsiveWidth(context, 16),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xffE6E6E6),
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xff999999),
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty || !val.contains("/")) {
                                  return "Enter valid expiry date";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16), // مسافة بين الحقول
                          Expanded(
                            child: TextFormField(
                              controller: securityCode,
                              keyboardType: TextInputType.number,
                              maxLength: 3, // CVV غالباً 3 أرقام
                              decoration:  InputDecoration(
                                hintText: '123',hintStyle: TextStyle(
                                  color: Color(0xff999999)
                              ),
                                labelText: "Security Code",labelStyle: TextStyle(
                                color: Colors.black87,
                                fontSize: responsiveWidth(context, 16),
                              ),
                                counterText: "",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xffE6E6E6),
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xff999999),
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty || val.length < 3) {
                                  return "Enter valid CVC";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      /// Save Button
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final card = CardModel(
                              type: "VISA",
                              number: numberController.text,
                              expiryDate: expiryController.text,
                              securityCode: securityCode.text,
                            );
                            context.read<PaymentCubit>().addCard(card);
                            showDialog(context: context,
                                builder: (context){
                              return CongratsDialog(
                                  title: 'Congratulations!',
                                  buttonText: 'Thanks',
                                  onButtonPressed:(){
                                    Navigator.pop(context, card); // رجوع مع الكارد

                                  }
                              );
                                });

                            Navigator.pop(context, card);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Add Card",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
