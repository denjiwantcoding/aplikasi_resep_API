import 'package:flutter/foundation.dart';

import '../data/dummy_data.dart';
import '../data/local_storage.dart';
import '../models/recipe_model.dart';
import '../services/meal_api_service.dart';

class RecipeProvider extends ChangeNotifier {
  List<Recipe> _allRecipes = [];
  List<Recipe> _favorites = [];
  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  bool _isLoading = false;
  List<String> _categories = ['Semua'];

  List<Recipe> get favorites => List.unmodifiable(_favorites);
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  List<Recipe> get allRecipes => _allRecipes;

  List<String> get categories => _categories;

  // Initialize and load data from API
  Future<void> initialize() async {
    await loadCategories();
    await loadRandomMeals();
    await loadFavorites();
  }

  // Load categories from API
  Future<void> loadCategories() async {
    try {
      _isLoading = true;
      notifyListeners();

      final apiCategories = await MealApiService.getCategories();
      _categories = ['Semua', ...apiCategories];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading categories: $e');
      _categories = ['Semua', ...dummyRecipes.map((r) => r.category).toSet()];
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load random meals to populate initial list
  Future<void> loadRandomMeals({int count = 20}) async {
    try {
      _isLoading = true;
      notifyListeners();

      List<Recipe> meals = [];
      for (int i = 0; i < count; i++) {
        final meal = await MealApiService.getRandomMeal();
        if (meal != null) {
          meals.add(meal);
        }
      }

      if (meals.isNotEmpty) {
        _allRecipes = meals;
      } else {
        _allRecipes = dummyRecipes;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading random meals: $e');
      _allRecipes = dummyRecipes;
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search recipes from API
  Future<void> searchRecipes(String query) async {
    if (query.isEmpty) {
      await loadRandomMeals();
      return;
    }

    try {
      _isLoading = true;
      _searchQuery = query;
      notifyListeners();

      final results = await MealApiService.searchMeals(query);

      if (results.isNotEmpty) {
        _allRecipes = results;
      } else {
        _allRecipes = [];
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error searching recipes: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load recipes by category from API
  Future<void> loadRecipesByCategory(String category) async {
    if (category == 'Semua') {
      await loadRandomMeals();
      return;
    }

    try {
      _isLoading = true;
      _selectedCategory = category;
      notifyListeners();

      final results = await MealApiService.filterByCategory(category);

      if (results.isNotEmpty) {
        _allRecipes = results;
      } else {
        _allRecipes = [];
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading recipes by category: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get recipe details by ID
  Future<Recipe?> getRecipeById(String id) async {
    try {
      return await MealApiService.getMealById(id);
    } catch (e) {
      print('Error getting recipe by ID: $e');
      return null;
    }
  }

  // Load all meals by browsing through alphabet
  Future<void> loadAllMeals() async {
    try {
      _isLoading = true;
      notifyListeners();

      List<Recipe> allMeals = [];

      // Load meals starting with each letter
      for (var letter in 'abcdefghijklmnopqrstuvwxyz'.split('')) {
        final meals = await MealApiService.searchMealsByLetter(letter);
        allMeals.addAll(meals);

        // Update UI progressively
        if (meals.isNotEmpty) {
          _allRecipes = allMeals;
          notifyListeners();
        }
      }

      _allRecipes = allMeals;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading all meals: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Recipe> get filteredRecipes {
    return _allRecipes.where((recipe) {
      final matchCategory =
          _selectedCategory == 'Semua' || recipe.category == _selectedCategory;
      final matchSearch =
          _searchQuery.isEmpty ||
          recipe.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();
  }

  List<Recipe> get popularRecipes {
    final sorted = [..._allRecipes];
    sorted.sort((a, b) => b.rating.compareTo(a.rating));
    return sorted;
  }

  List<Recipe> recipesByCategory(String category) {
    if (category == 'Semua') {
      return [..._allRecipes];
    }
    return _allRecipes.where((recipe) => recipe.category == category).toList();
  }

  void setCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    loadRecipesByCategory(category);
  }

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    searchRecipes(query);
  }

  List<Recipe> search(String query) {
    return _allRecipes
        .where(
          (recipe) => recipe.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  void toggleFavorite(Recipe recipe) {
    final exists = _favorites.any((item) => item.id == recipe.id);
    if (exists) {
      _favorites.removeWhere((item) => item.id == recipe.id);
    } else {
      _favorites.add(recipe);
    }
    LocalStorage.saveFavorites(_favorites);
    notifyListeners();
  }

  bool isFavorite(Recipe recipe) {
    return _favorites.any((item) => item.id == recipe.id);
  }

  Future<void> loadFavorites() async {
    final stored = await LocalStorage.loadFavorites();
    final storedIds = stored.map((recipe) => recipe.id).toSet();
    _favorites = _allRecipes
        .where((recipe) => storedIds.contains(recipe.id))
        .toList();
    notifyListeners();
  }
}
