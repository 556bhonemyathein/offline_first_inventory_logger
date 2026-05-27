import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../model/inventory_item_model.dart';
import '../../model/supplier_model.dart';
import '../services/api_service.dart';
import '../services/db_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final dbServiceProvider = Provider<DBService>((ref) => DBService());

final suppliersProvider = FutureProvider<List<SupplierModel>>((ref) async {
  print("PROVIDER START");
  return ref.read(apiServiceProvider).fetchSuppliers();
});

final inventoryProvider =
    StateNotifierProvider<InventoryNotifier, List<InventoryItemModel>>((ref) {
      return InventoryNotifier(ref.read(dbServiceProvider));
    });

class InventoryNotifier extends StateNotifier<List<InventoryItemModel>> {
  final DBService dbService;

  InventoryNotifier(this.dbService) : super([]) {
    loadItems();
  }

  Future<void> loadItems() async {
    state = await dbService.getItems();
  }

  Future<void> addItem(InventoryItemModel item) async {
    await dbService.insertItem(item);
    await loadItems();
  }

  Future<void> updateItem(InventoryItemModel item) async {
    await dbService.updateItem(item);
    await loadItems();
  }

  Future<void> deleteItem(int id) async {
    await dbService.deleteItem(id);
    await loadItems();
  }
}
