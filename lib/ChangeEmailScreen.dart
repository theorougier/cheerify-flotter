import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangeEmailScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Clé globale pour le formulaire

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Changer l\'email'),
        backgroundColor: Colors.deepPurple, // Consistent AppBar color
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Nouvel email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un email';
                    } else if (!value.contains('@')) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        try {
                          await user.updateEmail(_emailController.text);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Email changé avec succès.')));
                          Navigator.of(context).pop();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Erreur lors du changement d\'email. Vérifiez que vous êtes connecté récemment.')));
                          // Pour les erreurs comme l'authentification récente requise, envisagez de rediriger l'utilisateur vers un écran de reconnexion.
                        }
                      }
                    }
                  },
                  child: Text('Changer'),
                  style: ElevatedButton.styleFrom(
                    primary:
                        Colors.deepPurple, // Harmoniser la couleur du bouton
                    onPrimary: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
