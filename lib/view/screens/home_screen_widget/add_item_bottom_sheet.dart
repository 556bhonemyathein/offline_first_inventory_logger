import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../controller/providers/inventory_provider.dart';
import '../../../model/inventory_item_model.dart';
import '../../../model/supplier_model.dart';

import '../const/app_color.dart';
import '../const/app_spacing.dart';
import 'custom_text_field.dart';

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
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        top: AppSpacing.screenPadding,
        bottom:
            MediaQuery.of(context).viewInsets.bottom + AppSpacing.screenPadding,
      ),

      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.largeRadius),
        ),
      ),

      child: SingleChildScrollView(
        child: Form(
          key: _formKey,

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              _buildTopBar(),

              const SizedBox(height: AppSpacing.large),

              _buildTitle(),

              const SizedBox(height: AppSpacing.extraLarge),

              /// ITEM NAME
              CustomTextField(
                controller: _nameController,
                label: 'Item Name',
                icon: Icons.inventory,

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Item name required';
                  }

                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.medium),

              /// SUPPLIER
              _buildSupplierDropdown(),

              const SizedBox(height: AppSpacing.medium),

              /// QUANTITY
              CustomTextField(
                controller: _quantityController,
                label: 'Quantity',
                icon: Icons.numbers,
                keyboardType: TextInputType.number,

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

              const SizedBox(height: AppSpacing.large),

              /// SAVE BUTTON
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
        color: AppColors.grey.shade300,
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

  /// SUPPLIER DROPDOWN
  Widget _buildSupplierDropdown() {
    return widget.suppliersAsync.when(
      data: (suppliers) {
        _hasNetworkError = false;

        final supplierList = suppliers as List<SupplierModel>;

        return DropdownButtonFormField<String>(
          value: _selectedSupplier,

          decoration: InputDecoration(
            labelText: 'Supplier',

            prefixIcon: const Icon(Icons.person_outline),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.mediumRadius),
            ),
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
        padding: EdgeInsets.all(AppSpacing.medium),
        child: CircularProgressIndicator(),
      ),

      error: (e, _) {
        _hasNetworkError = true;

        return _buildNetworkError();
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
              ? AppColors.grey
              : AppColors.primary,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.mediumRadius),
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
                  color: AppColors.white,
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
        itemName: _nameController.text.trim(),

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

      padding: const EdgeInsets.all(AppSpacing.screenPadding),

      decoration: BoxDecoration(
        color: AppColors.red.shade50,

        borderRadius: BorderRadius.circular(AppSpacing.mediumRadius),

        border: Border.all(color: AppColors.red.shade200),
      ),

      child: Column(
        children: [
          const Icon(Icons.wifi_off, size: 70, color: AppColors.red),

          const SizedBox(height: AppSpacing.medium),

          const Text(
            "No Internet Connection",

            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: AppSpacing.small),

          Text(
            "Reconnect internet and try again.\nOr use VPN if available.",

            textAlign: TextAlign.center,

            style: TextStyle(color: AppColors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
