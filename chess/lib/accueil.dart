import 'package:flutter/material.dart';
import 'globals.dart';  

class Accueil extends StatefulWidget {
  const Accueil({super.key});



  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {

  @override
 Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Globals().backgroundColor, // Fond 
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Section En-tête
              Row(
                children: [
                  // Podium
                  Padding(
                    padding:EdgeInsets.only(left: 5, right: 40), // Marges à gauche et à droite
                    child :GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/podium');
                    },
                    child: Image.asset(
                      'assets/podium.jpg',
                      width: 70, // Largeur
                      height: 70, //Longueur
                    ),
                    ),
                  ),
                  Align(alignment: Alignment.center,
                  // Logo du jeu
                    child: Image.asset(
                      'assets/logo-echec.png', // Chemin vers votre logo
                      width: 120, // Largeur du logo
                      height: 100, // Hauteur du logo
                    ),
                  ),            
                ],
              ),

              // Espacement entre l'en-tête et la section centrale
              SizedBox(height: 20),

              // Section Centrale
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          // Zone grise large
                          child :Padding(
                          padding:EdgeInsets.only(left: 13, right: 13), // Marges à gauche et à droite
                          child: ElevatedButton(
                            onPressed: () {
                              
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Globals().backgroundColor, // Couleur du texte
                              backgroundColor: Globals().blanc, // Couleur du bouton
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20), // Coins arrondis
                              ),
                            ),
                            child: Text('Partie Normale'), // Texte du bouton
                          ),
                          ),
                        ),
                      ],
                    ),
                

                    // Deux blocs bleus horizontaux
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                      
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, // Couleur du texte
                            backgroundColor: Globals().bleuClair, // Couleur du bouton
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Taille
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20), // Coins arrondis
                            ),
                          ),
                          child: Text('Avantager Blanc'), // Texte du bouton
                        ),
                        ElevatedButton(
                          onPressed: () {
                      
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black, // Couleur du texte
                            backgroundColor: Globals().bleuFonce, // Couleur du bouton
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Taille
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20), // Coins arrondis
                            ),
                          ),
                          child: Text('Avantager Noir'), // Texte du bouton
                        )
                      ],
                    ),

                    // Options de durée
                    
                    Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,         
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Globals().backgroundColor, backgroundColor: Globals().blanc,
                          ),
                          child: Text('3min'),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Globals().backgroundColor, backgroundColor: Globals().blanc,
                          ),
                          child: Text('10min'),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Globals().backgroundColor, backgroundColor: Globals().blanc,
                          ),
                          child: Text('60min'),
                        ),
                      ],
                    ),
    

                    // Pions d'échecs
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          color: Globals().bleuFonce,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                              backgroundColor: Globals().bleuFonce,
                              ),
                              child: null,
                            ),
                          ),
                        
                        Container(
                          width: 150,
                          height: 150,
                          color: Globals().bleuClair,             
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                              backgroundColor:  Globals().bleuClair,
                              ), child: null,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Bouton "JOUER"
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/jeu');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Globals().rouge, backgroundColor: Globals().blanc,
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