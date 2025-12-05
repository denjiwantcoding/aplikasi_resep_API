import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe_model.dart';
import '../providers/recipe_provider.dart';
import '../utils/image_helpers.dart';
import '../widgets/category_card.dart';
import '../widgets/recipe_card.dart';
import '../widgets/search_bar.dart';
import 'all_categories_screen.dart';
import 'all_recipes_screen.dart';
import 'favorites_screen.dart';
import 'recipe_detail_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  String? _titleForIndex(int index) {
    switch (index) {
      case 1:
        return 'Resep Favorit';
      case 2:
        return 'Pengaturan';
      default:
        return null;
    }
  }

  Widget _pageForIndex(int index) {
    switch (index) {
      case 1:
        return const FavoritesScreen();
      case 2:
        return SettingsScreen(
          isDarkMode: widget.isDarkMode,
          onThemeChanged: widget.onThemeChanged,
        );
      default:
        return const HomeDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHome = _selectedIndex == 0;
    final title = _titleForIndex(_selectedIndex);

    return Scaffold(
      appBar: isHome || title == null ? null : AppBar(title: Text(title)),
      body: _pageForIndex(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final initialQuery = context.read<RecipeProvider>().searchQuery;
    _searchController = TextEditingController(text: initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openRecipeDetail(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<RecipeProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.allRecipes.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final categories = provider.categories;
        final popularRecipes = provider.popularRecipes.take(3).toList();
        final filteredRecipes = provider.filteredRecipes;
        final hasFilters =
            provider.searchQuery.isNotEmpty ||
            provider.selectedCategory != 'Semua';
        final resultsTitle = provider.searchQuery.isNotEmpty
            ? 'Hasil untuk "${provider.searchQuery}"'
            : provider.selectedCategory == 'Semua'
            ? 'Semua Resep'
            : 'Resep ${provider.selectedCategory}';

        return SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📚 Buku Resep Modern',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Temukan inspirasi masakan terbaik setiap hari.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                RecipeSearchBar(
                  controller: _searchController,
                  onChanged: (value) => context
                      .read<RecipeProvider>()
                      .setSearchQuery(value.trim()),
                  onClear: () =>
                      context.read<RecipeProvider>().setSearchQuery(''),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AllRecipesScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.restaurant_menu),
                        label: const Text('Semua Resep'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AllCategoriesScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.category),
                        label: const Text('Semua Kategori'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (categories.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kategori Resep',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AllCategoriesScreen(),
                            ),
                          );
                        },
                        child: const Text('Lihat semua'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 60,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected =
                            category == provider.selectedCategory;
                        return CategoryCard(
                          label: category,
                          isSelected: isSelected,
                          onTap: () => context
                              .read<RecipeProvider>()
                              .setCategory(category),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemCount: categories.length,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                if (popularRecipes.isNotEmpty) ...[
                  Text(
                    'Resep Terpopuler',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _FeaturedRecipeCard(
                    recipe: popularRecipes.first,
                    onTap: () => _openRecipeDetail(popularRecipes.first),
                  ),
                  const SizedBox(height: 12),
                  if (popularRecipes.length > 1)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: popularRecipes.length - 1,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final recipe = popularRecipes[index + 1];
                        final isFavorite = provider.isFavorite(recipe);
                        return RecipeCard(
                          recipe: recipe,
                          isFavorite: isFavorite,
                          onTap: () => _openRecipeDetail(recipe),
                          onFavoriteToggle: () => context
                              .read<RecipeProvider>()
                              .toggleFavorite(recipe),
                        );
                      },
                    ),
                  const SizedBox(height: 24),
                ],
                Text(
                  hasFilters ? resultsTitle : 'Semua Resep',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                if (filteredRecipes.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 42,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Resep tidak ditemukan',
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Coba ubah kata kunci atau pilih kategori lain.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredRecipes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];
                      final isFavorite = provider.isFavorite(recipe);
                      return RecipeCard(
                        recipe: recipe,
                        isFavorite: isFavorite,
                        onTap: () => _openRecipeDetail(recipe),
                        onFavoriteToggle: () => context
                            .read<RecipeProvider>()
                            .toggleFavorite(recipe),
                      );
                    },
                  ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FeaturedRecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const _FeaturedRecipeCard({required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: buildRecipeImage(recipe.imageUrl, fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.05),
                      Colors.black.withValues(alpha: 0.65),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rate_rounded,
                      color: theme.colorScheme.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      recipe.rating.toStringAsFixed(1),
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.category,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    recipe.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
