import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../model/inventory_item_model.dart';

class InventoryItemCard extends StatelessWidget {
  final InventoryItemModel item;

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const InventoryItemCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      child: Slidable(
        key: Key(item.id.toString()),

        startActionPane: ActionPane(
          motion: const DrawerMotion(),

          children: [
            SlidableAction(
              onPressed: (_) => onEdit(),

              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,

              icon: Icons.edit,
              label: 'Edit',

              borderRadius: BorderRadius.circular(20),
            ),
          ],
        ),

        endActionPane: ActionPane(
          motion: const DrawerMotion(),

          children: [
            SlidableAction(
              onPressed: (_) => onDelete(),

              backgroundColor: Colors.red,
              foregroundColor: Colors.white,

              icon: Icons.delete,
              label: 'Delete',

              borderRadius: BorderRadius.circular(20),
            ),
          ],
        ),

        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(24),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),

                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: ListTile(
            contentPadding: const EdgeInsets.all(18),

            leading: Container(
              width: 60,
              height: 60,

              decoration: BoxDecoration(
                color: Colors.blue.shade50,

                borderRadius: BorderRadius.circular(18),
              ),

              child: Icon(
                Icons.inventory_2_outlined,
                color: Colors.blue.shade700,
                size: 32,
              ),
            ),

            title: Text(
              item.itemName,

              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            subtitle: Padding(
              padding: const EdgeInsets.only(top: 10),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 16,
                        color: Colors.grey.shade700,
                      ),

                      const SizedBox(width: 5),

                      Expanded(
                        child: Text(
                          item.supplier,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.green.shade50,

                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: Text(
                      "Quantity : ${item.quantity}",

                      style: TextStyle(
                        color: Colors.green.shade700,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              crossAxisAlignment: CrossAxisAlignment.end,

              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),

                const SizedBox(height: 5),

                SizedBox(
                  width: 95,

                  child: Text(
                    item.dateAdded,

                    textAlign: TextAlign.end,

                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
