import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/models/shopping_list_item.dart';
import 'package:market/services/shopping_list_service.dart';
import 'package:market/views/edit_shopping_item_screen.dart';

import '../services/offer_type_service.dart';
class ShoppingListItemComponent extends StatefulWidget {
  final ShoppingListItem preset;
  final bool isAdded;
  final VoidCallback? onDelete;
  final BorderRadius borderRadius; // Added borderRadius parameter

  const ShoppingListItemComponent({
    super.key,
    required this.preset,
    this.onDelete,
    required this.isAdded,
    required this.borderRadius, // Constructor now accepts borderRadius
  });

  @override
  State<ShoppingListItemComponent> createState() => _ShoppingListItemComponentState();
}

class _ShoppingListItemComponentState extends State<ShoppingListItemComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
        decoration: BoxDecoration(
          color: const Color(0xffFFFFFF),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 0,
              blurRadius: 15,
              offset: Offset(5, 5), // Shadow moved to the right and bottom
            ),
          ],
          borderRadius: widget.borderRadius, // Apply borderRadius here
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
                  color: OfferTypeService.instance.getColor(widget.preset.type),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 0,
                      blurRadius: 15,
                      offset: Offset(5, 5), // Shadow moved to the right and bottom
                    ),
                  ],
                ),
                child: Center(child: OfferTypeService.instance.getIcon(widget.preset.type)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    child: Text(
                      widget.preset.title,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                  Text("${widget.preset.quantity} KG "),
                ],
              ),
              Visibility(
                visible: widget.isAdded,
                maintainSize: false,
                maintainState: false,
                maintainAnimation: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final ShoppingListItem? updatedItem = await Get.to(
                              () => EditShoppingListItemView(item: widget.preset),
                          transition: Transition.fade,
                        );
                        if (updatedItem != null) {
                          if(mounted){
                            setState(() {
                              widget.preset.title = updatedItem.title;
                              widget.preset.quantity = updatedItem.quantity;
                              widget.preset.category = updatedItem.category;
                              widget.preset.type = updatedItem.type;
                            });
                          }
                        }
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        if(mounted) {
                          widget.onDelete!();
                        }

                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
      onTap: () async {
        // Get off the list
        if(!widget.isAdded) {
          await ShoppingListService.instance.add(widget.preset);
          Get.back(result: widget.preset);
        }
      },
    );
  }
}
