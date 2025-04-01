import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';  // Assure-toi que ce fichier est bien importé

class GestionJoueur extends StatefulWidget {
  const GestionJoueur({super.key});

  @override
  State<GestionJoueur> createState() => _GestionJoueurState();
}

class _GestionJoueurState extends State<GestionJoueur> {
  List<Map<String, dynamic>> _players = [];

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    final dbHelper = DatabaseHelper.instance;
    final players = await dbHelper.getUsers(); // Appelle la méthode pour récupérer les joueurs
    setState(() {
      _players = players;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion des Joueurs")),
      body: _players.isEmpty
          ? const Center(child: Text("Aucun joueur enregistré"))
          : ListView.builder(
              itemCount: _players.length,
              itemBuilder: (context, index) {
                final player = _players[index];
                return ListTile(
                  title: Text(player['name']),
                  subtitle: Text("Âge: ${player['age']}"),
                  leading: CircleAvatar(child: Text(player['name'][0])),
                );
              },
            ),
    );
  }
}
