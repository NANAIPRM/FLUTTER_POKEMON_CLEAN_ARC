import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';

/// Use case for retrieving a single Pokemon by its ID.
/// 
/// This use case encapsulates the business logic for getting a Pokemon
/// and handles validation of the input parameters.
class GetPokemon {
  final PokemonRepository repository;

  const GetPokemon(this.repository);

  /// Executes the use case to get a Pokemon by ID.
  ///
  /// Validates that the [id] is within the valid range (1-1010)
  /// before delegating to the repository.
  ///
  /// Returns [Right(Pokemon)] on success or [Left(Failure)] on error.
  Future<Either<Failure, Pokemon>> call(int id) async {
    // Validate Pokemon ID range
    if (id < 1 || id > 1010) {
      return Left(ValidationFailure('Pokemon ID must be between 1 and 1010'));
    }

    return await repository.getPokemon(id);
  }
}
