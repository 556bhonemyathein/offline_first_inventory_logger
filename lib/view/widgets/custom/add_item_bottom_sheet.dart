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
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();

  String? _selectedSupplier;

  bool _isLoading = false;
  bool _hasNetworkError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

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
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTopBar(),
              const SizedBox(height: 20),

              _buildTitle(),
              const SizedBox(height: 25),

              _buildNameField(),
              const SizedBox(height: 18),

              _buildSupplierDropdown(),
              const SizedBox(height: 18),

              _buildQuantityField(),
              const SizedBox(height: 28),

              _buildSaveButton(isSupplierLoading),
            ],
          ),
        ),
      ),
    );
  }

  /// TOP BAR
  Widget _buildTopBar() {
    return Container(
      width: 60,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  /// TITLE
  Widget _buildTitle() {
    return const Text(
      "Add Inventory Item",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  /// ITEM NAME
  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: _inputDecoration(label: 'Item Name', icon: Icons.inventory),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Item name required';
        }
        return null;
      },
    );
  }

  /// SUPPLIER
  Widget _buildSupplierDropdown() {
    return widget.suppliersAsync.when(
      data: (suppliers) {
        _hasNetworkError = false;

        final supplierList = suppliers as List<SupplierModel>;

        return DropdownButtonFormField<String>(
          value: _selectedSupplier,
          decoration: _inputDecoration(
            label: 'Supplier',
            icon: Icons.person_outline,
          ),
          items: supplierList.map<DropdownMenuItem<String>>((supplier) {
            return DropdownMenuItem(
              value: supplier.name,
              child: Text(supplier.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedSupplier = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Select supplier';
            }
            return null;
          },
        );
      },

      loading: () => const Padding(
        padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(),
      ),

      error: (e, _) {
        _hasNetworkError = true;

        return _buildNetworkError();
      },
    );
  }

  /// QUANTITY
  Widget _buildQuantityField() {
    return TextFormField(
      controller: _quantityController,
      keyboardType: TextInputType.number,
      decoration: _inputDecoration(label: 'Quantity', icon: Icons.numbers),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Quantity required';
        }

        if (int.tryParse(value) == null) {
          return 'Must be number';
        }

        return null;
      },
    );
  }

  /// SAVE BUTTON
  Widget _buildSaveButton(bool isSupplierLoading) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: (_hasNetworkError || isSupplierLoading)
              ? Colors.grey
              : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: (_isLoading || _hasNetworkError || isSupplierLoading)
            ? null
            : _saveItem,
        child: _isLoading
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
    );
  }

  /// SAVE ITEM
  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final item = InventoryItemModel(
        itemName: _nameController.text,
        supplier: _selectedSupplier ?? '',
        quantity: int.parse(_quantityController.text),
        dateAdded: DateFormat('MMM dd, yyyy • hh:mm a').format(DateTime.now()),
      );

      await widget.ref.read(inventoryProvider.notifier).addItem(item);

      if (mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Item Added Successfully")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// NETWORK ERROR
  Widget _buildNetworkError() {
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Text(
            "Reconnect internet and try again.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  /// INPUT DECORATION
  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
    );
  }
}
