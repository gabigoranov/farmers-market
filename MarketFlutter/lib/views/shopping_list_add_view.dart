import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShoppingListAddView extends StatefulWidget {
  const ShoppingListAddView({super.key});

  @override
  State<ShoppingListAddView> createState() => _ShoppingListAddViewState();
}

class _ShoppingListAddViewState extends State<ShoppingListAddView> {
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
    );
  }
}
