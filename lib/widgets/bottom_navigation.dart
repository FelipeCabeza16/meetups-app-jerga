import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text('Inicio')),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Perfil')),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text('Configuración'))
        ]);
  }
}
