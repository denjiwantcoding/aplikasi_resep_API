import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';
import '../widgets/search_bar.dart';
import 'recipe_detail_screen.dart';

class AllRecipesScreen extends StatefulWidget {
  const AllRecipesScreen({super.key});

  @override
  State<AllRecipesScreen> createState() => _AllRecipesScreenState();
}

class _AllRecipesScreenState extends State<AllRecipesScreen> {
  late final TextEditingController _searchController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      // Load all meals when screen opens
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<RecipeProvider>().loadAllMeals();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Semua Resep')),
      body: Consumer<RecipeProvider>(
        builder: (context, provider, _) {
          final recipes = provider.allRecipes;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: RecipeSearchBar(
                  controller: _searchController,
                  onChanged: (value) {
                    provider.setSearchQuery(value.trim());
                  },
                  onClear: () {
                    _searchController.clear();
                    provider.setSearchQuery('');
                  },
                ),
              ),
              if (provider.isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (recipes.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada resep ditemukan',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Coba kata kunci lain',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: recipes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      final isFavorite = provider.isFavorite(recipe);

                      return RecipeCard(
                        recipe: recipe,
                        isFavorite: isFavorite,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  RecipeDetailScreen(recipe: recipe),
                            ),
                          );
                        },
                        onFavoriteToggle: () {
                          provider.toggleFavorite(recipe);
                        },
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
