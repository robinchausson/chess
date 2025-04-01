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
  Color rouge = const Color.fromARGB(255, 162, 15, 5);

  //Images

  //Logo
  AssetImage logo = const AssetImage('assets/images/logo.png');

  //Pièces
  
}