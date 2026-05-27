import 'package:flutter/material.dart';

import '../const/app_color.dart';

class DeleteConfirmDialog extends StatelessWidget {
  final String itemName;

  const DeleteConfirmDialog({super.key, required this.itemName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      title: const Text("Delete Item"),

      content: Text("Are you sure you want to delete '$itemName' ?"),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },

          child: const Text("Cancel"),
        ),

        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),

          onPressed: () {
            Navigator.pop(context, true);
          },

          child: const Text("Delete"),
        ),
      ],
    );
  }
}
