class Recipe {
  String recipeID;
  String title;
  String description;
  String imageUrl;
  String author;
  String servings;
  int prepTime; // in minutes
  int cookTime; // in minutes
  String category; // Breakfast, Lunch, Dinner, Desserts, Drinks
  List<String> ingredients;
  List<String> instructions;
  bool isFavorite;

  Recipe({
    required this.recipeID,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.author,
    required this.servings,
    required this.prepTime,
    int? cookTime,
    required this.category,
    this.ingredients = const [],
    this.instructions = const [],
    this.isFavorite = false,
  }) : cookTime = cookTime ?? prepTime;
}
