class Product {
  final String id;
  final String name;
  final List<dynamic> variations;
  final dynamic
      recipe; // You can replace dynamic with a specific class type if needed
  final List<Map<String, dynamic>> ingredientsWithNutrients;

  Product({
    required this.id,
    required this.name,
    required this.variations,
    required this.recipe,
    required this.ingredientsWithNutrients,
  });
}

class ProductVariation {
  final String id;
  final String size;
  final double price;

  ProductVariation({
    required this.id,
    required this.size,
    required this.price,
  });
}

class Recipe {
  final String id;
  final List<RecipeIngredient> ingredients;

  Recipe({
    required this.id,
    required this.ingredients,
  });
}

class RecipeIngredient {
  final String ingredientId; // Reference to the ingredient
  final String recipeId; // Reference to the recipe

  RecipeIngredient({
    required this.ingredientId,
    required this.recipeId,
  });
}

class Ingredient {
  final String id;
  final String name;
  final String nutrientId;

  Ingredient({required this.id, required this.name, required this.nutrientId});
}

class NutrientData {
  final String id;
  final double value;
  final String nutrientName;

  NutrientData({
    required this.id,
    required this.value,
    required this.nutrientName,
  });
}

class IngredientWithNutrient {
  final Ingredient ingredient;
  final NutrientData nutrientData;

  IngredientWithNutrient({
    required this.ingredient,
    required this.nutrientData,
  });
}
