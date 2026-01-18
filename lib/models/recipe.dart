class Recipe {
  String recipeID;
  String title;
  String description;   // I made this String instead of Float (more logical)
  String imageUrl;
  String author;
  String servings;

  Recipe(this.recipeID, this.title, this.description, this.imageUrl, this.author, this.servings);
}
