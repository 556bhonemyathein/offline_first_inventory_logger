import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/providers/inventory_provider.dart';
import '../../../model/inventory_item_model.dart';
import '../../widgets/custom/custom_confirm_dialog.dart';
import '../../widgets/const/app_color.dart';
import '../../widgets/custom/custom_snackbar.dart';

class EditItemDialog extends ConsumerStatefulWidget {
  final InventoryItemModel item;

  const EditItemDialog({super.key, required this.item});

  @override
  ConsumerState<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends ConsumerState<EditItemDialog> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;

  late TextEditingController _quantityController;

  bool isUpdating = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.item.itemName);

    _quantityController = TextEditingController(
      text: widget.item.quantity.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),

      title: const Text("Edit Inventory"),

      content: Form(
        key: formKey,

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            /// ITEM NAME
            TextFormField(
              controller: _nameController,

              decoration: const InputDecoration(labelText: 'Item Name'),

              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Required';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            /// QUANTITY
            TextFormField(
              controller: _quantityController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(labelText: 'Quantity'),

              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Required';
                }

                if (int.tryParse(value) == null) {
                  return 'Must be number';
                }

                return null;
              },
            ),
          ],
        ),
      ),

      actions: [
        /// CANCEL
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },

          child: const Text("Cancel"),
        ),

        /// UPDATE
        ElevatedButton(
          onPressed: isUpdating
              ? null
              : () async {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }

                  final confirm = await showDialog<bool>(
                    context: context,

                    builder: (_) => const CustomConfirmDialog(
                      title: "Update Item",

                      content: "Are you sure you want to update this item?",

                      confirmText: "Update",

                      confirmColor: AppColors.primary,
                      icon: Icons.edit,
                    ),
                  );

                  if (confirm != true) {
                    return;
                  }

                  setState(() {
                    isUpdating = true;
                  });

                  try {
                    final updatedItem = InventoryItemModel(
                      id: widget.item.id,

                      itemName: _nameController.text,

                      supplier: widget.item.supplier,

                      quantity: int.parse(_quantityController.text),

                      dateAdded: widget.item.dateAdded,
                    );

                    await ref
                        .read(inventoryProvider.notifier)
                        .updateItem(updatedItem);

                    if (context.mounted) {
                      Navigator.pop(context);
                      CustomSnackbar.show(
                        context,
                        message: "Item Updated Successfully",
                        color: Colors.green,
                      );
                    }
                  } finally {
                    if (mounted) {
                      setState(() {
                        isUpdating = false;
                      });
                    }
                  }
                },

          child: isUpdating
              ? const SizedBox(
                  width: 18,
                  height: 18,

                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : const Text("Update"),
        ),
      ],
    );
  }
}
