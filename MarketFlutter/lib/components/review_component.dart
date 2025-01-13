import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

import '../models/review.dart';

class ReviewComponent extends StatelessWidget {
  final Review review;
  const ReviewComponent({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 6,),
        Container(
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
            borderRadius: BorderRadius.circular(25),

          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("${review.firstName} ${review.lastName}"),
                  const SizedBox(width: 4,),
                  StarRating(
                    rating: review.rating,
                    allowHalfRating: true,
                    mainAxisAlignment: MainAxisAlignment.start,
                    size: 24,
                  ),
                ],
              ),
              Text(review.description),
            ],
          ),
        ),
      ],
    );
  }
}

