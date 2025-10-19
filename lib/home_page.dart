import 'package:flutter/material.dart';
import 'personal_data_page.dart'; // ✅ Import your Personal Data Page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color maroon = Color(0xFF800000);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bottom Nav Example',
      theme: ThemeData(
        primaryColor: maroon,
      ),
      home: HomePage(), // 🔹 no const
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  static const Color maroon = Color(0xFF800000);

  // ✅ List of image asset paths
  final List<String> _iconPaths = [
    'assets/icons8-home-50.png',
    'assets/icons8-mind-map-50.png',
    'assets/icons8-growing-money-80.png',
    'assets/icons8-people-50.png',
    'assets/icons8-documents-50.png',
    'assets/icons8-settings-50.png',
  ];

  // ✅ List of labels
  final List<String> _pageTitles = [
    'Home',
    'Data',
    'Funds',
    'Panel',
    'Records',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // clean white background

      // ✅ Add AppBar with a back button
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: maroon),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PersonalDataPage(),
              ),
            );
          },
        ),
      ),

      body: const SizedBox(), // ✅ completely empty body

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, -3),
            ),
          ],
          border: const Border(
            top: BorderSide(
              color: maroon,
              width: 1.5,
            ),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: maroon,
            unselectedItemColor: maroon,
            currentIndex: 0,
            onTap: (_) {},
            items: List.generate(_pageTitles.length, (index) {
              return BottomNavigationBarItem(
                icon: Image.asset(
                  _iconPaths[index],
                  height: 28,
                  width: 28,
                  color: maroon,
                ),
                label: _pageTitles[index],
              );
            }),
          ),
        ),
      ),
    );
  }
}
