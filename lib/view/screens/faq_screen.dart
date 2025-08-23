import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/widget/custom_toggle_faqs_widget.dart';
import 'package:ecommerce/view/widget/faq_accordion_widget.dart';
import 'package:ecommerce/view/widget/notification_icon_widget.dart';
import 'package:flutter/material.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  int selectedCategory = -1; // -1 تعني عرض كل الفئات أولًا

  final categories = ["General", "Account", "Service", "Payment"];

  // يمكن نقل faqItems خارج build لتجنب إعادة الإنشاء
  final List<Map<String, String>> faqItems = [
    {
      "category": "Service",
      "question": "How do I make a purchase?",
      "answer": 'When you find a product you want to purchase, tap on it to view the product details. Check the price, description, and available options (if applicable), and then tap the "Add to Cart" button. Follow the on-screen instructions to complete the purchase, including providing shipping details and payment information.'
    },
    {
      "category": "Payment",
      "question": "What payment methods are accepted?",
      "answer": "Various payment methods are accepted, including credit/debit cards and digital wallets."
    },
    {
      "category": "General",
      "question": "How do I track my orders?",
      "answer": "You can track your orders from the 'Orders' section in your account."
    },
    {
      "category": "Account",
      "question": "Can I cancel or return an order?",
      "answer": "You can cancel or return an order within 24 hours of purchase from your account."
    },
    {
      "category": "Service",
      "question": "How can I contact customer support?",
      "answer": "You can contact customer support via the 'Help' section in the app or by email."
    },
  ];

  @override
  Widget build(BuildContext context) {
    // فلترة الأسئلة حسب الفئة، -1 تعني عرض كل الأسئلة
    final filteredItems = (selectedCategory == -1 || selectedCategory == 0)
        ? faqItems
        : faqItems
        .where((item) => item["category"] == categories[selectedCategory])
        .toList();

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
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BackButton(),
                  Text(
                    "FAQs",
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

              // Toggle Buttons
              CustomToggleButton(
                options: categories,
                initialIndex: selectedCategory == -1 ? 0 : selectedCategory,
                onSelected: (index) {
                  setState(() {
                    selectedCategory = index;
                  });
                },
              ),
              SizedBox(height: responsiveHeight(context, 24)),

              // FAQ Accordion
              Expanded(
                child: SingleChildScrollView(
                  child: FaqAccordion(faqItems: filteredItems),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


