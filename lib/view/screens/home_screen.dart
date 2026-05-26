import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../controller/providers/inventory_provider.dart';
import '../../model/inventory_item_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(inventoryProvider);
    final suppliersAsync = ref.watch(suppliersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Offline Inventory Logger')),
      body: items.isEmpty
          ? const Center(child: Text('No inventory items'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return Dismissible(
                  key: Key(item.id.toString()),
                  background: Container(color: Colors.red),
                  onDismissed: (_) {
                    ref.read(inventoryProvider.notifier).deleteItem(item.id!);
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(item.itemName),
                      subtitle: Text(
                        '${item.supplier}\nQuantity: ${item.quantity}',
                      ),
                      trailing: Text(item.dateAdded),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) {
              final nameController = TextEditingController();
              final quantityController = TextEditingController();
              String? selectedSupplier;

              return Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Add Item', style: TextStyle(fontSize: 22)),
                      const SizedBox(height: 20),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Item Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      suppliersAsync.when(
                        data: (suppliers) {
                          return DropdownButtonFormField<String>(
                            items: suppliers.map((supplier) {
                              return DropdownMenuItem(
                                value: supplier.name,
                                child: Text(supplier.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              selectedSupplier = value;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Supplier',
                              border: OutlineInputBorder(),
                            ),
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (e, _) => const Text('Error loading suppliers'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
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
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
