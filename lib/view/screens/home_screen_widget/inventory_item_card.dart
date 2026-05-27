import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../model/inventory_item_model.dart';
import '../../widgets/const/app_color.dart';
import '../../widgets/const/app_spacing.dart';

class InventoryItemCard extends StatelessWidget {
  final InventoryItemModel item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const InventoryItemCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  static const double _cardRadius = 24;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.small,
      ),

      child: Slidable(
        key: Key(item.id.toString()),

        startActionPane: ActionPane(
          motion: const DrawerMotion(),

          children: [_buildEditAction()],
        ),

        endActionPane: ActionPane(
          motion: const DrawerMotion(),

          children: [_buildDeleteAction()],
        ),

        child: Container(
          decoration: _cardDecoration(),

          child: ListTile(
            contentPadding: const EdgeInsets.all(AppSpacing.medium),

            leading: _buildLeadingIcon(),

            title: _buildTitle(),

            subtitle: _buildSubtitle(),

            trailing: _buildDateSection(),
          ),
        ),
      ),
    );
  }

  /// EDIT ACTION
  Widget _buildEditAction() {
    return SlidableAction(
      onPressed: (_) => onEdit(),

      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,

      icon: Icons.edit,
      label: 'Edit',

      borderRadius: BorderRadius.circular(AppSpacing.mediumRadius),
    );
  }

  /// DELETE ACTION
  Widget _buildDeleteAction() {
    return SlidableAction(
      onPressed: (_) => onDelete(),

      backgroundColor: AppColors.red,
      foregroundColor: AppColors.white,

      icon: Icons.delete,
      label: 'Delete',

      borderRadius: BorderRadius.circular(AppSpacing.mediumRadius),
    );
  }

  /// CARD DECORATION
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.white,

      borderRadius: BorderRadius.circular(_cardRadius),

      boxShadow: [
        BoxShadow(
          color: AppColors.grey,

          blurRadius: 12,

          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// LEADING ICON
  Widget _buildLeadingIcon() {
    return Container(
      width: 60,
      height: 60,

      decoration: BoxDecoration(
        color: AppColors.blue.shade50,

        borderRadius: BorderRadius.circular(AppSpacing.mediumRadius),
      ),

      child: Icon(
        Icons.inventory_2_outlined,
        color: AppColors.blue.shade700,
        size: 32,
      ),
    );
  }

  /// TITLE
  Widget _buildTitle() {
    return Text(
      item.itemName,

      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  /// SUBTITLE
  Widget _buildSubtitle() {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.small),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          _buildSupplierRow(),

          const SizedBox(height: AppSpacing.small),

          _buildQuantityBadge(),
        ],
      ),
    );
  }

  /// SUPPLIER ROW
  Widget _buildSupplierRow() {
    return Row(
      children: [
        Icon(Icons.person_outline, size: 16, color: AppColors.grey.shade700),

        const SizedBox(width: 5),

        Expanded(
          child: Text(
            item.supplier,

            style: TextStyle(color: AppColors.grey.shade700),
          ),
        ),
      ],
    );
  }

  /// QUANTITY BADGE
  Widget _buildQuantityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      decoration: BoxDecoration(
        color: Colors.green.shade50,

        borderRadius: BorderRadius.circular(AppSpacing.largeRadius),
      ),

      child: Text(
        "Quantity : ${item.quantity}",

        style: TextStyle(
          color: Colors.green.shade700,

          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// DATE SECTION
  Widget _buildDateSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      crossAxisAlignment: CrossAxisAlignment.end,

      children: [
        Icon(Icons.access_time, size: 16, color: AppColors.grey.shade600),

        const SizedBox(height: 5),

        SizedBox(
          width: 95,

          child: Text(
            item.dateAdded,

            textAlign: TextAlign.end,

            style: TextStyle(fontSize: 11, color: AppColors.grey.shade600),
          ),
        ),
      ],
    );
  }
}
