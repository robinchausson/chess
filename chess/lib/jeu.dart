import 'package:flutter/material.dart';
import 'globals.dart';
import 'dart:async';

class Jeu extends StatefulWidget {
  const Jeu({super.key});

  @override
  State<Jeu> createState() => _JeuState();
}

class _JeuState extends State<Jeu> {
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
  Set<List<int>> validMoves = {};

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
    joueurBlanc = args['joueurBlanc'] ?? 'Blanc';
    joueurNoir = args['joueurNoir'] ?? 'Noir';
    classementBlanc = int.tryParse(args['classementBlanc'].toString()) ?? 1300;
    classementNoir = int.tryParse(args['classementNoir'].toString()) ?? 1200;
    mode = args['mode'] ?? 'normale';

    selectedTime = args['temps'] ?? 3;

    whiteTime = Duration(minutes: selectedTime);
    blackTime = Duration(minutes: selectedTime);
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
          _showEndDialog('Temps écoulé', isWhiteTurn ? '$joueurNoir gagne' : '$joueurBlanc gagne');
        }
      });
    });
  }

  void _showEndDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context)
                ..pop()
                ..pop(); // Sort de la page jeu
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
 
  if (isWhite != isWhiteTurn) return [];

  List<List<int>> moves = [];

  void tryAdd(int r, int c, {bool captureOnly = false}) {
    if (r < 0 || r >= 8 || c < 0 || c >= 8) return;
    String? target = board[r][c];
    if (target == null && !captureOnly) {
      moves.add([r, c]);
    } else if (target != null && target.startsWith(isWhite ? 'b' : 'w')) {
      moves.add([r, c]);
    }
  }

  switch (piece.substring(1)) {
    case 'p':
      int dir = isWhite ? -1 : 1;
      int startRow = isWhite ? 6 : 1;
      if (board[row + dir][col] == null) moves.add([row + dir, col]);
      if (row == startRow && board[row + dir][col] == null && board[row + 2 * dir][col] == null) {
        moves.add([row + 2 * dir, col]);
      }
      for (int dCol in [-1, 1]) {
        int newCol = col + dCol;
        if (newCol >= 0 && newCol < 8) {
          String? target = board[row + dir][newCol];
          if (target != null && target.startsWith(isWhite ? 'b' : 'w')) {
            moves.add([row + dir, newCol]);
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
      return [
        ..._getValidMoves(row, col)..removeWhere((pos) => pos[0] == row || pos[1] == col),
        ..._getValidMoves(row, col)..removeWhere((pos) => pos[0] != row && pos[1] != col),
      ];
    case 'k':
      for (var d in [[1,0], [-1,0], [0,1], [0,-1], [1,1], [1,-1], [-1,1], [-1,-1]]) {
        tryAdd(row + d[0], col + d[1]);
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

    bool stillInCheck = _isInCheck(piece!.startsWith('w'));

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
              _showEndDialog("Victoire", isWhite ? "$joueurNoir gagne" : "$joueurBlanc gagne");
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
    Color lightColor = const Color(0xFFBCE5C7);
    Color darkColor = const Color(0xFF6F9E73);
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
      onTap: () {
        setState(() {
          if (selectedRow != null && validMoves.any((m) => m[0] == row && m[1] == col)) {
            board[row][col] = board[selectedRow!][selectedCol!];
            board[selectedRow!][selectedCol!] = null;
            selectedRow = null;
            selectedCol = null;
            validMoves.clear();
            isWhiteTurn = !isWhiteTurn;
            bool kingInCheck = _isInCheck(!isWhiteTurn);
            bool hasLegalMoves = false;
            for (int r = 0; r < 8; r++) {
              for (int c = 0; c < 8; c++) {
                if (board[r][c]?.startsWith(isWhiteTurn ? 'w' : 'b') ?? false) {
                  if (_getLegalMoves(r, c).isNotEmpty) {
                    hasLegalMoves = true;
                    break;
                  }
                }
              }
            }
            if (kingInCheck && !hasLegalMoves) {
              timer?.cancel();
              _showEndDialog('Échec et mat', isWhiteTurn ? '$joueurNoir gagne' : '$joueurBlanc gagne');
            } else if (kingInCheck) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Roi en échec !")),
              );
            }
          } else if (board[row][col] != null &&
                    board[row][col]!.startsWith(isWhiteTurn ? 'w' : 'b')) {
            selectedRow = row;
            selectedCol = col;
            validMoves = _getLegalMoves(row, col).toSet();
          } else {
            selectedRow = null;
            selectedCol = null;
            validMoves.clear();
          }
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
        child: Center(child: image != null ? Image(image: image, width: 42) : null),
      ),
    );
  }

  Widget _buildBoard() {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Globals().blanc)),
          Text('Classement: $ranking', style: TextStyle(color: Globals().blanc, fontSize: 13)),
          Text(formattedTime, style: TextStyle(fontSize: 18, color: Globals().rouge)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: onNul, child: const Text("Proposer le nul", style: TextStyle(fontSize: 12))),
              ElevatedButton(onPressed: onAbandon, child: const Text("Abandonner", style: TextStyle(fontSize: 12))),
            ],
          ),
          const SizedBox(height: 4),
          Text("Pièces perdues :", style: TextStyle(color: Globals().blanc, fontSize: 12)),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: const []),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Globals().backgroundColor,
      body: SafeArea(
        child: Column(
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
}
