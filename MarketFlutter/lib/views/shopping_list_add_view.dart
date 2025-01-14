import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:market/components/shopping_list_item_component.dart';
import 'package:market/models/shopping_list_item.dart';
import 'package:market/services/shopping_list_service.dart';

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
