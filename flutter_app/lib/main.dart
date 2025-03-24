import 'package:database_project/services/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:database_project/pages/add_product_page.dart';
import 'package:database_project/pages/cart_page.dart';
import 'package:database_project/pages/home_page.dart';
import 'package:database_project/pages/label_preview_page.dart';
import 'package:database_project/pages/login_page.dart';
import 'package:database_project/pages/product_list_page.dart';
import 'package:database_project/pages/reporting_page.dart';
import 'package:database_project/pages/sale_tracking_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is ready

  await Supabase.initialize(
    url: 'https://nqcserhbdtubmzrgcpeb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5xY3NlcmhiZHR1Ym16cmdjcGViIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE4MDM5NjcsImV4cCI6MjA1NzM3OTk2N30.7uJL2OWMvxJaFbwVC7oHte8_jdbjSuHjIfVUP09lQZc',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              DataProvider()..fetchProducts(), // Fetch after Supabase init
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      title: "Aunt Rosie's Kitchen",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login', // Start at login page
      routes: {
        '/add-product': (context) => AddProductPage(),
        '/cart': (context) => CartPage(),
        // '/': (context) => HomePage(),
        '/label-preview': (context) => LabelPreviewPage(),
        '/login': (context) => LoginPage(),
        //'/product-list': (context) => ProductListPage(),
        //'/reports': (context) => ReportingPage(),
        '/': (context) => MainScreen(),
      },
    );
  }
}

// Main Navigation with Bottom Navigation Bar
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    SaleTrackingPage(),
    ProductListPage(),
    ReportingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Sales'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Products'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Reports'),
        ],
      ),
    );
  }
}
