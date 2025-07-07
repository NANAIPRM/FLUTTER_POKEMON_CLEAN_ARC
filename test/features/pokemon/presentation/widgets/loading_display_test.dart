import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_pokemon_clean_arc/features/pokemon/presentation/widgets/loading_display.dart';

void main() {
  group('LoadingDisplay Widget Tests', () {
    testWidgets('should display loading indicator',
        (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingDisplay(),
          ),
        ),
      );

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display loading text when message is provided',
        (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingDisplay(message: 'Loading Pokémon...'),
          ),
        ),
      );

      // assert
      expect(find.text('Loading Pokémon...'), findsOneWidget);
    });

    testWidgets('should not display text when message is null',
        (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingDisplay(),
          ),
        ),
      );

      // assert
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('should be centered on screen', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingDisplay(),
          ),
        ),
      );

      // assert
      expect(find.byType(Center), findsOneWidget);
    });
  });
}
