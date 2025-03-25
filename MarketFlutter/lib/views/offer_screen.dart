import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import 'package:market/models/order.dart';
import 'package:market/views/chats_view.dart';
import 'package:market/views/loading_screen.dart';
import 'package:market/services/firebase_service.dart';
import 'package:market/models/offer.dart';
import 'package:market/services/user_service.dart';
import 'package:market/views/reviews_screen.dart';
import 'package:market/views/purchase_screen.dart';
import 'package:market/l10n/app_localizations.dart';
import 'package:market/views/seller_screen.dart';

import '../providers/notification_provider.dart';
import '../services/offer_service.dart';

class OfferView extends StatefulWidget {
  final Offer offer;

  const OfferView({super.key, required this.offer});

  @override
  State<OfferView> createState() => _OfferViewState();
}

class _OfferViewState extends State<OfferView> {
  String? imageLink;

  Future<void> getData() async {
    imageLink = await FirebaseService().getImageLink("offers/${widget.offer.id}");
    //load this offer's reviews and save it in the service
    widget.offer.reviews ??= await OfferService.instance.loadOfferReviews(widget.offer);
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
              backgroundColor: Get.theme.scaffoldBackgroundColor,
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
                            Get.to(SellerInfo(id: widget.offer.ownerId), transition: Transition.circularReveal);
                          },
                          child: Text(
                            AppLocalizations.of(context)?.seller_info ?? "View seller's info",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Get.theme.colorScheme.surfaceDim,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await NotificationProvider.instance.addContact(widget.offer.ownerId);
                            Get.to(() => const ChatsView(), transition: Transition.fade);
                          },
                          icon: const Icon(CupertinoIcons.paperplane),
                        ),
                      ],
                    )
                ),
                shadowColor: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.87),
                elevation: 0.4,
                backgroundColor: Get.theme.scaffoldBackgroundColor,
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
                                  Get.theme.brightness == Brightness.light ? "assets/clouds.png" : "assets/clouds_dark.png",
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  color: Get.theme.scaffoldBackgroundColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.offer.title,
                                    style: TextStyle(
                                        fontSize: 34, fontWeight: FontWeight.w900, color: Get.theme.colorScheme.surfaceDim),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: widget.offer.stock.quantity >= 60 ? Colors.green : widget.offer.stock.quantity < 60 ? Colors.orange : Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: Text(
                                      "${widget.offer.stock.quantity} KG",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,

                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.25,
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  child: Text(
                                    widget.offer.description,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.54)),
                                  )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StarRating(
                                    rating:
                                    (2 * widget.offer.avgRating).floorToDouble() /
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
                                            reviews: widget.offer.reviews!,
                                            offerId: widget.offer.id,
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
                                                  offerId: widget.offer.id,
                                                  buyerId: UserService
                                                      .instance.user.id,
                                                  sellerId: widget.offer.ownerId,
                                                  status: "None",
                                                  offerTypeId: widget.offer.stock.offerTypeId,
                                                  offerType: widget.offer.stock.offerType,
                                              ),
                                              offer: widget.offer);
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
                                    "${widget.offer.pricePerKG}\nlv/kg",
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
