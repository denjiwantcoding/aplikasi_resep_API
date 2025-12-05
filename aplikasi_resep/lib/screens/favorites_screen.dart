import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (context, provider, _) {
        if (provider.favorites.isEmpty) {
          return const Center(child: Text('Belum ada resep favorit.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: provider.favorites.length,
          itemBuilder: (context, index) {
            final recipe = provider.favorites[index];
            return RecipeCard(
              recipe: recipe,
              isFavorite: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailScreen(recipe: recipe),
                  ),
                );
              },
              onFavoriteToggle: () => provider.toggleFavorite(recipe),
            );
          },
        );
      },
    );
  }
}
