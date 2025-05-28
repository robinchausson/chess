import 'package:chess/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'globals.dart';
import 'dart:async';

class Jeu extends StatefulWidget {
  const Jeu({super.key});

  @override
  State<Jeu> createState() => _JeuState();
}

class _JeuState extends State<Jeu> {
  bool _isKingInCheck(bool whiteKing) {
    int kingRow = -1, kingCol = -1;
    String king = whiteKing ? 'wk' : 'bk';

    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        if (board[r][c] == king) {
          kingRow = r;
          kingCol = c;
        }
      }
    }
    if (kingRow == -1 || kingCol == -1) return false; // roi non trouvé, pas d'échec

    // Vérification spéciale pour les cavaliers
    List<List<int>> knightMoves = [
      [2, 1], [2, -1], [-2, 1], [-2, -1],
      [1, 2], [1, -2], [-1, 2], [-1, -2]
    ];
    String enemyKnight = whiteKing ? 'bn' : 'wn';
    for (var d in knightMoves) {
      int r = kingRow + d[0], c = kingCol + d[1];
      if (r >= 0 && r < 8 && c >= 0 && c < 8) {
        if (board[r][c] == enemyKnight) return true;
      }
    }

    // Vérification pour les autres pièces
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        String? piece = board[r][c];
        if (piece == null || piece.startsWith(whiteKing ? 'w' : 'b')) continue;
        if (piece.endsWith('n')) continue; // déjà traité
        List<List<int>> enemyMoves = _getValidMoves(r, c, ignoreTurn: true);
        for (var move in enemyMoves) {
          if (move[0] == kingRow && move[1] == kingCol) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool _isCheckmate(bool whiteKing) {
    if (!_isKingInCheck(whiteKing)) return false;

    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        String? piece = board[r][c];
        if (piece == null || piece.startsWith(whiteKing ? 'b' : 'w')) continue;
        List<List<int>> moves = _getValidMoves(r, c);
        for (var move in moves) {
          String? temp = board[move[0]][move[1]];
          board[move[0]][move[1]] = piece;
          board[r][c] = null;
          bool stillCheck = _isKingInCheck(whiteKing);
          board[r][c] = piece;
          board[move[0]][move[1]] = temp;
          if (!stillCheck) return false;
        }
      }
    }
    return true;
  }

  Future<void> _promotePawn(BuildContext context, int row, int col) async {
    String? piece = board[row][col];
    if (piece == null || piece[1] != 'p') return;

    bool isWhite = piece.startsWith('w');
    bool atEnd = (isWhite && row == 0) || (!isWhite && row == 7);
    if (!atEnd) return;

    // Liste des choix possibles pour la promotion
    final List<Map<String, String>> choices = [
      {'code': 'q', 'label': 'Reine'},
      {'code': 'r', 'label': 'Tour'},
      {'code': 'b', 'label': 'Fou'},
      {'code': 'n', 'label': 'Cavalier'},
    ];

    String? selected = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Promotion du pion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: choices.map((choice) {
              String code = choice['code']!;
              String label = choice['label']!;
              String pieceCode = (isWhite ? 'w' : 'b') + code;
              return ListTile(
                leading: Image(
                  image: _getPieceImage(pieceCode),
                  width: 32,
                ),
                title: Text(label),
                onTap: () => Navigator.pop(context, code),
              );
            }).toList(),
          ),
        );
      },
    );

    // Si le joueur a choisi une pièce, on promeut
    if (selected != null) {
      board[row][col] = piece[0] + selected;
    } else {
      // Si le joueur annule, on promeut en reine par défaut
      board[row][col] = piece[0] + 'q';
    }
  }

  // Ajoute cette fonction utilitaire pour obtenir l'image d'une pièce
  ImageProvider _getPieceImage(String piece) {
    switch (piece) {
      case 'wp': return Globals().pionBlanc;
      case 'bp': return Globals().pionNoir;
      case 'wr': return Globals().tourBlanc;
      case 'br': return Globals().tourNoir;
      case 'wn': return Globals().cavalierBlanc;
      case 'bn': return Globals().cavalierNoir;
      case 'wb': return Globals().fouBlanc;
      case 'bb': return Globals().fouNoir;
      case 'wq': return Globals().reineBlanc;
      case 'bq': return Globals().reineNoir;
      case 'wk': return Globals().roiBlanc;
      case 'bk': return Globals().roiNoir;
      default: return Globals().pionBlanc;
    }
  }

  List<List<String?>> board = List.generate(8, (i) => List.filled(8, null));
  bool isWhiteTurn = true;
  late String joueurBlanc;
  late String joueurNoir;
  late int classementBlanc;
  late int classementNoir;
  late int selectedTime;
  late String mode;

  Duration whiteTime = Duration.zero;
  Duration blackTime = Duration.zero;
  Timer? timer;

  int? selectedRow;
  int? selectedCol;
  List<List<int>> validMoves = [];

  List<String> capturedWhite = [];
  List<String> capturedBlack = [];

  int? idPartie;

  Map<String, dynamic>? joueur1;
  Map<String, dynamic>? joueur2;

  @override
  void initState() {
    super.initState();
    _initBoard(); // seulement le plateau ici
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;

    if (args != null) {
      joueur1 = args['joueur1'];
      joueur2 = args['joueur2'];
      joueurBlanc = args['joueurBlanc'] ?? 'Blanc';
      joueurNoir = args['joueurNoir'] ?? 'Noir';
      classementBlanc = int.tryParse(args['classementBlanc'].toString()) ?? 0;
      classementNoir = int.tryParse(args['classementNoir'].toString()) ?? 0;
      mode = args['mode'] ?? 'normale';

      selectedTime = args['temps'] ?? 3;

      whiteTime = Duration(minutes: selectedTime);
      blackTime = Duration(minutes: selectedTime);

      if (idPartie == null && joueur1 != null && joueur2 != null) {
        databaseHelper.instance.insertPartie(
          joueur1!['id'],
          joueur2!['id'],
        ).then((id) {
          setState(() {
            idPartie = id;
          });
        });
      }
    }

    _startTimer();
  }

  void _initBoard() {
    List<String> order = ['r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'];
    for (int i = 0; i < 8; i++) {
      board[1][i] = 'bp';
      board[6][i] = 'wp';
      board[0][i] = 'b${order[i]}';
      board[7][i] = 'w${order[i]}';
    }
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (isWhiteTurn) {
          whiteTime -= const Duration(seconds: 1);
        } else {
          blackTime -= const Duration(seconds: 1);
        }

        if (whiteTime.inSeconds <= 0 || blackTime.inSeconds <= 0) {
          timer?.cancel();
          int? idVainqueur = isWhiteTurn
              ? (joueur2 != null ? joueur2!['id'] : null)
              : (joueur1 != null ? joueur1!['id'] : null);
          _showEndDialog('Temps écoulé', isWhiteTurn ? '$joueurNoir gagne' : '$joueurBlanc gagne', idVainqueur: idVainqueur);
        }
      });
    });
  }

  void _showEndDialog(String title, String message, {int? idVainqueur}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () async {
              if (idVainqueur != null && idPartie != null && joueur1 != null && joueur2 != null) {
                await databaseHelper.instance.joueurAGagne(idVainqueur, idPartie!);
                int? idPerdant;
                var idJ1 = joueur1!['id'];
                var idJ2 = joueur2!['id'];
                if (idJ1 != null && idJ2 != null) {
                  idPerdant = (idVainqueur == idJ1) ? idJ2 : idJ1;
                  await databaseHelper.instance.joueurAPerdu(idPerdant!, idPartie!);
                }
              }
              Navigator.of(context)
                ..pop()
                ..pop();
            },
          ),
        ],
      ),
    );
  }

  List<List<int>> _getValidMoves(int row, int col, {bool ignoreTurn = false}) {
    String? piece = board[row][col];
    if (piece == null) return [];

    bool isWhite = piece.startsWith('w');
    if (!ignoreTurn && isWhite != isWhiteTurn) return [];

    List<List<int>> moves = [];

    void tryAdd(int r, int c, {bool captureOnly = false}) {
      if (r < 0 || r >= 8 || c < 0 || c >= 8) return;
      String? target = board[r][c];
      if (target == null && !captureOnly) {
        moves.add([r, c]);
      } else if (target != null &&
          target.startsWith(isWhite ? 'b' : 'w') &&
          !target.endsWith('k')) { // interdit de prendre le roi
          moves.add([r, c]);
      }
    }

    switch (piece.substring(1)) {
      case 'p':
        int dir = isWhite ? -1 : 1;
        int startRow = isWhite ? 6 : 1;
        // Avance d'une case
        if (row + dir >= 0 && row + dir < 8 && board[row + dir][col] == null) {
          moves.add([row + dir, col]);
        }
        // Avance de deux cases
        if (row == startRow &&
            board[row + dir][col] == null &&
            board[row + 2 * dir][col] == null) {
          moves.add([row + 2 * dir, col]);
        }
        // Prises diagonales
        for (int dCol in [-1, 1]) {
          int newCol = col + dCol;
          int newRow = row + dir;
          if (newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8) {
            String? target = board[newRow][newCol];
            if (ignoreTurn) {
              // Pour la détection d'échec, le pion attaque toujours la diagonale
              moves.add([newRow, newCol]);
            } else if (target != null && target.startsWith(isWhite ? 'b' : 'w') && !target.endsWith('k')) {
              moves.add([newRow, newCol]);
            }
          }
        }
        break;
      case 'r':
        for (var d in [[1,0], [-1,0], [0,1], [0,-1]]) {
          int r = row + d[0], c = col + d[1];
          while (r >= 0 && r < 8 && c >= 0 && c < 8) {
            String? target = board[r][c];
            if (target == null) {
              moves.add([r, c]);
            } else {
              if (target.startsWith(isWhite ? 'b' : 'w')) moves.add([r, c]);
              break;
            }
            r += d[0];
            c += d[1];
          }
        }
        break;
      case 'n':
        for (var d in [[2,1], [2,-1], [-2,1], [-2,-1], [1,2], [1,-2], [-1,2], [-1,-2]]) {
          tryAdd(row + d[0], col + d[1]);
        }
        break;
      case 'b':
        for (var d in [[1,1], [1,-1], [-1,1], [-1,-1]]) {
          int r = row + d[0], c = col + d[1];
          while (r >= 0 && r < 8 && c >= 0 && c < 8) {
            String? target = board[r][c];
            if (target == null) {
              moves.add([r, c]);
            } else {
              if (target.startsWith(isWhite ? 'b' : 'w')) moves.add([r, c]);
              break;
            }
            r += d[0];
            c += d[1];
          }
        }
        break;
      case 'q':
        // Combine mouvements de la tour et du fou
        for (var d in [[1,0], [-1,0], [0,1], [0,-1], [1,1], [1,-1], [-1,1], [-1,-1]]) {
          int r = row + d[0], c = col + d[1];
          while (r >= 0 && r < 8 && c >= 0 && c < 8) {
            String? target = board[r][c];
            if (target == null) {
              moves.add([r, c]);
            } else {
              if (target.startsWith(isWhite ? 'b' : 'w')) moves.add([r, c]);
              break;
            }
            r += d[0];
            c += d[1];
          }
        }
        break;
      case 'k':
        for (var d in [[1,0], [-1,0], [0,1], [0,-1], [1,1], [1,-1], [-1,1], [-1,-1]]) {
          int newRow = row + d[0], newCol = col + d[1];
          if (newRow < 0 || newRow >= 8 || newCol < 0 || newCol >= 8) continue;
          String? target = board[newRow][newCol];

          // Correction : pour la détection d'échec, le roi attaque toutes les cases adjacentes, même si occupées par un roi adverse
          if (ignoreTurn) {
            moves.add([newRow, newCol]);
            continue;
          }

          // Le roi ne peut pas prendre un roi adverse
          if (target != null && target.endsWith('k')) continue;

          // Simule le déplacement du roi
          String? original = board[newRow][newCol];
          board[newRow][newCol] = board[row][col];
          board[row][col] = null;

          // Vérifie si la nouvelle case est attaquée
          bool isAttacked = false;

          // Vérification spéciale pour les cavaliers
          List<List<int>> knightMoves = [
            [2, 1], [2, -1], [-2, 1], [-2, -1],
            [1, 2], [1, -2], [-1, 2], [-1, -2]
          ];
          for (var km in knightMoves) {
            int kr = newRow + km[0], kc = newCol + km[1];
            if (kr >= 0 && kr < 8 && kc >= 0 && kc < 8) {
              String? enemy = board[kr][kc];
              if (enemy != null && enemy == (isWhite ? 'bn' : 'wn')) {
                isAttacked = true;
                break;
              }
            }
          }

          // Vérification spéciale pour les pions adverses
          if (!isAttacked) {
            // Correction : la direction d'attaque dépend de la couleur du ROI (et non du pion adverse)
            int pawnAttackDir = isWhite ? 1 : -1; // Si roi blanc, pions noirs attaquent vers le bas (1), sinon vers le haut (-1)
            String pawnType = isWhite ? 'bp' : 'wp';
            for (int dc in [-1, 1]) {
              int pr = newRow + pawnAttackDir;
              int pc = newCol + dc;
              if (pr >= 0 && pr < 8 && pc >= 0 && pc < 8) {
                String? enemy = board[pr][pc];
                if (enemy != null && enemy == pawnType) {
                  isAttacked = true;
                  break;
                }
              }
            }
          }

          // Vérification pour les autres pièces
          if (!isAttacked) {
            for (int r = 0; r < 8; r++) {
              for (int c = 0; c < 8; c++) {
                String? enemy = board[r][c];
                if (enemy != null && enemy.startsWith(isWhite ? 'b' : 'w')) {
                  if (enemy.endsWith('k') || enemy.endsWith('n') || enemy.endsWith('p')) continue; // ignore roi, cavaliers, pions (déjà traités)
                  var enemyMoves = _getValidMoves(r, c, ignoreTurn: true);
                  if (enemyMoves.any((m) => m[0] == newRow && m[1] == newCol)) {
                    isAttacked = true;
                    break;
                  }
                }
              }
              if (isAttacked) break;
            }
          }

          // Restaure le plateau
          board[row][col] = board[newRow][newCol];
          board[newRow][newCol] = original;

          if (!isAttacked && (target == null || target.startsWith(isWhite ? 'b' : 'w'))) {
            moves.add([newRow, newCol]);
          }
        }
        break;
    }

    return moves;
  }


  List<List<int>> _getLegalMoves(int row, int col) {
    List<List<int>> candidateMoves = _getValidMoves(row, col);
    List<List<int>> legalMoves = [];

    for (var move in candidateMoves) {
      var backup = board[move[0]][move[1]];
      String? piece = board[row][col];

      board[move[0]][move[1]] = piece;
      board[row][col] = null;

      // Utilise _isKingInCheck pour vérifier si le roi du joueur est en échec après le coup
      bool stillInCheck = _isKingInCheck(piece!.startsWith('w'));

      board[row][col] = piece;
      board[move[0]][move[1]] = backup;

      if (!stillInCheck) legalMoves.add(move);
    }

    return legalMoves;
  }


  List<int>? _findKing(bool white) {
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        String? piece = board[r][c];
        if (piece == (white ? 'wk' : 'bk')) return [r, c];
      }
    }
    return null;
  }

  bool _isInCheck(bool white) {
    List<int>? kingPos = _findKing(white);
    if (kingPos == null) return false;

    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        String? piece = board[r][c];
        if (piece != null && piece.startsWith(white ? 'b' : 'w')) {
          var enemyMoves = _getValidMoves(r, c, ignoreTurn: true);
          if (enemyMoves.any((m) => m[0] == kingPos[0] && m[1] == kingPos[1])) {
            return true;
          }
        }
      }
    }

    return false;
  }

  void _handleProposerNul() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Proposition de match nul'),
        content: const Text("L'adversaire accepte-t-il le match nul ?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showEndDialog("Match nul", "Les deux joueurs sont d'accord.");
            },
            child: const Text('Accepter'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Refuser'),
          ),
        ],
      ),
    );
  }

  void _handleAbandon({required bool isWhite}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Abandonner"),
        content: const Text("Êtes-vous sûr de vouloir abandonner ?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              int? idVainqueur = isWhite
                  ? (joueur2 != null ? joueur2!['id'] : null)
                  : (joueur1 != null ? joueur1!['id'] : null);
              _showEndDialog("Victoire", isWhite ? "$joueurNoir gagne" : "$joueurBlanc gagne", idVainqueur: idVainqueur);
            },
            child: const Text("Oui"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Non"),
          ),
        ],
      ),
    );
  }

  Widget _buildSquare(int row, int col) {
    Color lightColor = Globals().bleuClair;
    Color darkColor = Globals().bleuFonce;
    bool isLight = (row + col) % 2 == 0;
    String? piece = board[row][col];

    ImageProvider? image;
    if (piece != null) {
      switch (piece) {
        case 'wp': image = Globals().pionBlanc; break;
        case 'bp': image = Globals().pionNoir; break;
        case 'wr': image = Globals().tourBlanc; break;
        case 'br': image = Globals().tourNoir; break;
        case 'wn': image = Globals().cavalierBlanc; break;
        case 'bn': image = Globals().cavalierNoir; break;
        case 'wb': image = Globals().fouBlanc; break;
        case 'bb': image = Globals().fouNoir; break;
        case 'wq': image = Globals().reineBlanc; break;
        case 'bq': image = Globals().reineNoir; break;
        case 'wk': image = Globals().roiBlanc; break;
        case 'bk': image = Globals().roiNoir; break;
      }
    }

   return GestureDetector(
      onTap: () async {
        bool showCheck = false;

        // 1. Si on clique sur une pièce à soi, on la sélectionne (même si une autre est déjà sélectionnée)
        if (board[row][col] != null &&
            board[row][col]!.startsWith(isWhiteTurn ? 'w' : 'b')) {
          List<List<int>> legal = _getLegalMoves(row, col);
          setState(() {
            if (legal.isNotEmpty) {
              selectedRow = row;
              selectedCol = col;
              validMoves = legal;
            } else {
              selectedRow = null;
              selectedCol = null;
              validMoves.clear();
            }
          });
          if (_isInCheck(isWhiteTurn)) {
            _showCheckInfo(isWhiteTurn);
          }
          return; // On arrête ici, pas de tentative de déplacement
        }

        // 2. Si une pièce est sélectionnée et la case cliquée fait partie des coups légaux
        if (selectedRow != null && selectedCol != null) {
          if (validMoves.any((m) => m[0] == row && m[1] == col)) {
            String? target = board[row][col];
            if (target != null && target.endsWith('k')) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Impossible de prendre le roi !")),
              );
              return;
            }
            // Ajoute la pièce capturée à la bonne liste
            if (target != null) {
              if (target.startsWith('w')) {
                capturedWhite.add(target);
              } else if (target.startsWith('b')) {
                capturedBlack.add(target);
              }
            }
            // Joue le coup
            board[row][col] = board[selectedRow!][selectedCol!];
            board[selectedRow!][selectedCol!] = null;

            // Promotion automatique si un pion atteint la dernière rangée
            await _promotePawn(context, row, col);

            selectedRow = null;
            selectedCol = null;
            validMoves.clear();
            isWhiteTurn = !isWhiteTurn;

            // Vérifie si le roi adverse est en échec APRÈS le coup
            showCheck = _isInCheck(!isWhiteTurn);

            // Vérifie échec et mat ou pat pour l'adversaire
            if (_isCheckmate(!isWhiteTurn)) {
              timer?.cancel();
              int? idVainqueur = isWhiteTurn
                  ? (joueur2 != null ? joueur2!['id'] : null)
                  : (joueur1 != null ? joueur1!['id'] : null);
              String gagnant = isWhiteTurn ? '$joueurNoir gagne' : '$joueurBlanc gagne';
              _showEndDialog('Échec et mat', gagnant, idVainqueur: idVainqueur);
              setState(() {});
              return;
            }
          }
          return;
        }

        // 3. Si aucune pièce sélectionnée ou case vide ou pièce adverse, on désélectionne tout
        setState(() {
          selectedRow = null;
          selectedCol = null;
          validMoves.clear();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isLight ? lightColor : darkColor,
          border: selectedRow == row && selectedCol == col
              ? Border.all(color: Colors.yellow, width: 3)
              : validMoves.any((m) => m[0] == row && m[1] == col)
                  ? Border.all(color: Colors.green, width: 2)
                  : null,
        ),
        child: Center(
          child: image != null
              ? (piece != null && piece.startsWith('b')
                  ? Transform.rotate(
                      angle: 3.1415926535897932, // 180 degrés en radians
                      child: Image(image: image, width: 42),
                    )
                  : Image(image: image, width: 42))
              : null,
        ),
      ),
    );
  }

  Widget _buildBoard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          itemCount: 64,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
          itemBuilder: (context, index) {
            int row = index ~/ 8;
            int col = index % 8;
            return _buildSquare(row, col);
          },
        ),
      ),
    );
  }

  Widget _buildPlayerInfo({
    required String name,
    required int ranking,
    required Duration time,
    required bool isTop,
    required VoidCallback onNul,
    required VoidCallback onAbandon,
  }) {
    String formattedTime =
    '${time.inHours > 0 ? '${time.inHours}:' : ''}'
    '${time.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
    '${time.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    // Utilise les vraies listes
    List<String> captured = isTop ? capturedWhite : capturedBlack;

    Widget content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: 
      Column(
        children: [
          const SizedBox(height: 8),
          if (captured.isNotEmpty) ...[
            SizedBox(
              height: 64,
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: 2,
                runSpacing: 8,
                children: captured.map((piece) {
                  ImageProvider? img;
                  switch (piece) {
                    case 'wp': img = Globals().pionBlanc; break;
                    case 'bp': img = Globals().pionNoir; break;
                    case 'wr': img = Globals().tourBlanc; break;
                    case 'br': img = Globals().tourNoir; break;
                    case 'wn': img = Globals().cavalierBlanc; break;
                    case 'bn': img = Globals().cavalierNoir; break;
                    case 'wb': img = Globals().fouBlanc; break;
                    case 'bb': img = Globals().fouNoir; break;
                    case 'wq': img = Globals().reineBlanc; break;
                    case 'bq': img = Globals().reineNoir; break;
                    case 'wk': img = Globals().roiBlanc; break;
                    case 'bk': img = Globals().roiNoir; break;
                  }
                  return img != null
                    ? Image(image: img, width: 24)
                    : const SizedBox.shrink();
                }).toList(),
              ),
            ),
          ] else if (!isTop && capturedBlack.isNotEmpty) ...[
            SizedBox(
          height: 64,
          child: Wrap(
            alignment: WrapAlignment.end, // align right
            spacing: 2,
            runSpacing: 8,
            children: capturedBlack.map((piece) {
              ImageProvider? img;
              switch (piece) {
                case 'bp': img = Globals().pionBlanc; break;
                case 'br': img = Globals().tourBlanc; break;
                case 'bn': img = Globals().cavalierBlanc; break;
                case 'bb': img = Globals().fouBlanc; break;
                case 'bq': img = Globals().reineBlanc; break;
                case 'bk': img = Globals().roiBlanc; break;
              }
              return img != null
            ? Image(image: img, width: 24)
            : const SizedBox.shrink();
            }).toList(),
          ),
              ),
            ],

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Globals().blanc)),
                    Text('Classement: $ranking', style: TextStyle(color: Globals().blanc, fontSize: 13)),
                  ],
                ),
                Text(formattedTime, style: TextStyle(fontSize: 21, color: Globals().rouge, fontWeight: FontWeight.bold)),
              ],
            ),

          ),
          const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                  onPressed: onNul,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Globals().bleuClair,
                    foregroundColor: Globals().blanc,
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Proposer le nul", style: TextStyle(fontSize: 12)),
                  ),

                  const SizedBox(width: 12),

                  ElevatedButton(
                  onPressed: onAbandon,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Globals().bleuFonce,
                    foregroundColor: Globals().blanc,
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Abandonner", style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );

    if (isTop) {
      return Transform.rotate(
        angle: 3.1415926535897932, // 180 deg en radians
        child: content,
      );
    } else {
      return content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Globals().backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        _buildPlayerInfo(
          name: joueurNoir,
          ranking: classementNoir,
          time: blackTime,
          isTop: true,
          onNul: _handleProposerNul,
          onAbandon: () => _handleAbandon(isWhite: false),
        ),
        _buildBoard(),
        _buildPlayerInfo(
          name: joueurBlanc,
          ranking: classementBlanc,
          time: whiteTime,
          isTop: false,
          onNul: _handleProposerNul,
          onAbandon: () => _handleAbandon(isWhite: true),
        ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _showCheckInfo(bool whiteInCheck) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(whiteInCheck ? "Le roi blanc est en échec !" : "Le roi noir est en échec !"),
        duration: const Duration(seconds: 2),
      ),
    );
  });
}

}