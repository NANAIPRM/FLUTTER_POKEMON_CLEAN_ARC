import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_pokemon_clean_arc/core/error/failures.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/domain/entities/pokemon.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/domain/repositories/pokemon_repository.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/domain/usecases/get_pokemon_list.dart';

// Generate mock class
@GenerateNiceMocks([MockSpec<PokemonRepository>()])
import 'get_pokemon_list_test.mocks.dart';

void main() {
  late GetPokemonList usecase;
  late MockPokemonRepository mockPokemonRepository;

  setUp(() {
    mockPokemonRepository = MockPokemonRepository();
    usecase = GetPokemonList(mockPokemonRepository);
  });

  const tPokemon = Pokemon(
    id: 1,
    name: 'bulbasaur',
    imageUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
    types: ['grass', 'poison'],
    height: 7,
    weight: 69,
  );

  final tPokemonList = [tPokemon];

  group('GetPokemonList Use Case', () {
    test('should return List<Pokemon> when the repository call is successful',
        () async {
      // arrange
      const tParams = GetPokemonListParams(limit: 20, offset: 0);
      when(mockPokemonRepository.getPokemonList(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => Right(tPokemonList));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, Right(tPokemonList));
      verify(mockPokemonRepository.getPokemonList(limit: 20, offset: 0));
      verifyNoMoreInteractions(mockPokemonRepository);
    });

    test('should return Failure when the repository call fails', () async {
      // arrange
      const tParams = GetPokemonListParams(limit: 20, offset: 0);
      const tFailure = ServerFailure('Server error');
      when(mockPokemonRepository.getPokemonList(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, Left(tFailure));
      verify(mockPokemonRepository.getPokemonList(limit: 20, offset: 0));
      verifyNoMoreInteractions(mockPokemonRepository);
    });

    test('should return ValidationFailure when limit is 0', () async {
      // arrange
      const tParams = GetPokemonListParams(limit: 0, offset: 0);

      // act
      final result = await usecase(tParams);

      // assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ValidationFailure>());
      expect(
        (result as Left).value.message,
        'Invalid pagination parameters. Limit must be 1-100, offset must be >= 0',
      );
      verifyNever(mockPokemonRepository.getPokemonList(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      ));
    });

    test('should return ValidationFailure when limit is greater than 100',
        () async {
      // arrange
      const tParams = GetPokemonListParams(limit: 101, offset: 0);

      // act
      final result = await usecase(tParams);

      // assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ValidationFailure>());
      expect(
        (result as Left).value.message,
        'Invalid pagination parameters. Limit must be 1-100, offset must be >= 0',
      );
      verifyNever(mockPokemonRepository.getPokemonList(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      ));
    });

    test('should return ValidationFailure when offset is negative', () async {
      // arrange
      const tParams = GetPokemonListParams(limit: 20, offset: -1);

      // act
      final result = await usecase(tParams);

      // assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ValidationFailure>());
      expect(
        (result as Left).value.message,
        'Invalid pagination parameters. Limit must be 1-100, offset must be >= 0',
      );
      verifyNever(mockPokemonRepository.getPokemonList(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      ));
    });

    test('should call repository with correct parameters', () async {
      // arrange
      const tParams = GetPokemonListParams(limit: 50, offset: 100);
      when(mockPokemonRepository.getPokemonList(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => Right(tPokemonList));

      // act
      await usecase(tParams);

      // assert
      verify(mockPokemonRepository.getPokemonList(limit: 50, offset: 100));
    });

    test('should use default parameters when not specified', () async {
      // arrange
      const tParams = GetPokemonListParams();
      when(mockPokemonRepository.getPokemonList(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => Right(tPokemonList));

      // act
      await usecase(tParams);

      // assert
      verify(mockPokemonRepository.getPokemonList(limit: 20, offset: 0));
    });
  });
}
