import 'package:ecommerce/cubit/payment_state.dart';
import 'package:ecommerce/cubit/paymnet_cubit.dart';
import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/widget/notification_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'new_card_screen.dart';

class EditPaymentScreen extends StatelessWidget {
  const EditPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentCubit()..loadCards(),
      child: const EditPaymentView(),
    );
  }
}

class EditPaymentView extends StatelessWidget {
  const EditPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: responsiveHeight(context, 16),
            horizontal: responsiveWidth(context, 24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BackButton(),
                  Text(
                    "Payment Method",
                    style: TextStyle(
                      fontSize: responsiveWidth(context, 24),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  NotificationIcon(),
                ],
              ),
               SizedBox(height: responsiveHeight(context, 24)),

              // Title
              Text(
                "Saved Cards",
                style: TextStyle(
                  fontSize: responsiveWidth(context, 20),
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
               SizedBox(height: responsiveHeight(context, 16)),

              // 🔹 Saved Cards List
              Expanded(
                child: BlocBuilder<PaymentCubit, PaymentState>(
                  builder: (context, state) {
                    if (state.cards.isEmpty) {
                      return const Center(child: Text("No saved cards"));
                    }
                    return ListView.builder(
                      itemCount: state.cards.length,
                      itemBuilder: (context, index) {
                        final card = state.cards[index];
                        return Dismissible(
                          key: Key(card.number), // مفتاح فريد لكل كارد
                          direction: DismissDirection.endToStart, // سحب للشمال فقط
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.red,
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (_) {
                            context.read<PaymentCubit>().removeCard(index);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Card removed")),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300),

                            ),

                            child: ListTile(
                              leading: const Icon(Icons.credit_card, color: Colors.black54),
                              title: Text(
                                "**** **** **** ${card.number.substring(card.number.length - 4)}",
                              ),
                              subtitle: Text("Exp: ${card.expiryDate}"),
                              trailing: Radio<int>(
                                value: index,
                                groupValue: state.selectedCardIndex,
                                onChanged: (val) {
                                  context.read<PaymentCubit>().selectCard(val!);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // 🔹 Add New Card
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<PaymentCubit>(),
                        child: const NewCardScreen(),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.black),
                      SizedBox(width: 8),
                      Text("Add New Card"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Apply Button
              ElevatedButton(
                onPressed: () {
                  final cubit = context.read<PaymentCubit>();
                  if (cubit.state.selectedCardIndex != null) {
                    cubit.applySelection();
                    Navigator.pop(context, cubit.state.cards[cubit.state.selectedCardIndex!]);
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
                  "Apply",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
