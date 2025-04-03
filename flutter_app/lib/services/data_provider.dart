import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataProvider extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  Map<String, dynamic>? _loggedInUser;

  Map<String, dynamic>? get loggedInUser => _loggedInUser;

  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _variations = [];
  List<Map<String, dynamic>> _cart = [];

  List<Map<String, dynamic>> _recipes = [];
  List<Map<String, dynamic>> _recipeIngredients = [];
  List<Map<String, dynamic>> _ingredients = [];
  List<Map<String, dynamic>> _nutrientData = [];

  List<Map<String, dynamic>> get products => _products;
  List<Map<String, dynamic>> get variations => _variations;
  List<Map<String, dynamic>> get cart => _cart;

  // Add getters for the new lists
  List<Map<String, dynamic>> get recipes => _recipes;
  List<Map<String, dynamic>> get recipeIngredients => _recipeIngredients;
  List<Map<String, dynamic>> get ingredients => _ingredients;
  List<Map<String, dynamic>> get nutrientData => _nutrientData;

  double get totalPrice =>
      _cart.fold(0, (sum, item) => sum + (item['cost'] * item['quantity']));

  void setUser(Map<String, dynamic> userData) {
    _loggedInUser = userData;
  }

  //Fetch products and variations from Supabase.
  Future<void> fetchProducts() async {
    try {
      print("Fetching products...");

      final productResponse = await supabase.from('product_table').select();
      print("Product Response: $productResponse");

      final variationResponse =
          await supabase.from('product_variation_table').select();
      print("Variation Response: $variationResponse");

      // _products = productResponse;
      // _variations = variationResponse;
      _products = productResponse as List<Map<String, dynamic>>;
      _variations = variationResponse as List<Map<String, dynamic>>;

      notifyListeners();
      print("Data fetched successfully.");
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  // Function to get a product by its ID.
  Future<Map<String, dynamic>?> getProductById(String productId) async {
    try {
      final product = _products.firstWhere(
        (product) => product['product_id'] == productId,
      );

      if (product == null) {
        final response = await supabase
            .from('product_table')
            .select('*')
            .eq('product_id', productId)
            .single();

        return response;
      }
      return product;
    } catch (e) {
      print("Error fetching product by ID: $e");
      return null;
    }
  }

  // Add product variation to cart.
  void addToCart(Map<String, dynamic> variation) {
    final existingItem = _cart.firstWhere(
      (item) => item['variation_id'] == variation['variation_id'],
      orElse: () => {},
    );

    if (existingItem.isNotEmpty) {
      existingItem['quantity'] += 1;
    } else {
      _cart.add({...variation, 'quantity': 1});
    }

    notifyListeners();
  }

  // Remove item from cart.
  void removeFromCart(int variationId) {
    _cart.removeWhere((item) => item['variation_id'] == variationId);
    notifyListeners();
  }

  // Submit sale to Supabase.
  Future<void> completeSale() async {
    if (_cart.isEmpty) return;

    try {
      // ✅ Step 1: Insert into sales_table.
      final saleResponse = await supabase.from('sales_table').insert({
        'total_price': _cart.fold(
            0.0, (sum, item) => sum + (item['cost'] * item['quantity'])),
        'sale_date': DateTime.now().toString().split(' ')[0], // Only date
      }).select(); // Ensure inserted data is returned.

      if (saleResponse == null || saleResponse.isEmpty) {
        throw Exception('Failed to create sale: No data returned');
      }

      final saleId =
          saleResponse[0]['sale_id']; // ✅ Correct way to get sale_id.
      print("✅ Sale created with ID: $saleId");

      // ✅ Step 2: Insert into sales_variations_table.
      for (var item in _cart) {
        final salesVariationResponse =
            await supabase.from('sales_variations_table').insert({
          'sale_id': saleId,
          'variation_id': item['variation_id'],
          'quantity': item['quantity'],
        }).select();

        print("🔍 Sales Variation Insert Response: $salesVariationResponse");

        if (salesVariationResponse == null || salesVariationResponse.isEmpty) {
          throw Exception(
              'Failed to insert sale variation: Response is empty for variation_id ${item['variation_id']}');
        }

        // ✅ Step 3: Reduce stock.
        final productVariationResponse =
            await supabase.from('product_variation_table').update({
          'stock': item['stock'] - item['quantity'],
        }).match({'variation_id': item['variation_id']}).select();

        print("📉 Stock Updated: $productVariationResponse");

        if (productVariationResponse == null ||
            productVariationResponse.isEmpty) {
          throw Exception(
              'Failed to update stock for variation_id ${item['variation_id']}');
        }
      }

      // ✅ Step 4: Clear cart & Notify.
      _cart.clear();
      notifyListeners();
      print("✅ Sale completed successfully!");
    } catch (e) {
      print("❌ Error submitting sale: $e");
    }
  }

  Future<Map<String, dynamic>> fetchSalesReport(String period) async {
    try {
      DateTime now = DateTime.now();
      DateTime startDate;

      switch (period) {
        case 'today':
          startDate = DateTime(now.year, now.month, now.day);
          break;
        case 'this_week':
          startDate = now.subtract(
              Duration(days: now.weekday - 1)); // Start of the week. (Monday)
          break;
        case 'this_month':
          startDate = DateTime(now.year, now.month, 1);
          break;
        case 'this_year':
          startDate = DateTime(now.year, 1, 1);
          break;
        default:
          throw Exception("Invalid period");
      }

      // Fetch sales data, grouped by sale_date.
      final salesData = await supabase
          .from('sales_table')
          .select('sale_id, sale_date, total_price')
          .gte('sale_date', startDate.toIso8601String())
          .order('sale_date');

      Map<String, double> dailySales = {};
      for (var sale in salesData) {
        String saleDate = sale['sale_date']?.substring(0, 10) ?? '';
        double totalPrice =
            sale['total_price'] is double ? sale['total_price'] : 0.0;
        if (saleDate.isNotEmpty) {
          dailySales[saleDate] = dailySales.containsKey(saleDate)
              ? dailySales[saleDate]! + totalPrice
              : totalPrice;
        }
      }

      final sortedDailySales = Map.fromEntries(
        dailySales.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
      );

      double totalProfit =
          sortedDailySales.values.fold(0.0, (sum, sale) => sum + sale);

      List<int> saleIds = salesData
          .map<int>((sale) => sale['sale_id'] as int? ?? 0)
          .where((id) => id != 0)
          .toList();

      int totalItemsSold = 0;
      Map<String, int> productSummary =
          {}; // Flat map of product variation with size -> quantity.

      if (saleIds.isNotEmpty) {
        // Fetch sales variations data. (NO product_id here)
        final salesVariations = await supabase
            .from('sales_variations_table')
            .select(
                'sale_id, variation_id, quantity') // Only variation_id and quantity.
            .inFilter('sale_id', saleIds);

        // Fetch product variation data. (with product_id and size)
        final variationsData = await supabase
            .from('product_variation_table')
            .select(
                'variation_id, product_id, size'); // Just variation_id, product_id, and size.

        // Fetch product names for all product_ids in the variations data.
        List<int> productIds = variationsData
            .map<int>((variation) => variation['product_id'] as int)
            .toList();
        final productsData = await supabase
            .from('product_table')
            .select('product_id, product_name')
            .inFilter('product_id', productIds);

        Map<int, String> productNamesMap = {};
        for (var product in productsData) {
          int productId = product['product_id'];
          String productName = product['product_name'] ?? 'Unknown Product';
          productNamesMap[productId] = productName;
        }

        Map<int, String> variationSizeMap = {};
        for (var variation in variationsData) {
          int variationId = variation['variation_id'];
          String size = variation['size'] ?? 'Unknown Size';
          variationSizeMap[variationId] = size;
        }

        for (var variation in salesVariations) {
          int variationId = variation['variation_id'];
          int quantity = variation['quantity'] as int? ?? 0;

          // Find the size based on variation_id.
          String size = variationSizeMap[variationId] ?? 'Unknown Size';

          // Find the product_name based on product_id.
          int productId = variationsData.firstWhere(
              (v) => v['variation_id'] == variationId)['product_id'];
          String productName = productNamesMap[productId] ?? 'Unknown Product';

          // Accumulate the quantity sold by product name and size.
          String key = '$productName - $size';
          productSummary[key] = (productSummary[key] ?? 0) + quantity;
        }

        totalItemsSold = salesVariations.fold(
            0, (sum, item) => sum + (item['quantity'] as int? ?? 0));
      }

      return {
        'totalProfit': totalProfit,
        'totalItemsSold': totalItemsSold,
        'dailySales': sortedDailySales,
        'productSummary': productSummary,
      };
    } catch (e) {
      print("Error fetching sales report: $e");
      return {
        'totalProfit': 0.0,
        'totalItemsSold': 0,
        'dailySales': {},
        'productSummary': {},
      };
    }
  }

  // Insert recipe into recipe_table and return the recipe_id.
  Future<int?> addRecipe(Map<String, dynamic> recipeData) async {
    try {
      final response =
          await supabase.from('recipes_table').insert(recipeData).select();
      if (response == null || response.isEmpty) {
        throw Exception('Failed to add recipe');
      }
      return response[0]['recipe_id'];
    } catch (e) {
      print("❌ Error adding recipe: $e");
      return null;
    }
  }

  // Insert product into product_table and return the product_id.
  Future<int?> addProduct(Map<String, dynamic> productData) async {
    try {
      final response =
          await supabase.from('product_table').insert(productData).select();
      if (response == null || response.isEmpty) {
        throw Exception('Failed to add product');
      }
      return response[0]['product_id'];
    } catch (e) {
      print("❌ Error adding product: $e");
      return null;
    }
  }

  // Insert product variation into product_variation_table.
  Future<void> addProductVariation(Map<String, dynamic> variationData) async {
    try {
      await supabase.from('product_variation_table').insert(variationData);
      print("✅ Product variation added successfully!");
    } catch (e) {
      print("❌ Error adding product variation: $e");
    }
  }

  Future<void> fetchProductsData() async {
    try {
      // Step 1: Fetch Products
      final productResponse = await supabase.from('product_table').select('*');
      _products = List<Map<String, dynamic>>.from(productResponse ?? []);
      print(_products);

      // Step 2: Fetch Product Variations
      final variationResponse =
          await supabase.from('product_variation_table').select('*');
      _variations = List<Map<String, dynamic>>.from(variationResponse ?? []);
      print(_variations);

      // Step 3: Fetch Recipes
      final recipeResponse = await supabase.from('recipes_table').select('*');
      _recipes = List<Map<String, dynamic>>.from(recipeResponse ?? []);
      print(_recipes);

      // Step 4: Fetch Recipe Ingredients
      final recipeIngredientsResponse =
          await supabase.from('recipe_ingredients_table').select('*');
      _recipeIngredients =
          List<Map<String, dynamic>>.from(recipeIngredientsResponse ?? []);
      print(_recipeIngredients);

      // Step 5: Fetch Ingredients
      final ingredientResponse =
          await supabase.from('ingredient_table').select('*');
      _ingredients = List<Map<String, dynamic>>.from(ingredientResponse ?? []);
      print(_ingredients);

      notifyListeners(); // Notify listeners when data is fetched successfully
      print("✅ Data fetched successfully!");
    } catch (e) {
      print('❌ Error fetching data: $e');
    }
  }

  // Centralized function to get ingredients with nutrients for a product
  Future<List<Map<String, dynamic>>> getIngredientsWithNutrientsForProduct(
      Map<String, dynamic> product) async {
    // Ensure product has a valid recipe_id
    if (product['recipe_id'] == null || product['recipe_id'] == '') {
      print("No recipe ID for product: ${product['product_id']}");
      return [];
    }

    // Find the related recipe using the recipe_id
    var relatedRecipe = _recipes.firstWhere(
      (recipe) => recipe['recipe_id'] == product['recipe_id'],
      orElse: () => {},
    );

    if (relatedRecipe.isEmpty) {
      print("No related recipe found for product: ${product['product_id']}");
      return [];
    }

    // Find related ingredients for the recipe
    var relatedIngredients = _recipeIngredients
        .where(
          (ingredient) => ingredient['recipe_id'] == relatedRecipe['recipe_id'],
        )
        .toList();

    // Find ingredients from _ingredients that match the relatedIngredients
    List<Map<String, dynamic>> productIngredients = [];
    for (var ingredient in relatedIngredients) {
      var ingredientData = _ingredients.firstWhere(
        (ing) => ing['ingredient_id'] == ingredient['ingredient_id'],
        orElse: () => {},
      );
      if (ingredientData.isNotEmpty) {
        productIngredients.add(ingredientData);
      }
    }
    // Create the query string by joining the ingredient names with commas
    String query = productIngredients.join(' ');
    // Fetch nutrient data from API
    var nutrientData = await _fetchNutrientDataFromAPI(query);

    // If the nutrient data is not null and has items, process it
    if (nutrientData != null && nutrientData.isNotEmpty) {
      List<Map<String, dynamic>> ingredientsWithNutrients = [];

      for (var ingredient in nutrientData) {
        ingredientsWithNutrients.add({
          'ingredient_name': ingredient['name'],
          'calories': ingredient['calories'],
          'protein': ingredient['protein_g'], // Adjusted for response
          'carbohydrates':
              ingredient['carbohydrates_total_g'], // Adjusted for response
          'fat': ingredient['fat_total_g'], // Adjusted for response
          'sugar': ingredient['sugar_g'], // Adjusted for response
          'fiber': ingredient['fiber_g'], // Adjusted for response
          'sodium': ingredient['sodium_mg'], // Adjusted for response
          'cholesterol': ingredient['cholesterol_mg'], // Adjusted for response
        });
      }

      return ingredientsWithNutrients;
    } else {
      print("No nutrient data found for the ingredients.");
      return [];
    }
  }

// Function to fetch nutrient data from the external API
  Future<List<Map<String, dynamic>>?> _fetchNutrientDataFromAPI(
      String ingredientName) async {
    final apiKey = 'sWbeoShtz5Xg7L8kQ/Wkig==rWW8vkhoamojSzh3';
    final apiUrl =
        'https://api.calorieninjas.com/v1/nutrition?query=$ingredientName';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'X-Api-Key': apiKey, // Include the API key in the header
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if the response is a map (i.e., not a list)
        if (data is Map<String, dynamic>) {
          // Extract the 'items' key if present, assuming the actual nutrient data is under it
          var items = data['items'];

          if (items != null && items is List) {
            return items.map((item) => item as Map<String, dynamic>).toList();
          } else {
            print("No items found in the response.");
            return null;
          }
        } else {
          print("Unexpected response format: Expected a map, but got $data");
          return null;
        }
      } else {
        print("Error fetching nutrient data: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error making API call: $e");
      return null;
    }
  }
}
