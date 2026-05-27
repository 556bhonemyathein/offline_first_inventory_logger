import 'package:flutter/material.dart';

class EmptyInventoryWidget extends StatelessWidget {
  const EmptyInventoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Container(
            padding: const EdgeInsets.all(24),

            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),

            child: Icon(
              Icons.inventory_2_outlined,
              size: 70,
              color: Colors.blue.shade700,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "No Inventory Yet",

            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Text(
            "Tap + button to add inventory item",

            style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
