import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_pokemon_clean_arc/features/pokemon/presentation/widgets/pokemon_search_bar.dart';

void main() {
  group('PokemonSearchBar Widget Tests', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('should display search text field',
        (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PokemonSearchBar(
              controller: controller,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should display search hint text', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PokemonSearchBar(
              controller: controller,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // assert
      expect(find.text('Search Pokémon by name...'), findsOneWidget);
    });

    testWidgets('should display search icon', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PokemonSearchBar(
              controller: controller,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // assert
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should call onChanged when text changes',
        (WidgetTester tester) async {
      // arrange
      String changedValue = '';
      void onChanged(String value) {
        changedValue = value;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PokemonSearchBar(
              controller: controller,
              onChanged: onChanged,
            ),
          ),
        ),
      );

      // act
      await tester.enterText(find.byType(TextField), 'pikachu');
      await tester.pumpAndSettle();

      // assert
      expect(changedValue, equals('pikachu'));
    });

    testWidgets('should display clear button when text is not empty',
        (WidgetTester tester) async {
      // arrange
      controller.text = 'pikachu';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PokemonSearchBar(
              controller: controller,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // assert
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('should call onClear when clear button is tapped',
        (WidgetTester tester) async {
      // arrange
      bool wasClearCalled = false;
      void onClear() {
        wasClearCalled = true;
        controller.clear();
      }

      controller.text = 'pikachu';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PokemonSearchBar(
              controller: controller,
              onChanged: (value) {},
              onClear: onClear,
            ),
          ),
        ),
      );

      // act
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // assert
      expect(wasClearCalled, isTrue);
      expect(controller.text, isEmpty);
    });

    testWidgets('should not display clear button when text is empty',
        (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PokemonSearchBar(
              controller: controller,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // assert
      expect(find.byIcon(Icons.clear), findsNothing);
    });
  });
}
