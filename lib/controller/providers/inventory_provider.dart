import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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

/// SUPPLIERS PROVIDER
final suppliersProvider = FutureProvider<List<SupplierModel>>((ref) async {
  return ref.read(apiServiceProvider).fetchSuppliers();
});

/// INVENTORY PROVIDER
final inventoryProvider =
    StateNotifierProvider<InventoryNotifier, List<InventoryItemModel>>((ref) {
      final dbService = ref.read(dbServiceProvider);

      return InventoryNotifier(dbService);
    });

/// INVENTORY NOTIFIER
class InventoryNotifier extends StateNotifier<List<InventoryItemModel>> {
  final DBService _dbService;

  InventoryNotifier(this._dbService) : super([]) {
    loadItems();
  }

  /// LOAD ITEMS
  Future<void> loadItems() async {
    final items = await _dbService.getItems();

    state = items;
  }

  /// ADD ITEM
  Future<void> addItem(InventoryItemModel item) async {
    await _dbService.insertItem(item);

    await loadItems();
  }

  /// UPDATE ITEM
  Future<void> updateItem(InventoryItemModel item) async {
    await _dbService.updateItem(item);

    await loadItems();
  }

  /// DELETE ITEM
  Future<void> deleteItem(int id) async {
    await _dbService.deleteItem(id);

    await loadItems();
  }
}
