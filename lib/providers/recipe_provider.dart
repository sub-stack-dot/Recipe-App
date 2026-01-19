import 'package:flutter/foundation.dart';

import '../data/sample_recipes.dart';
import '../models/recipe.dart';

class RecipeProvider extends ChangeNotifier {
  RecipeProvider() : _recipes = SampleRecipes.getRecipes();

  final List<Recipe> _recipes;

  List<Recipe> get recipes => List.unmodifiable(_recipes);

  List<Recipe> get favorites =>
      _recipes.where((recipe) => recipe.isFavorite).toList(growable: false);

  int get totalRecipes => _recipes.length;

  int get favoritesCount => favorites.length;

  int get createdCount => 8;

  List<Recipe> filtered({String category = 'All', String query = ''}) {
    final normalizedCategory = category.trim();
    final normalizedQuery = query.trim().toLowerCase();

    return _recipes
        .where((recipe) {
          final matchesCategory =
              normalizedCategory == 'All' ||
              recipe.category == normalizedCategory;
          final matchesQuery =
              normalizedQuery.isEmpty ||
              recipe.title.toLowerCase().contains(normalizedQuery) ||
              recipe.description.toLowerCase().contains(normalizedQuery);

          return matchesCategory && matchesQuery;
        })
        .toList(growable: false);
  }

  void toggleFavorite(String recipeID) {
    final index = _recipes.indexWhere((recipe) => recipe.recipeID == recipeID);
    if (index == -1) {
      return;
    }

    _recipes[index].isFavorite = !_recipes[index].isFavorite;
    notifyListeners();
  }
}
