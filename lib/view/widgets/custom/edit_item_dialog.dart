import 'package:flutter/material.dart';

class EditItemDialog extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController quantityController;
  final VoidCallback onUpdate;

  const EditItemDialog({
    super.key,
    required this.nameController,
    required this.quantityController,
    required this.onUpdate,
  });

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  final formKey = GlobalKey<FormState>();

  bool isUpdating = false;

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
            TextFormField(
              controller: widget.nameController,

              decoration: const InputDecoration(labelText: 'Item Name'),

              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Required';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: widget.quantityController,

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
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },

          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed: isUpdating
              ? null
              : () async {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }

                  setState(() {
                    isUpdating = true;
                  });

                  await Future.delayed(const Duration(milliseconds: 300));

                  widget.onUpdate();

                  if (mounted) {
                    setState(() {
                      isUpdating = false;
                    });
                  }
                },

          child: isUpdating
              ? const SizedBox(
                  width: 18,
                  height: 18,

                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text("Update"),
        ),
      ],
    );
  }
}
