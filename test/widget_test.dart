// This is a basic Flutter widget test for the Pokemon app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_pokemon_clean_arc/features/pokemon/presentation/bloc/bloc.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/presentation/pages/pokemon_list_page.dart';

class MockPokemonBloc extends Mock implements PokemonBloc {}

void main() {
  testWidgets('Pokemon app should show Pokédex title', (WidgetTester tester) async {
    final mockBloc = MockPokemonBloc();
    
    // Mock the initial state
    when(mockBloc.state).thenReturn(const PokemonInitial());
    when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([const PokemonInitial()]));

    // Build our app and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<PokemonBloc>.value(
          value: mockBloc,
          child: const PokemonListPage(),
        ),
      ),
    );

    // Verify that the app bar shows Pokédex title
    expect(find.text('Pokédex'), findsOneWidget);
  });
}
