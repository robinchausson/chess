import 'package:flutter/material.dart';

class Globals {
  static final Globals _instance = Globals._internal();

  factory Globals() {
    return _instance;
  }

  Globals._internal();

  // Variables globales
  String appTitle = "Chess App";
  
  
  //Couleurs
  Color backgroundColor = const Color.fromARGB(255, 13, 27, 42);
  Color blanc = const Color.fromARGB(255, 224, 225, 221);
  Color bleuClair = const Color.fromARGB(255, 119, 141, 1695);
  Color bleuFonce = const Color.fromARGB(255, 65, 90, 119);
  Color rouge =Color.fromARGB(255, 162, 15, 5);

  //Images
  //Pièces Blanches
  AssetImage pionBlanc = const AssetImage('assets/pieces/blanc/pion_blanc.png');
  AssetImage tourBlanc = const AssetImage('assets/pieces/blanc/tour_blanc.png');
  AssetImage cavalierBlanc = const AssetImage('assets/pieces/blanc/cavalier_blanc.png');
  AssetImage fouBlanc = const AssetImage('assets/pieces/blanc/fou_blanc.png');
  AssetImage roiBlanc = const AssetImage('assets/pieces/blanc/roi_blanc.png');
  AssetImage reineBlanc = const AssetImage('assets/pieces/blanc/reine_blanc.png');

  //Pièces Noires
  AssetImage pionNoir = const AssetImage('assets/pieces/noir/pion_noir.png');
  AssetImage tourNoir = const AssetImage('assets/pieces/noir/tour_noir.png');
  AssetImage cavalierNoir = const AssetImage('assets/pieces/noir/cavalier_noir.png');
  AssetImage fouNoir = const AssetImage('assets/pieces/noir/fou_noir.png');
  AssetImage roiNoir = const AssetImage('assets/pieces/noir/roi_noir.png');
  AssetImage reineNoir = const AssetImage('assets/pieces/noir/reine_noir.png');

  //Podium
  AssetImage podium1 = const AssetImage('asset/podium.png');

 


  //Logo
  AssetImage logo = const AssetImage('assets/logo-echec.png');


  //Pièces
  
}