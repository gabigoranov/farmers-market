import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:market/models/shopping_list_item.dart';
import 'package:market/services/shopping_list_service.dart';
import 'package:market/views/create_custom_shopping_list_item_view.dart';

import '../components/shopping_list_item_add_component.dart';

class ShoppingListAddView extends StatefulWidget {
  const ShoppingListAddView({super.key});

  @override
  State<ShoppingListAddView> createState() => _ShoppingListAddViewState();
}

class _ShoppingListAddViewState extends State<ShoppingListAddView> {
  final List<ShoppingListItem> presets = ShoppingListService.instance.presets;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(alignment: Alignment.centerRight, child: Text(AppLocalizations.of(context)!.shopping_list_add, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),)),
        shadowColor: Colors.black87,
        elevation: 0.4,
        backgroundColor: Colors.white,
      ),
      body: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      CupertinoIcons.add,
                      size: 32,
                      color: Colors.white,
                    ),
                    Text(
                      AppLocalizations.of(context)!.custom_item,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
              onTap: () async {
                final result = await Get.to(() => const CreateCustomShoppingListItemView(), transition: Transition.fade);
                setState(() {

                });
              },
            ),
            const SizedBox(height: 12,),
            Expanded(
              child: ListView.builder(
                itemCount: presets.length,
                itemBuilder: (BuildContext context, int index) {
                  ShoppingListItem item = presets[index];
                  return ShoppingListItemAddComponent(preset: item,);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
