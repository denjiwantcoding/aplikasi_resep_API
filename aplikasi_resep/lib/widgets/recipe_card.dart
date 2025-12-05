import 'package:flutter/material.dart';

import '../models/recipe_model.dart';
import '../utils/image_helpers.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: SizedBox(
          width: 60,
          height: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: buildRecipeImage(recipe.imageUrl, fit: BoxFit.cover),
          ),
        ),
        title: Text(recipe.title),
        subtitle: Text(
          '${recipe.category} · ⭐ ${recipe.rating.toStringAsFixed(1)}',
        ),
        onTap: onTap,
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Theme.of(context).colorScheme.primary : null,
          ),
          onPressed: onFavoriteToggle,
          tooltip: isFavorite ? 'Hapus dari favorit' : 'Tambah ke favorit',
        ),
      ),
    );
  }
}
