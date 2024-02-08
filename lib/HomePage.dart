import 'package:flutter/material.dart';

import 'SettingsScreenPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Index pour suivre l'onglet sélectionné

  // Liste des widgets à afficher pour chaque onglet
  static List<Widget> _widgetOptions = <Widget>[
    Text('Page d\'accueil',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    SettingsScreen(), // Écran des paramètres à définir
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Mettre à jour l'index avec l'onglet sélectionné
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: Center(
        // Afficher le widget sélectionné
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
