import 'package:chess/accueil.dart';
import 'package:chess/gestionJoueur.dart';
import 'package:chess/jeu.dart';
import 'package:chess/podium.dart';
import 'package:flutter/material.dart';
import 'package:chess/databaseHelper.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper.instance;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(), // Applique Rubik partout
      ),
      routes: {
        '/accueil': (context) => Accueil(), // Page d'accueil
        '/podium': (context) => Podium(), // Page de podium
        '/jeu': (context) => Jeu(), // Page de jeu
        '/gestionJoueur': (context) => GestionJoueur(), // Page de gestion des joueurs

      },
      debugShowCheckedModeBanner: false,
      home: const Accueil(),
    );
  }
}

