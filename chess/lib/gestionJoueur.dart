import 'package:flutter/material.dart';
import 'databaseHelper.dart';  // Assure-toi que ce fichier est bien importé

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
  }


  Future<void> AjouterJoueur(String pseudo) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('joueur', {
      'pseudo': pseudo,
      'date_creation': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion des Joueurs")),
      body: 
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Exemple d'ajout d'un joueur
                await AjouterJoueur("apEX");
                // Rafraîchir la liste des joueurs après ajout
                setState(() {});
              },
              child: const Text("Ajouter Joueur"),
            ),
            // Afficher la liste des joueurs ici
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: DatabaseHelper.instance.database.then((db) => db.query('joueur')),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erreur : ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Aucun joueur trouvé');
                  } else {
                    _players = snapshot.data!;
                    return ListView.builder(
                      itemCount: _players.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_players[index]['pseudo']),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
