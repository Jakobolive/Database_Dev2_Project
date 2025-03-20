import 'package:flutter/material.dart';

class AddProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text("Add Product"),
          centerTitle: true,
          backgroundColor: Colors.teal),
    );
  }
}
