import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import 'package:market/components/review_item_component.dart';
import 'package:market/services/offer_service.dart';
import 'package:market/services/review_service.dart';
import 'package:market/services/user_service.dart';
import 'package:market/l10n/app_localizations.dart';

import '../models/review.dart';
import 'bottom_navigation_view.dart';

class OfferReviewsView extends StatefulWidget {
  List<Review> reviews;
  final int offerId;

  OfferReviewsView({Key? key, required this.reviews, required this.offerId}) : super(key: key);

  @override
  State<OfferReviewsView> createState() => _OfferReviewsViewState();
}

class _OfferReviewsViewState extends State<OfferReviewsView> {
  double rating = 2.5;
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            _buildReviewsList(),
            _buildReviewInputSection(),
          ],
        ),
      ),
    );
  }

  // Builds the reviews list
  Widget _buildReviewsList() {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: widget.reviews.length,
          itemBuilder: (BuildContext context, int index) {
            final review = widget.reviews[widget.reviews.length - 1 - index];

            // Determine if the current item is the first or last item
            bool isFirstItem = index == 0;
            bool isLastItem = index == widget.reviews.length - 1;

            return ReviewItemComponent(
              review: review,
              borderRadius: BorderRadius.only(
                topLeft: isFirstItem ? const Radius.circular(25) : Radius.zero,
                topRight: isFirstItem ? const Radius.circular(25) : Radius.zero,
                bottomLeft: isLastItem ? const Radius.circular(25) : Radius.zero,
                bottomRight: isLastItem ? const Radius.circular(25) : Radius.zero,
              ),
            );
          },
        ),
      ),
    );
  }

  // Builds the review input section at the bottom
  Widget _buildReviewInputSection() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(30),
        width: double.infinity,
        height: 267,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          color: Get.theme.scaffoldBackgroundColor,
          boxShadow: Theme.of(context).brightness == Brightness.light
              ? [ // Apply shadow in light mode
                  const BoxShadow(
                    color: Colors.black54,
                    offset: Offset(5.0, 5.0),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ),
                ]
              : [], // No shadow in dark mode
          border: Theme.of(context).brightness == Brightness.dark
              ? Border(
                  top: BorderSide(color: Colors.grey[700]!, width: 1), // Top border only
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRatingAndTextField(),
            _buildPublishButton(),
          ],
        ),
      ),
    );
  }

  // Builds the rating and text input field
  Widget _buildRatingAndTextField() {
    return Column(
      children: [
        StarRating(
          rating: rating,
          allowHalfRating: true,
          mainAxisAlignment: MainAxisAlignment.start,
          size: 34,
          onRatingChanged: (newRating) => setState(() => rating = newRating),
        ),
        TextFormField(
          controller: descriptionController,
          maxLines: 4,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: AppLocalizations.of(context)!.review_cta,
            hintStyle: const TextStyle(color: Colors.blue),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter a valid description!";
            }
            return null;
          },
        ),
      ],
    );
  }

  // Builds the publish button
  Widget _buildPublishButton() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _publishReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.black,
                  elevation: 4.0,
                ),
                child: Text(
                  AppLocalizations.of(context)!.publish,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Handles publishing the review
  void _publishReview() async {
    Review review = Review(
      offerId: widget.offerId,
      firstName: UserService.instance.user.firstName,
      lastName: UserService.instance.user.lastName,
      description: descriptionController.text,
      rating: rating,
    );

    // Publish the review
    await ReviewService.instance.publish(review);

    // Update local state
    final offer = OfferService.instance.loadedOffers.singleWhere((x) => x.id == widget.offerId);
    offer.reviews?.add(review);
    widget.reviews = offer.reviews!;
    offer.avgRating = widget.reviews.isNotEmpty
        ? widget.reviews.map((m) => m.rating).reduce((a, b) => a + b) / widget.reviews.length
        : 0.0;

    // Refresh the offer data
    OfferService.instance.loadOfferComponents();

    // Navigate to the next screen
    Get.offAll(const Navigation(index: 1), transition: Transition.fade);
  }
}
