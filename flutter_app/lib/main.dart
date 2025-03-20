import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:database_project/pages/add_product_page.dart';
import 'package:database_project/pages/home_page.dart';
import 'package:database_project/pages/label_preview_page.dart';
import 'package:database_project/pages/login_page.dart';
import 'package:database_project/pages/product_list_page.dart';

void main() async {
  runApp(const MyApp());
  await Supabase.initialize(
    url: 'https://enwbbyztboyashdtxocf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5xY3NlcmhiZHR1Ym16cmdjcGViIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE4MDM5NjcsImV4cCI6MjA1NzM3OTk2N30.7uJL2OWMvxJaFbwVC7oHte8_jdbjSuHjIfVUP09lQZc',
  );
}

// final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      title: 'URent App Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login', // Start at login page
      routes: {
        '/add-product': (context) => AddProductPage(),
        '/': (context) => HomePage(),
        '/label-preview': (context) => LabelPreviewPage(),
        '/login': (context) => LoginPage(),
        '/product-list': (context) => ProductListPage(),
      },
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false, // Removes the debug banner
//       title: 'URent App Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       initialRoute: '/login', // Start at login page
//       routes: {
// '/login': (context) => LoginPage(),
// '/signup': (context) => SignUpPage(),
// '/home': (context) => MainScreen(),
// '/build-profile': (context) => BuildProfilePage(),
// '/matched': (context) => MatchPopupPage(
//       matchName: 'John',
//       matchProfileImage: '.', // Placeholder
//     ),
// '/edit-profile': (context) => EditProfilePage(),
//       },
//     );
//   }
// }

// // Main Navigation with Bottom Navigation Bar
// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     // SwipePage(), // Replacing the recursive MainScreen() call
//     // MessengerApp(),
//     // ProfilePage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//     );
//   }
// }
