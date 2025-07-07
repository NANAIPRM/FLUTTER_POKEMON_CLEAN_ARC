import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/failures.dart';
import '../models/pokemon_model.dart';
import 'pokemon_local_data_source.dart';

/// Implementation of [PokemonLocalDataSource] using SharedPreferences.
///
/// This class handles local caching of Pokemon data using SharedPreferences
/// and maps cache errors to appropriate Failure types.
class PokemonLocalDataSourceImpl implements PokemonLocalDataSource {
  final SharedPreferences _sharedPreferences;

  const PokemonLocalDataSourceImpl(this._sharedPreferences);

  // Cache keys
  static const String _cachedPokemonPrefix = 'CACHED_POKEMON_';
  static const String _cachedPokemonList = 'CACHED_POKEMON_LIST';
  static const String _cachedPokemonByNamePrefix = 'CACHED_POKEMON_NAME_';

  @override
  Future<void> cachePokemon(PokemonModel pokemon) async {
    try {
      final jsonString = json.encode(pokemon.toJson());
      final success = await _sharedPreferences.setString(
        '$_cachedPokemonPrefix${pokemon.id}',
        jsonString,
      );

      if (!success) {
        throw const CacheFailure('Failed to cache Pokemon');
      }

      // Also cache by name for search functionality
      await _sharedPreferences.setString(
        '$_cachedPokemonByNamePrefix${pokemon.name.toLowerCase()}',
        jsonString,
      );
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure('Failed to cache Pokemon: ${e.toString()}');
    }
  }

  @override
  Future<void> cachePokemonList(List<PokemonModel> pokemonList) async {
    try {
      final jsonList = pokemonList.map((pokemon) => pokemon.toJson()).toList();
      final jsonString = json.encode(jsonList);

      final success = await _sharedPreferences.setString(
        _cachedPokemonList,
        jsonString,
      );

      if (!success) {
        throw const CacheFailure('Failed to cache Pokemon list');
      }

      // Cache individual Pokemon as well
      for (final pokemon in pokemonList) {
        await cachePokemon(pokemon);
      }
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure('Failed to cache Pokemon list: ${e.toString()}');
    }
  }

  @override
  Future<PokemonModel> getLastPokemon(int id) async {
    try {
      final jsonString =
          _sharedPreferences.getString('$_cachedPokemonPrefix$id');

      if (jsonString == null) {
        throw CacheFailure('No cached Pokemon found for ID: $id');
      }

      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return PokemonModel.fromJson(jsonMap);
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure('Failed to retrieve cached Pokemon: ${e.toString()}');
    }
  }

  @override
  Future<List<PokemonModel>> getLastPokemonList() async {
    try {
      final jsonString = _sharedPreferences.getString(_cachedPokemonList);

      if (jsonString == null) {
        throw const CacheFailure('No cached Pokemon list found');
      }

      final jsonList = json.decode(jsonString) as List;
      return jsonList
          .map((json) => PokemonModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(
          'Failed to retrieve cached Pokemon list: ${e.toString()}');
    }
  }

  @override
  Future<PokemonModel> getLastPokemonByName(String name) async {
    try {
      final jsonString = _sharedPreferences.getString(
        '$_cachedPokemonByNamePrefix${name.toLowerCase()}',
      );

      if (jsonString == null) {
        throw CacheFailure('No cached Pokemon found for name: $name');
      }

      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return PokemonModel.fromJson(jsonMap);
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(
          'Failed to retrieve cached Pokemon by name: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final keys = _sharedPreferences.getKeys();
      final pokemonKeys = keys
          .where((key) =>
              key.startsWith(_cachedPokemonPrefix) ||
              key == _cachedPokemonList ||
              key.startsWith(_cachedPokemonByNamePrefix))
          .toList();

      for (final key in pokemonKeys) {
        await _sharedPreferences.remove(key);
      }
    } catch (e) {
      throw CacheFailure('Failed to clear cache: ${e.toString()}');
    }
  }
}
