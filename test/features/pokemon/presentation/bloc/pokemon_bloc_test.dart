import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_pokemon_clean_arc/core/error/failures.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/domain/entities/pokemon.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/domain/usecases/get_pokemon.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/domain/usecases/get_pokemon_by_name.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/domain/usecases/get_pokemon_list.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/presentation/bloc/bloc.dart';

// Generate mock classes
@GenerateNiceMocks([
  MockSpec<GetPokemon>(),
  MockSpec<GetPokemonByName>(),
  MockSpec<GetPokemonList>(),
])
import 'pokemon_bloc_test.mocks.dart';

void main() {
  late PokemonBloc pokemonBloc;
  late MockGetPokemon mockGetPokemon;
  late MockGetPokemonByName mockGetPokemonByName;
  late MockGetPokemonList mockGetPokemonList;

  setUp(() {
    mockGetPokemon = MockGetPokemon();
    mockGetPokemonByName = MockGetPokemonByName();
    mockGetPokemonList = MockGetPokemonList();
    pokemonBloc = PokemonBloc(
      getPokemon: mockGetPokemon,
      getPokemonByName: mockGetPokemonByName,
      getPokemonList: mockGetPokemonList,
    );
  });

  tearDown(() {
    pokemonBloc.close();
  });

  const tPokemon = Pokemon(
    id: 1,
    name: 'bulbasaur',
    imageUrl: 'https://example.com/bulbasaur.png',
    types: ['grass', 'poison'],
    height: 7,
    weight: 69,
  );

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
      id: 2,
      name: 'ivysaur',
      imageUrl: 'https://example.com/ivysaur.png',
      types: ['grass', 'poison'],
      height: 10,
      weight: 130,
    ),
  ];

  group('PokemonBloc', () {
    test('initial state should be PokemonInitial', () {
      expect(pokemonBloc.state, equals(const PokemonInitial()));
    });

    group('GetPokemonEvent', () {
      blocTest<PokemonBloc, PokemonState>(
        'should emit [PokemonLoading, PokemonLoaded] when getPokemon succeeds',
        build: () {
          when(mockGetPokemon.call(any))
              .thenAnswer((_) async => const Right(tPokemon));
          return pokemonBloc;
        },
        act: (bloc) => bloc.add(const GetPokemonEvent(1)),
        expect: () => [
          const PokemonLoading(),
          const PokemonLoaded(tPokemon),
        ],
        verify: (_) {
          verify(mockGetPokemon.call(1));
        },
      );

      blocTest<PokemonBloc, PokemonState>(
        'should emit [PokemonLoading, PokemonError] when getPokemon fails',
        build: () {
          when(mockGetPokemon.call(any)).thenAnswer(
              (_) async => const Left(ServerFailure('Server error')));
          return pokemonBloc;
        },
        act: (bloc) => bloc.add(const GetPokemonEvent(1)),
        expect: () => [
          const PokemonLoading(),
          predicate<PokemonError>((state) =>
              state.failure is ServerFailure &&
              state.message ==
                  'Server error occurred. Please try again later.'),
        ],
        verify: (_) {
          verify(mockGetPokemon.call(1));
        },
      );
    });

    group('GetPokemonByNameEvent', () {
      blocTest<PokemonBloc, PokemonState>(
        'should emit [PokemonLoading, PokemonLoaded] when getPokemonByName succeeds',
        build: () {
          when(mockGetPokemonByName.call(any))
              .thenAnswer((_) async => const Right(tPokemon));
          return pokemonBloc;
        },
        act: (bloc) => bloc.add(const GetPokemonByNameEvent('bulbasaur')),
        expect: () => [
          const PokemonLoading(),
          const PokemonLoaded(tPokemon),
        ],
        verify: (_) {
          verify(mockGetPokemonByName.call('bulbasaur'));
        },
      );

      blocTest<PokemonBloc, PokemonState>(
        'should emit [PokemonLoading, PokemonError] when getPokemonByName fails',
        build: () {
          when(mockGetPokemonByName.call(any)).thenAnswer(
              (_) async => const Left(NetworkFailure('Network error')));
          return pokemonBloc;
        },
        act: (bloc) => bloc.add(const GetPokemonByNameEvent('bulbasaur')),
        expect: () => [
          const PokemonLoading(),
          predicate<PokemonError>((state) =>
              state.failure is NetworkFailure &&
              state.message ==
                  'No internet connection. Showing cached data if available.'),
        ],
        verify: (_) {
          verify(mockGetPokemonByName.call('bulbasaur'));
        },
      );
    });

    group('GetPokemonListEvent', () {
      blocTest<PokemonBloc, PokemonState>(
        'should emit [PokemonLoading, PokemonListLoaded] when getPokemonList succeeds',
        build: () {
          when(mockGetPokemonList.call(any))
              .thenAnswer((_) async => const Right(tPokemonList));
          return pokemonBloc;
        },
        act: (bloc) => bloc.add(const GetPokemonListEvent()),
        expect: () => [
          const PokemonLoading(),
          const PokemonListLoaded(
            pokemonList: tPokemonList,
            hasReachedMax: true, // 2 items < 20 limit = true
            currentOffset: 2,
          ),
        ],
        verify: (_) {
          verify(mockGetPokemonList.call(any));
        },
      );

      blocTest<PokemonBloc, PokemonState>(
        'should emit [PokemonLoading, PokemonError] when getPokemonList fails',
        build: () {
          when(mockGetPokemonList.call(any))
              .thenAnswer((_) async => const Left(CacheFailure('Cache error')));
          return pokemonBloc;
        },
        act: (bloc) => bloc.add(const GetPokemonListEvent()),
        expect: () => [
          const PokemonLoading(),
          predicate<PokemonError>((state) =>
              state.failure is CacheFailure &&
              state.message ==
                  'Cache error occurred. Please check your storage.'),
        ],
        verify: (_) {
          verify(mockGetPokemonList.call(any));
        },
      );

      blocTest<PokemonBloc, PokemonState>(
        'should emit [PokemonLoadingMore, PokemonListLoaded] when loading more items',
        seed: () => const PokemonListLoaded(
          pokemonList: [tPokemon],
          currentOffset: 1,
        ),
        build: () {
          when(mockGetPokemonList.call(any))
              .thenAnswer((_) async => Right([tPokemonList[1]]));
          return pokemonBloc;
        },
        act: (bloc) => bloc.add(const GetPokemonListEvent(offset: 1)),
        expect: () => [
          const PokemonLoadingMore([tPokemon]),
          PokemonListLoaded(
            pokemonList: [tPokemon, tPokemonList[1]],
            hasReachedMax: true, // Only 1 item returned, less than limit
            currentOffset: 2,
          ),
        ],
        verify: (_) {
          verify(mockGetPokemonList.call(any));
        },
      );
    });

    group('SearchPokemonEvent', () {
      blocTest<PokemonBloc, PokemonState>(
        'should emit [PokemonLoading, PokemonSearchLoaded] when search succeeds',
        build: () {
          when(mockGetPokemonByName.call(any))
              .thenAnswer((_) async => const Right(tPokemon));
          return pokemonBloc;
        },
        act: (bloc) => bloc.add(const SearchPokemonEvent('bulbasaur')),
        expect: () => [
          const PokemonLoading(),
          const PokemonSearchLoaded(
            searchResults: [tPokemon],
            query: 'bulbasaur',
          ),
        ],
        verify: (_) {
          verify(mockGetPokemonByName.call('bulbasaur'));
        },
      );

      blocTest<PokemonBloc, PokemonState>(
        'should clear search when query is empty',
        build: () {
          when(mockGetPokemonList.call(any))
              .thenAnswer((_) async => const Right(tPokemonList));
          return pokemonBloc;
        },
        act: (bloc) => bloc.add(const SearchPokemonEvent('')),
        expect: () => [
          const PokemonLoading(),
          const PokemonListLoaded(
            pokemonList: tPokemonList,
            hasReachedMax: true, // 2 items < 20 limit = true
            currentOffset: 2,
          ),
        ],
        verify: (_) {
          verify(mockGetPokemonList.call(any));
        },
      );
    });

    group('ClearSearchEvent', () {
      blocTest<PokemonBloc, PokemonState>(
        'should load fresh list when clearing search',
        build: () {
          when(mockGetPokemonList.call(any))
              .thenAnswer((_) async => const Right(tPokemonList));
          return pokemonBloc;
        },
        act: (bloc) => bloc.add(const ClearSearchEvent()),
        expect: () => [
          const PokemonLoading(),
          const PokemonListLoaded(
            pokemonList: tPokemonList,
            hasReachedMax: true, // 2 items < 20 limit = true
            currentOffset: 2,
          ),
        ],
        verify: (_) {
          verify(mockGetPokemonList.call(any));
        },
      );
    });

    group('RefreshPokemonEvent', () {
      blocTest<PokemonBloc, PokemonState>(
        'should refresh when in PokemonListLoaded state',
        seed: () => const PokemonListLoaded(pokemonList: tPokemonList),
        build: () {
          when(mockGetPokemonList.call(any))
              .thenAnswer((_) async => const Right(tPokemonList));
          return pokemonBloc;
        },
        act: (bloc) => bloc.add(const RefreshPokemonEvent()),
        expect: () => [
          const PokemonRefreshing(tPokemonList),
          const PokemonLoading(),
          const PokemonListLoaded(
            pokemonList: tPokemonList,
            hasReachedMax: true, // 2 items < 20 limit = true
            currentOffset: 2,
          ),
        ],
        verify: (_) {
          verify(mockGetPokemonList.call(any));
        },
      );

      blocTest<PokemonBloc, PokemonState>(
        'should load fresh list when not in list state',
        build: () {
          when(mockGetPokemonList.call(any))
              .thenAnswer((_) async => const Right(tPokemonList));
          return pokemonBloc;
        },
        act: (bloc) => bloc.add(const RefreshPokemonEvent()),
        expect: () => [
          const PokemonLoading(),
          const PokemonListLoaded(
            pokemonList: tPokemonList,
            hasReachedMax: true, // 2 items < 20 limit = true
            currentOffset: 2,
          ),
        ],
        verify: (_) {
          verify(mockGetPokemonList.call(any));
        },
      );
    });
  });
}
