import 'package:database_project/pages/cart_page.dart';
import 'package:database_project/services/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleTrackingPage extends StatefulWidget {
  @override
  _SaleTrackingPageState createState() => _SaleTrackingPageState();
}

class _SaleTrackingPageState extends State<SaleTrackingPage> {
  @override
  void initState() {
    super.initState();
    // Call the fetchProfiles method here to load profiles when the page is first loaded.
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    dataProvider.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text("Sale Tracking"),
          centerTitle: true,
          backgroundColor: Colors.teal),
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
                      trailing: IconButton(
                        icon: Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          dataProvider.addToCart(variation);
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shopping_cart),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CartPage()));
        },
      ),
    );
  }
}
