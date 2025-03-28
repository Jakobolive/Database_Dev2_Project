// import 'package:database_project/services/data_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/pdf.dart';
// import 'package:printing/printing.dart';

// class ProductListPage extends StatefulWidget {
//   @override
//   _ProductListPageState createState() => _ProductListPageState();
// }

// class _ProductListPageState extends State<ProductListPage> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch products from the data provider
//     final dataProvider = Provider.of<DataProvider>(context, listen: false);
//     dataProvider.fetchProducts();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dataProvider = Provider.of<DataProvider>(context);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Product List"),
//         centerTitle: true,
//         backgroundColor: Colors.teal,
//       ),
//       body: dataProvider.products.isEmpty
//           ? Center(child: Text("No products found or still loading..."))
//           : ListView.builder(
//               itemCount: dataProvider.products.length,
//               itemBuilder: (context, index) {
//                 final product = dataProvider.products[index];
//                 final variations = dataProvider.variations
//                     .where((varItem) =>
//                         varItem['product_id'] == product['product_id'])
//                     .toList();

//                 return ExpansionTile(
//                   title: Text(product['product_name']),
//                   children: variations.map((variation) {
//                     return ListTile(
//                       title:
//                           Text("${variation['size']} - \$${variation['cost']}"),
//                       subtitle: Text("Stock: ${variation['stock']}"),
//                       onTap: () async {
//                         // Show product details and generate label
//                         await _showProductDetails(
//                             context, product, variation, dataProvider);
//                       },
//                     );
//                   }).toList(),
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to add product page
//           Navigator.pushNamed(context, '/addProduct');
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.teal,
//       ),
//     );
//   }

