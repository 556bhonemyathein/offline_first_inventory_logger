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
          ? _buildEmptyState()
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
                            _showEditDialog(context, ref, item);
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
                            await ref
                                .read(inventoryProvider.notifier)
                                .deleteItem(item.id!);

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Item deleted")),
                              );
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
          _showAddBottomSheet(context, ref, suppliersAsync);
        },

        icon: const Icon(Icons.add),
        label: const Text("Add Item"),
      ),
    );
  }

  /// EMPTY STATE
  Widget _buildEmptyState() {
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

  /// ADD ITEM
  void _showAddBottomSheet(
    BuildContext context,
    WidgetRef ref,
    AsyncValue suppliersAsync,
  ) {
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController();

    final quantityController = TextEditingController();

    String? selectedSupplier;

    bool isLoading = false;
    bool hasNetworkError = false;

    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      backgroundColor: Colors.transparent,

      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final isSupplierLoading = suppliersAsync.isLoading;

            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),

              decoration: const BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),

              child: SingleChildScrollView(
                child: Form(
                  key: formKey,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Container(
                        width: 60,
                        height: 5,

                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,

                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Add Inventory Item",

                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 25),

                      /// ITEM NAME
                      TextFormField(
                        controller: nameController,

                        decoration: InputDecoration(
                          labelText: 'Item Name',

                          prefixIcon: const Icon(Icons.inventory),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Item name required';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      /// SUPPLIER
                      suppliersAsync.when(
                        data: (suppliers) {
                          hasNetworkError = false;

                          final supplierList = suppliers as List<SupplierModel>;

                          return DropdownButtonFormField<String>(
                            value: selectedSupplier,

                            items: supplierList.map<DropdownMenuItem<String>>((
                              supplier,
                            ) {
                              return DropdownMenuItem(
                                value: supplier.name,
                                child: Text(supplier.name),
                              );
                            }).toList(),

                            onChanged: (value) {
                              setState(() {
                                selectedSupplier = value;
                              });
                            },

                            decoration: InputDecoration(
                              labelText: 'Supplier',

                              prefixIcon: const Icon(Icons.person_outline),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
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

                        loading: () => Container(
                          height: 70,
                          alignment: Alignment.center,

                          child: const CircularProgressIndicator(),
                        ),

                        error: (e, _) {
                          hasNetworkError = true;

                          return Container(
                            width: double.infinity,

                            padding: const EdgeInsets.all(20),

                            decoration: BoxDecoration(
                              color: Colors.red.shade50,

                              borderRadius: BorderRadius.circular(20),

                              border: Border.all(color: Colors.red.shade200),
                            ),

                            child: Column(
                              children: [
                                const Icon(
                                  Icons.wifi_off,
                                  size: 70,
                                  color: Colors.red,
                                ),

                                const SizedBox(height: 16),

                                const Text(
                                  "No Internet Connection",

                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  "Reconnect internet and try again.",

                                  textAlign: TextAlign.center,

                                  style: TextStyle(color: Colors.grey.shade700),
                                ),

                                const SizedBox(height: 16),

                                Text(
                                  "Try VPN or Airplane Mode ON/OFF",

                                  textAlign: TextAlign.center,

                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 18),

                      /// QUANTITY
                      TextFormField(
                        controller: quantityController,

                        keyboardType: TextInputType.number,

                        decoration: InputDecoration(
                          labelText: 'Quantity',

                          prefixIcon: const Icon(Icons.numbers),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Quantity required';
                          }

                          if (int.tryParse(value) == null) {
                            return 'Must be number';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 28),

                      /// SAVE BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 58,

                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                (hasNetworkError || isSupplierLoading)
                                ? Colors.grey
                                : Colors.black,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),

                          onPressed:
                              (isLoading ||
                                  hasNetworkError ||
                                  isSupplierLoading)
                              ? null
                              : () async {
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  }

                                  setState(() {
                                    isLoading = true;
                                  });

                                  try {
                                    final item = InventoryItemModel(
                                      itemName: nameController.text,

                                      supplier: selectedSupplier ?? '',

                                      quantity: int.parse(
                                        quantityController.text,
                                      ),

                                      dateAdded: DateFormat(
                                        'MMM dd, yyyy • hh:mm a',
                                      ).format(DateTime.now()),
                                    );

                                    await ref
                                        .read(inventoryProvider.notifier)
                                        .addItem(item);

                                    if (context.mounted) {
                                      Navigator.pop(context);

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Item Added Successfully",
                                          ),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Error: $e")),
                                    );
                                  } finally {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },

                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,

                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Save Item",

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
      },
    );
  }

  /// EDIT
  void _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    InventoryItemModel item,
  ) {
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(text: item.itemName);

    final quantityController = TextEditingController(
      text: item.quantity.toString(),
    );

    bool isUpdating = false;

    showDialog(
      context: context,

      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),

              title: const Text("Edit Inventory"),

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
                          return 'Required';
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

                          try {
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

                            if (context.mounted) {
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Item Updated")),
                              );
                            }
                          } finally {
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
          },
        );
      },
    );
  }
}
