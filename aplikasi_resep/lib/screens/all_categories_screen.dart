import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';
import 'recipe_list_screen.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Semua Kategori')),
      body: Consumer<RecipeProvider>(
        builder: (context, provider, _) {
          final categories = provider.categories
              .where((cat) => cat != 'Semua')
              .toList();

          if (provider.isLoading && categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (categories.isEmpty) {
            return const Center(child: Text('Tidak ada kategori tersedia'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final icon = _getCategoryIcon(category);
              final color = _getCategoryColor(context, index);

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeListScreen(category: category),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: color.withOpacity(0.3), width: 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 48, color: color),
                      const SizedBox(height: 12),
                      Text(
                        category,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'beef':
        return Icons.fastfood;
      case 'chicken':
        return Icons.egg_alt;
      case 'dessert':
        return Icons.cake;
      case 'lamb':
        return Icons.dining;
      case 'miscellaneous':
        return Icons.restaurant;
      case 'pasta':
        return Icons.ramen_dining;
      case 'pork':
        return Icons.lunch_dining;
      case 'seafood':
        return Icons.set_meal;
      case 'side':
        return Icons.rice_bowl;
      case 'starter':
        return Icons.restaurant_menu;
      case 'vegan':
        return Icons.eco;
      case 'vegetarian':
        return Icons.spa;
      case 'breakfast':
        return Icons.free_breakfast;
      case 'goat':
        return Icons.cruelty_free;
      default:
        return Icons.restaurant;
    }
  }

  Color _getCategoryColor(BuildContext context, int index) {
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
      Colors.amber,
      Colors.cyan,
      Colors.lime,
      Colors.deepOrange,
    ];
    return colors[index % colors.length];
  }
}