//   Future<void> _showProductDetails(
//       BuildContext context,
//       Map<String, dynamic> product,
//       Map<String, dynamic> variation,
//       DataProvider dataProvider) async {
//     // Fetch the ingredientsWithNutrients for this product
//     final ingredientsWithNutrients =
//         _getIngredientsWithNutrientsForProduct(product, dataProvider);

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(product['product_name'] + ' ' + variation['size']),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Text("Description: ${product['description']}"),
//               Text("Price: \$${variation['cost']}"),
//               Text("Stock: ${variation['stock']}"),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   // Navigate to label generation page with the variation data and nutritional data.
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => LabelGenerationPage(
//                           product, variation, ingredientsWithNutrients),
//                     ),
//                   );
//                 },
//                 child: const Text("Generate Label"),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // Function to get ingredients with nutrients for a product
// //   List<Map<String, dynamic>> _getIngredientsWithNutrientsForProduct(
// //       Map<String, dynamic> product, DataProvider dataProvider) {
// //     // Find related recipe for this product
// //     var relatedRecipe = dataProvider.recipes.firstWhere(
// //       (recipe) =>
// //           recipe['recipe_id'] ==
// //           product['recipe_id'], // Ensure key matches your schema
// //       orElse: () => {},
// //     );

// //     if (relatedRecipe.isEmpty) {
// //       print("No related recipe found for product: ${product['product_id']}");
// //       return [];
// //     }

// //     // Find related ingredients for this recipe
// //     var relatedIngredients = dataProvider.recipeIngredients
// //         .where((ingredient) =>
// //             ingredient['recipe_id'] == relatedRecipe['recipe_id'])
// //         .toList();

// //     if (relatedIngredients.isEmpty) {
// //       print(
// //           "No related ingredients found for recipe: ${relatedRecipe['recipe_id']}");
// //       return [];
// //     }

// //     // Fetch nutrient data for each ingredient
// //     List<Map<String, dynamic>> ingredientsWithNutrients = [];

// //     for (var ingredient in relatedIngredients) {
// //       var relatedIngredient = dataProvider.ingredients.firstWhere(
// //         (ing) => ing['ingredient_id'] == ingredient['ingredient_id'],
// //         orElse: () => {},
// //       );

// //       if (relatedIngredient.isEmpty) {
// //         print(
// //             "No related ingredient found for ingredient_id: ${ingredient['ingredient_id']}");
// //         continue;
// //       }

// //       // Find all nutrient data entries for the ingredient
// //       var relatedNutrientData = dataProvider.nutrientData
// //           .where((nutrient) =>
// //               nutrient['nutrient_id'] == relatedIngredient['nutrient_id'])
// //           .toList();

// //       if (relatedNutrientData.isEmpty) {
// //         print(
// //             "No related nutrient data found for nutrient_id: ${relatedIngredient['nutrient_id']}");
// //         continue;
// //       }

// //       ingredientsWithNutrients.add({
// //         'ingredient': relatedIngredient,
// //         'nutrients': relatedNutrientData,
// //       });
// //     }

// //     return ingredientsWithNutrients;
// //   }
// // }
// // Function to get ingredients with nutrients for a product
//   List<Map<String, dynamic>> _getIngredientsWithNutrientsForProduct(
//       Map<String, dynamic> product, DataProvider dataProvider) {
//     // Check if the product has a valid recipe_id
//     if (product['recipe_id'] == null || product['recipe_id'] == '') {
//       print("No recipe ID for product: ${product['product_id']}");
//       return [];
//     }
//     var relatedRecipe = dataProvider.recipes.firstWhere(
//       (recipe) =>
//           recipe['recipe_id'] == product['recipe_id'], // Ensure key matches your schema
//       orElse: () => {},
//     );

//     if (relatedRecipe.isEmpty) {
//       print("No related recipe found for product: ${product['product_id']}");
//       return [];
//     }

//     // Find related ingredients for this recipe
//     var relatedIngredients = dataProvider.recipeIngredients
//         .where((ingredient) =>
//             ingredient['ingredient_id'] == relatedRecipe['ingredient_id'])
//         .toList();

//     if (relatedIngredients.isEmpty) {
//       print(
//           "No related ingredients found for recipe: ${relatedRecipe['recipe_id']}");
//       return [];
//     }

//     // Fetch nutrient data for each ingredient
//     List<Map<String, dynamic>> ingredientsWithNutrients = [];

//     for (var ingredient in relatedIngredients) {
//       var relatedIngredient = dataProvider.ingredients.firstWhere(
//         (ing) => ing['ingredient_id'] == ingredient['ingredient_id'],
//         orElse: () => {},
//       );

//       if (relatedIngredient.isEmpty) {
//         print(
//             "No related ingredient found for ingredient_id: ${ingredient['ingredient_id']}");
//         continue;
//       }

//       // Find nutrient data from API result
//       var relatedNutrientData = dataProvider.nutrientData
//           .where((nutrient) =>
//               nutrient['ingredient_id'] == relatedIngredient['ingredient_id'])
//           .toList();

//       if (relatedNutrientData.isEmpty) {
//         print(
//             "No related nutrient data found for ingredient_id: ${relatedIngredient['ingredient_id']}");
//         continue;
//       }

//       ingredientsWithNutrients.add({
//         'ingredient': relatedIngredient,
//         'nutrients': relatedNutrientData,
//       });
//     }

//     return ingredientsWithNutrients;
//   }
// }

// class LabelGenerationPage extends StatelessWidget {
//   final Map<String, dynamic> variation;
//   final Map<String, dynamic> product;
//   final List<Map<String, dynamic>>
//       ingredientsWithNutrients; // Nutritional data for the product

//   LabelGenerationPage(
//       this.product, this.variation, this.ingredientsWithNutrients);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:
//             Text("Label for ${product['product_name']}: ${variation['size']}"),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Display product data
//             Text("${product['product_name']}", style: TextStyle(fontSize: 20)),
//             Text("${product['description']}"),
//             SizedBox(height: 20),
//             // Display variation data
//             Text("Size: ${variation['size']}", style: TextStyle(fontSize: 16)),
//             Text("Price: \$${variation['cost']}",
//                 style: TextStyle(fontSize: 16)),
//             SizedBox(height: 20),

//             // Display nutritional values
//             Text("Nutritional Information:",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),
//             ..._buildNutritionalValues(),

//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 // Generate PDF
//                 final pdf = pw.Document();

//                 // Add content to the PDF
//                 pdf.addPage(pw.Page(
//                   build: (pw.Context context) {
//                     return pw.Column(
//                       children: [
//                         pw.Text("${product['product_name']}",
//                             style: pw.TextStyle(fontSize: 18)),
//                         pw.Text("${product['description']}",
//                             style: pw.TextStyle(fontSize: 14)),
//                         pw.SizedBox(height: 20),
//                         pw.Text("${variation['size']}",
//                             style: pw.TextStyle(fontSize: 16)),
//                         pw.Text("\$${variation['cost']}",
//                             style: pw.TextStyle(fontSize: 14)),
//                         pw.SizedBox(height: 20),

//                         // Add nutritional information to PDF
//                         pw.Text("Nutritional Information:",
//                             style: pw.TextStyle(
//                                 fontSize: 18, fontWeight: pw.FontWeight.bold)),
//                         pw.SizedBox(height: 10),
//                         ..._buildNutritionalValuesForPDF(),
//                       ],
//                     );
//                   },
//                 ));

//                 // Save or share the PDF
//                 await Printing.layoutPdf(
//                   onLayout: (PdfPageFormat format) async => pdf.save(),
//                 );

//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: Text(
//                         "Label generated for ${product['product_name']}: ${variation['size']}")));
//               },
//               child: Text("Print Label"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Function to build a list of nutritional information for display
//   List<Widget> _buildNutritionalValues() {
//     List<Widget> nutritionalWidgets = [];

//     for (var ingredientWithNutrient in ingredientsWithNutrients) {
//       var ingredient = ingredientWithNutrient['ingredient'];
//       var nutrients = ingredientWithNutrient['nutrients'];

//       nutritionalWidgets.add(
//         Text("${ingredient['ingredient_name']}",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//       );

//       for (var nutrient in nutrients) {
//         nutritionalWidgets.add(
//           Text(
//             "Calories: ${nutrient['calories'] ?? 'N/A'} kcal\n"
//             "Protein: ${nutrient['protein'] ?? 'N/A'} g\n"
//             "Carbohydrates: ${nutrient['carbohydrates'] ?? 'N/A'} g\n"
//             "Fat: ${nutrient['fat'] ?? 'N/A'} g\n"
//             "Sugar: ${nutrient['sugar'] ?? 'N/A'} g\n"
//             "Fiber: ${nutrient['fiber'] ?? 'N/A'} g\n"
//             "Sodium: ${nutrient['sodium'] ?? 'N/A'} mg\n"
//             "Cholesterol: ${nutrient['cholesterol'] ?? 'N/A'} mg",
//             style: TextStyle(fontSize: 14),
//           ),
//         );
//       }
//       nutritionalWidgets.add(SizedBox(height: 10));
//     }
//     return nutritionalWidgets;
//   }

// // Function to build the nutritional information for PDF generation
//   List<pw.Widget> _buildNutritionalValuesForPDF() {
//     List<pw.Widget> nutritionalWidgets = [];

//     for (var ingredientWithNutrient in ingredientsWithNutrients) {
//       var ingredient = ingredientWithNutrient['ingredient'];
//       var nutrients = ingredientWithNutrient['nutrients'];

//       nutritionalWidgets.add(
//         pw.Text("${ingredient['ingredient_name']}",
//             style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
//       );

//       for (var nutrient in nutrients) {
//         nutritionalWidgets.add(
//           pw.Text(
//             "Calories: ${nutrient['calories'] ?? 'N/A'} kcal\n"
//             "Protein: ${nutrient['protein'] ?? 'N/A'} g\n"
//             "Carbohydrates: ${nutrient['carbohydrates'] ?? 'N/A'} g\n"
//             "Fat: ${nutrient['fat'] ?? 'N/A'} g\n"
//             "Sugar: ${nutrient['sugar'] ?? 'N/A'} g\n"
//             "Fiber: ${nutrient['fiber'] ?? 'N/A'} g\n"
//             "Sodium: ${nutrient['sodium'] ?? 'N/A'} mg\n"
//             "Cholesterol: ${nutrient['cholesterol'] ?? 'N/A'} mg",
//             style: pw.TextStyle(fontSize: 12),
//           ),
//         );
//       }
//       nutritionalWidgets.add(pw.SizedBox(height: 10));
//     }
//     return nutritionalWidgets;
//   }
// }
import 'package:database_project/models/data_model.dart';
import 'package:database_project/services/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  void initState() {
    super.initState();
    // Fetch products from the data provider
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    dataProvider.fetchProductsData();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Product List"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: dataProvider.products.isEmpty
          ? Center(child: Text("No products found or still loading..."))
          : ListView.builder(
              itemCount: dataProvider.products.length,
              itemBuilder: (context, index) {
                final product = dataProvider.products[index];
                final variations = dataProvider.variations
                    .where((varItem) =>
                        varItem['product_id'] == product['product_id'])
                    .toList();

                return ExpansionTile(
                  title: Text(product['product_name']),
                  children: variations.map((variation) {
                    return ListTile(
                      title:
                          Text("${variation['size']} - \$${variation['cost']}"),
                      subtitle: Text("Stock: ${variation['stock']}"),
                      onTap: () async {
                        // Show product details and generate label
                        await _showProductDetails(
                            context, product, variation, dataProvider);
                      },
                    );
                  }).toList(),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add product page
          Navigator.pushNamed(context, '/addProduct');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Future<void> _showProductDetails(
      BuildContext context,
      Map<String, dynamic> product,
      Map<String, dynamic> variation,
      DataProvider dataProvider) async {
    // Fetch the ingredientsWithNutrients for this product
    final ingredientsWithNutrients =
        await dataProvider.getIngredientsWithNutrientsForProduct(product);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product['product_name'] + ' ' + variation['size']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Description: ${product['description']}"),
              Text("Price: \$${variation['cost']}"),
              Text("Stock: ${variation['stock']}"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to label generation page with the variation data and nutritional data.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LabelGenerationPage(
                          product, variation, ingredientsWithNutrients),
                    ),
                  );
                },
                child: const Text("Generate Label"),
              ),
            ],
          ),
        );
      },
    );
  }

