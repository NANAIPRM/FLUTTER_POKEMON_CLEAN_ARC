import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_local_data_source.dart';
import '../datasources/pokemon_remote_data_source.dart';
import '../models/pokemon_model.dart';

/// Implementation of [PokemonRepository].
///
/// This class coordinates between remote and local data sources,
/// implements caching strategy, and handles network connectivity.
/// It demonstrates the use of various Failure types based on different scenarios.
class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource _remoteDataSource;
  final PokemonLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  const PokemonRepositoryImpl({
    required PokemonRemoteDataSource remoteDataSource,
    required PokemonLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, Pokemon>> getPokemon(int id) async {
    if (await _networkInfo.isConnected) {
      try {
        final remotePokemon = await _remoteDataSource.getPokemon(id);

        // Cache the result for offline access (ignore cache failures)
        _cachePokemonSafely(remotePokemon);

        return Right(remotePokemon.toEntity());
      } catch (e) {
        final failure = _mapToFailure(e);

        // Try cache for recoverable errors, return immediately for others
        if (_shouldRetryFromCache(failure)) {
          return _tryGetFromCache(id, failure);
        } else {
          return Left(failure);
        }
      }
    } else {
      return _getFromCacheOnly(id);
    }
  }

  @override
  Future<Either<Failure, List<Pokemon>>> getPokemonList({
    int limit = 20,
    int offset = 0,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final remotePokemonList = await _remoteDataSource.getPokemonList(
          limit: limit,
          offset: offset,
        );

        // Cache the result for offline access (ignore cache failures)
        _cachePokemonListSafely(remotePokemonList);

        return Right(remotePokemonList.map((model) => model.toEntity()).toList());
      } catch (e) {
        final failure = _mapToFailure(e);
        
        // Try cache for recoverable errors, return immediately for others
        if (_shouldRetryFromCache(failure)) {
          return _tryGetListFromCache(failure);
        } else {
          return Left(failure);
        }
      }
    } else {
      return _getListFromCacheOnly();
    }
  }

  @override
  Future<Either<Failure, Pokemon>> getPokemonByName(String name) async {
    if (await _networkInfo.isConnected) {
      try {
        final remotePokemon = await _remoteDataSource.getPokemonByName(name);

        // Cache the result for offline access (ignore cache failures)
        _cachePokemonSafely(remotePokemon);

        return Right(remotePokemon.toEntity());
      } catch (e) {
        final failure = _mapToFailure(e);
        
        // Try cache for recoverable errors, return immediately for others
        if (_shouldRetryFromCache(failure)) {
          return _tryGetByNameFromCache(name, failure);
        } else {
          return Left(failure);
        }
      }
    } else {
      return _getByNameFromCacheOnly(name);
    }
  }

  // 🔄 Helper methods for cache fallback

  /// Determines if we should try cache when remote fails
  bool _shouldRetryFromCache(Failure failure) {
    return failure is ServerFailure ||
        failure is TimeoutFailure ||
        failure is ConnectionFailure;
  }

  /// Maps any error to appropriate Failure
  Failure _mapToFailure(dynamic error) {
    if (error is Failure) return error;
    return ServerFailure('Unexpected error: ${error.toString()}');
  }

  /// Safely cache Pokemon without throwing on cache errors
  void _cachePokemonSafely(PokemonModel pokemon) {
    _localDataSource.cachePokemon(pokemon).catchError((_) {
      // Ignore cache errors when we have data
    });
  }

  /// Safely cache Pokemon list without throwing on cache errors
  void _cachePokemonListSafely(List<PokemonModel> pokemonList) {
    _localDataSource.cachePokemonList(pokemonList).catchError((_) {
      // Ignore cache errors when we have data
    });
  }

  /// Get Pokemon from cache only (offline mode)
  Future<Either<Failure, Pokemon>> _getFromCacheOnly(int id) async {
    try {
      final localPokemon = await _localDataSource.getLastPokemon(id);
      return Right(localPokemon.toEntity());
    } on CacheFailure catch (failure) {
      return Left(NetworkFailure(
        'No internet connection and no cached data available: ${failure.message}',
      ));
    }
  }

  /// Get Pokemon list from cache only (offline mode)
  Future<Either<Failure, List<Pokemon>>> _getListFromCacheOnly() async {
    try {
      final localPokemonList = await _localDataSource.getLastPokemonList();
      return Right(localPokemonList.map((model) => model.toEntity()).toList());
    } on CacheFailure catch (failure) {
      return Left(NetworkFailure(
        'No internet connection and no cached data available: ${failure.message}',
      ));
    }
  }

  /// Get Pokemon by name from cache only (offline mode)
  Future<Either<Failure, Pokemon>> _getByNameFromCacheOnly(String name) async {
    try {
      final localPokemon = await _localDataSource.getLastPokemonByName(name);
      return Right(localPokemon.toEntity());
    } on CacheFailure catch (failure) {
      return Left(NetworkFailure(
        'No internet connection and no cached data available: ${failure.message}',
      ));
    }
  }

  Future<Either<Failure, Pokemon>> _tryGetFromCache(
      int id, Failure originalFailure) async {
    try {
      final localPokemon = await _localDataSource.getLastPokemon(id);
      return Right(localPokemon.toEntity());
    } on CacheFailure {
      // Cache also failed, return original remote failure
      return Left(originalFailure);
    }
  }

  Future<Either<Failure, List<Pokemon>>> _tryGetListFromCache(
      Failure originalFailure) async {
    try {
      final localPokemonList = await _localDataSource.getLastPokemonList();
      return Right(localPokemonList.map((model) => model.toEntity()).toList());
    } on CacheFailure {
      // Cache also failed, return original remote failure
      return Left(originalFailure);
    }
  }

  Future<Either<Failure, Pokemon>> _tryGetByNameFromCache(
    String name,
    Failure originalFailure,
  ) async {
    try {
      final localPokemon = await _localDataSource.getLastPokemonByName(name);
      return Right(localPokemon.toEntity());
    } on CacheFailure {
      // Cache also failed, return original remote failure
      return Left(originalFailure);
    }
  }
}
