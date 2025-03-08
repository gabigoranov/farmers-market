import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/l10n/app_localizations.dart';
import '../models/shopping_list_item.dart';
import '../services/shopping_list_service.dart';

class CreateCustomShoppingListItemView extends StatefulWidget {
  const CreateCustomShoppingListItemView({super.key});

  @override
  State<CreateCustomShoppingListItemView> createState() => _CreateCustomShoppingListItemViewState();
}

class _CreateCustomShoppingListItemViewState extends State<CreateCustomShoppingListItemView> {
  late TextEditingController _titleController;
  late TextEditingController _quantityController;
  late String _type;
  late String _category;

  final _formKey = GlobalKey<FormState>();

  final Map<String, String> _typeToCategory = {
    'Apples': 'Fruits',
    'Carrots': 'Vegetables',
    'Steak': 'Meat',
    'Cheese': 'Dairy',
  };

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _quantityController = TextEditingController();
    _type = _typeToCategory.keys.first;
    _category = _typeToCategory[_type]!;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future _saveNewItem() async {
    if (_formKey.currentState!.validate()) {
      final newItem = ShoppingListItem(
        title: _titleController.text,
        category: _category,
        type: _type,
        quantity: double.parse(_quantityController.text),
      );

      await ShoppingListService.instance.addPreset(newItem);

      Get.back(result: newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(AppLocalizations.of(context)!.custom_item),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.title,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? AppLocalizations.of(context)!.title_required
                          : ShoppingListService.instance.isTitleUsed(value)
                          ? AppLocalizations.of(context)!.title_used
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.quantity,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.required;
                        }
                        final quantity = double.tryParse(value);
                        if (quantity == null || quantity <= 0) {
                          return AppLocalizations.of(context)!.invalid_quantity;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _type,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.product,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                items: _typeToCategory.keys.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _type = newValue;
                      _category = _typeToCategory[newValue]!;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveNewItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text(AppLocalizations.of(context)!.save),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
