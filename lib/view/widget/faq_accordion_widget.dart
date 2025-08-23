import 'package:ecommerce/responsive.dart';
import 'package:flutter/material.dart';

class FaqAccordion extends StatefulWidget {
  final List<Map<String, String>> faqItems;

  const FaqAccordion({Key? key, required this.faqItems}) : super(key: key);

  @override
  State<FaqAccordion> createState() => _FaqAccordionState();
}

class _FaqAccordionState extends State<FaqAccordion> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.faqItems.map((item) {
        return Card(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.symmetric(vertical: responsiveHeight(context, 8)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: ExpansionTile(
            title: Text(
              item["question"]!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(responsiveWidth(context, 16)),
                child: Text(item["answer"]!),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
