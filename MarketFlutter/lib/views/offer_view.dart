import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:market/models/order.dart';
import 'package:market/services/offer_service.dart';
import 'package:market/views/loading.dart';
import 'package:market/services/firebase_service.dart';
import 'package:market/models/offer.dart';
import 'package:market/services/user_service.dart';
import 'package:market/models/user.dart';
import 'package:market/views/navigation.dart';
import 'package:market/views/offer_reviews_view.dart';
import 'package:market/views/purchase_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OfferView extends StatelessWidget {
  final Offer offer;

  OfferView({super.key, required this.offer});


  User? owner;
  String? imageLink;

  Future<void> getData() async{
    imageLink = await FirebaseService().getImageLink("offers/${offer.id}");
    owner = await UserService.instance.getWithId(offer.ownerId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: getData(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting)
          {
            return Loading(); // Show a loading indicator
          }
          else if (snapshot.hasError)
          {
            return const Text('Error loading image'); // Handle errors
          }
          else
          {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Align(alignment: Alignment.centerRight, child: Text('${owner!.firstName} ${owner!.lastName}', style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xff1E1E1E)),)),
                shadowColor: Colors.black87,
                elevation: 0.4,
                backgroundColor: Colors.white,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0,0,0,16),
                    margin:  const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    child: Column(
                      children: [
                        Stack(
                          children: <Widget>[
                            Container(
                              constraints: const BoxConstraints(
                                maxHeight: 400,
                                //maximum width set to 100% of width
                              ),
                              child: Container(
                                height: MediaQuery.of(context).size.height*0.6,
                                child: Image.network(imageLink!,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      // Image is fully loaded
                                      return child;
                                    } else {
                                      // Display a loading indicator (e.g., CircularProgressIndicator)
                                      return const Center(child: CircularProgressIndicator());
                                    }
                                  },
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Image.asset("assets/clouds.png",
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
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(offer.title, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900),),
                                    Visibility(
                                      visible: offer.ownerId == UserService.instance.user.id,
                                      child: IconButton(
                                        onPressed: () async{
                                          await OfferService.instance.delete(offer.id);
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(builder: (context){
                                              return const Navigation(index: 0,);
                                            }),
                                            ModalRoute.withName('/'),
                                          );
                                        },
                                        icon: const Icon(CupertinoIcons.delete_solid),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height*0.25,width: MediaQuery.of(context).size.width*0.9, child: Text(offer.description, textAlign: TextAlign.left,style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black54),)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StarRating(
                                    rating: (2*offer.avgRating).floorToDouble()/2,
                                    allowHalfRating: true,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    size: 24,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: (){
                                      Navigator.push(context,
                                        MaterialPageRoute(builder: (context){
                                          return OfferReviewsView(reviews: offer.reviews!, offerId: offer.id,);
                                        }),
                                      );
                                    },
                                    icon: const Icon(CupertinoIcons.bubble_left_bubble_right_fill,),
                                  ),
                                  const SizedBox(width: 16,),
                                  TextButton(
                                    onPressed: (){
                                      Navigator.push(context,
                                        MaterialPageRoute(builder: (context){
                                          return PurchaseView(model: Order(offerId: offer.id, buyerId: UserService.instance.user.id, sellerId: offer.ownerId, isDelivered: false), offer: offer);
                                        }),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff40B886),
                                      foregroundColor: Colors.white,
                                      shadowColor: Colors.black,
                                      elevation: 4.0,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(AppLocalizations.of(context)!.order_now, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),),
                                    ),
                                  ),
                                  const SizedBox(width: 16,),
                                  Text("${offer.pricePerKG}\nlv/kg", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, height: 0.9, ),textAlign: TextAlign.right,),
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
        }
    );
  }
}
