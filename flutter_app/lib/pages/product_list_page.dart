import 'package:database_project/pages/cart_page.dart';
import 'package:database_project/services/data_provider.dart';
import 'package:database_project/pages/add_product_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Product List"),
        centerTitle: true,
        backgroundColor: Colors.teal
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
                        await _showProductDetails(context, variation);
                      },
                    );
                  }).toList(),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addProduct'); 
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.teal,
            ),
    );
  }

  Future<void> _showProductDetails(
      BuildContext context, Map<String, dynamic> variation) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(variation['size']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Price: \$${variation['cost']}"),
              Text("Stock: ${variation['stock']}"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); 
                },
                child: Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }
}