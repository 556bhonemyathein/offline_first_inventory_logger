import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final Color confirmColor;
  final IconData icon;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.confirmColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      title: Row(
        children: [
          Icon(icon, color: confirmColor),
          const SizedBox(width: 10),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),

      content: Text(content, style: const TextStyle(fontSize: 15)),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },

          child: const Text("Cancel"),
        ),

        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: confirmColor),

          onPressed: () {
            Navigator.pop(context, true);
          },

          child: Text(confirmText),
        ),
      ],
    );
  }
}
