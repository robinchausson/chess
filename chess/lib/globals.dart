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
  Color backgroundColor = const Color.fromARGB(255, 27, 38, 59);
  Color blanc = const Color.fromARGB(225, 224, 225, 221);
  Color bleuClair = const Color.fromARGB(225, 119, 141, 1695);
  Color bleuFonce = const Color.fromARGB(225, 65, 90, 119);

  //Images

  //Logo
  AssetImage logo = const AssetImage('assets/images/logo.png');

  //Pièces
  
}