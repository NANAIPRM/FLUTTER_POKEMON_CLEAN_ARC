import '../models/pokemon_model.dart';

/// Abstract interface for remote Pokemon data operations.
///
/// This interface defines the contract for fetching Pokemon data
/// from remote sources (APIs).
abstract class PokemonRemoteDataSource {
  /// Fetches a Pokemon by its ID from the remote API.
  ///
  /// Throws [ServerFailure] if the server returns an error.
  /// Throws [TimeoutFailure] if the request times out.
  /// Throws [ConnectionFailure] if there's a connection issue.
  /// Throws [NotFoundFailure] if the Pokemon is not found (404).
  /// Throws [UnauthorizedFailure] if the request is unauthorized (401).
  Future<PokemonModel> getPokemon(int id);

  /// Fetches a list of Pokemon from the remote API with pagination.
  ///
  /// The [limit] parameter controls how many Pokemon to fetch.
  /// The [offset] parameter controls the starting point for pagination.
  ///
  /// Throws [ServerFailure] if the server returns an error.
  /// Throws [TimeoutFailure] if the request times out.
  /// Throws [ConnectionFailure] if there's a connection issue.
  Future<List<PokemonModel>> getPokemonList({
    required int limit,
    required int offset,
  });

  /// Fetches a Pokemon by its name from the remote API.
  ///
  /// Throws [ServerFailure] if the server returns an error.
  /// Throws [TimeoutFailure] if the request times out.
  /// Throws [ConnectionFailure] if there's a connection issue.
  /// Throws [NotFoundFailure] if the Pokemon is not found (404).
  /// Throws [UnauthorizedFailure] if the request is unauthorized (401).
  Future<PokemonModel> getPokemonByName(String name);
}
