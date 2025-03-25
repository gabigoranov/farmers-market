import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/components/offer_item_component.dart';
import 'package:market/services/offer_service.dart';
import 'package:market/models/offer.dart';
import 'package:market/services/user_service.dart';
import 'package:market/models/user.dart';
import 'package:market/l10n/app_localizations.dart';

import '../services/dio_service.dart';

final dio = DioClient().dio;


class DiscoverBody extends StatefulWidget {
  String? text;
  final String? category;

  DiscoverBody({super.key, this.text, this.category});

  @override
  State<DiscoverBody> createState() => _DiscoverBodyState();
}

class _DiscoverBodyState extends State<DiscoverBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();

  User userData = UserService.instance.user;

  List<Widget> offers = [];
  bool isLoading = false;

  Future<void> reloadWidgets() async {
    setState((){
      if(widget.category != null){
        offers = OfferService.instance.loadedOffers.where((x) => x.stock.offerType.category == widget.category).map((element) => OfferItemComponent(offer: element)).toList();
      }
      else{
        OfferService.instance.loadOfferComponents();
        offers = OfferService.instance.offerWidgets;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    reloadWidgets();
    if(widget.text != null){
      search(widget.text!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width*0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.75,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: widget.text ?? AppLocalizations.of(context)!.search,
                            contentPadding: const EdgeInsets.all(12.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.red, width: 3.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async{
                        if(isLoading) return;
                        String input = searchController.value.text;
                        await search(input);
      
                      },
                      icon: const Icon(CupertinoIcons.search),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 22,),
              isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: offers.isNotEmpty ? List<Widget>.generate(
                    offers.length * 2 - 1, (index) {
                      if (index.isEven) {
                        return offers[index ~/ 2];
                      } else {
                        return const SizedBox(height: 8);
                      }
                    }
                ) : [],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> search(String input) async {
    if(input == "") {
      reloadWidgets();
      widget.text = null;
      return;
    }
    setState(() {
      isLoading = true;
      offers = [];
    });
    String url = "https://api.freshly-groceries.com/api/offers/search?input=$input&preferredTown=${userData.town}";
    var response = await dio.get(url);
    setState(() {
      for(int i = 0; i < response.data.length; i++){
        Offer offer = Offer.fromJson(response.data[i]);
        print(jsonEncode(offer));
        if(widget.category != null){
          if(offer.stock.offerType.category == widget.category){
            offers.add(OfferItemComponent(offer: offer));
            continue;
          }
          continue;
        }
        offers.add(OfferItemComponent(offer: offer));
      }
    });
    setState(() {
      isLoading = false;
      widget.text = null;
    });
  }

}


class Discover extends StatefulWidget {
  final String? text;
  final String? category;
  const Discover({super.key, this.text, this.category});

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: DiscoverBody(text: widget.text, category: widget.category,)
    );
  }


}
