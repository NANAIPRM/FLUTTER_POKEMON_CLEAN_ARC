import '../models/pokemon_model.dart';

/// Abstract interface for local Pokemon data operations.
///
/// This interface defines the contract for caching and retrieving
/// Pokemon data from local storage.
abstract class PokemonLocalDataSource {
  /// Caches a Pokemon in local storage.
  ///
  /// Throws [CacheFailure] if caching fails.
  Future<void> cachePokemon(PokemonModel pokemon);

  /// Caches a list of Pokemon in local storage.
  ///
  /// Throws [CacheFailure] if caching fails.
  Future<void> cachePokemonList(List<PokemonModel> pokemonList);

  /// Retrieves the last cached Pokemon by ID.
  ///
  /// Throws [CacheFailure] if no cached data is found or retrieval fails.
  Future<PokemonModel> getLastPokemon(int id);

  /// Retrieves the last cached Pokemon list.
  ///
  /// Throws [CacheFailure] if no cached data is found or retrieval fails.
  Future<List<PokemonModel>> getLastPokemonList();

  /// Retrieves the last cached Pokemon by name.
  ///
  /// Throws [CacheFailure] if no cached data is found or retrieval fails.
  Future<PokemonModel> getLastPokemonByName(String name);

  /// Clears all cached Pokemon data.
  ///
  /// Throws [CacheFailure] if clearing cache fails.
  Future<void> clearCache();
}
