import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_pokemon_clean_arc/features/pokemon/domain/entities/pokemon.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/presentation/widgets/pokemon_card.dart';

void main() {
  group('PokemonCard Widget Tests', () {
    const tPokemon = Pokemon(
      id: 25,
      name: 'pikachu',
      imageUrl: 'https://example.com/pikachu.png',
      types: ['electric'],
      height: 4,
      weight: 60,
    );

    Widget createTestWidget() {
      return MaterialApp.router(
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const Scaffold(
                body: PokemonCard(pokemon: tPokemon),
              ),
            ),
            GoRoute(
              path: '/pokemon/:id',
              builder: (context, state) => const Scaffold(
                body: Text('Detail Page'),
              ),
            ),
          ],
        ),
      );
    }

    testWidgets('should display Pokemon name', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(createTestWidget());

      // assert
      expect(find.text('Pikachu'), findsOneWidget);
    });

    testWidgets('should display Pokemon types', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(createTestWidget());

      // assert
      expect(find.text('Electric'), findsOneWidget);
    });

    testWidgets('should display Pokemon image', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(createTestWidget());

      // assert
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should be tappable', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(createTestWidget());

      // assert
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('should display multiple types correctly',
        (WidgetTester tester) async {
      // arrange
      const multiTypePokemon = Pokemon(
        id: 6,
        name: 'charizard',
        imageUrl: 'https://example.com/charizard.png',
        types: ['fire', 'flying'],
        height: 17,
        weight: 905,
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const Scaffold(
                  body: PokemonCard(pokemon: multiTypePokemon),
                ),
              ),
            ],
          ),
        ),
      );

      // assert
      expect(find.text('Charizard'), findsOneWidget);
      expect(find.text('Fire'), findsOneWidget);
      expect(find.text('Flying'), findsOneWidget);
    });
  });
}
