// selection_joueur_page.dart

import 'package:flutter/material.dart';
import 'databaseHelper.dart';
import 'globals.dart';

class gestionJoueur extends StatefulWidget {
  @override
  _GestionJoueurState createState() => _GestionJoueurState();
}

class _GestionJoueurState extends State<gestionJoueur> {
  List<Map<String, dynamic>> joueurs = [];
  List<Map<String, dynamic>> joueursFiltres = [];
  TextEditingController rechercheCtrl = TextEditingController();
  TextEditingController ajoutCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    chargerJoueurs();
  }

  Future<void> chargerJoueurs() async {
    final data = await databaseHelper.instance.getJoueurs();
    setState(() {
      joueurs = data;
      joueursFiltres = data;
    });
  }

  void filtrer(String value) {
    setState(() {
      joueursFiltres = joueurs
          .where((j) =>
              j['pseudo'].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Future<void> ajouterJoueur() async {
    final pseudo = ajoutCtrl.text.trim();
    if (pseudo.isEmpty) return;
    final id = await databaseHelper.instance.insertJoueur(pseudo);
    await chargerJoueurs();
    final classement = joueurs.length;
    final joueur = {
      'id': id,
      'pseudo': pseudo,
      'nb_victoires': 0,
      'classement': classement
    };
    if (!mounted) return;
    Navigator.pop(context, joueur); // retour avec le nouveau joueur
  }

  void selectionnerJoueur(Map<String, dynamic> joueur) {
    Navigator.pop(context, joueur); // retour avec le joueur sélectionné
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Globals().backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Container(
                    height: 100,
                    width: 120,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                  image: AssetImage('assets/logo-echec.png'),
                  fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.only(left: 12.0),
              child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Sélectionnez un joueur",
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: rechercheCtrl,
                onChanged: filtrer,
                decoration: InputDecoration(
                  hintText: 'Chercher un joueur',
                  filled: true,
                  fillColor: Globals().blanc,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            Flexible(
              child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: joueursFiltres.length > 5 ? 5 : joueursFiltres.length,
              itemBuilder: (context, index) {
                final joueur = joueursFiltres[index];
                return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                dense: true,
                visualDensity: VisualDensity.compact,
                title: Text(
                  "${joueur['pseudo']}",
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                trailing: Text(
                  "${joueur['nb_victoires']} victoires",
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                onTap: () => selectionnerJoueur(joueur),
                );
              },
              separatorBuilder: (context, index) => const Divider(color: Colors.white, height: 1),
              ),
            ),
            const Text("----- OU -----", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Padding(
                padding: const EdgeInsets.only(left: 12.0),
              child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Ajouter un joueur",
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: ajoutCtrl,
                decoration: InputDecoration(
                  hintText: "Entrez votre pseudo",
                  filled: true,
                  fillColor: Globals().blanc,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Globals().bleuClair,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: ajouterJoueur,
              child: const Text("Ajouter et sélectionner ce joueur", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
