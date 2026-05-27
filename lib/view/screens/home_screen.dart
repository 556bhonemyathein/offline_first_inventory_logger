import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/providers/inventory_provider.dart';

import '../widgets/custom/add_item_bottom_sheet.dart';
import '../widgets/custom/delete_confirm_dialog.dart';
import '../widgets/custom/edit_item_dialog.dart';
import '../widgets/custom/empty_inventory_widget.dart';
import '../widgets/custom/home_app_bar.dart';
import '../widgets/custom/inventory_item_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(inventoryProvider);
    final suppliersAsync = ref.watch(suppliersProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),

      appBar: const HomeAppBar(),

      body: items.isEmpty
          ? const EmptyInventoryWidget()
          : ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 100),

              itemCount: items.length,

              itemBuilder: (context, index) {
                final item = items[index];

                return InventoryItemCard(
                  item: item,

                  onEdit: () {
                    showDialog(
                      context: context,

                      builder: (_) {
                        return EditItemDialog(item: item);
                      },
                    );
                  },

                  onDelete: () async {
                    final confirm = await showDialog<bool>(
                      context: context,

                      builder: (_) {
                        return DeleteConfirmDialog(itemName: item.itemName);
                      },
                    );

                    if (confirm == true) {
                      await ref
                          .read(inventoryProvider.notifier)
                          .deleteItem(item.id!);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Item deleted successfully"),
                          ),
                        );
                      }
                    }
                  },
                );
              },
            ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,

        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,

            builder: (_) {
              return AddItemBottomSheet(
                ref: ref,
                suppliersAsync: suppliersAsync,
              );
            },
          );
        },

        icon: const Icon(Icons.add),
        label: const Text("Add Item"),
      ),
    );
  }
}
