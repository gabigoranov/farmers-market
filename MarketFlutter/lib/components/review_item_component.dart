import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

import '../models/review.dart';

class ReviewItemComponent extends StatelessWidget {
  final Review review;
  final BorderRadius borderRadius;

  const ReviewItemComponent({super.key, required this.review, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 6),
        _buildReviewCard(context),
      ],
    );
  }

  Widget _buildReviewCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 0,
            blurRadius: 15,
            offset: Offset(5, 5), // Shadow moved to the right and bottom
          )
        ],
        borderRadius: borderRadius, // Applying the border radius
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReviewHeader(),
          Text(review.description),
        ],
      ),
    );
  }

  Widget _buildReviewHeader() {
    return Row(
      children: [
        Text("${review.firstName} ${review.lastName}"),
        const SizedBox(width: 4),
        StarRating(
          rating: review.rating,
          allowHalfRating: true,
          mainAxisAlignment: MainAxisAlignment.start,
          size: 24,
        ),
      ],
    );
  }
}
