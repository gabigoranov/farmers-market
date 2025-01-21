import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import 'package:market/models/offer.dart';
import 'package:market/services/offer_type_service.dart';
import 'package:market/services/shopping_list_service.dart';
import 'package:market/views/offer_screen.dart';

class OfferItemComponent extends StatelessWidget {
  final Offer offer;

  const OfferItemComponent({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: ShoppingListService.instance.isNeeded(offer.stock.offerType.name)
              ? const Color(0xffe8feff)
              : const Color(0xffFFFFFF),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 0,
              blurRadius: 15,
              offset: Offset(5, 5), // Shadow moved to the right and bottom
            ),
          ],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconAndColor(),
              _buildOfferDetails(context),
            ],
          ),
        ),
      ),
      onTap: () {
        Get.to(OfferView(offer: offer), transition: Transition.fade);
      },
    );
  }

  Widget _buildIconAndColor() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: OfferTypeService.instance.getColor(offer.stock.offerType.name),
        borderRadius: BorderRadius.circular(50),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 0,
            blurRadius: 15,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Center(child: OfferTypeService.instance.getIcon(offer.stock.offerType.name)),
    );
  }

  Widget _buildOfferDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          offer.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        StarRating(
          rating: offer.avgRating,
          allowHalfRating: true,
          mainAxisAlignment: MainAxisAlignment.start,
          size: 24,
        ),
        Text("${offer.pricePerKG}lv/kg "),
      ],
    );
  }
}
