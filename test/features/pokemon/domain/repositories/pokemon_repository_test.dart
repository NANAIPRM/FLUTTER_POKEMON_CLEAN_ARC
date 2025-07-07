import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_pokemon_clean_arc/core/error/failures.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/domain/entities/pokemon.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/domain/repositories/pokemon_repository.dart';

// Generate mock class
@GenerateNiceMocks([MockSpec<PokemonRepository>()])
import 'pokemon_repository_test.mocks.dart';

void main() {
  late MockPokemonRepository mockPokemonRepository;

  setUp(() {
    mockPokemonRepository = MockPokemonRepository();
  });

  group('PokemonRepository', () {
    const tId = 1;
    const tName = 'bulbasaur';
    const tPokemon = Pokemon(
      id: 1,
      name: 'bulbasaur',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
      types: ['grass', 'poison'],
      height: 7,
      weight: 69,
    );

    test('should return Pokemon when call to repository is successful',
        () async {
      // arrange
      when(mockPokemonRepository.getPokemon(any))
          .thenAnswer((_) async => const Right(tPokemon));

      // act
      final result = await mockPokemonRepository.getPokemon(tId);

      // assert
      expect(result, equals(const Right(tPokemon)));
      verify(mockPokemonRepository.getPokemon(tId));
      verifyNoMoreInteractions(mockPokemonRepository);
    });

    test('should return Failure when call to repository fails', () async {
      // arrange
      const tFailure = ServerFailure('Server error');
      when(mockPokemonRepository.getPokemon(any))
          .thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await mockPokemonRepository.getPokemon(tId);

      // assert
      expect(result, equals(const Left(tFailure)));
      verify(mockPokemonRepository.getPokemon(tId));
      verifyNoMoreInteractions(mockPokemonRepository);
    });

    test(
        'should return List<Pokemon> when call to getPokemonList is successful',
        () async {
      // arrange
      final tPokemonList = [tPokemon];
      when(mockPokemonRepository.getPokemonList(
              limit: anyNamed('limit'), offset: anyNamed('offset')))
          .thenAnswer((_) async => Right(tPokemonList));

      // act
      final result = await mockPokemonRepository.getPokemonList();

      // assert
      expect(result, equals(Right(tPokemonList)));
      verify(mockPokemonRepository.getPokemonList(limit: 20, offset: 0));
      verifyNoMoreInteractions(mockPokemonRepository);
    });

    test('should return Pokemon when call to getPokemonByName is successful',
        () async {
      // arrange
      when(mockPokemonRepository.getPokemonByName(any))
          .thenAnswer((_) async => const Right(tPokemon));

      // act
      final result = await mockPokemonRepository.getPokemonByName(tName);

      // assert
      expect(result, equals(const Right(tPokemon)));
      verify(mockPokemonRepository.getPokemonByName(tName));
      verifyNoMoreInteractions(mockPokemonRepository);
    });
  });
}
