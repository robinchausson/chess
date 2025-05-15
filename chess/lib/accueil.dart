import 'package:flutter/material.dart';
import 'globals.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  String nomJoueurBlanc = ''; 
  String nomJoueurNoir = ''; 
  String classementBlanc = '';
  String classementNoir = '';
  int selectedTime = 0;
  String selectedMode = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Globals().backgroundColor,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // En-tête
              Row(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 10, top: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/podium');
                      },
                      child: Image.asset(
                        'assets/podium.png',
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, right: 50),
                      child: Image(
                        width: 100,
                        height: 120,
                        image: Globals().logo,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Corps
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Partie Normale
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 13, right: 13),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedMode = 'normale';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Globals().backgroundColor,
                                backgroundColor: selectedMode == 'normale'
                                    ? Colors.greenAccent
                                    : Globals().blanc,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text('Partie Normale'),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Avantager Blanc / Noir
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedMode = 'blanc';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: selectedMode == 'blanc'
                                ? Colors.greenAccent
                                : Globals().bleuClair,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text('Avantager Blanc'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedMode = 'noir';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: selectedMode == 'noir'
                                ? Colors.greenAccent
                                : Globals().bleuFonce,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text('Avantager Noir'),
                        ),
                      ],
                    ),

                    // Durée
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedTime = 3;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Globals().backgroundColor,
                            backgroundColor: selectedTime == 3
                                ? Colors.greenAccent
                                : Globals().blanc,
                          ),
                          child: Text('3min'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedTime = 10;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Globals().backgroundColor,
                            backgroundColor: selectedTime == 10
                                ? Colors.greenAccent
                                : Globals().blanc,
                          ),
                          child: Text('10min'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedTime = 60;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Globals().backgroundColor,
                            backgroundColor: selectedTime == 60
                                ? Colors.greenAccent
                                : Globals().blanc,
                          ),
                          child: Text('60min'),
                        ),
                      ],
                    ),

                    // Choix pion
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          color: Globals().bleuFonce,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/gestionJoueur');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Globals().bleuFonce,
                              padding: EdgeInsets.zero,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Image(
                                    image: Globals().pionBlanc,
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 150,
                          height: 150,
                          color: Globals().bleuClair,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/gestionJoueur');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Globals().bleuClair,
                              padding: EdgeInsets.zero,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Image(
                                    image: Globals().pionNoir,
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Bouton JOUER
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                      '/jeu',
                    arguments: {
                      'joueurBlanc': nomJoueurBlanc,
                      'joueurNoir': nomJoueurNoir,
                      'classementBlanc': classementBlanc,
                      'classementNoir': classementNoir,
                      'temps': selectedTime, 
                      'mode': selectedMode,   
                  },
                );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Globals().rouge,
                  backgroundColor: Globals().blanc,
                ),
                child: Text(
                  'JOUER',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
