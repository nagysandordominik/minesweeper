import 'package:flutter/material.dart';
import 'minesweeper_board.dart';

void main() {
  runApp(const MinesweeperApp());
}

class MinesweeperApp extends StatelessWidget {
  const MinesweeperApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minesweeper',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DifficultySelection(),
    );
  }
}

class DifficultySelection extends StatelessWidget {
  const DifficultySelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minesweeper - Válassz nehézségi szintet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const MinesweeperGame(rows: 8, columns: 8, mineCount: 10),
                  ),
                );
              },
              child: const Text('Könnyű'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const MinesweeperGame(rows: 12, columns: 12, mineCount: 25),
                  ),
                );
              },
              child: const Text('Közepes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const MinesweeperGame(rows: 16, columns: 16, mineCount: 40),
                  ),
                );
              },
              child: const Text('Nehéz'),
            ),
          ],
        ),
      ),
    );
  }
}

class MinesweeperGame extends StatelessWidget {
  final int rows;
  final int columns;
  final int mineCount;

  const MinesweeperGame({
    Key? key,
    required this.rows,
    required this.columns,
    required this.mineCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minesweeper'),
      ),
      body: MinesweeperBoard(
        rows: rows,
        columns: columns,
        mineCount: mineCount,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MinesweeperGame(
                      rows: rows,
                      columns: columns,
                      mineCount: mineCount,
                    ),
                  ),
                );
              },
              child: const Text('Újraindítás'),
            ),
          ],
        ),
      ),
    );
  }
}