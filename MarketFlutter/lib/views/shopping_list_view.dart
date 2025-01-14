import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:market/views/shopping_list_add_view.dart';

import '../components/shopping_list_item_component.dart';
import '../models/shopping_list_item.dart';
import '../services/shopping_list_service.dart';

class ShoppingListView extends StatefulWidget {
  const ShoppingListView({super.key});

  @override
  State<ShoppingListView> createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(alignment: Alignment.centerRight, child: Text(AppLocalizations.of(context)!.shopping_list, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),)),
        shadowColor: Colors.black87,
        elevation: 0.4,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: ShoppingListService.instance.items.length,
              itemBuilder: (BuildContext context, int index) {
                ShoppingListItem item = ShoppingListService.instance.items[index];
                return ShoppingListItemComponent(preset: item,);
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80,
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
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async{
                            //Delete current shopping list
                          },
                          icon: const Icon(Icons.delete),
                        ),
                        const SizedBox(width: 12,),
                        SizedBox(
                          width: 200,
                          child: TextButton(
                            onPressed: () {
                              Get.to(() => const ShoppingListAddView(), transition: Transition.fade);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff26D156),
                              foregroundColor: Colors.white,
                              shadowColor: Colors.black,
                              elevation: 4.0,
                            ),
                            child: Text(AppLocalizations.of(context)?.add ?? "Add", style: const TextStyle(color: Colors.white, fontSize: 24),),
                          ),
                        ),
                        const SizedBox(width: 12,),
                        IconButton(
                          onPressed: () async{
                            //change shopping list
                          },
                          icon: const Icon(Icons.settings),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
