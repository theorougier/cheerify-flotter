import 'package:flutter/material.dart';
import 'dart:async';

class CoherenceCardiaqueScreen extends StatefulWidget {
  @override
  _CoherenceCardiaqueScreenState createState() =>
      _CoherenceCardiaqueScreenState();
}

class _CoherenceCardiaqueScreenState extends State<CoherenceCardiaqueScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isAnimating = false;
  String _breathPhase = "Démarrer";
  int _timer = 5 * 60 * 1000; // 5 minutes en millisecondes
  final int _animationDuration = 5000; // 5 secondes pour inspirer ou expirer
  Timer? _timerInstance; // Déclaration de la variable _timerInstance

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: _animationDuration),
      vsync: this,
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
        setState(() => _breathPhase = "Expirer");
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
        setState(() => _breathPhase = "Inspirer");
      }
    });
  }

  void _startAnimation() {
    if (!_isAnimating) {
      _animationController.forward(
          from: 0.0); // Assurez-vous de démarrer depuis le début
      _isAnimating = true;
      setState(() => _breathPhase = "Inspirer");

      // Initialiser le Timer pour décrémenter le timer toutes les secondes
      _timerInstance?.cancel(); // Annuler le Timer existant si présent
      _timerInstance = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        if (_timer <= 0) {
          _stopAnimation(); // Arrête l'animation et le Timer si le temps est écoulé
        } else {
          setState(() {
            _timer -=
                1000; // Décrémenter le timer de 1000 millisecondes (1 seconde)
          });
        }
      });
    }
  }

  void _stopAnimation() {
    if (_isAnimating) {
      _animationController.reset();
      _animationController.stop();
      _isAnimating = false;
      setState(() {
        _breathPhase = "Démarrer";
        _timer = 5 * 60 * 1000; // Réinitialiser le timer à 5 minutes
      });
      _timerInstance?.cancel(); // Arrêter le Timer
    }
  }

  String _formatTime(int milliseconds) {
    final int totalSeconds = milliseconds ~/ 1000;
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    return "${minutes}:${seconds < 10 ? "0" : ""}$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cohérence Cardiaque'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) => Transform.scale(
                scale: 1.0 + _animationController.value * 0.5, // De 1.0 à 1.5
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _breathPhase,
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(_formatTime(_timer),
                style: TextStyle(fontSize: 20, color: Colors.black)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isAnimating ? _stopAnimation : _startAnimation,
              child: Text(_isAnimating ? 'Arrêter' : 'Commencer'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timerInstance?.cancel(); // Nettoyer le Timer
    super.dispose();
  }
}
