import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MinesweeperBoard extends StatefulWidget {
  final int rows;
  final int columns;
  final int mineCount;

  const MinesweeperBoard({
    Key? key,
    required this.rows,
    required this.columns,
    required this.mineCount,
  }) : super(key: key);

  @override
  _MinesweeperBoardState createState() => _MinesweeperBoardState();
}

class _MinesweeperBoardState extends State<MinesweeperBoard> {
  late List<List<Cell>> board;
  bool gameOver = false;
  int steps = 0;
  late Timer timer;
  int elapsedTime = 0;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    board = _generateBoard(widget.rows, widget.columns, widget.mineCount);
    elapsedTime = 0;
    steps = 0;
    gameOver = false;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTime++;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  List<List<Cell>> _generateBoard(int rows, int columns, int mineCount) {
    List<List<Cell>> board =
        List.generate(rows, (row) => List.generate(columns, (col) => Cell()));

    int placedMines = 0;
    Random random = Random();

    while (placedMines < mineCount) {
      int row = random.nextInt(rows);
      int col = random.nextInt(columns);

      if (!board[row][col].hasMine) {
        board[row][col].hasMine = true;
        placedMines++;
      }
    }

    return board;
  }

  void _revealCell(int row, int col) {
    if (gameOver || board[row][col].isRevealed) return;

    setState(() {
      board[row][col].isRevealed = true;
      steps++;
      if (board[row][col].hasMine) {
        gameOver = true;
        timer.cancel();
        _showGameOverDialog(false);
      }
    });
  }

  void _showGameOverDialog(bool won) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(won ? 'Gratulálunk!' : 'Vesztettél!'),
          content: Text(won
              ? 'Sikerült megoldani a pályát $steps lépésből, $elapsedTime másodperc alatt!'
              : 'Ráléptél egy aknára!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _startGame();
              },
              child: const Text('Új játék'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Idő: $elapsedTime mp'),
              Text('Lépések: $steps'),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.columns,
            ),
            itemCount: widget.rows * widget.columns,
            itemBuilder: (context, index) {
              int row = index ~/ widget.columns;
              int col = index % widget.columns;

              return GestureDetector(
                onTap: () => _revealCell(row, col),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  color: board[row][col].isRevealed
                      ? (board[row][col].hasMine ? Colors.red : Colors.green)
                      : Colors.grey[300],
                  child: Center(
                    child: Text(
                      board[row][col].isRevealed
                          ? (board[row][col].hasMine ? '💣' : '')
                          : '',
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Cell {
  bool hasMine;
  bool isRevealed;

  Cell({
    this.hasMine = false,
    this.isRevealed = false,
  });
}