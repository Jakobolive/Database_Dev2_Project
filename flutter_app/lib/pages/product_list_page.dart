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
//     final dataProvider = Provider.of<DataProvider>(context, listen: false);
//     dataProvider.fetchProducts();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dataProvider = Provider.of<DataProvider>(context);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//           title: const Text("Product List"),
//           centerTitle: true,
//           backgroundColor: Colors.teal),
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
//                         await _showProductDetails(context, product, variation);
//                       },
//                     );
//                   }).toList(),
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushNamed(context, '/addProduct');
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.teal,
//       ),
//     );
//   }

//   Future<void> _showProductDetails(BuildContext context,
//       Map<String, dynamic> product, Map<String, dynamic> variation) async {
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
//                   // Navigate to label generation page with the variation data.
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           LabelGenerationPage(product, variation),
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
// }

// class LabelGenerationPage extends StatelessWidget {
//   final Map<String, dynamic> variation;
//   final Map<String, dynamic> product;

//   LabelGenerationPage(this.product, this.variation);

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
//             Text("${product['product_name']}"),
//             Text("${product['description']}"),
//             SizedBox(height: 20),
//             // Display variation data
//             Text("${variation['size']}"),
//             Text("\$${variation['cost']}"),
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
// }
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
    dataProvider.fetchProducts();
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
        _getIngredientsWithNutrientsForProduct(product, dataProvider);

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

  // Function to get ingredients with nutrients for a product
  // List<Map<String, dynamic>> _getIngredientsWithNutrientsForProduct(
  //     Map<String, dynamic> product, DataProvider dataProvider) {
  //   // Find related recipe and ingredients for this product
  //   var relatedRecipe = dataProvider.recipes.firstWhere(
  //       (recipe) => recipe['product_id'] == product['id'],
  //       orElse: () => <String, dynamic>{});

  //   var relatedIngredients = dataProvider.recipeIngredients
  //       .where((ingredient) => ingredient['recipe_id'] == relatedRecipe?['id'])
  //       .toList();

  //   // Fetch nutrient data for each ingredient
  //   return relatedIngredients.map((ingredient) {
  //     var relatedIngredient = dataProvider.ingredients
  //         .firstWhere((ing) => ing['id'] == ingredient['ingredient_id']);
  //     var relatedNutrientData = dataProvider.nutrientData.firstWhere(
  //         (nutrient) => nutrient['ingredient_id'] == relatedIngredient['id']);

  //     return {
  //       'ingredient': relatedIngredient,
  //       'nutrients': relatedNutrientData,
  //     };
  //   }).toList();
  // }

  // Function to get ingredients with nutrients for a product
  List<Map<String, dynamic>> _getIngredientsWithNutrientsForProduct(
      Map<String, dynamic> product, DataProvider dataProvider) {
    print(dataProvider.recipes);
    print(dataProvider.recipeIngredients);
    print(dataProvider.ingredients);
    print(dataProvider.nutrientData);
    // Find related recipe for this product
    var relatedRecipe = dataProvider.recipes.firstWhere(
      (recipe) => recipe['product_id'] == product['id'],
      orElse: () => <String, dynamic>{}, // If no recipe is found, return null
    );

    if (relatedRecipe == null) {
      print("No related recipe found for product: ${product['id']}");
      return []; // Return empty list if no related recipe is found
    }

    // Find related ingredients for this recipe
    var relatedIngredients = dataProvider.recipeIngredients
        .where((ingredient) => ingredient['recipe_id'] == relatedRecipe['id'])
        .toList();

    if (relatedIngredients.isEmpty) {
      print("No related ingredients found for recipe: ${relatedRecipe['id']}");
      return []; // Return empty list if no related ingredients are found
    }

    // Fetch nutrient data for each ingredient
    List<Map<String, dynamic>> ingredientsWithNutrients = [];

    for (var ingredient in relatedIngredients) {
      var relatedIngredient = dataProvider.ingredients.firstWhere(
        (ing) => ing['id'] == ingredient['ingredient_id'],
        orElse: () =>
            <String, dynamic>{}, // Return null if ingredient is not found
      );

      if (relatedIngredient == null) {
        print(
            "No related ingredient found for ingredient_id: ${ingredient['ingredient_id']}");
        continue; // Skip this ingredient if not found
      }

      var relatedNutrientData = dataProvider.nutrientData.firstWhere(
        (nutrient) => nutrient['ingredient_id'] == relatedIngredient['id'],
        orElse: () =>
            <String, dynamic>{}, // Return null if nutrient data is not found
      );

      if (relatedNutrientData == null) {
        print(
            "No related nutrient data found for ingredient_id: ${relatedIngredient['id']}");
        continue; // Skip this ingredient if nutrient data is not found
      }

      ingredientsWithNutrients.add({
        'ingredient': relatedIngredient,
        'nutrients': relatedNutrientData,
      });
    }

    return ingredientsWithNutrients;
  }
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
            // Display product data
            Text("${product['product_name']}", style: TextStyle(fontSize: 20)),
            Text("${product['description']}"),
            SizedBox(height: 20),
            // Display variation data
            Text("Size: ${variation['size']}", style: TextStyle(fontSize: 16)),
            Text("Price: \$${variation['cost']}",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),

            // Display nutritional values
            Text("Nutritional Information:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ..._buildNutritionalValues(),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Generate PDF
                final pdf = pw.Document();

                // Add content to the PDF
                pdf.addPage(pw.Page(
                  build: (pw.Context context) {
                    return pw.Column(
                      children: [
                        pw.Text("${product['product_name']}",
                            style: pw.TextStyle(fontSize: 18)),
                        pw.Text("${product['description']}",
                            style: pw.TextStyle(fontSize: 14)),
                        pw.SizedBox(height: 20),
                        pw.Text("${variation['size']}",
                            style: pw.TextStyle(fontSize: 16)),
                        pw.Text("\$${variation['cost']}",
                            style: pw.TextStyle(fontSize: 14)),
                        pw.SizedBox(height: 20),

                        // Add nutritional information to PDF
                        pw.Text("Nutritional Information:",
                            style: pw.TextStyle(
                                fontSize: 18, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 10),
                        ..._buildNutritionalValuesForPDF(),
                      ],
                    );
                  },
                ));

                // Save or share the PDF
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

  // Function to build a list of nutritional information for display
  List<Widget> _buildNutritionalValues() {
    List<Widget> nutritionalWidgets = [];

    for (var ingredientWithNutrient in ingredientsWithNutrients) {
      var ingredient = ingredientWithNutrient['ingredient'];
      var nutrientData = ingredientWithNutrient['nutrients'];

      // Add nutritional info to the list
      nutritionalWidgets.add(
        Text(
            "${ingredient['name']}: ${nutrientData['value']} ${nutrientData['unit']}",
            style: TextStyle(fontSize: 14)),
      );
    }
    return nutritionalWidgets;
  }

  // Function to build the nutritional information for PDF generation
  List<pw.Widget> _buildNutritionalValuesForPDF() {
    List<pw.Widget> nutritionalWidgets = [];

    for (var ingredientWithNutrient in ingredientsWithNutrients) {
      var ingredient = ingredientWithNutrient['ingredient'];
      var nutrientData = ingredientWithNutrient['nutrients'];

      // Add nutritional info to the list
      nutritionalWidgets.add(
        pw.Text(
            "${ingredient['name']}: ${nutrientData['value']} ${nutrientData['unit']}",
            style: pw.TextStyle(fontSize: 12)),
      );
    }
    return nutritionalWidgets;
  }
}
