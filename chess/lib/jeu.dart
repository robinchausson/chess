import 'package:flutter/material.dart';

class Jeu extends StatefulWidget {
  const Jeu({super.key});



  @override
  State<Jeu> createState() => _JeuState();
}

class _JeuState extends State<Jeu> {
  

  

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
