import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/views/landing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../services/locale_service.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {

  final CarouselSliderController _carouselController = CarouselSliderController();
  int currentSlider = 0;

  @override
  Widget build(BuildContext context) {
    List<Map> data = [
      {
        "image": "assets/onboarding_1.png",
        "title": AppLocalizations.of(context)!.onboarding_1_title,
        "desc": AppLocalizations.of(context)!.onboarding_1_description
      },
      {
        "image": "assets/onboarding_2.png",
        "title": AppLocalizations.of(context)!.onboarding_2_title,
        "desc": AppLocalizations.of(context)!.onboarding_2_description
      },
      {
        "image": "assets/onboarding_3.png",
        "title": AppLocalizations.of(context)!.onboarding_3_title,
        "desc": AppLocalizations.of(context)!.onboarding_3_description
      },

    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height,
                  viewportFraction: 1.0,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  initialPage: 0,
                  onPageChanged: (index, _) {
                    setState(() {
                      currentSlider = index;
                    });
                  },
                ),
                items: data.map((e) {
                  return Image.asset(e["image"], width: double.infinity, fit: BoxFit.fitWidth,);
                }).toList(),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        data[currentSlider]["title"],
                        style: const TextStyle(
                          color: Color(0xff384161),
                          fontWeight: FontWeight.w600,
                          fontSize: 20,

                        ),
                      ),
                      const SizedBox(height: 18,),
                      Text(
                        data[currentSlider]["desc"],
                        style: const TextStyle(
                          color: Color(0xff384161),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,

                        ),
                      ),


                    ],
                  ),
                ),
              ),
              const SizedBox(height: 44,),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(30),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                    color: Color(0xffFEFEFE),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          if(currentSlider==0) return;
                          setState(() {
                            currentSlider -= 1;
                            _carouselController.animateToPage(currentSlider);
                          });
                        },
                        child: const Text("Back"),
                      ),
                      TextButton(
                        onPressed: () async {
                          await LocaleService.instance.toggle();
                        },
                        child: Text(AppLocalizations.of(context)!.change_lang),
                      ),
                      TextButton(
                        onPressed: () {
                          if(currentSlider == data.length-1) {
                            Get.to(const Landing(), transition: Transition.circularReveal, duration: const Duration(milliseconds: 800));
                            return;
                          }
                          setState(() {
                            currentSlider += 1;
                            _carouselController.animateToPage(currentSlider);
                          });
                        },
                        child: const Text("Next"),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

