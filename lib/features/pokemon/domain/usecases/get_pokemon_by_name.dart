import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';

/// Use case for retrieving a Pokemon by its name.
/// 
/// This use case encapsulates the business logic for searching Pokemon
/// by name and handles validation of the input parameters.
class GetPokemonByName {
  final PokemonRepository repository;

  const GetPokemonByName(this.repository);

  /// Executes the use case to get a Pokemon by name.
  ///
  /// Validates that the [name] is not empty and contains only valid characters
  /// before delegating to the repository.
  ///
  /// Returns [Right(Pokemon)] on success or [Left(Failure)] on error.
  Future<Either<Failure, Pokemon>> call(String name) async {
    // Validate Pokemon name
    final trimmedName = name.trim().toLowerCase();
    
    if (trimmedName.isEmpty) {
      return Left(ValidationFailure('Pokemon name cannot be empty'));
    }

    if (trimmedName.length > 50) {
      return Left(ValidationFailure('Pokemon name is too long'));
    }

    // Check for valid characters (letters, numbers, hyphens)
    final validNameRegex = RegExp(r'^[a-z0-9-]+$');
    if (!validNameRegex.hasMatch(trimmedName)) {
      return Left(ValidationFailure(
        'Pokemon name can only contain letters, numbers, and hyphens',
      ));
    }

    return await repository.getPokemonByName(trimmedName);
  }
}
