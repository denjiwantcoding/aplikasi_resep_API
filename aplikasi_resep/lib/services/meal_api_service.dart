import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';

class MealApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Search meals by name
  static Future<List<Recipe>> searchMeals(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search.php?s=$query'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          return (data['meals'] as List)
              .map((meal) => _mealToRecipe(meal))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error searching meals: $e');
      return [];
    }
  }

  // Search meals by first letter
  static Future<List<Recipe>> searchMealsByLetter(String letter) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search.php?f=$letter'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          return (data['meals'] as List)
              .map((meal) => _mealToRecipe(meal))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error searching meals by letter: $e');
      return [];
    }
  }

  // Get meal by ID
  static Future<Recipe?> getMealById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null && data['meals'].isNotEmpty) {
          return _mealToRecipe(data['meals'][0]);
        }
      }
      return null;
    } catch (e) {
      print('Error getting meal by ID: $e');
      return null;
    }
  }

  // Get random meal
  static Future<Recipe?> getRandomMeal() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/random.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null && data['meals'].isNotEmpty) {
          return _mealToRecipe(data['meals'][0]);
        }
      }
      return null;
    } catch (e) {
      print('Error getting random meal: $e');
      return null;
    }
  }

  // Get all categories
  static Future<List<String>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['categories'] != null) {
          return (data['categories'] as List)
              .map((cat) => cat['strCategory'] as String)
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }

  // Get list of areas
  static Future<List<String>> getAreas() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/list.php?a=list'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          return (data['meals'] as List)
              .map((area) => area['strArea'] as String)
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting areas: $e');
      return [];
    }
  }

  // Get list of ingredients
  static Future<List<String>> getIngredients() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/list.php?i=list'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          return (data['meals'] as List)
              .map((ing) => ing['strIngredient'] as String)
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting ingredients: $e');
      return [];
    }
  }

  // Filter by category
  static Future<List<Recipe>> filterByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/filter.php?c=$category'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          return (data['meals'] as List)
              .map((meal) => _simpleMealToRecipe(meal))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error filtering by category: $e');
      return [];
    }
  }

  // Filter by area
  static Future<List<Recipe>> filterByArea(String area) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/filter.php?a=$area'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          return (data['meals'] as List)
              .map((meal) => _simpleMealToRecipe(meal))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error filtering by area: $e');
      return [];
    }
  }

  // Filter by ingredient
  static Future<List<Recipe>> filterByIngredient(String ingredient) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/filter.php?i=$ingredient'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          return (data['meals'] as List)
              .map((meal) => _simpleMealToRecipe(meal))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error filtering by ingredient: $e');
      return [];
    }
  }

  // Convert API meal data to Recipe model (full details)
  static Recipe _mealToRecipe(Map<String, dynamic> meal) {
    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = meal['strIngredient$i'];
      final measure = meal['strMeasure$i'];
      if (ingredient != null &&
          ingredient.toString().trim().isNotEmpty &&
          ingredient != 'null') {
        final ingredientText =
            measure != null &&
                measure.toString().trim().isNotEmpty &&
                measure != 'null'
            ? '$measure $ingredient'
            : ingredient;
        ingredients.add(ingredientText.toString().trim());
      }
    }

    return Recipe(
      id: meal['idMeal'] ?? '',
      title: meal['strMeal'] ?? 'Unknown',
      category: meal['strCategory'] ?? 'Other',
      imageUrl: meal['strMealThumb'] ?? '',
      ingredients: ingredients,
      instructions: meal['strInstructions'] ?? '',
      rating: 4.5,
      area: meal['strArea'],
      tags: meal['strTags']?.split(',') ?? [],
      youtubeUrl: meal['strYoutube'],
    );
  }

  // Convert simplified API meal data to Recipe model (from filter endpoints)
  static Recipe _simpleMealToRecipe(Map<String, dynamic> meal) {
    return Recipe(
      id: meal['idMeal'] ?? '',
      title: meal['strMeal'] ?? 'Unknown',
      category: 'Other',
      imageUrl: meal['strMealThumb'] ?? '',
      ingredients: [],
      instructions: '',
      rating: 4.5,
    );
  }
}
