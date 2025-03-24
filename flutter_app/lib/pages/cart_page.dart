import 'package:database_project/services/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: dataProvider.cart.isEmpty
          ? Center(child: Text("Your cart is empty"))
          : ListView.builder(
              itemCount: dataProvider.cart.length,
              itemBuilder: (context, index) {
                final item = dataProvider.cart[index];

                return ListTile(
                  title: Text("${item['size']} - \$${item['cost']}"),
                  subtitle: Text("Quantity: ${item['quantity']}"),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      dataProvider.removeFromCart(item['variation_id']);
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Total: \$${dataProvider.totalPrice}",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await dataProvider.completeSale();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Sale completed!")));

                // Refresh Products
                dataProvider.fetchProducts();
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Text("Complete Sale"),
            ),
          ],
        ),
      ),
    );
  }
}
