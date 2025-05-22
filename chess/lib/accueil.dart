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
  String selectedMode = 'normale'; // normale, blanc, noir
  int selectedTime = 3; // 3, 10, 60

  Map<String, dynamic>? joueur1;
  Map<String, dynamic>? joueur2;

  Future<void> selectionnerJoueur(bool estJoueur1) async {
    final joueur = await Navigator.pushNamed(context, '/gestionJoueur');
    if (joueur != null && joueur is Map<String, dynamic>) {
      setState(() {
        if (estJoueur1) {
          joueur1 = joueur;
        } else {
          joueur2 = joueur;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Globals().backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // En-tête avec podium à gauche et logo parfaitement centré
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                Align(
                  alignment: Alignment.centerLeft,
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
                Center(
                  child: Container(
                  height: 120,
                  width: 140,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                    image: const AssetImage('assets/logo-echec.png'),
                    fit: BoxFit.contain,
                    ),
                  ),
                  ),
                ),
                ],
              ),
              ),

              SizedBox(height: 20),

              // Corps
              Expanded(
                child: Column(
                    children: [
                    // Partie Normale
                    Row(
                      children: [
                      Expanded(
                        child: Padding(
                        padding: EdgeInsets.only(left: 13, right: 13, bottom: 10, top: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
                            child: Text(
                            'Mode de jeu',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Globals().blanc,
                            ),
                            ),
                          ),
                            SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                              setState(() {
                                selectedMode = 'normale';
                              });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: selectedMode == 'normale'
                                ? Globals().blanc
                                : Globals().backgroundColor,
                                backgroundColor: selectedMode == 'normale'
                                ? Globals().rouge
                                : Globals().blanc,
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14), // Ajout du padding vertical
                              ),
                              child: Text('Partie Normale'),
                            ),
                            ),
                          ],
                        ),
                        ),
                      ),
                      ],
                    ),

                    // Avantager Blanc / Noir
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: ElevatedButton(
                          onPressed: () {
                          setState(() {
                            selectedMode = 'blanc';
                          });
                          },
                          style: ElevatedButton.styleFrom(
                          foregroundColor: Globals().blanc,
                          backgroundColor: selectedMode == 'blanc'
                            ? Globals().rouge
                            : Globals().bleuClair,
                          padding: EdgeInsets.symmetric(
                            horizontal: 0, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          ),
                          child: Text('Avantagé Blanc'),
                        ),
                        ),
                        SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: ElevatedButton(
                          onPressed: () {
                          setState(() {
                            selectedMode = 'noir';
                          });
                          },
                          style: ElevatedButton.styleFrom(
                          foregroundColor: Globals().blanc,
                          backgroundColor: selectedMode == 'noir'
                            ? Globals().rouge
                            : Globals().bleuFonce,
                          padding: EdgeInsets.symmetric(
                            horizontal: 0, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          ),
                          child: Text('Avantagé Noir'),
                        ),
                        ),
                      ],
                      ),
                    ),

                    // Titre durée
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, left: 16.0),
                      child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Temps de jeu',
                        style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Globals().blanc,
                        ),
                      ),
                      ),
                    ),

                    // Durée
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.29,
                          child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                            selectedTime = 3;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: selectedTime == 3
                              ? Globals().blanc
                              : Globals().backgroundColor,
                            backgroundColor: selectedTime == 3
                              ? Globals().rouge
                              : Globals().blanc,
                              padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('3min'),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.29,
                          child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                            selectedTime = 10;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: selectedTime == 10
                              ? Globals().blanc
                              : Globals().backgroundColor,
                            backgroundColor: selectedTime == 10
                              ? Globals().rouge
                              : Globals().blanc,
                              padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('10min'),
                          
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.29,
                          child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                            selectedTime = 60;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: selectedTime == 60
                              ? Globals().blanc
                              : Globals().backgroundColor,
                            backgroundColor: selectedTime == 60
                              ? Globals().rouge
                              : Globals().blanc,
                              padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('60min'),
                          ),
                        ),
                        ],
                        ),
                      ),

                    // Titre joueurs
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, left: 16.0),
                      child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Qui joue ?',
                        style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Globals().blanc,
                        ),
                      ),
                      ),
                    ),

                    // Choix des joueurs
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Globals().bleuFonce,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                          selectionnerJoueur(true); // joueur1
                          },
                          style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          ),
                          child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                            Image(
                              image: Globals().pionBlanc,
                              width: 40,
                              height: 40,
                            ),
                            if (joueur1 != null)
                              Padding(
                              padding: EdgeInsets.only(top: 20),
                                child: Column(
                                children: [
                                  Text(
                                  joueur1!['pseudo'],
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                  joueur1!['classement'] != null
                                    ? 'Classement: ${joueur1!['classement']}'
                                    : 'null',
                                  style: TextStyle(color: Colors.white70, fontSize: 14),
                                  ),
                                ],
                                ),
                              ),
                            if (joueur1 == null)
                              Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                'Sélectionner',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              ),
                            ],
                          ),
                          ),
                        ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Globals().bleuClair,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                          selectionnerJoueur(false); // joueur2
                          },
                          style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          ),
                          child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                            Image(
                              image: Globals().pionNoir,
                              width: 40,
                              height: 40,
                            ),
                            if (joueur2 != null)
                              Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                Text(
                                  joueur2!['pseudo'],
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  joueur2!['classement'] != null
                                    ? 'Classement: ${joueur2!['classement']}'
                                    : 'null',
                                  style: TextStyle(color: Colors.white70, fontSize: 14),
                                ),
                                ],
                              ),
                              ),
                            if (joueur2 == null)
                              Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                'Sélectionner',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              ),
                            ],
                          ),
                          ),
                        ),
                        ),
                      ),
                      ],
                    ),
                    ],
                ),
              ),

              // Bouton JOUER
                Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                    context,
                    '/jeu',
                    arguments: {
                      'joueurBlanc': joueur1!['pseudo'],
                      'joueurNoir': joueur2!['pseudo'],
                      'classementBlanc': joueur1!['classement'],
                      'classementNoir': joueur2!['classement'],
                      'temps': selectedTime,
                      'mode': selectedMode,
                    },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Globals().rouge,
                    backgroundColor: Globals().blanc,
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'JOUER',
                    style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Globals().rouge,
                    ),
                  ),
                  ),
                ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
