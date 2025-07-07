import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:flutter_pokemon_clean_arc/core/error/failures.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/domain/entities/pokemon.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/presentation/bloc/bloc.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/presentation/pages/pokemon_detail_page.dart';
import 'package:flutter_pokemon_clean_arc/core/router/app_router.dart';

class MockPokemonBloc extends MockBloc<PokemonEvent, PokemonState>
    implements PokemonBloc {}

void main() {
  group('PokemonDetailPage Widget Tests', () {
    const tPokemon = Pokemon(
      id: 25,
      name: 'pikachu',
      imageUrl: 'https://example.com/pikachu.png',
      types: ['electric'],
      height: 4,
      weight: 60,
    );

    testWidgets('should display Pokemon details correctly',
        (WidgetTester tester) async {
      // arrange
      Widget testWidget = MaterialApp(
        home: const PokemonDetailPage(pokemon: tPokemon),
      );

      // act
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // assert
      expect(find.text('Pikachu'), findsWidgets);
      expect(find.text('#025'), findsOneWidget);
      expect(find.text('Electric'),
          findsWidgets); // appears in type chip and info section
      expect(find.text('Types'),
          findsWidgets); // appears in section header and info row
      expect(find.text('Physical Stats'), findsOneWidget);
      expect(find.text('Pokemon Information'), findsOneWidget);
    });

    testWidgets('should display Pokemon stats correctly',
        (WidgetTester tester) async {
      // arrange
      Widget testWidget = MaterialApp(
        home: const PokemonDetailPage(pokemon: tPokemon),
      );

      // act
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // assert
      expect(find.text('0.4 m'), findsOneWidget); // height converted to meters
      expect(find.text('6.0 kg'), findsOneWidget); // weight converted to kg
    });

    testWidgets('should display Pokemon information rows',
        (WidgetTester tester) async {
      // arrange
      Widget testWidget = MaterialApp(
        home: const PokemonDetailPage(pokemon: tPokemon),
      );

      // act
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // assert
      expect(find.text('ID'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('0.4 meters'), findsOneWidget);
      expect(find.text('6.0 kilograms'), findsOneWidget);
    });
  });

  group('PokemonDetailPageWithLoader Widget Tests', () {
    late MockPokemonBloc mockPokemonBloc;

    setUp(() {
      mockPokemonBloc = MockPokemonBloc();
    });

    const tPokemon = Pokemon(
      id: 25,
      name: 'pikachu',
      imageUrl: 'https://example.com/pikachu.png',
      types: ['electric'],
      height: 4,
      weight: 60,
    );

    Widget createTestWidget() {
      return MaterialApp(
        home: BlocProvider<PokemonBloc>.value(
          value: mockPokemonBloc,
          child: const PokemonDetailPageWithLoader(pokemonId: 25),
        ),
      );
    }

    testWidgets('should display loading when state is PokemonLoading',
        (WidgetTester tester) async {
      // arrange
      whenListen(
        mockPokemonBloc,
        Stream.fromIterable([const PokemonLoading()]),
        initialState: const PokemonLoading(),
      );

      // act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('should display Pokemon when state is PokemonLoaded',
        (WidgetTester tester) async {
      // arrange
      whenListen(
        mockPokemonBloc,
        Stream.fromIterable([const PokemonLoaded(tPokemon)]),
        initialState: const PokemonLoaded(tPokemon),
      );

      // act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // assert
      expect(find.text('Pikachu'), findsWidgets);
      expect(find.text('#025'), findsOneWidget);
      expect(find.text('Electric'),
          findsWidgets); // appears in type chip and info section
    });

    testWidgets('should display error when state is PokemonError',
        (WidgetTester tester) async {
      // arrange
      const errorState = PokemonError(
        failure: NetworkFailure('Network error'),
        message: 'Failed to load Pokemon',
      );

      whenListen(
        mockPokemonBloc,
        Stream.fromIterable([errorState]),
        initialState: errorState,
      );

      // act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // assert
      expect(find.text('Failed to load Pokemon'),
          findsWidgets); // appears in title and message
      expect(find.text('Error'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should display retry button on error',
        (WidgetTester tester) async {
      // arrange
      const errorState = PokemonError(
        failure: NetworkFailure('Network error'),
        message: 'Failed to load Pokemon',
      );

      whenListen(
        mockPokemonBloc,
        Stream.fromIterable([errorState]),
        initialState: errorState,
      );

      // act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // assert
      expect(find.text('Go Back'), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
    });
  });
}