//   List<Map<String, dynamic>> _getIngredientsWithNutrientsForProduct(
//       Map<String, dynamic> product, DataProvider dataProvider) {
//     // Check if the product has a valid recipe_id
//     if (product['recipe_id'] == null || product['recipe_id'] == '') {
//       print("No recipe ID for product: ${product['product_id']}");
//       return [];
//     }
//     var relatedRecipe = dataProvider.recipes.firstWhere(
//       (recipe) =>
//           recipe['recipe_id'] == product['recipe_id'], // Ensure key matches your schema
//       orElse: () => {},
//     );

//     if (relatedRecipe.isEmpty) {
//       print("No related recipe found for product: ${product['product_id']}");
//       return [];
//     }

//     // Find related ingredients for this recipe
//     var relatedIngredients = dataProvider.recipeIngredients
//         .where((ingredient) =>
//             ingredient['ingredient_id'] == relatedRecipe['ingredient_id'])
//         .toList();

//     if (relatedIngredients.isEmpty) {
//       print(
//           "No related ingredients found for recipe: ${relatedRecipe['recipe_id']}");
//       return [];
//     }

//     // Fetch nutrient data for each ingredient
//     List<Map<String, dynamic>> ingredientsWithNutrients = [];

//     for (var ingredient in relatedIngredients) {
//       var relatedIngredient = dataProvider.ingredients.firstWhere(
//         (ing) => ing['ingredient_id'] == ingredient['ingredient_id'],
//         orElse: () => {},
//       );

