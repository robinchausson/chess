import 'package:flutter/material.dart';
import 'globals.dart'; // pour accéder aux couleurs définies
import 'databaseHelper.dart'; // pour récupérer les scores depuis bdd.db

class Podium extends StatefulWidget {
  const Podium({super.key});

  @override
  State<Podium> createState() => _PodiumState();
}

class _PodiumState extends State<Podium> {
  List<Map<String, dynamic>> topJoueurs = [];

  @override
  void initState() {
    super.initState();
    fetchClassement();
  }

  Future<void> fetchClassement() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.rawQuery("""
      SELECT joueur.pseudo, COUNT(victoire.id) as victoires
      FROM joueur
      LEFT JOIN victoire ON joueur.id = victoire.id_joueur
      GROUP BY joueur.id
      ORDER BY victoires DESC
      LIMIT 10
      """
    );
    setState(() {
      topJoueurs = result;
    });
  }
  
  Future<void> AjouterVictoire(int idJoueur) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('victoire', {
      'id_joueur': idJoueur,
      'date': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    // On ajoute des victoires fictives pour tester
    return Scaffold(
      backgroundColor: Globals().backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Retour + Logo
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
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/logo-echec.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Podium
            if (topJoueurs.length >= 3)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 2e place
                  podiumColumn(
                    nom: topJoueurs[1]['pseudo'],
                    place: 2,
                    victoires: topJoueurs[1]['victoires'],
                    height: 100,
                    color: Globals().bleuFonce,
                  ),
                  // 1ère place
                  podiumColumn(
                    nom: topJoueurs[0]['pseudo'],
                    place: 1,
                    victoires: topJoueurs[0]['victoires'],
                    height: 140,
                    color: Globals().blanc,
                  ),
                  // 3e place
                  podiumColumn(
                    nom: topJoueurs[2]['pseudo'],
                    place: 3,
                    victoires: topJoueurs[2]['victoires'],
                    height: 80,
                    color: Globals().bleuClair,
                  ),
                ],
              ),

            const SizedBox(height: 20),

            // Autres joueurs du top 10
            Expanded(
              child: ListView.separated(
                itemCount: topJoueurs.length,
                itemBuilder: (context, index) {
                  final joueur = topJoueurs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${index+1} | ${joueur['pseudo']}',
                          style: TextStyle(color: Globals().blanc, fontSize: 16),
                        ),
                        Text(
                          '${joueur['victoires']} victoires',
                          style: TextStyle(color: Globals().blanc, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 32),
                  child: Divider(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour une colonne du podium
  Widget podiumColumn({
    required String nom,
    required int place,
    required int victoires,
    required double height,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Text(
            nom,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            width: 70,
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '$place',
                style: TextStyle(
                  color: Globals().rouge,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
