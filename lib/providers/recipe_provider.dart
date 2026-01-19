import 'package:flutter/foundation.dart';

import '../data/sample_recipes.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class RecipeProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  List<Recipe> _recipes = [];
  List<String> _userFavorites = [];
  bool _isLoading = false;
  String? _error;

  // Use sample data as fallback or for offline mode
  RecipeProvider() {
    _recipes = SampleRecipes.getRecipes();
    loadRecipes();
  }

  List<Recipe> get recipes => List.unmodifiable(_recipes);
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Recipe> get favorites {
    return _recipes
        .where((recipe) => _userFavorites.contains(recipe.recipeID))
        .toList(growable: false);
  }

  int get totalRecipes => _recipes.length;

  int get favoritesCount => _userFavorites.length;

  int get createdCount => 8;

  // Load recipes from Firestore
  Future<void> loadRecipes() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final recipes = await _apiService.getRecipes();
      _recipes = recipes;

      // Load user favorites if logged in
      final userId = _authService.currentUserId;
      if (userId != null) {
        await loadUserFavorites(userId);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      // Keep sample data on error
      if (_recipes.isEmpty) {
        _recipes = SampleRecipes.getRecipes();
      }
      notifyListeners();
    }
  }

  // Load user favorites
  Future<void> loadUserFavorites(String userId) async {
    try {
      _userFavorites = await _apiService.getUserFavorites(userId);
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load favorites: $e');
    }
  }

  // Toggle favorite with Firestore sync
  Future<void> toggleFavorite(String recipeID) async {
    final userId = _authService.currentUserId;

    if (userId == null) {
      // If not logged in, just update local state
      _toggleLocalFavorite(recipeID);
      return;
    }

    try {
      final isFavorite = _userFavorites.contains(recipeID);

      if (isFavorite) {
        await _apiService.removeFromFavorites(userId, recipeID);
        _userFavorites.remove(recipeID);
      } else {
        await _apiService.addToFavorites(userId, recipeID);
        _userFavorites.add(recipeID);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Failed to toggle favorite: $e');
      // Fallback to local toggle
      _toggleLocalFavorite(recipeID);
    }
  }

  // Local favorite toggle (fallback)
  void _toggleLocalFavorite(String recipeID) {
    final index = _recipes.indexWhere((recipe) => recipe.recipeID == recipeID);
    if (index == -1) return;

    _recipes[index].isFavorite = !_recipes[index].isFavorite;
    notifyListeners();
  }

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

  // Add new recipe
  Future<void> addRecipe(Recipe recipe) async {
    try {
      final userId = _authService.currentUserId;

      final recipeId = await _apiService.addRecipe(
        title: recipe.title,
        description: recipe.description,
        imageUrl: recipe.imageUrl,
        author: recipe.author,
        servings: recipe.servings,
        prepTime: recipe.prepTime,
        category: recipe.category,
        userId: userId,
      );

      // Add to local list
      _recipes.add(
        Recipe(
          recipeID: recipeId,
          title: recipe.title,
          description: recipe.description,
          imageUrl: recipe.imageUrl,
          author: recipe.author,
          servings: recipe.servings,
          prepTime: recipe.prepTime,
          category: recipe.category,
          isFavorite: false,
        ),
      );

      notifyListeners();
    } catch (e) {
      throw 'Failed to add recipe: $e';
    }
  }

  // Refresh recipes
  Future<void> refresh() async {
    await loadRecipes();
  }
}
