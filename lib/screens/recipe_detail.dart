import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../providers/recipe_provider.dart';

class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late Recipe recipe;
  late List<bool> _checkedIngredients;

  @override
  void initState() {
    super.initState();
    recipe = widget.recipe;
    _checkedIngredients = List<bool>.filled(_ingredients.length, false);
  }

  List<String> get _ingredients {
    if (recipe.ingredients.isNotEmpty) return recipe.ingredients;
    return const [
      '2 cups all-purpose flour',
      '2 tablespoons sugar',
      '2 teaspoons baking powder',
      '1/2 teaspoon salt',
      '2 eggs',
      '1 3/4 cups milk',
      '1/4 cup melted butter',
      '1 teaspoon vanilla extract',
    ];
  }

  List<String> get _instructions {
    if (recipe.instructions.isNotEmpty) return recipe.instructions;
    return const [
      'In a large bowl, whisk together flour, sugar, baking powder, and salt.',
      'In another bowl, beat eggs and add milk, melted butter, and vanilla extract.',
      "Pour wet ingredients into dry ingredients and mix until just combined. Don't overmix.",
      'Heat a griddle or pan over medium heat and lightly grease it.',
      'Pour 1/4 cup of batter for each pancake and cook until bubbles form on the surface.',
      'Flip and cook until golden brown on both sides.',
      'Serve hot with maple syrup and your favorite toppings.',
    ];
  }

  void _resetChecklistIfNeeded() {
    if (_checkedIngredients.length != _ingredients.length) {
      _checkedIngredients = List<bool>.filled(_ingredients.length, false);
    }
  }

  Future<void> _toggleFavorite(RecipeProvider provider) async {
    await provider.toggleFavorite(recipe.recipeID);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _resetChecklistIfNeeded();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D11),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildHeroWithCard(context),
                const SizedBox(height: 90),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildIngredientsSection(),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildInstructionsSection(),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _roundIcon(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                  Consumer<RecipeProvider>(
                    builder: (context, provider, _) {
                      final isFavorite =
                          provider.isRecipeFavorite(recipe.recipeID) ||
                          recipe.isFavorite;
                      return _roundIcon(
                        icon: isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        iconColor: isFavorite ? Colors.redAccent : Colors.white,
                        onTap: () => _toggleFavorite(provider),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroWithCard(BuildContext context) {
    return SizedBox(
      height: 470,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildHeroImage(),
          Positioned(
            left: 16,
            right: 16,
            bottom: -70,
            child: _buildInfoCard(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      height: 360,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            recipe.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[800],
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 48,
                ),
              );
            },
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x66000000), Color(0xCC000000)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipe.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statTile(
                icon: Icons.schedule,
                label: 'Prep',
                value: '${recipe.prepTime} mins',
              ),
              _statTile(
                icon: Icons.restaurant,
                label: 'Cook',
                value: '${recipe.cookTime} mins',
              ),
              _statTile(
                icon: Icons.group,
                label: 'Serves',
                value: recipe.servings,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ingredients',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF111118),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: List.generate(_ingredients.length, (index) {
              final item = _ingredients[index];
              final isChecked = _checkedIngredients[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          _checkedIngredients[index] = value ?? false;
                        });
                      },
                      activeColor: const Color(0xFFFF6B35),
                      checkColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xFF3D3D45),
                        width: 1.4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          decoration: isChecked
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Instructions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        Column(
          children: List.generate(_instructions.length, (index) {
            final step = _instructions[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF111118),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF6B35),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      step,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _statTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF1B1B22),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(icon, color: const Color(0xFFFF6B35)),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _roundIcon({
    required IconData icon,
    Color iconColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }
}