//       if (relatedIngredient.isEmpty) {
//         print(
//             "No related ingredient found for ingredient_id: ${ingredient['ingredient_id']}");
//         continue;
//       }

//       // Find nutrient data from API result
//       var relatedNutrientData = dataProvider.nutrientData
//           .where((nutrient) =>
//               nutrient['ingredient_id'] == relatedIngredient['ingredient_id'])
//           .toList();

//       if (relatedNutrientData.isEmpty) {
//         print(
//             "No related nutrient data found for ingredient_id: ${relatedIngredient['ingredient_id']}");
//         continue;
//       }

//       ingredientsWithNutrients.add({
//         'ingredient': relatedIngredient,
//         'nutrients': relatedNutrientData,
//       });
//     }

//     return ingredientsWithNutrients;
//   }
}

class LabelGenerationPage extends StatelessWidget {
  final Map<String, dynamic> variation;
  final Map<String, dynamic> product;
  final List<Map<String, dynamic>>
      ingredientsWithNutrients; // Nutritional data for the product

  LabelGenerationPage(
      this.product, this.variation, this.ingredientsWithNutrients);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Label for ${product['product_name']}: ${variation['size']}"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${product['product_name']}", style: TextStyle(fontSize: 20)),
            Text("${product['description']}"),
            SizedBox(height: 20),
            Text("Size: ${variation['size']}", style: TextStyle(fontSize: 16)),
            Text("Price: \$${variation['cost']}",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text("Nutritional Information:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            // Using FutureBuilder to handle async data loading
            FutureBuilder<Map<String, dynamic>>(
              future: _buildNutritionalValues(ingredientsWithNutrients),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final nutritionalData = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _displayNutritionalValues(nutritionalData),
                  );
                }
              },
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final nutritionalData =
                    await _buildNutritionalValues(ingredientsWithNutrients);
                final pdf = pw.Document();
                pdf.addPage(pw.Page(
                  build: (pw.Context context) {
                    return pw.Column(
                      children: _buildNutritionalValuesForPDF(nutritionalData),
                    );
                  },
                ));

                await Printing.layoutPdf(
                  onLayout: (PdfPageFormat format) async => pdf.save(),
                );

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Label generated for ${product['product_name']}: ${variation['size']}")));
              },
              child: Text("Print Label"),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _buildNutritionalValues(
      List<Map<String, dynamic>> ingredientsWithNutrients) async {
    double totalCalories = 0, totalProtein = 0, totalCarbohydrates = 0;
    double totalFat = 0, totalSugar = 0, totalFiber = 0;
    double totalSodium = 0, totalCholesterol = 0;
    List<String> ingredientList = [];

    for (var ingredient in ingredientsWithNutrients) {
      ingredientList.add(ingredient['ingredient_name'] ?? 'Unknown Ingredient');
      totalCalories += ingredient['calories'] ?? 0;
      totalProtein += ingredient['protein'] ?? 0;
      totalCarbohydrates += ingredient['carbohydrates'] ?? 0;
      totalFat += ingredient['fat'] ?? 0;
      totalSugar += ingredient['sugar'] ?? 0;
      totalFiber += ingredient['fiber'] ?? 0;
      totalSodium += ingredient['sodium'] ?? 0;
      totalCholesterol += ingredient['cholesterol'] ?? 0;
    }

    return {
      'ingredient_names': ingredientList,
      'total_calories': totalCalories,
      'total_protein': totalProtein,
      'total_carbohydrates': totalCarbohydrates,
      'total_fat': totalFat,
      'total_sugar': totalSugar,
      'total_fiber': totalFiber,
      'total_sodium': totalSodium,
      'total_cholesterol': totalCholesterol,
    };
  }

  List<Widget> _displayNutritionalValues(Map<String, dynamic> nutritionalData) {
    return [
      Text("Ingredients: ${nutritionalData['ingredient_names'].join(', ')}"),
      Text("Total Calories: ${nutritionalData['total_calories']} kcal"),
      Text("Total Protein: ${nutritionalData['total_protein']} g"),
      Text("Total Carbohydrates: ${nutritionalData['total_carbohydrates']} g"),
      Text("Total Fat: ${nutritionalData['total_fat']} g"),
      Text("Total Sugar: ${nutritionalData['total_sugar']} g"),
      Text("Total Fiber: ${nutritionalData['total_fiber']} g"),
      Text("Total Sodium: ${nutritionalData['total_sodium']} mg"),
      Text("Total Cholesterol: ${nutritionalData['total_cholesterol']} mg"),
    ];
  }

  List<pw.Widget> _buildNutritionalValuesForPDF(
      Map<String, dynamic> nutritionalData) {
    return [
      pw.Text("Ingredients: ${nutritionalData['ingredient_names'].join(', ')}"),
      pw.Text("Total Calories: ${nutritionalData['total_calories']} kcal"),
      pw.Text("Total Protein: ${nutritionalData['total_protein']} g"),
      pw.Text(
          "Total Carbohydrates: ${nutritionalData['total_carbohydrates']} g"),
      pw.Text("Total Fat: ${nutritionalData['total_fat']} g"),
      pw.Text("Total Sugar: ${nutritionalData['total_sugar']} g"),
      pw.Text("Total Fiber: ${nutritionalData['total_fiber']} g"),
      pw.Text("Total Sodium: ${nutritionalData['total_sodium']} mg"),
      pw.Text("Total Cholesterol: ${nutritionalData['total_cholesterol']} mg"),
    ];
  }
}
