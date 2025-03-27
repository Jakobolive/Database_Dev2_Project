import 'package:database_project/services/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  @override
  void initState() {
    super.initState();
    // Call the fetchProfiles method here to load profiles when the page is first loaded.
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    dataProvider.fetchProducts();
  }

  // UI Fields
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _recipeDescController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  Future<void> _addProduct(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);

      // Insert into the recipe table first
      final newRecipeData = {
        'recipe_name': _recipeNameController.text,
        'recipe_desc': _recipeDescController.text,
      };

      final recipeId = await dataProvider.addRecipe(newRecipeData);

      if (recipeId != null) {
        // Insert into the product table next, linking to the recipe_id
        final newProductData = {
          'product_name': _recipeNameController.text,
          'description': _recipeDescController.text,
          'recipe_id': recipeId,
        };

        final productId = await dataProvider.addProduct(newProductData);

        if (productId != null) {
          // Finally, insert into the product_variation table
          final newVariationData = {
            'product_id': productId,
            'size': _sizeController.text,
            'cost': double.parse(_priceController.text),
            'stock': int.parse(_stockController.text),
          };

          await dataProvider.addProductVariation(newVariationData);
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Add Product"), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _recipeNameController,
                decoration: InputDecoration(labelText: "Product Name"),
                validator: (value) =>
                    value!.isEmpty ? "Enter product name" : null,
              ),
              TextFormField(
                controller: _recipeDescController,
                decoration: InputDecoration(labelText: "Product Description"),
                validator: (value) =>
                    value!.isEmpty ? "Enter product description" : null,
              ),
              TextFormField(
                controller: _sizeController,
                decoration: InputDecoration(labelText: "Size"),
                validator: (value) => value!.isEmpty ? "Enter size" : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter price" : null,
              ),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: "Stock"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Enter stock quantity" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _addProduct(context),
                child: Text("Add Product"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
