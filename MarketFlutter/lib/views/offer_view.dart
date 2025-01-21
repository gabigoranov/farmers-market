import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import 'package:market/models/order.dart';
import 'package:market/views/chats_view.dart';
import 'package:market/views/loading.dart';
import 'package:market/services/firebase_service.dart';
import 'package:market/models/offer.dart';
import 'package:market/services/user_service.dart';
import 'package:market/views/offer_reviews_view.dart';
import 'package:market/views/purchase_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:market/views/seller_info.dart';

import '../providers/notification_provider.dart';
import '../services/offer_service.dart';

class OfferView extends StatelessWidget {
  final Offer offer;

  OfferView({super.key, required this.offer});

  String? imageLink;

  Future<void> getData() async {
    imageLink = await FirebaseService().getImageLink("offers/${offer.id}");
    //load this offer's reviews and save it in the service
    offer.reviews ??= await OfferService.instance.loadOfferReviews(offer);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading(); // Show a loading indicator
          } else if (snapshot.hasError) {
            return const Text('Error loading image'); // Handle errors
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(EdgeInsets.zero),
                            overlayColor: WidgetStateProperty.all(Colors.transparent),
                          ),
                          onPressed: () {
                            Get.to(SellerInfo(id: offer.ownerId), transition: Transition.circularReveal);
                          },
                          child: Text(
                            AppLocalizations.of(context)?.seller_info ?? "View seller's info",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xff1E1E1E)
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await NotificationProvider.instance.addContact(offer.ownerId);
                            Get.to(() => const ChatsView(), transition: Transition.fade);
                          },
                          icon: const Icon(CupertinoIcons.paperplane),
                        ),
                      ],
                    )
                ),
                shadowColor: Colors.black87,
                elevation: 0.4,
                backgroundColor: Colors.white,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: Column(
                      children: [
                        Stack(
                          children: <Widget>[
                            Container(
                              constraints: const BoxConstraints(
                                maxHeight: 400,
                                //maximum width set to 100% of width
                              ),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: Image.network(
                                  imageLink!,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      // Image is fully loaded
                                      return child;
                                    } else {
                                      // Display a loading indicator (e.g., CircularProgressIndicator)
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Image.asset(
                                  "assets/clouds.png",
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                offer.title,
                                style: const TextStyle(
                                    fontSize: 34, fontWeight: FontWeight.w900),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.25,
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  child: Text(
                                    offer.description,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black54),
                                  )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StarRating(
                                    rating:
                                        (2 * offer.avgRating).floorToDouble() /
                                            2,
                                    allowHalfRating: true,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    size: 24,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return OfferReviewsView(
                                            reviews: offer.reviews!,
                                            offerId: offer.id,
                                          );
                                        }),
                                      );
                                    },
                                    icon: const Icon(
                                      CupertinoIcons
                                          .bubble_left_bubble_right_fill,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return PurchaseView(
                                              model: Order(
                                                  offerId: offer.id,
                                                  buyerId: UserService
                                                      .instance.user.id,
                                                  sellerId: offer.ownerId,
                                                  isDelivered: false),
                                              offer: offer);
                                        }),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff26D156),
                                      foregroundColor: Colors.white,
                                      shadowColor: Colors.black,
                                      elevation: 4.0,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Text(
                                        AppLocalizations.of(context)!.order_now,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    "${offer.pricePerKG}\nlv/kg",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      height: 0.9,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
