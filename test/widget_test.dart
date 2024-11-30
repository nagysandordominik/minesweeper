import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minesweeper/main.dart'; // Cseréld a helyes fájlnevet, ha más az app belépési pontja.
import 'package:minesweeper/minesweeper_board.dart';

void main() {
  group('Minesweeper App Tests', () {
    testWidgets('Kezdő képernyő megjelenítése és nehézségi szintek', (WidgetTester tester) async {
      await tester.pumpWidget(const MinesweeperApp());

      // Ellenőrizzük a nehézségi szinteket
      expect(find.text('Könnyű'), findsOneWidget);
      expect(find.text('Közepes'), findsOneWidget);
      expect(find.text('Nehéz'), findsOneWidget);

      // Navigáljunk a "Könnyű" szintre
      await tester.tap(find.text('Könnyű'));
      await tester.pumpAndSettle();

      // Ellenőrizzük, hogy a játéktér megjelenik
      expect(find.byType(MinesweeperBoard), findsOneWidget);
    });

    testWidgets('Időmérő és lépésszámláló helyes kezdőértékei', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: MinesweeperGame(rows: 8, columns: 8, mineCount: 10),
      ));

      // Ellenőrizzük a kezdő értékeket
      expect(find.text('Idő: 0 mp'), findsOneWidget);
      expect(find.text('Lépések: 0'), findsOneWidget);
    });

    testWidgets('A játékos rálép egy aknára és megjelenik a vereség üzenet', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: MinesweeperGame(rows: 4, columns: 4, mineCount: 1),
      ));

      // Keresünk egy mezőt, és megérintjük
      final firstCell = find.byType(GestureDetector).first;
      await tester.tap(firstCell);
      await tester.pumpAndSettle();

      // Ellenőrizzük, hogy megjelenik a vereség üzenet
      expect(find.text('Vesztettél!'), findsOneWidget);
    });

    testWidgets('Újraindítás gomb működése', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: MinesweeperGame(rows: 8, columns: 8, mineCount: 10),
      ));

      // Ellenőrizzük, hogy az Újraindítás gomb megjelenik
      expect(find.text('Újraindítás'), findsOneWidget);

      // Kattintsunk az Újraindítás gombra
      await tester.tap(find.text('Újraindítás'));
      await tester.pumpAndSettle();

      // Ellenőrizzük, hogy újra betöltött a játéktér
      expect(find.text('Idő: 0 mp'), findsOneWidget);
      expect(find.text('Lépések: 0'), findsOneWidget);
    });

    testWidgets('Sikeres játékmenet: győzelem megjelenítése', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: MinesweeperGame(rows: 2, columns: 2, mineCount: 1),
      ));

      // Felfedjük az összes nem aknás mezőt
      final cells = find.byType(GestureDetector);
      await tester.tap(cells.at(1));
      await tester.tap(cells.at(2));
      await tester.tap(cells.at(3));
      await tester.pumpAndSettle();

      // Ellenőrizzük, hogy megjelenik a győzelem üzenet
      expect(find.text('Gratulálunk!'), findsOneWidget);
    });
  });
}