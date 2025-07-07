import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/repository_error_handler.dart';
import '../../../../core/utils/cache_helper.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_local_data_source.dart';
import '../datasources/pokemon_remote_data_source.dart';

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
        CacheHelper.safeCacheAsync(
            () => _localDataSource.cachePokemon(remotePokemon));

        return Right(remotePokemon.toEntity());
      } catch (e) {
        final failure = RepositoryErrorHandler.mapToFailure(e);

        // Try cache for recoverable errors, return immediately for others
        if (RepositoryErrorHandler.shouldRetryFromCache(failure)) {
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
        CacheHelper.safeCacheAsync(
            () => _localDataSource.cachePokemonList(remotePokemonList));

        return Right(
            remotePokemonList.map((model) => model.toEntity()).toList());
      } catch (e) {
        final failure = RepositoryErrorHandler.mapToFailure(e);

        // Try cache for recoverable errors, return immediately for others
        if (RepositoryErrorHandler.shouldRetryFromCache(failure)) {
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
        CacheHelper.safeCacheAsync(
            () => _localDataSource.cachePokemon(remotePokemon));

        return Right(remotePokemon.toEntity());
      } catch (e) {
        final failure = RepositoryErrorHandler.mapToFailure(e);

        // Try cache for recoverable errors, return immediately for others
        if (RepositoryErrorHandler.shouldRetryFromCache(failure)) {
          return _tryGetByNameFromCache(name, failure);
        } else {
          return Left(failure);
        }
      }
    } else {
      return _getByNameFromCacheOnly(name);
    }
  }

  // 🔄 Cache fallback methods

  /// Get Pokemon from cache only (offline mode)
  Future<Either<Failure, Pokemon>> _getFromCacheOnly(int id) async {
    try {
      final localPokemon = await _localDataSource.getLastPokemon(id);
      return Right(localPokemon.toEntity());
    } on CacheFailure catch (failure) {
      return Left(RepositoryErrorHandler.createOfflineFailure(failure.message));
    }
  }

  /// Get Pokemon list from cache only (offline mode)
  Future<Either<Failure, List<Pokemon>>> _getListFromCacheOnly() async {
    try {
      final localPokemonList = await _localDataSource.getLastPokemonList();
      return Right(localPokemonList.map((model) => model.toEntity()).toList());
    } on CacheFailure catch (failure) {
      return Left(RepositoryErrorHandler.createOfflineFailure(failure.message));
    }
  }

  /// Get Pokemon by name from cache only (offline mode)
  Future<Either<Failure, Pokemon>> _getByNameFromCacheOnly(String name) async {
    try {
      final localPokemon = await _localDataSource.getLastPokemonByName(name);
      return Right(localPokemon.toEntity());
    } on CacheFailure catch (failure) {
      return Left(RepositoryErrorHandler.createOfflineFailure(failure.message));
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
