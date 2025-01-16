import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:market/models/shopping_list_item.dart';
import 'package:market/services/shopping_list_service.dart';
import 'package:market/views/edit_shopping_list_item_view.dart';
import 'package:market/views/shopping_list_view.dart';

class ShoppingListItemComponent extends StatefulWidget {
  final ShoppingListItem preset;
  final VoidCallback onDelete;

  const ShoppingListItemComponent({super.key, required this.preset, required this.onDelete});

  @override
  State<ShoppingListItemComponent> createState() => _ShoppingListItemComponentState();
}

class _ShoppingListItemComponentState extends State<ShoppingListItemComponent> {
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
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
        decoration: const BoxDecoration(
          color: Color(0xffFFFFFF),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 0,
              blurRadius: 15,
              offset: Offset(5, 5), // Shadow moved to the right and bottom
            )
          ],
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
                  color: colors[widget.preset.type],
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
                child: Center(child: offerTypes[widget.preset.type]),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox( width: 140, child: Text(widget.preset.title, textAlign: TextAlign.right, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.tertiary),)),
                  Text("${widget.preset.quantity} KG ")
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      final ShoppingListItem? updatedItem = await Get.to(() => EditShoppingListItemView(item: widget.preset,), transition: Transition.fade);
                      if (updatedItem != null) {
                        setState(() {
                          widget.preset.title = updatedItem.title;
                          widget.preset.quantity = updatedItem.quantity;
                          widget.preset.category = updatedItem.category;
                          widget.preset.type = updatedItem.type;
                        });
                      }
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.onDelete();
                      dispose();
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
      onTap: (){
        //get off the list
      },
    );
  }
}
