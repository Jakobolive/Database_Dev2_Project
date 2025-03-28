class Product {
  final String id;
  final String name;
  final List<ProductVariation> variations;
  final Recipe recipe;
  final List<IngredientWithNutrient> ingredientsWithNutrients;

  Product({
    required this.id,
    required this.name,
    required this.variations,
    required this.recipe,
    required this.ingredientsWithNutrients,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<ProductVariation> variations = (json['variations'] as List<dynamic>)
        .map((variationJson) => ProductVariation.fromJson(variationJson))
        .toList();

    List<IngredientWithNutrient> ingredientsWithNutrients = [];
    if (json['recipe'] != null && json['recipe']['ingredients'] != null) {
      final recipeIngredients = json['recipe']['ingredients'] as List<dynamic>;

      for (var ingredientJson in recipeIngredients) {
        if (ingredientJson['ingredient_table'] != null &&
            ingredientJson['ingredient_table']['nutrient_data_table'] != null) {
          final ingredient =
              Ingredient.fromJson(ingredientJson['ingredient_table']);

          final nutrientList = ingredientJson['ingredient_table']
              ['nutrient_data_table'] as List<dynamic>;

          for (var nutrientJson in nutrientList) {
            final nutrientData = NutrientData.fromJson(nutrientJson);
            ingredientsWithNutrients.add(IngredientWithNutrient(
              ingredient: ingredient,
              nutrientData: nutrientData,
            ));
          }
        }
      }
    }

    return Product(
      id: json['id'],
      name: json['name'],
      variations: variations,
      recipe: Recipe.fromJson(json['recipe']),
      ingredientsWithNutrients: ingredientsWithNutrients,
    );
  }
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

  factory ProductVariation.fromJson(Map<String, dynamic> json) {
    return ProductVariation(
      id: json['id'],
      size: json['size'],
      price: json['price'].toDouble(),
    );
  }
}

class Recipe {
  final String id;
  final List<RecipeIngredient> ingredients;

  Recipe({
    required this.id,
    required this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<RecipeIngredient> ingredients = (json['ingredients'] as List<dynamic>)
        .map((ingredientJson) => RecipeIngredient.fromJson(ingredientJson))
        .toList();

    return Recipe(
      id: json['id'],
      ingredients: ingredients,
    );
  }
}

class RecipeIngredient {
  final String ingredientId;
  final String recipeId;

  RecipeIngredient({
    required this.ingredientId,
    required this.recipeId,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      ingredientId: json['ingredientId'],
      recipeId: json['recipeId'],
    );
  }
}

class Ingredient {
  final String id;
  final String name;
  final String nutrientId;

  Ingredient({
    required this.id,
    required this.name,
    required this.nutrientId,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      name: json['name'],
      nutrientId: json['nutrientId'],
    );
  }
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

  factory NutrientData.fromJson(Map<String, dynamic> json) {
    return NutrientData(
      id: json['id'],
      value: json['amount'].toDouble(),
      nutrientName: json['nutrient_name'],
    );
  }
}

class IngredientWithNutrient {
  final Ingredient ingredient;
  final NutrientData nutrientData;

  IngredientWithNutrient({
    required this.ingredient,
    required this.nutrientData,
  });
}
