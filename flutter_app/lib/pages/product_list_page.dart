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
                      onTap: () async {
                        await _showProductDetails(context, product, variation);
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

  Future<void> _showProductDetails(BuildContext context,
      Map<String, dynamic> product, Map<String, dynamic> variation) async {
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
                  // Navigate to label generation page with the variation data.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LabelGenerationPage(product, variation),
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
}

class LabelGenerationPage extends StatelessWidget {
  final Map<String, dynamic> variation;
  final Map<String, dynamic> product;

  LabelGenerationPage(this.product, this.variation);

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
            Text("${product['product_name']}"),
            Text("${product['description']}"),
            SizedBox(height: 20),
            // Display variation data
            Text("${variation['size']}"),
            Text("\$${variation['cost']}"),
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
}
