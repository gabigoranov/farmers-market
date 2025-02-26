import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:market/models/shopping_list_item.dart';
import 'package:market/services/shopping_list_service.dart';
import 'package:market/views/custom_shopping_item_screen.dart';
import '../components/shopping_list_item_component.dart';

class ShoppingListAddView extends StatefulWidget {
  const ShoppingListAddView({super.key});

  @override
  State<ShoppingListAddView> createState() => _ShoppingListAddViewState();
}

class _ShoppingListAddViewState extends State<ShoppingListAddView> {
  final List<ShoppingListItem> presets = ShoppingListService.instance.presets;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: false,
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            AppLocalizations.of(context)!.shopping_list_add,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section title for custom items
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
                child: Text(
                  AppLocalizations.of(context)?.add_item ?? 'Add Item',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),

              // Custom item button
              GestureDetector(
                onTap: () async {
                  await Get.to(
                        () => const CreateCustomShoppingListItemView(),
                    transition: Transition.rightToLeft,
                  );
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          CupertinoIcons.add,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        AppLocalizations.of(context)!.custom_item,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white70,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Section title for presets
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
                child: Text(
                  AppLocalizations.of(context)?.suggested_items ?? 'Suggested Items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),

              // Preset items list
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 4, bottom: 16),
                  itemCount: presets.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 6),
                  itemBuilder: (BuildContext context, int index) {
                    ShoppingListItem item = presets[index];

                    return ShoppingListItemComponent(
                      preset: item,
                      isAdded: false,
                      borderRadius: BorderRadius.circular(16),
                      hasBoxShadow: false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}