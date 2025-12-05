import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe_model.dart';
import 'dummy_data.dart';

class LocalStorage {
  static const String key = 'favorites';

  static Future<void> saveFavorites(List<Recipe> recipes) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, recipes.map((r) => r.id).toList());
  }

  static Future<List<Recipe>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(key) ?? [];
    return dummyRecipes.where((r) => ids.contains(r.id)).toList();
  }
}
