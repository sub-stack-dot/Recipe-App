class Recipe {
  String recipeID;
  String title;
  String description;
  String imageUrl;
  String author;
  String servings;
  int prepTime; // in minutes
  String category; // Breakfast, Lunch, Dinner, Desserts, Drinks
  bool isFavorite;

  Recipe({
    required this.recipeID,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.author,
    required this.servings,
    required this.prepTime,
    required this.category,
    this.isFavorite = false,
  });
}
