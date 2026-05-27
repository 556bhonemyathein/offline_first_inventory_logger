import 'package:flutter/material.dart';

import '../../widgets/const/app_color.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.white,
      centerTitle: true,

      title: const Text(
        'Offline First Inventory Logger',

        style: TextStyle(color: AppColors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
