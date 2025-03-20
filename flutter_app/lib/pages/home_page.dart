import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text("Dashboard"),
          centerTitle: true,
          backgroundColor: Colors.teal),
    );
  }
}
