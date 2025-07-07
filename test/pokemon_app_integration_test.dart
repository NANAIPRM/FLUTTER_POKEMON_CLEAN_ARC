// Integration test for the Pokemon app main functionality.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:flutter_pokemon_clean_arc/features/pokemon/presentation/bloc/bloc.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/presentation/pages/pokemon_list_page.dart';

class MockPokemonBloc extends MockBloc<PokemonEvent, PokemonState>
    implements PokemonBloc {}

void main() {
  group('Pokemon App Integration Tests', () {
    testWidgets('should display Pokédex title on main page',
        (WidgetTester tester) async {
      final mockBloc = MockPokemonBloc();

      // Mock the initial state
      whenListen(
        mockBloc,
        Stream.fromIterable([const PokemonInitial()]),
        initialState: const PokemonInitial(),
      );

      // Build our app and trigger a frame
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PokemonBloc>.value(
            value: mockBloc,
            child: const PokemonListPage(),
          ),
        ),
      );

      // Verify that the app bar shows Pokédx title
      expect(find.text('Pokédex'), findsOneWidget);
    });

    testWidgets('should display search bar on main page',
        (WidgetTester tester) async {
      final mockBloc = MockPokemonBloc();

      // Mock the initial state
      whenListen(
        mockBloc,
        Stream.fromIterable([const PokemonInitial()]),
        initialState: const PokemonInitial(),
      );

      // Build our app and trigger a frame
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PokemonBloc>.value(
            value: mockBloc,
            child: const PokemonListPage(),
          ),
        ),
      );

      // Verify that search bar is present
      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });
}
