import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../controller/providers/inventory_provider.dart';
import '../../../model/inventory_item_model.dart';
import '../../../model/supplier_model.dart';

class AddItemBottomSheet extends StatefulWidget {
  final WidgetRef ref;
  final AsyncValue suppliersAsync;

  const AddItemBottomSheet({
    super.key,
    required this.ref,
    required this.suppliersAsync,
  });

  @override
  State<AddItemBottomSheet> createState() => _AddItemBottomSheetState();
}

class _AddItemBottomSheetState extends State<AddItemBottomSheet> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final quantityController = TextEditingController();

  String? selectedSupplier;

  bool isLoading = false;

  bool hasNetworkError = false;

  @override
  Widget build(BuildContext context) {
    final isSupplierLoading = widget.suppliersAsync.isLoading;

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
              /// TOP BAR
              Container(
                width: 60,
                height: 5,

                decoration: BoxDecoration(
                  color: Colors.grey.shade300,

                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 20),

              /// TITLE
              const Text(
                "Add Inventory Item",

                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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

              /// SUPPLIER DROPDOWN
              widget.suppliersAsync.when(
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
                        const Icon(Icons.wifi_off, size: 70, color: Colors.red),

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
                    backgroundColor: (hasNetworkError || isSupplierLoading)
                        ? Colors.grey
                        : Colors.black,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  onPressed: (isLoading || hasNetworkError || isSupplierLoading)
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

                              quantity: int.parse(quantityController.text),

                              dateAdded: DateFormat(
                                'MMM dd, yyyy • hh:mm a',
                              ).format(DateTime.now()),
                            );

                            await widget.ref
                                .read(inventoryProvider.notifier)
                                .addItem(item);

                            if (context.mounted) {
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Item Added Successfully"),
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
                      : const Text("Save Item", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
