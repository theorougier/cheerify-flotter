import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'HomePage.dart';

class PreferencesPage extends StatefulWidget {
  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  // Liste des thèmes disponibles
  final List<String> themes = [
    "Chien",
    "Chat",
    "Paysage",
    "Sourire",
    "Nature",
    "Espace",
    "Plage",
    "Ville",
    "Montagne",
    "Forêt",
    "Fleurs",
    "Animaux"
  ];

  // Préférences sélectionnées par l'utilisateur
  List<String> selectedThemes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choisissez vos thèmes'),
        backgroundColor: Colors.deepPurple, // Assorti à la page de connexion
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: themes.length,
                itemBuilder: (context, index) {
                  return ThemeItem(
                    theme: themes[index],
                    isSelected: selectedThemes.contains(themes[index]),
                    onSelected: () {
                      setState(() {
                        final theme = themes[index];
                        if (selectedThemes.contains(theme)) {
                          selectedThemes.remove(theme);
                        } else {
                          selectedThemes.add(theme);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: savePreferences,
              child: Text('Sauvegarder mes préférences'),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                minimumSize:
                    Size(double.infinity, 50), // Largeur pleine et hauteur fixe
              ),
            ),
          ],
        ),
      ),
    );
  }

  void savePreferences() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'preferences': selectedThemes,
      });
      // Redirection vers la page d'accueil ou affichage d'un message de confirmation
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomePage()), // Assurez-vous que HomePage est bien importée si nécessaire
        (Route<dynamic> route) => false,
      );
    }
  }
}

class ThemeItem extends StatelessWidget {
  final String theme;
  final bool isSelected;
  final VoidCallback onSelected;

  const ThemeItem({
    required this.theme,
    required this.isSelected,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.white,
          border: Border.all(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(theme,
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.deepPurple)),
        ),
      ),
    );
  }
}
