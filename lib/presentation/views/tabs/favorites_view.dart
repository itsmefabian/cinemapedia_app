import 'package:flutter/material.dart';

class FavoritesView extends StatelessWidget {
  const new({super.key});

  static const name = 'favorites-view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites movies')),
      body: const Center(child: Text('My favorite movies')),
    );
  }
}
