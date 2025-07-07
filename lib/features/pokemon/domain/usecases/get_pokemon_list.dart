import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';

/// Parameters for the GetPokemonList use case.
/// 
/// This class encapsulates the input parameters for pagination
/// and provides validation logic.
class GetPokemonListParams {
  final int limit;
  final int offset;

  const GetPokemonListParams({
    this.limit = 20,
    this.offset = 0,
  });

  /// Validates the parameters.
  bool get isValid {
    return limit > 0 && limit <= 100 && offset >= 0;
  }
}

/// Use case for retrieving a list of Pokemon with pagination.
/// 
/// This use case handles the business logic for fetching multiple Pokemon
/// and includes validation for pagination parameters.
class GetPokemonList {
  final PokemonRepository repository;

  const GetPokemonList(this.repository);

  /// Executes the use case to get a paginated list of Pokemon.
  ///
  /// Validates the pagination parameters before delegating to the repository.
  /// The [params] contain the limit and offset for pagination.
  ///
  /// Returns [Right(List<Pokemon>)] on success or [Left(Failure)] on error.
  Future<Either<Failure, List<Pokemon>>> call(GetPokemonListParams params) async {
    // Validate pagination parameters
    if (!params.isValid) {
      return Left(ValidationFailure(
        'Invalid pagination parameters. Limit must be 1-100, offset must be >= 0',
      ));
    }

    return await repository.getPokemonList(
      limit: params.limit,
      offset: params.offset,
    );
  }
}
