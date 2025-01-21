import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/components/discover_component.dart';
import 'package:market/components/history_item_component.dart';
import 'package:market/views/chats_view.dart';
import 'package:market/views/bottom_navigation_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/purchase.dart';
import '../services/purchase_service.dart';

class Home extends StatefulWidget {
  const Home({super.key,});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();
  late List<Purchase> orders;

  @override
  void initState() {
    super.initState();
    orders =  PurchaseService.instance.getPurchases().reversed.take(2).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<HistoryItemComponent> widgets = List.generate(orders.length, (index) {
      final borderRadius = BorderRadius.only(
        topLeft: Radius.circular(index == 0 ? 25 : 0),
        topRight: Radius.circular(index == 0 ? 25 : 0),
        bottomLeft: Radius.circular(index == orders.length - 1 ? 25 : 0),
        bottomRight: Radius.circular(index == orders.length - 1 ? 25 : 0),
      );
      return HistoryItemComponent(order: orders[index], borderRadius: borderRadius);
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width*0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      //search
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.65,
                            child: Form(
                              child: TextFormField(
                                key: _formKey,
                                controller: searchController,
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!.search,
                                  contentPadding: const EdgeInsets.all(12.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(color: Colors.white, width: 3.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Get.offAll(Navigation(index: 1, text: searchController.text, category: null,), transition: Transition.fade);
                            },
                            icon: const Icon(CupertinoIcons.search),
                          ),
                          IconButton(
                            onPressed: () {
                              Get.to(() => const ChatsView(), transition: Transition.fade);
                            },
                            icon: const Icon(CupertinoIcons.paperplane),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      DiscoverComponent(title: AppLocalizations.of(context)!.vegetables, value: "Vegetables", imgURL: "assets/discover-vegetables.jpg", color: 0xff26D156),
                      const SizedBox(height: 10,),
                      DiscoverComponent(title: AppLocalizations.of(context)!.fruits, value: "Fruits", imgURL: "assets/discover-fruits.jpg", color: 0xffF13A3A),
                      const SizedBox(height: 10,),
                      DiscoverComponent(title: AppLocalizations.of(context)!.dairy, value: "Dairy", imgURL: "assets/discover-dairy.jpg", color: 0xff56A8E4),
                      const SizedBox(height: 10,),
                      DiscoverComponent(title: AppLocalizations.of(context)!.meat, value: "Meat", imgURL: "assets/discover-meat.jpg", color: 0xffFFFAA8),
                      //tags
                      const SizedBox(height: 30,),

                    ],
                  ),
                  Text(AppLocalizations.of(context)!.recent_orders),
                  Column(
                    children: widgets,
                  ),
                  const SizedBox(height: 82,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
