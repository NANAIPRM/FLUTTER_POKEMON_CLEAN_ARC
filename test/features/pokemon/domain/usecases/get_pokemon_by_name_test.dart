import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_pokemon_clean_arc/core/error/failures.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/domain/entities/pokemon.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/domain/repositories/pokemon_repository.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/domain/usecases/get_pokemon_by_name.dart';

// Generate mock class
@GenerateNiceMocks([MockSpec<PokemonRepository>()])
import 'get_pokemon_by_name_test.mocks.dart';

void main() {
  late GetPokemonByName usecase;
  late MockPokemonRepository mockPokemonRepository;

  setUp(() {
    mockPokemonRepository = MockPokemonRepository();
    usecase = GetPokemonByName(mockPokemonRepository);
  });

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

  group('GetPokemonByName Use Case', () {
    test('should return Pokemon when the repository call is successful',
        () async {
      // arrange
      when(mockPokemonRepository.getPokemonByName(any))
          .thenAnswer((_) async => Right(tPokemon));

      // act
      final result = await usecase(tName);

      // assert
      expect(result, Right(tPokemon));
      verify(mockPokemonRepository.getPokemonByName(tName));
      verifyNoMoreInteractions(mockPokemonRepository);
    });

    test('should return Failure when the repository call fails', () async {
      // arrange
      const tFailure = ServerFailure('Server error');
      when(mockPokemonRepository.getPokemonByName(any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(tName);

      // assert
      expect(result, Left(tFailure));
      verify(mockPokemonRepository.getPokemonByName(tName));
      verifyNoMoreInteractions(mockPokemonRepository);
    });

    test('should return ValidationFailure when name is empty', () async {
      // arrange
      const tEmptyName = '';

      // act
      final result = await usecase(tEmptyName);

      // assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ValidationFailure>());
      expect(
        (result as Left).value.message,
        'Pokemon name cannot be empty',
      );
      verifyNever(mockPokemonRepository.getPokemonByName(any));
    });

    test('should return ValidationFailure when name is only whitespace',
        () async {
      // arrange
      const tWhitespaceName = '   ';

      // act
      final result = await usecase(tWhitespaceName);

      // assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ValidationFailure>());
      expect(
        (result as Left).value.message,
        'Pokemon name cannot be empty',
      );
      verifyNever(mockPokemonRepository.getPokemonByName(any));
    });

    test('should return ValidationFailure when name is too long', () async {
      // arrange
      final tLongName = 'a' * 51; // 51 characters

      // act
      final result = await usecase(tLongName);

      // assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ValidationFailure>());
      expect(
        (result as Left).value.message,
        'Pokemon name is too long',
      );
      verifyNever(mockPokemonRepository.getPokemonByName(any));
    });

    test(
        'should return ValidationFailure when name contains invalid characters',
        () async {
      // arrange
      const tInvalidName = 'bulba@saur';

      // act
      final result = await usecase(tInvalidName);

      // assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ValidationFailure>());
      expect(
        (result as Left).value.message,
        'Pokemon name can only contain letters, numbers, and hyphens',
      );
      verifyNever(mockPokemonRepository.getPokemonByName(any));
    });

    test('should convert name to lowercase before calling repository',
        () async {
      // arrange
      const tUpperCaseName = 'BULBASAUR';
      when(mockPokemonRepository.getPokemonByName(any))
          .thenAnswer((_) async => Right(tPokemon));

      // act
      await usecase(tUpperCaseName);

      // assert
      verify(mockPokemonRepository.getPokemonByName('bulbasaur'));
    });

    test('should trim whitespace from name before validation', () async {
      // arrange
      const tNameWithSpaces = '  bulbasaur  ';
      when(mockPokemonRepository.getPokemonByName(any))
          .thenAnswer((_) async => Right(tPokemon));

      // act
      await usecase(tNameWithSpaces);

      // assert
      verify(mockPokemonRepository.getPokemonByName('bulbasaur'));
    });

    test('should accept valid names with hyphens and numbers', () async {
      // arrange
      const tValidName = 'ho-oh2';
      when(mockPokemonRepository.getPokemonByName(any))
          .thenAnswer((_) async => Right(tPokemon));

      // act
      final result = await usecase(tValidName);

      // assert
      expect(result, Right(tPokemon));
      verify(mockPokemonRepository.getPokemonByName(tValidName));
    });
  });
}
