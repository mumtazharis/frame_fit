import 'package:flutter/material.dart';
import 'package:frame_fit/pages/aboutUs_page.dart';
import 'package:frame_fit/pages/contactUs_page.dart';
import 'package:frame_fit/pages/ubahPassword_page.dart';
import 'beranda_page.dart';
import 'favorite_page.dart';
import 'camera_page.dart';
import 'profil_page.dart';

class NavbarPage extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<NavbarPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    BerandaPage(),
    FavoritePage(favoriteGlassesList: [],),
    CameraPage(),
    ProfilePage(),
    UbahPasswordPage(),
    ContactUsPage(),
    AboutUsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scan Wajah'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}