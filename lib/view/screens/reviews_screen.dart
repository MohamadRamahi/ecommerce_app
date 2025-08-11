import 'package:ecommerce/model/product_model.dart';
import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/widget/notification_icon_widget.dart';
import 'package:ecommerce/view/widget/review_widget.dart';
import 'package:flutter/material.dart';

class ReviewsScreen extends StatefulWidget {
  final ProductModel product;

  const ReviewsScreen({super.key, required this.product});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  Widget buildStarRow(double rating) {
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;
    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.amber, size: 20);
        } else if (index == fullStars && halfStar) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 20);
        } else {
          return const Icon(Icons.star_border, color: Colors.grey, size: 20);
        }
      }),
    );
  }

  // نموذج تعليقات
  final List<Map<String, dynamic>> reviews = [
    {
      'name': 'Ali',
      'rating': 4.5,
      'comment': 'The item is very good, my son likes it very much and plays every day.',
      'date':'2 Weeks'
    },
    {
      'name': 'Sara',
      'rating': 3.0,
      'comment': 'Good quality but packaging could be improved.',
      'date':'2 Weeks'
    },
    {
      'name': 'Mohamad',
      'rating': 4.0,
      'comment': 'The item is very good, my son likes it very much and plays every day.',
      'date':'2 Weeks'
    },
    {
      'name': 'Ahmad',
      'rating': 5.0,
      'comment': 'The item is very good, my son likes it very much and plays every day.',
      'date':'2 Weeks'

    },
  ];

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
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BackButton(),
                    Text(
                      "Reviews",
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

                // Review Summary Widget (stars + total ratings)
                ReviewWidget(
                  product: widget.product,
                  totalRatings: 1034,
                  ratingCounts: [40, 60, 100, 250, 600],
                ),

                SizedBox(height: responsiveHeight(context, 24)),
                Divider(
                  color: Colors.grey.withOpacity(0.5),
                ),
                SizedBox(height: responsiveHeight(context, 24)),

                // Reviews count and sort option
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${reviews.length} Reviews',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: responsiveWidth(context, 20),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Most Relevant',
                      style: TextStyle(
                        fontSize: responsiveWidth(context, 16),
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: responsiveHeight(context, 16)),

                // List of customer reviews
                ...reviews.map((review) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: responsiveHeight(context, 24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildStarRow(review['rating']),
                        SizedBox(height: responsiveHeight(context, 12)),
                        Text(
                          review['comment'],
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: responsiveWidth(context, 16),
                          ),
                        ),
                        SizedBox(height: responsiveHeight(context, 12)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                            review['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: responsiveWidth(context, 18),
                              color: Colors.black87,
                            ),
                          ),
                            SizedBox(width: responsiveWidth(context, 4),),
                            Text(
                              review['date'],style: TextStyle(
                              color: Colors.grey
                            ),
                            )
                          ]
                        ),
                      SizedBox(height: responsiveHeight(context, 16),),
                      Divider(
                        color: Colors.grey.withOpacity(0.5),
                      )
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
