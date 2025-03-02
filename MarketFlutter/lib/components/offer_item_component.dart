import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import 'package:market/models/offer.dart';
import 'package:market/services/offer_type_service.dart';
import 'package:market/services/shopping_list_service.dart';
import 'package:market/views/offer_screen.dart';
import 'package:provider/provider.dart';

class OfferItemComponent extends StatelessWidget {
  final Offer offer;

  const OfferItemComponent({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 0,
              blurRadius: 15,
              offset: Offset(5, 5),
            ),
          ],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildIconAndColor(),
            _buildOfferDetails(context),
          ],
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
    return Consumer<ShoppingListService>(
      builder: (context, shoppingListService, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                shoppingListService.isNeeded(offer.offerTypeName)
                    ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade300,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text("Needed", style: TextStyle(color: Colors.white),),
                )
                    : const SizedBox(),
                const SizedBox(width: 12,),
                Text(
                  offer.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ],
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
    );
  }
}
