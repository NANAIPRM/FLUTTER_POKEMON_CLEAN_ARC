import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_pokemon_clean_arc/core/error/failures.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/domain/entities/pokemon.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/domain/repositories/pokemon_repository.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/domain/usecases/get_pokemon.dart';

// Generate mock class
@GenerateNiceMocks([MockSpec<PokemonRepository>()])
import 'get_pokemon_test.mocks.dart';

void main() {
  late GetPokemon usecase;
  late MockPokemonRepository mockPokemonRepository;

  setUp(() {
    mockPokemonRepository = MockPokemonRepository();
    usecase = GetPokemon(mockPokemonRepository);
  });

  const tId = 1;
  const tPokemon = Pokemon(
    id: 1,
    name: 'bulbasaur',
    imageUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
    types: ['grass', 'poison'],
    height: 7,
    weight: 69,
  );

  group('GetPokemon Use Case', () {
    test('should return Pokemon when the repository call is successful',
        () async {
      // arrange
      when(mockPokemonRepository.getPokemon(any))
          .thenAnswer((_) async => const Right(tPokemon));

      // act
      final result = await usecase(tId);

      // assert
      expect(result, const Right(tPokemon));
      verify(mockPokemonRepository.getPokemon(tId));
      verifyNoMoreInteractions(mockPokemonRepository);
    });

    test('should return Failure when the repository call fails', () async {
      // arrange
      const tFailure = ServerFailure('Server error');
      when(mockPokemonRepository.getPokemon(any))
          .thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await usecase(tId);

      // assert
      expect(result, const Left(tFailure));
      verify(mockPokemonRepository.getPokemon(tId));
      verifyNoMoreInteractions(mockPokemonRepository);
    });

    test('should return ValidationFailure when Pokemon ID is less than 1',
        () async {
      // arrange
      const tInvalidId = 0;

      // act
      final result = await usecase(tInvalidId);

      // assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ValidationFailure>());
      expect(
        (result as Left).value.message,
        'Pokemon ID must be between 1 and 1010',
      );
      verifyNever(mockPokemonRepository.getPokemon(any));
    });

    test('should return ValidationFailure when Pokemon ID is greater than 1010',
        () async {
      // arrange
      const tInvalidId = 1011;

      // act
      final result = await usecase(tInvalidId);

      // assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ValidationFailure>());
      expect(
        (result as Left).value.message,
        'Pokemon ID must be between 1 and 1010',
      );
      verifyNever(mockPokemonRepository.getPokemon(any));
    });

    test('should call repository with correct Pokemon ID', () async {
      // arrange
      when(mockPokemonRepository.getPokemon(any))
          .thenAnswer((_) async => const Right(tPokemon));

      // act
      await usecase(tId);

      // assert
      verify(mockPokemonRepository.getPokemon(tId));
    });
  });
}
