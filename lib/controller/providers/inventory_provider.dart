import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/repo/inventory_repository.dart';

import '../../data/services/api_service.dart';
import '../../data/services/db_service.dart';

import '../../model/inventory_item_model.dart';
import '../../model/supplier_model.dart';

/// API SERVICE PROVIDER
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

/// DATABASE SERVICE PROVIDER
final dbServiceProvider = Provider<DBService>((ref) {
  return DBService();
});

/// REPOSITORY PROVIDER
final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepository(ref.read(dbServiceProvider));
});

/// SUPPLIERS PROVIDER
final suppliersProvider = FutureProvider<List<SupplierModel>>((ref) async {
  return ref.read(apiServiceProvider).fetchSuppliers();
});

/// INVENTORY PROVIDER
final inventoryProvider =
    StateNotifierProvider<InventoryNotifier, List<InventoryItemModel>>((ref) {
      return InventoryNotifier(ref.read(inventoryRepositoryProvider));
    });

/// INVENTORY NOTIFIER
class InventoryNotifier extends StateNotifier<List<InventoryItemModel>> {
  final InventoryRepository repository;

  InventoryNotifier(this.repository) : super([]) {
    loadItems();
  }

  /// LOAD ITEMS
  Future<void> loadItems() async {
    state = await repository.getItems();
  }

  /// ADD ITEM
  Future<void> addItem(InventoryItemModel item) async {
    await repository.addItem(item);

    await loadItems();
  }

  /// UPDATE ITEM
  Future<void> updateItem(InventoryItemModel item) async {
    await repository.updateItem(item);

    await loadItems();
  }

  /// DELETE ITEM
  Future<void> deleteItem(int id) async {
    await repository.deleteItem(id);

    await loadItems();
  }
}
