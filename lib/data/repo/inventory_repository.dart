import '../../model/inventory_item_model.dart';
import '../services/db_service.dart';

class InventoryRepository {
  final DBService dbService;

  InventoryRepository(this.dbService);

  Future<void> addItem(InventoryItemModel item) async {
    await dbService.insertItem(item);
  }

  Future<List<InventoryItemModel>> getItems() async {
    return await dbService.getItems();
  }

  Future<void> updateItem(InventoryItemModel item) async {
    await dbService.updateItem(item);
  }

  Future<void> deleteItem(int id) async {
    await dbService.deleteItem(id);
  }
}
