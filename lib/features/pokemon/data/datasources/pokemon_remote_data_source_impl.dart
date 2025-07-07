import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exception_handler.dart';
import '../../../../core/network/dio_client.dart';
import '../models/pokemon_model.dart';
import 'pokemon_remote_data_source.dart';

/// Implementation of [PokemonRemoteDataSource] using Dio HTTP client.
///
/// This class handles all remote API calls for Pokemon data
/// and maps HTTP errors to appropriate Failure types.
class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final DioClient _dioClient;

  const PokemonRemoteDataSourceImpl(this._dioClient);

  @override
  Future<PokemonModel> getPokemon(int id) async {
    try {
      final response = await _dioClient.get(
        '${ApiConstants.pokemonEndpoint}/$id',
      );

      if (response.data == null) {
        throw const ServerFailure('Empty response from server');
      }

      return PokemonModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      // 🎯 ใช้ Failures หลากหลายตาม error type
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ServerFailure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<List<PokemonModel>> getPokemonList({
    required int limit,
    required int offset,
  }) async {
    try {
      // First, get the list of Pokemon with names and URLs
      final listResponse = await _dioClient.get(
        ApiConstants.pokemonEndpoint,
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );

      if (listResponse.data == null) {
        throw const ServerFailure('Empty response from server');
      }

      final listResponseModel = PokemonListResponseModel.fromJson(
        listResponse.data as Map<String, dynamic>,
      );

      // Fetch detailed data for each Pokemon
      final List<PokemonModel> pokemonList = [];

      for (final item in listResponseModel.results) {
        try {
          final pokemon = await getPokemon(item.id);
          pokemonList.add(pokemon);
        } on NotFoundFailure {
          // Skip Pokemon that are not found, but continue with others
          continue;
        }
      }

      return pokemonList;
    } on DioException catch (e) {
      // 🎯 ใช้ Failures หลากหลายตาม error type
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      if (e is Failure) {
        rethrow; // Re-throw known failures
      }
      throw ServerFailure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<PokemonModel> getPokemonByName(String name) async {
    try {
      final response = await _dioClient.get(
        '${ApiConstants.pokemonEndpoint}/${name.toLowerCase()}',
      );

      if (response.data == null) {
        throw const ServerFailure('Empty response from server');
      }

      return PokemonModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      // 🎯 ใช้ Failures หลากหลายตาม error type
      if (e.response?.statusCode == 404) {
        throw NotFoundFailure('Pokemon "$name" not found');
      }

      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      if (e is Failure) {
        rethrow; // Re-throw known failures
      }
      throw ServerFailure('Unexpected error: ${e.toString()}');
    }
  }
}
