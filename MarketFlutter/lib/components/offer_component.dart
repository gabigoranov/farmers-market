import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import 'package:market/models/offer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:market/views/offer_view.dart';


class OfferComponent extends StatelessWidget {
  final Offer offer;
  OfferComponent({super.key, required this.offer});
  final Map<String, Widget> offerTypes = {
    "Apples": SvgPicture.asset(
      'assets/icons/apple.svg',
      width: 30,  // Set the desired width
      height: 30, // Set the desired height
      color: Colors.white, // Optionally set a color
    ),
    "Lemons": SvgPicture.asset(
      'assets/icons/lemon.svg',
      width: 30,  // Set the desired width
      height: 30, // Set the desired height
      color: Colors.white, // Optionally set a color
    ),
    "Eggs": SvgPicture.asset(
      'assets/icons/eggs.svg',
      width: 30,  // Set the desired width
      height: 30, // Set the desired height
      color: Colors.white, // Optionally set a color
    ),
    "Bananas": SvgPicture.asset(
      'assets/icons/bananas.svg',
      width: 30,  // Set the desired width
      height: 30, // Set the desired height
      color: Colors.white, // Optionally set a color
    ),
    "Grapes": SvgPicture.asset(
      'assets/icons/grapes.svg',
      width: 30,  // Set the desired width
      height: 30, // Set the desired height
      color: Colors.white, // Optionally set a color
    ),
    "Oranges": SvgPicture.asset(
      'assets/icons/oranges.svg',
      width: 30,  // Set the desired width
      height: 30, // Set the desired height
      color: Colors.white, // Optionally set a color
    ),
    "Carrots": SvgPicture.asset(
      'assets/icons/carrot.svg',
      width: 30,  // Set the desired width
      height: 30, // Set the desired height
      color: Colors.white, // Optionally set a color
    ),
    "Cucumbers": SvgPicture.asset(
      'assets/icons/cucumber.svg',
      width: 30,  // Set the desired width
      height: 30, // Set the desired height
      color: Colors.white, // Optionally set a color
    ),
    "Lettuce": SvgPicture.asset(
      'assets/icons/lettuce.svg',
      width: 30,  // Set the desired width
      height: 30, // Set the desired height
      color: Colors.white, // Optionally set a color
    ),
    "Onions": SvgPicture.asset(
      'assets/icons/onion.svg',
      width: 30,  // Set the desired width
      height: 30, // Set the desired height
      color: Colors.white, // Optionally set a color
    ),
    "Peppers": SvgPicture.asset(
      'assets/icons/pepper.svg',
      width: 30,  // Set the desired width
      height: 30, // Set the desired height
      color: Colors.white, // Optionally set a color
    ),
    "Potatoes": SvgPicture.asset(
      'assets/icons/potato.svg',
      width: 30,  // Set the desired width
      height: 30, // Set the desired height
      color: Colors.white, // Optionally set a color
    ),
    "Strawberries": SvgPicture.asset(
      'assets/icons/strawberry.svg',
      width: 30,  // Set the desired width
      height: 30, // Set the desired height
      color: Colors.white, // Optionally set a color
    ),
    "Tomatoes": SvgPicture.asset(
      'assets/icons/tomato.svg',
      width: 30,  // Set the desired width
      height: 30, // Set the desired height
      color: Colors.white, // Optionally set a color
    ),
    "Steak": SvgPicture.asset(
      'assets/icons/steak.svg',
      width: 30,  // Set the desired width
      height: 30, // Set the desired height
      color: Colors.white, // Optionally set a color
    ),
    "Cheese": SvgPicture.asset(
      'assets/icons/cheese.svg',
      width: 30,  // Set the desired width
      height: 30, // Set the desired height
      color: Colors.white, // Optionally set a color
    )
  };
  final Map<String, Color> colors = {
    "Apples": const Color(0xffF67979),
    "Lemons": const Color(0xffFFE380),
    "Eggs": const Color(0xffF3E1A3),
    "Bananas": const Color(0xffF6EA79),
    "Grapes": const Color(0xff6A4382),
    "Oranges": const Color(0xffFFB763),
    "Cucumbers": const Color(0xff67ab05),
    "Lettuce": const Color(0xff93c560),
    "Onions": const Color(0xff62121b),
    "Peppers": const Color(0xff578c42),
    "Potatoes": const Color(0xffffc284),
    "Strawberries": const Color(0xfffb2943),
    "Carrots": const Color(0xffed9121),
    "Tomatoes": const Color(0xffff6347),
    "Steak": const Color(0xffff7f7f),
    "Cheese": const Color(0xfff7c028),

  };


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          color: const Color(0xffFFFFFF),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: colors[offer.stock.offerType.name],
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const[
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 0,
                      blurRadius: 15,
                      offset: Offset(5, 5), // Shadow moved to the right and bottom
                    )
                  ],
                ),
                child: Center(child: offerTypes[offer.stock.offerType.name]),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(offer.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.tertiary),),
                  StarRating(
                    rating: offer.avgRating,
                    allowHalfRating: true,
                    mainAxisAlignment: MainAxisAlignment.start,
                    size: 24,
                  ),
                  Text("${offer.pricePerKG}lv/kg ") //TODO: add town to user class (update api and db)
                ],
              )

            ],
          ),
        ),
      ),
      onTap: (){
        Get.to(OfferView(offer: offer), transition: Transition.fade);
      },
    );
  }
}
