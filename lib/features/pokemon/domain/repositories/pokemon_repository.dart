import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/pokemon.dart';

/// Abstract repository interface for Pokemon data operations.
/// 
/// This interface defines the contract for accessing Pokemon data,
/// following the Repository pattern in Clean Architecture.
/// All implementations must return Either<Failure, T> for error handling.
abstract class PokemonRepository {
  /// Retrieves a Pokemon by its unique identifier.
  ///
  /// Returns [Right(Pokemon)] on success or [Left(Failure)] on error.
  /// The [id] parameter must be between 1 and 1010 (valid Pokemon IDs).
  Future<Either<Failure, Pokemon>> getPokemon(int id);

  /// Retrieves a list of Pokemon with pagination support.
  ///
  /// Returns [Right(List<Pokemon>)] on success or [Left(Failure)] on error.
  /// The [limit] parameter controls how many Pokemon to fetch (default: 20).
  /// The [offset] parameter controls the starting point for pagination (default: 0).
  Future<Either<Failure, List<Pokemon>>> getPokemonList({
    int limit = 20,
    int offset = 0,
  });

  /// Searches for Pokemon by name.
  ///
  /// Returns [Right(Pokemon)] on success or [Left(Failure)] on error.
  /// The [name] parameter must be a valid Pokemon name (case-insensitive).
  Future<Either<Failure, Pokemon>> getPokemonByName(String name);
}
