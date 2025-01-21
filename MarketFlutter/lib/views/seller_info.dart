import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/components/offer_component.dart';
import 'package:market/providers/image_provider.dart';
import 'package:market/services/user_service.dart';
import 'package:market/services/firebase_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../models/seller.dart';
import '../providers/notification_provider.dart';
import 'chats_view.dart';

class SellerInfo extends StatefulWidget {
  final String id;

  const SellerInfo({super.key, required this.id});

  @override
  State<SellerInfo> createState() => _SellerInfoState();
}

class _SellerInfoState extends State<SellerInfo> {
  final storage = FirebaseStorage.instance.ref();
  late String networkImageURL;
  late Seller userData; // Nullable to avoid errors before initialization.
  late Future<void> _initDataFuture;

  Future<void> getImageData() async {
    userData = await UserService.instance.getSellerWithId(widget.id);
    networkImageURL = await FirebaseService.instance
        .getImageLink("profiles/${userData.email}");
  }

  @override
  void initState() {
    super.initState();
    _initDataFuture = getImageData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageFileProvider>(
      builder:
          (BuildContext context, ImageFileProvider provider, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    AppLocalizations.of(context)?.seller_info ?? "View seller's info",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1E1E1E)
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await NotificationProvider.instance.addContact(widget.id);
                      Get.to(() => const ChatsView(), transition: Transition.fade);
                    },
                    icon: const Icon(CupertinoIcons.paperplane),
                  ),
                ],
              ),
            ),
            shadowColor: Colors.black87,
            elevation: 0.4,
            backgroundColor: Colors.white,
          ),
          backgroundColor: Colors.white,
          body: FutureBuilder<void>(
            future: _initDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                //
                return Center(
                    child:
                        Text(AppLocalizations.of(context)!.error_loading_data));
              }

              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 14),
                                Text(
                                  '${userData.firstName} ${userData.lastName}',
                                  style: const TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 10,
                                          color: Colors.blue,
                                          spreadRadius: 8)
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 85,
                                    backgroundColor: Colors.black87,
                                    backgroundImage:
                                        NetworkImage(networkImageURL),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(userData.town,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 24)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 22, vertical: 2),
                                  child: Text(
                                    userData.description,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey, width: 1.0),
                                ),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.person,
                                    size: 30, color: Colors.blue),
                                title: Text(
                                    "${userData.firstName} ${userData.lastName}",
                                    style: const TextStyle(fontSize: 18)),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey, width: 1.0),
                                ),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.calendar_month,
                                    size: 30, color: Colors.blue),
                                title: Text(
                                    "${AppLocalizations.of(context)!.age}: ${userData.age}",
                                    style: const TextStyle(fontSize: 18)),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey, width: 1.0),
                                ),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.phone,
                                    size: 30, color: Colors.blue),
                                title: Text(userData.phoneNumber,
                                    style: const TextStyle(fontSize: 18)),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey, width: 1.0),
                                ),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.email,
                                    size: 30, color: Colors.blue),
                                title: Text(userData.email,
                                    style: const TextStyle(fontSize: 18)),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey, width: 1.0),
                                ),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.star,
                                    size: 30, color: Colors.blue),
                                title: Text("Rating: ${userData.rating}",
                                    style: const TextStyle(fontSize: 18)),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey, width: 1.0),
                                ),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.mode_comment,
                                    size: 30, color: Colors.blue),
                                title: Text("Reviews: ${userData.reviewsCount}",
                                    style: const TextStyle(fontSize: 18)),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey, width: 1.0),
                                ),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.thumb_up_off_alt_sharp,
                                    size: 30, color: Colors.blue),
                                title: Text(
                                    "Positive Reviews: ${userData.positiveReviewsCount}",
                                    style: const TextStyle(fontSize: 18)),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey, width: 1.0),
                                ),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.shopping_cart,
                                    size: 30, color: Colors.blue),
                                title: Text(
                                    "Sold Orders: ${userData.ordersCount}",
                                    style: const TextStyle(fontSize: 18)),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocalizations.of(context)?.seller_offers ?? "All Offers:",
                              style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                              )
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 1,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: ListView.builder(
                                itemCount: userData.offers.length,
                                itemBuilder: (context, index) {
                                  return OfferComponent(
                                    offer: userData.offers[index],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
