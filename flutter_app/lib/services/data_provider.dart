import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DataProvider extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;
  Map<String, dynamic>? _loggedInUser;

  Map<String, dynamic>? get loggedInUser => _loggedInUser;

  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _variations = [];
  List<Map<String, dynamic>> _cart = [];

  List<Map<String, dynamic>> get products => _products;
  List<Map<String, dynamic>> get variations => _variations;
  List<Map<String, dynamic>> get cart => _cart;

  double get totalPrice =>
      _cart.fold(0, (sum, item) => sum + (item['cost'] * item['quantity']));

  void setUser(Map<String, dynamic> userData) {
    _loggedInUser = userData;
  }

  // Fetch products and variations from Supabase
  Future<void> fetchProducts() async {
    try {
      print("Fetching products...");

      final productResponse = await supabase.from('product_table').select();
      print("Product Response: $productResponse");

      final variationResponse =
          await supabase.from('product_variation_table').select();
      print("Variation Response: $variationResponse");

      _products = productResponse;
      _variations = variationResponse;

      notifyListeners();
      print("Data fetched successfully.");
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  // Add product variation to cart
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

  // Remove item from cart
  void removeFromCart(int variationId) {
    _cart.removeWhere((item) => item['variation_id'] == variationId);
    notifyListeners();
  }

  // Submit sale to Supabase
  Future<void> completeSale() async {
    if (_cart.isEmpty) return;

    try {
      // ✅ Step 1: Insert into sales_table
      final saleResponse = await supabase.from('sales_table').insert({
        'total_price': _cart.fold(
            0.0, (sum, item) => sum + (item['cost'] * item['quantity'])),
        'sale_date': DateTime.now().toString().split(' ')[0], // Only date
      }).select(); // Ensure inserted data is returned

      if (saleResponse == null || saleResponse.isEmpty) {
        throw Exception('Failed to create sale: No data returned');
      }

      final saleId = saleResponse[0]['sale_id']; // ✅ Correct way to get sale_id
      print("✅ Sale created with ID: $saleId");

      // ✅ Step 2: Insert into sales_variations_table
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

        // ✅ Step 3: Reduce stock
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

      // ✅ Step 4: Clear cart & Notify
      _cart.clear();
      notifyListeners();
      print("✅ Sale completed successfully!");
    } catch (e) {
      print("❌ Error submitting sale: $e");
    }
  }
  // Future<void> completeSale() async {
  //   if (_cart.isEmpty) return;

  //   try {
  //     // Step 1: Insert the sale into the sales_table (without variations yet)
  //     final saleResponse = await supabase.from('sales_table').insert({
  //       'total_price': _cart.fold(
  //           0.0, (sum, item) => sum + (item['cost'] * item['quantity'])),
  //       'sale_date': DateTime.now().toIso8601String(),
  //     });

  //     // Check for errors in saleResponse
  //     if (saleResponse.error != null || saleResponse.data.isEmpty) {
  //       throw Exception(
  //           'Failed to create sale: ${saleResponse.error?.message}');
  //     }

  //     // Get the sale_id from the insert response
  //     final saleId = saleResponse.data[0]['sale_id'];

  //     // Step 2: Insert items into sales_variations_table to link variations to this sale
  //     for (var item in _cart) {
  //       final salesVariationResponse =
  //           await supabase.from('sales_variations_table').insert({
  //         'sale_id': saleId,
  //         'variation_id': item['variation_id'],
  //         'quantity': item['quantity'],
  //       }).select();

  //       // Debugging print statements
  //       print("Sales Variation Insert Response: $salesVariationResponse");

  //       // Check for errors in salesVariationResponse
  //       if (salesVariationResponse == null || salesVariationResponse.isEmpty) {
  //         throw Exception('Failed to insert sale variation: Response is empty');
  //       }

  //       // Step 3: Reduce stock in product_variation_table
  //       final productVariationResponse =
  //           await supabase.from('product_variation_table').update({
  //         'stock': item['stock'] - item['quantity'],
  //       }).match({'variation_id': item['variation_id']});

  //       // Check for errors in productVariationResponse
  //       if (productVariationResponse.error != null) {
  //         throw Exception(
  //             'Failed to update product variation stock: ${productVariationResponse.error?.message}');
  //       }
  //     }

  //     // Clear the cart after the sale is complete
  //     _cart.clear();
  //     notifyListeners();
  //   } catch (e) {
  //     print("Error submitting sale: $e");
  //   }
  // }
}
