import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../model/inventory_item_model.dart';

class DBService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'inventory.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE inventory(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            itemName TEXT,
            supplier TEXT,
            quantity INTEGER,
            dateAdded TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertItem(InventoryItemModel item) async {
    final db = await database;
    await db.insert('inventory', item.toMap());
  }

  Future<List<InventoryItemModel>> getItems() async {
    final db = await database;
    final maps = await db.query('inventory');

    return maps.map((e) => InventoryItemModel.fromMap(e)).toList();
  }

  Future<void> updateItem(InventoryItemModel item) async {
    final db = await database;

    await db.update(
      'inventory',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteItem(int id) async {
    final db = await database;

    await db.delete('inventory', where: 'id = ?', whereArgs: [id]);
  }
}
