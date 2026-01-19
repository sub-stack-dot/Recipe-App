import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/recipe.dart';

class ApiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get all recipes
  Future<List<Recipe>> getRecipes() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('recipes')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Recipe(
          recipeID: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          author: data['author'] ?? '',
          servings: data['servings'] ?? '',
          prepTime: data['prepTime'] ?? 0,
          cookTime: data['cookTime'] ?? data['prepTime'] ?? 0,
          category: data['category'] ?? '',
          ingredients: List<String>.from(data['ingredients'] ?? const []),
          instructions: List<String>.from(data['instructions'] ?? const []),
          isFavorite: false, // Will be set by provider based on user favorites
        );
      }).toList();
    } catch (e) {
      throw 'Failed to fetch recipes.';
    }
  }

  // Get recipes stream (real-time updates)
  Stream<List<Recipe>> getRecipesStream() {
    return _firestore.collection('recipes').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Recipe(
          recipeID: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          author: data['author'] ?? '',
          servings: data['servings'] ?? '',
          prepTime: data['prepTime'] ?? 0,
          cookTime: data['cookTime'] ?? data['prepTime'] ?? 0,
          category: data['category'] ?? '',
          ingredients: List<String>.from(data['ingredients'] ?? const []),
          instructions: List<String>.from(data['instructions'] ?? const []),
          isFavorite: false,
        );
      }).toList();
    });
  }

  // Get recipe by ID
  Future<Recipe?> getRecipeById(String recipeId) async {
    try {
      final doc = await _firestore.collection('recipes').doc(recipeId).get();

      if (!doc.exists) return null;

      final data = doc.data()!;
      return Recipe(
        recipeID: doc.id,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        author: data['author'] ?? '',
        servings: data['servings'] ?? '',
        prepTime: data['prepTime'] ?? 0,
        cookTime: data['cookTime'] ?? data['prepTime'] ?? 0,
        category: data['category'] ?? '',
        ingredients: List<String>.from(data['ingredients'] ?? const []),
        instructions: List<String>.from(data['instructions'] ?? const []),
        isFavorite: false,
      );
    } catch (e) {
      throw 'Failed to fetch recipe.';
    }
  }

  // Add new recipe
  Future<String> addRecipe({
    required String title,
    required String description,
    required String imageUrl,
    required String author,
    required String servings,
    required int prepTime,
    required String category,
    int? cookTime,
    List<String>? ingredients,
    List<String>? instructions,
    String? userId,
  }) async {
    try {
      final docRef = await _firestore.collection('recipes').add({
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'author': author,
        'servings': servings,
        'prepTime': prepTime,
        'cookTime': cookTime ?? prepTime,
        'category': category,
        if (ingredients != null) 'ingredients': ingredients,
        if (instructions != null) 'instructions': instructions,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return docRef.id;
    } catch (e) {
      throw 'Failed to add recipe.';
    }
  }

  // Update recipe
  Future<void> updateRecipe({
    required String recipeId,
    String? title,
    String? description,
    String? imageUrl,
    String? servings,
    int? prepTime,
    int? cookTime,
    String? category,
    List<String>? ingredients,
    List<String>? instructions,
  }) async {
    try {
      final Map<String, dynamic> updates = {};

      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (imageUrl != null) updates['imageUrl'] = imageUrl;
      if (servings != null) updates['servings'] = servings;
      if (prepTime != null) updates['prepTime'] = prepTime;
      if (cookTime != null) updates['cookTime'] = cookTime;
      if (category != null) updates['category'] = category;
      if (ingredients != null) updates['ingredients'] = ingredients;
      if (instructions != null) updates['instructions'] = instructions;

      if (updates.isNotEmpty) {
        updates['updatedAt'] = FieldValue.serverTimestamp();
        await _firestore.collection('recipes').doc(recipeId).update(updates);
      }
    } catch (e) {
      throw 'Failed to update recipe.';
    }
  }

  // Delete recipe
  Future<void> deleteRecipe(String recipeId) async {
    try {
      await _firestore.collection('recipes').doc(recipeId).delete();
    } catch (e) {
      throw 'Failed to delete recipe.';
    }
  }

  // Get user favorites
  Future<List<String>> getUserFavorites(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      final data = doc.data();

      if (data != null && data.containsKey('favorites')) {
        return List<String>.from(data['favorites']);
      }

      return [];
    } catch (e) {
      throw 'Failed to fetch favorites.';
    }
  }

  // Add to favorites
  Future<void> addToFavorites(String userId, String recipeId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'favorites': FieldValue.arrayUnion([recipeId]),
      });
    } catch (e) {
      throw 'Failed to add to favorites.';
    }
  }

  // Remove from favorites
  Future<void> removeFromFavorites(String userId, String recipeId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'favorites': FieldValue.arrayRemove([recipeId]),
      });
    } catch (e) {
      throw 'Failed to remove from favorites.';
    }
  }

  // Upload image to Firebase Storage
  Future<String> uploadImage(String path, List<int> imageBytes) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = await ref.putData(imageBytes as Uint8List);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw 'Failed to upload image.';
    }
  }

  // Search recipes
  Future<List<Recipe>> searchRecipes(String query) async {
    try {
      final queryLower = query.toLowerCase();

      // Note: Firestore doesn't support full-text search natively
      // You might want to use Algolia or similar for better search
      final snapshot = await _firestore.collection('recipes').get();

      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            return Recipe(
              recipeID: doc.id,
              title: data['title'] ?? '',
              description: data['description'] ?? '',
              imageUrl: data['imageUrl'] ?? '',
              author: data['author'] ?? '',
              servings: data['servings'] ?? '',
              prepTime: data['prepTime'] ?? 0,
              cookTime: data['cookTime'] ?? data['prepTime'] ?? 0,
              category: data['category'] ?? '',
              ingredients: List<String>.from(data['ingredients'] ?? const []),
              instructions: List<String>.from(data['instructions'] ?? const []),
              isFavorite: false,
            );
          })
          .where(
            (recipe) =>
                recipe.title.toLowerCase().contains(queryLower) ||
                recipe.description.toLowerCase().contains(queryLower),
          )
          .toList();
    } catch (e) {
      throw 'Failed to search recipes.';
    }
  }

  // Get recipes by category
  Future<List<Recipe>> getRecipesByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('recipes')
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Recipe(
          recipeID: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          author: data['author'] ?? '',
          servings: data['servings'] ?? '',
          prepTime: data['prepTime'] ?? 0,
          cookTime: data['cookTime'] ?? data['prepTime'] ?? 0,
          category: data['category'] ?? '',
          ingredients: List<String>.from(data['ingredients'] ?? const []),
          instructions: List<String>.from(data['instructions'] ?? const []),
          isFavorite: false,
        );
      }).toList();
    } catch (e) {
      throw 'Failed to fetch recipes by category.';
    }
  }
}
