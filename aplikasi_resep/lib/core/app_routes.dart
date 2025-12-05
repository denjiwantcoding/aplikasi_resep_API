import 'package:flutter/material.dart';

import '../models/recipe_model.dart';
import '../screens/favorites_screen.dart';
import '../screens/recipe_detail_screen.dart';
import '../screens/recipe_list_screen.dart';
import '../screens/settings_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/list': (context) {
      final category = ModalRoute.of(context)?.settings.arguments as String?;
      return RecipeListScreen(category: category ?? 'Semua');
    },
    '/detail': (context) {
      final recipe = ModalRoute.of(context)?.settings.arguments as Recipe?;
      if (recipe == null) {
        return const Scaffold(
          body: Center(child: Text('Resep tidak ditemukan')),
        );
      }
      return RecipeDetailScreen(recipe: recipe);
    },
    '/favorites': (context) => const FavoritesScreen(),
    '/settings': (context) => const SettingsScreen(),
  };
}
