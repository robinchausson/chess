import 'package:flutter/material.dart';

class GestionJoueur extends StatefulWidget {
  const GestionJoueur({super.key});


  @override
  State<GestionJoueur> createState() => _GestionJoueurState();
}

class _GestionJoueurState extends State<GestionJoueur> {
  

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            
          ],
        ),
      ),
    );
  }
}
