import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_pokemon_clean_arc/core/error/failures.dart';
import 'package:flutter_pokemon_clean_arc/core/network/dio_client.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/data/datasources/pokemon_remote_data_source_impl.dart';
import 'package:flutter_pokemon_clean_arc/features/pokemon/data/models/pokemon_model.dart';

// Generate mock class
@GenerateNiceMocks([MockSpec<DioClient>()])
import 'pokemon_remote_data_source_test.mocks.dart';

void main() {
  late PokemonRemoteDataSourceImpl dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = PokemonRemoteDataSourceImpl(mockDioClient);
  });

  group('PokemonRemoteDataSource', () {
    const tId = 1;
    const tName = 'bulbasaur';

    final tPokemonJson = {
      'id': 1,
      'name': 'bulbasaur',
      'height': 7,
      'weight': 69,
      'sprites': {
        'front_default':
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
      },
      'types': [
        {
          'type': {
            'name': 'grass',
          }
        },
        {
          'type': {
            'name': 'poison',
          }
        }
      ]
    };

    final tPokemonModel = PokemonModel.fromJson(tPokemonJson);

    group('getPokemon', () {
      test('should return PokemonModel when the call is successful', () async {
        // arrange
        when(mockDioClient.get(any)).thenAnswer(
          (_) async => Response(
            data: tPokemonJson,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // act
        final result = await dataSource.getPokemon(tId);

        // assert
        expect(result, equals(tPokemonModel));
        verify(mockDioClient.get('pokemon/$tId'));
      });

      test('should throw ServerFailure when response data is null', () async {
        // arrange
        when(mockDioClient.get(any)).thenAnswer(
          (_) async => Response(
            data: null,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // act
        final call = dataSource.getPokemon;

        // assert
        expect(() => call(tId), throwsA(isA<ServerFailure>()));
      });

      test(
          'should throw TimeoutFailure when DioException is connection timeout',
          () async {
        // arrange
        when(mockDioClient.get(any)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // act
        final call = dataSource.getPokemon;

        // assert
        expect(() => call(tId), throwsA(isA<TimeoutFailure>()));
      });

      test(
          'should throw ConnectionFailure when DioException is connection error',
          () async {
        // arrange
        when(mockDioClient.get(any)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionError,
          ),
        );

        // act
        final call = dataSource.getPokemon;

        // assert
        expect(() => call(tId), throwsA(isA<ConnectionFailure>()));
      });

      test('should throw NotFoundFailure when response status is 404',
          () async {
        // arrange
        when(mockDioClient.get(any)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.badResponse,
            response: Response(
              statusCode: 404,
              requestOptions: RequestOptions(path: ''),
            ),
          ),
        );

        // act
        final call = dataSource.getPokemon;

        // assert
        expect(() => call(tId), throwsA(isA<NotFoundFailure>()));
      });

      test('should throw UnauthorizedFailure when response status is 401',
          () async {
        // arrange
        when(mockDioClient.get(any)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.badResponse,
            response: Response(
              statusCode: 401,
              requestOptions: RequestOptions(path: ''),
            ),
          ),
        );

        // act
        final call = dataSource.getPokemon;

        // assert
        expect(() => call(tId), throwsA(isA<UnauthorizedFailure>()));
      });

      test('should throw ServerFailure for other HTTP errors', () async {
        // arrange
        when(mockDioClient.get(any)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.badResponse,
            response: Response(
              statusCode: 500,
              requestOptions: RequestOptions(path: ''),
            ),
          ),
        );

        // act
        final call = dataSource.getPokemon;

        // assert
        expect(() => call(tId), throwsA(isA<ServerFailure>()));
      });
    });

    group('getPokemonByName', () {
      test('should return PokemonModel when the call is successful', () async {
        // arrange
        when(mockDioClient.get(any)).thenAnswer(
          (_) async => Response(
            data: tPokemonJson,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // act
        final result = await dataSource.getPokemonByName(tName);

        // assert
        expect(result, equals(tPokemonModel));
        verify(mockDioClient.get('pokemon/$tName'));
      });

      test('should throw NotFoundFailure when Pokemon name is not found',
          () async {
        // arrange
        when(mockDioClient.get(any)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.badResponse,
            response: Response(
              statusCode: 404,
              requestOptions: RequestOptions(path: ''),
            ),
          ),
        );

        // act
        final call = dataSource.getPokemonByName;

        // assert
        expect(() => call(tName), throwsA(isA<NotFoundFailure>()));
      });

      test('should convert name to lowercase before making request', () async {
        // arrange
        const tUpperCaseName = 'BULBASAUR';
        when(mockDioClient.get(any)).thenAnswer(
          (_) async => Response(
            data: tPokemonJson,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // act
        await dataSource.getPokemonByName(tUpperCaseName);

        // assert
        verify(mockDioClient.get('pokemon/bulbasaur'));
      });
    });
  });
}
