import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/sample_recipes.dart';

/// Helper function to seed Firestore with sample recipes
/// Run this once to populate your database
Future<void> seedRecipes() async {
  final firestore = FirebaseFirestore.instance;
  final recipes = SampleRecipes.getRecipes();

  try {
    // Check if recipes already exist
    final snapshot = await firestore.collection('recipes').limit(1).get();

    if (snapshot.docs.isNotEmpty) {
      print('Recipes already seeded');
      return;
    }

    // Add all sample recipes to Firestore
    for (final recipe in recipes) {
      await firestore.collection('recipes').add({
        'title': recipe.title,
        'description': recipe.description,
        'imageUrl': recipe.imageUrl,
        'author': recipe.author,
        'servings': recipe.servings,
        'prepTime': recipe.prepTime,
        'category': recipe.category,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    print('Successfully seeded ${recipes.length} recipes');
  } catch (e) {
    print('Error seeding recipes: $e');
  }
}
