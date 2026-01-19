import '../models/recipe.dart';

class SampleRecipes {
  static List<Recipe> getRecipes() {
    return [
      Recipe(
        recipeID: '1',
        title: 'Fluffy Pancakes',
        description: 'Light and fluffy pancakes perfect for breakfast',
        imageUrl:
            'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800',
        author: 'Chef Maria',
        servings: '4',
        prepTime: 20,
        category: 'Breakfast',
        isFavorite: false,
      ),
      Recipe(
        recipeID: '2',
        title: 'Creamy Pasta Carbonara',
        description: 'Classic Italian pasta with creamy sauce',
        imageUrl:
            'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=800',
        author: 'Chef Antonio',
        servings: '2',
        prepTime: 30,
        category: 'Lunch',
        isFavorite: false,
      ),
      Recipe(
        recipeID: '3',
        title: 'Fresh Garden Salad',
        description: 'Healthy and fresh garden salad with vinaigrette',
        imageUrl:
            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
        author: 'Chef Emma',
        servings: '2',
        prepTime: 15,
        category: 'Lunch',
        isFavorite: false,
      ),
      Recipe(
        recipeID: '4',
        title: 'Chocolate Lava Cake',
        description: 'Decadent chocolate dessert with molten center',
        imageUrl:
            'https://images.unsplash.com/photo-1624353365286-3f8d62daad51?w=800',
        author: 'Chef Pierre',
        servings: '4',
        prepTime: 45,
        category: 'Desserts',
        isFavorite: false,
      ),
      Recipe(
        recipeID: '5',
        title: 'Berry Smoothie Bowl',
        description: 'Refreshing smoothie bowl with fresh berries',
        imageUrl:
            'https://images.unsplash.com/photo-1590301157890-4810ed352733?w=800',
        author: 'Chef Sarah',
        servings: '1',
        prepTime: 10,
        category: 'Drinks',
        isFavorite: false,
      ),
      Recipe(
        recipeID: '6',
        title: 'Grilled Chicken Breast',
        description: 'Juicy grilled chicken with herbs and spices',
        imageUrl:
            'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=800',
        author: 'Chef Michael',
        servings: '4',
        prepTime: 35,
        category: 'Dinner',
        isFavorite: false,
      ),
      Recipe(
        recipeID: '7',
        title: 'Avocado Toast Delight',
        description: 'Simple and delicious avocado toast with toppings',
        imageUrl:
            'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=800',
        author: 'Chef Lisa',
        servings: '2',
        prepTime: 10,
        category: 'Breakfast',
        isFavorite: false,
      ),
      Recipe(
        recipeID: '8',
        title: 'Classic Beef Burger',
        description: 'Homemade beef burger with all the fixings',
        imageUrl:
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800',
        author: 'Chef John',
        servings: '4',
        prepTime: 25,
        category: 'Dinner',
        isFavorite: false,
      ),
    ];
  }
}
