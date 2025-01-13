import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import 'package:market/components/review_component.dart';
import 'package:market/services/offer_service.dart';
import 'package:market/services/review_service.dart';
import 'package:market/services/user_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/review.dart';
import 'navigation.dart';

class OfferReviewsView extends StatefulWidget {
  List<Review> reviews;
  final int offerId;
  OfferReviewsView({super.key, required this.reviews, required this.offerId});

  @override
  State<OfferReviewsView> createState() => _OfferReviewsViewState(offerId);
}

class _OfferReviewsViewState extends State<OfferReviewsView> {
  double rating = 2.5;
  TextEditingController descriptionController = TextEditingController();

  int offerId = 0;
  _OfferReviewsViewState(int offerId) {
    offerId = offerId;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFEFEFE),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: widget.reviews.reversed.map((element) => ReviewComponent(review: element)).toList(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(30),
                width: double.infinity,
                height: 267,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                  color: Color(0xffFEFEFE),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ), //BoxShadow
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        StarRating(
                          rating: rating,
                          allowHalfRating: true,
                          mainAxisAlignment: MainAxisAlignment.start,
                          size: 24,
                          onRatingChanged: (rating) => setState(() => this.rating = rating),
                        ),
                        TextFormField(
                          controller: descriptionController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: AppLocalizations.of(context)!.review_cta,
                            hintStyle: const TextStyle(color: Colors.blue),
                          ),
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return "Enter a valid description!";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  setState(() {
                                    Review review = Review(offerId: offerId, firstName: UserService.instance.user.firstName, lastName: UserService.instance.user.lastName, description: descriptionController.text, rating: rating);
                                    ReviewService.instance.publish(review);
                                    OfferService.instance.loadedOffers.singleWhere((x) => x.id == offerId).reviews!.add(review);
                                    widget.reviews = OfferService.instance.loadedOffers.singleWhere((x) => x.id == offerId).reviews!;
                                    OfferService.instance.loadedOffers.singleWhere((x) => x.id == offerId).avgRating = widget.reviews.length > 1 ? widget.reviews.map((m) => m.rating).reduce((a, b) => a + b) / widget.reviews.length : widget.reviews[0].rating;
                                    OfferService.instance.getData();
                                    Get.offAll(const Navigation(index: 1), transition: Transition.fade);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.blue,
                                  shadowColor: Colors.black,
                                  elevation: 4.0,
                                ),
                                child: Text(AppLocalizations.of(context)!.publish, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 24),),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

