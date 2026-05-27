import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../controller/providers/inventory_provider.dart';
import '../../model/inventory_item_model.dart';
import '../../model/supplier_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(inventoryProvider);
    final suppliersAsync = ref.watch(suppliersProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,

        title: const Text(
          'Inventory Logger',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: items.isEmpty
          ? const Center(
              child: Text('No inventory items', style: TextStyle(fontSize: 16)),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 100),

              itemCount: items.length,

              itemBuilder: (context, index) {
                final item = items[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),

                  child: Slidable(
                    key: Key(item.id.toString()),

                    /// LEFT = EDIT
                    startActionPane: ActionPane(
                      motion: const StretchMotion(),

                      children: [
                        SlidableAction(
                          onPressed: (_) {
                            showEditDialog(context, ref, item);
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
                      motion: const StretchMotion(),

                      children: [
                        SlidableAction(
                          onPressed: (_) async {
                            await ref
                                .read(inventoryProvider.notifier)
                                .deleteItem(item.id!);
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

                        borderRadius: BorderRadius.circular(22),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),

                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),

                        leading: Container(
                          width: 56,
                          height: 56,

                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,

                            borderRadius: BorderRadius.circular(16),
                          ),

                          child: const Icon(
                            Icons.inventory_2_outlined,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),

                        title: Text(
                          item.itemName,

                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                "Supplier: ${item.supplier}",
                                style: const TextStyle(fontSize: 14),
                              ),

                              const SizedBox(height: 6),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),

                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,

                                  borderRadius: BorderRadius.circular(20),
                                ),

                                child: Text(
                                  "Qty: ${item.quantity}",

                                  style: TextStyle(
                                    color: Colors.green.shade700,

                                    fontWeight: FontWeight.w600,
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
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey,
                            ),

                            const SizedBox(height: 4),

                            SizedBox(
                              width: 80,

                              child: Text(
                                item.dateAdded,
                                textAlign: TextAlign.end,

                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
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

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,

        onPressed: () {
          showAddBottomSheet(context, ref, suppliersAsync);
        },

        icon: const Icon(Icons.add),
        label: const Text("Add Item"),
      ),
    );
  }

  /// ADD ITEM BOTTOM SHEET
  void showAddBottomSheet(
    BuildContext context,
    WidgetRef ref,
    AsyncValue suppliersAsync,
  ) {
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController();
    final quantityController = TextEditingController();

    String? selectedSupplier;

    showModalBottomSheet(
      context: context,

      isScrollControlled: true,
      backgroundColor: Colors.transparent,

      builder: (_) {
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),

          decoration: const BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),

          child: SingleChildScrollView(
            child: Form(
              key: formKey,

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Container(
                    width: 50,
                    height: 5,

                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,

                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Add Inventory Item',

                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 24),

                  /// ITEM NAME
                  TextFormField(
                    controller: nameController,

                    decoration: InputDecoration(
                      labelText: 'Item Name',

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter item name';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  /// SUPPLIER
                  suppliersAsync.when(
                    data: (suppliers) {
                      return DropdownButtonFormField<String>(
                        value: selectedSupplier,

                        items: suppliers.map<DropdownMenuItem<String>>((
                          SupplierModel supplier,
                        ) {
                          return DropdownMenuItem<String>(
                            value: supplier.name,
                            child: Text(supplier.name),
                          );
                        }).toList(),

                        onChanged: (value) {
                          selectedSupplier = value;
                        },

                        decoration: InputDecoration(
                          labelText: 'Supplier',

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Select supplier';
                          }

                          return null;
                        },
                      );
                    },

                    loading: () =>
                        const Center(child: CircularProgressIndicator()),

                    error: (e, _) => Text(e.toString()),
                  ),

                  const SizedBox(height: 18),

                  /// QUANTITY
                  TextFormField(
                    controller: quantityController,

                    keyboardType: TextInputType.number,

                    decoration: InputDecoration(
                      labelText: 'Quantity',

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter quantity';
                      }

                      if (int.tryParse(value) == null) {
                        return 'Must be number';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      onPressed: () async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }

                        final item = InventoryItemModel(
                          itemName: nameController.text,

                          supplier: selectedSupplier ?? '',

                          quantity: int.parse(quantityController.text),

                          dateAdded: DateFormat(
                            'yyyy-MM-dd HH:mm',
                          ).format(DateTime.now()),
                        );

                        await ref
                            .read(inventoryProvider.notifier)
                            .addItem(item);

                        Navigator.pop(context);
                      },

                      child: const Text(
                        'Save Item',

                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// EDIT DIALOG
  void showEditDialog(
    BuildContext context,
    WidgetRef ref,
    InventoryItemModel item,
  ) {
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(text: item.itemName);

    final quantityController = TextEditingController(
      text: item.quantity.toString(),
    );

    showDialog(
      context: context,

      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),

          title: const Text("Edit Item"),

          content: Form(
            key: formKey,

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                TextFormField(
                  controller: nameController,

                  decoration: const InputDecoration(labelText: 'Item Name'),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter item name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: quantityController,

                  keyboardType: TextInputType.number,

                  decoration: const InputDecoration(labelText: 'Quantity'),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter quantity';
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
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                final updatedItem = InventoryItemModel(
                  id: item.id,

                  itemName: nameController.text,

                  supplier: item.supplier,

                  quantity: int.parse(quantityController.text),

                  dateAdded: item.dateAdded,
                );

                await ref
                    .read(inventoryProvider.notifier)
                    .updateItem(updatedItem);

                Navigator.pop(context);
              },

              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
