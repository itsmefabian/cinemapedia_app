import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const new({super.key, required this.navigationShell});

  static const _branchByItemIndex = <int, int>{0: 0, 2: 1};

  void onItemTap(BuildContext context, int index) {
    final branchIndex = _branchByItemIndex[index];
    if (branchIndex == null) return;

    navigationShell.goBranch(
      branchIndex,
      initialLocation: branchIndex == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentItemIndex = _branchByItemIndex.entries
        .firstWhere((entry) => entry.value == navigationShell.currentIndex)
        .key;

    return BottomNavigationBar(
      elevation: 0,
      currentIndex: currentItemIndex,
      onTap: (index) => onItemTap(context, index),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_max), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.label_outline),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outlined),
          label: 'Favorites',
        ),
      ],
    );
  }
}
