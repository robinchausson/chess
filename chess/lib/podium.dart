import 'package:flutter/material.dart';

class Podium extends StatefulWidget {
  const Podium({super.key});


  @override
  State<Podium> createState() => _PodiumState();
}

class _PodiumState extends State<Podium> {
  

  

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
