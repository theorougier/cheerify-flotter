import 'package:cheerify_flutter/ChangeEmailScreen.dart';
import 'package:cheerify_flutter/ChangePasswordScreen.dart';
import 'package:cheerify_flutter/ChangeUsernameScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Assurez-vous d'importer FirebaseAuth

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Changer d\'username'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangeUsernameScreen()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.mail),
          title: Text('Changer d\'email'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangeEmailScreen()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.lock),
          title: Text('Changer de mot de passe'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app, color: Colors.red),
          title: Text('Déconnexion', style: TextStyle(color: Colors.red)),
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
      ],
    );
  }
}
