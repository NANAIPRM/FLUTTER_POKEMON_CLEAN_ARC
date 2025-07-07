import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_pokemon_clean_arc/core/error/failures.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/domain/entities/pokemon.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/presentation/bloc/bloc.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/presentation/pages/pokemon_list_page.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/presentation/widgets/widgets.dart';

class MockPokemonBloc extends MockBloc<PokemonEvent, PokemonState>
    implements PokemonBloc {}

void main() {
  group('PokemonListPage Widget Tests', () {
    late MockPokemonBloc mockPokemonBloc;

    setUp(() {
      mockPokemonBloc = MockPokemonBloc();
    });

    const tPokemonList = [
      Pokemon(
        id: 1,
        name: 'bulbasaur',
        imageUrl: 'https://example.com/bulbasaur.png',
        types: ['grass', 'poison'],
        height: 7,
        weight: 69,
      ),
      Pokemon(
        id: 25,
        name: 'pikachu',
        imageUrl: 'https://example.com/pikachu.png',
        types: ['electric'],
        height: 4,
        weight: 60,
      ),
    ];

    Widget createTestWidget() {
      return MaterialApp.router(
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => BlocProvider<PokemonBloc>.value(
                value: mockPokemonBloc,
                child: const PokemonListPage(),
              ),
            ),
          ],
        ),
      );
    }

    testWidgets('should display app bar with title',
        (WidgetTester tester) async {
      // arrange
      whenListen(
        mockPokemonBloc,
        Stream.fromIterable([const PokemonInitial()]),
        initialState: const PokemonInitial(),
      );

      // act
      await tester.pumpWidget(createTestWidget());

      // assert
      expect(find.text('Pokédex'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display search bar', (WidgetTester tester) async {
      // arrange
      whenListen(
        mockPokemonBloc,
        Stream.fromIterable([const PokemonInitial()]),
        initialState: const PokemonInitial(),
      );

      // act
      await tester.pumpWidget(createTestWidget());

      // assert
      expect(find.byType(PokemonSearchBar), findsOneWidget);
    });

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
      expect(find.byType(LoadingDisplay), findsOneWidget);
    });

    testWidgets('should display Pokemon list when state is PokemonListLoaded',
        (WidgetTester tester) async {
      // arrange
      whenListen(
        mockPokemonBloc,
        Stream.fromIterable(
            [const PokemonListLoaded(pokemonList: tPokemonList)]),
        initialState: const PokemonListLoaded(pokemonList: tPokemonList),
      );

      // act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // assert
      expect(find.byType(PokemonListView), findsOneWidget);
    });

    testWidgets('should display error when state is PokemonError',
        (WidgetTester tester) async {
      // arrange
      const errorState = PokemonError(
        failure: NetworkFailure('Network error'),
        message: 'No internet connection',
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
      expect(find.byType(ErrorDisplay), findsOneWidget);
    });

    testWidgets('should display initial welcome message on PokemonInitial',
        (WidgetTester tester) async {
      // arrange
      whenListen(
        mockPokemonBloc,
        Stream.fromIterable([const PokemonInitial()]),
        initialState: const PokemonInitial(),
      );

      // act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // assert
      expect(
          find.text(
              'Welcome to Pokédex!\nPull down to refresh or search for Pokémon.'),
          findsOneWidget);
    });
  });
}
