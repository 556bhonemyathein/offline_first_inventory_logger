class InventoryItemModel {
  final int? id;
  final String itemName;
  final String supplier;
  final int quantity;
  final String dateAdded;

  InventoryItemModel({
    this.id,
    required this.itemName,
    required this.supplier,
    required this.quantity,
    required this.dateAdded,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemName': itemName,
      'supplier': supplier,
      'quantity': quantity,
      'dateAdded': dateAdded,
    };
  }

  factory InventoryItemModel.fromMap(Map<String, dynamic> map) {
    return InventoryItemModel(
      id: map['id'],
      itemName: map['itemName'],
      supplier: map['supplier'],
      quantity: map['quantity'],
      dateAdded: map['dateAdded'],
    );
  }
}
