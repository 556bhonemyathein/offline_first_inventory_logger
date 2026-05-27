import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../controller/providers/inventory_provider.dart';
import '../widgets/custom/add_item_bottom_sheet.dart';
import '../widgets/custom/delete_confirm_dialog.dart';
import '../widgets/custom/edit_item_dialog.dart';
import '../widgets/custom/empty_inventory_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(inventoryProvider);
    final suppliersAsync = ref.watch(suppliersProvider);
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,

        title: const Text(
          'Offline First Inventory Logger',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      /// BODY
      body: items.isEmpty
          ? const EmptyInventoryWidget()
          : ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 100),

              itemCount: items.length,

              itemBuilder: (context, index) {
                final item = items[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),

                  child: Slidable(
                    key: Key(item.id.toString()),

                    /// LEFT = EDIT
                    startActionPane: ActionPane(
                      motion: const DrawerMotion(),

                      children: [
                        SlidableAction(
                          onPressed: (_) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return EditItemDialog(item: item);
                              },
                            );
                          },

                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,

                          icon: Icons.edit,
                          label: 'Edit',

                          borderRadius: BorderRadius.circular(20),
                        ),
                      ],
                    ),

                    /// RIGHT = DELETE
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),

                      children: [
                        SlidableAction(
                          onPressed: (_) async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return DeleteConfirmDialog(
                                  itemName: item.itemName,
                                );
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

                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                      ),
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
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),

                            const SizedBox(height: 5),

                            SizedBox(
                              width: 95,

                              child: Text(
                                item.dateAdded,

                                textAlign: TextAlign.end,

                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

      /// FAB
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,

        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
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
