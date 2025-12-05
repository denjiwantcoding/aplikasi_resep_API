import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/recipe_model.dart';
import '../providers/recipe_provider.dart';
import '../utils/image_helpers.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Recipe? _fullRecipe;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFullRecipe();
  }

  Future<void> _loadFullRecipe() async {
    // If recipe already has ingredients, no need to load
    if (widget.recipe.ingredients.isNotEmpty) {
      setState(() => _fullRecipe = widget.recipe);
      return;
    }

    setState(() => _isLoading = true);

    final provider = context.read<RecipeProvider>();
    final recipe = await provider.getRecipeById(widget.recipe.id);

    setState(() {
      _fullRecipe = recipe ?? widget.recipe;
      _isLoading = false;
    });
  }

  Future<void> _launchYouTube(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipe = _fullRecipe ?? widget.recipe;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        actions: [
          Consumer<RecipeProvider>(
            builder: (context, provider, _) {
              final isFavorite = provider.isFavorite(recipe);
              return IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () => provider.toggleFavorite(recipe),
                tooltip: isFavorite
                    ? 'Hapus dari favorit'
                    : 'Tambah ke favorit',
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: buildRecipeImage(
                      recipe.imageUrl,
                      height: 220,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Chip(
                        label: Text(recipe.category),
                        backgroundColor: theme.colorScheme.primaryContainer,
                      ),
                      if (recipe.area != null) ...[
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(recipe.area!),
                          backgroundColor: theme.colorScheme.secondaryContainer,
                        ),
                      ],
                    ],
                  ),
                  if (recipe.tags != null && recipe.tags!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: recipe.tags!
                          .map(
                            (tag) => Chip(
                              label: Text(tag),
                              labelStyle: theme.textTheme.bodySmall,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  if (recipe.youtubeUrl != null &&
                      recipe.youtubeUrl!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => _launchYouTube(recipe.youtubeUrl),
                      icon: const Icon(Icons.play_circle_outline),
                      label: const Text('Lihat Video Tutorial'),
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Text(
                    'Bahan-bahan:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (recipe.ingredients.isEmpty)
                    const Text('Detail bahan tidak tersedia')
                  else
                    ...recipe.ingredients.map(
                      (b) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text('• $b'),
                      ),
                    ),
                  const SizedBox(height: 16),
                  const Text(
                    'Cara Membuat:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.instructions.isEmpty
                        ? 'Instruksi tidak tersedia'
                        : recipe.instructions,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
    );
  }
}
