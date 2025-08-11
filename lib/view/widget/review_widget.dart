import 'package:ecommerce/model/product_model.dart';
import 'package:flutter/material.dart';

class ReviewWidget extends StatelessWidget {
  final ProductModel product;
  final int totalRatings;
  final List<int> ratingCounts; // [count for 5 stars, 4 stars, 3 stars, 2 stars, 1 star]

  const ReviewWidget({
    super.key,
    required this.product,
    required this.totalRatings,
    required this.ratingCounts,
  });

  @override
  Widget build(BuildContext context) {
    // Prevent division by zero
    double progress(int count) =>
        totalRatings == 0 ? 0 : count / totalRatings;

    Widget buildStarRow(int stars, int count) {
      return Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              return Icon(
                index < stars ? Icons.star : Icons.star,
                color: index < stars ? Colors.amber : Color(0xffE6E6E6),
                size: 20,
              );
            }),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: progress(count),
              backgroundColor: Colors.grey.shade300,
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
              minHeight: 8,
            ),
          ),
          const SizedBox(width: 8),
          //Text('$count'),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Numeric rating + stars + total ratings count
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              product.rating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < product.rating.round() ? Icons.star : Icons.star,
                      color: index < product.rating.round() ? Colors.amber : Color(0xffE6E6E6),
                      size: 24,
                    );
                  }),
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalRatings Ratings',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Rating bars for each star level
        ...List.generate(5, (index) {
          int starCount = 5 - index;
          int count = (ratingCounts.length >= starCount)
              ? ratingCounts[starCount - 1]
              : 0;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: buildStarRow(starCount, count),
          );
        }),
      ],
    );
  }
}
