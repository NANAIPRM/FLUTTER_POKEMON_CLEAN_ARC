import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/pokemon.dart';

abstract class PokemonState extends Equatable {
  const PokemonState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class PokemonInitial extends PokemonState {
  const PokemonInitial();
}

/// Loading state
class PokemonLoading extends PokemonState {
  const PokemonLoading();
}

/// State when a single Pokemon is loaded successfully
class PokemonLoaded extends PokemonState {
  final Pokemon pokemon;

  const PokemonLoaded(this.pokemon);

  @override
  List<Object?> get props => [pokemon];
}

/// State when Pokemon list is loaded successfully
class PokemonListLoaded extends PokemonState {
  final List<Pokemon> pokemonList;
  final bool hasReachedMax;
  final int currentOffset;

  const PokemonListLoaded({
    required this.pokemonList,
    this.hasReachedMax = false,
    this.currentOffset = 0,
  });

  @override
  List<Object?> get props => [pokemonList, hasReachedMax, currentOffset];

  /// Create a copy with updated values
  PokemonListLoaded copyWith({
    List<Pokemon>? pokemonList,
    bool? hasReachedMax,
    int? currentOffset,
  }) {
    return PokemonListLoaded(
      pokemonList: pokemonList ?? this.pokemonList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentOffset: currentOffset ?? this.currentOffset,
    );
  }
}

/// State when search results are loaded
class PokemonSearchLoaded extends PokemonState {
  final List<Pokemon> searchResults;
  final String query;

  const PokemonSearchLoaded({
    required this.searchResults,
    required this.query,
  });

  @override
  List<Object?> get props => [searchResults, query];
}

/// Error state
class PokemonError extends PokemonState {
  final Failure failure;
  final String message;

  const PokemonError({
    required this.failure,
    required this.message,
  });

  @override
  List<Object?> get props => [failure, message];
}

/// Loading more items (for pagination)
class PokemonLoadingMore extends PokemonState {
  final List<Pokemon> currentList;

  const PokemonLoadingMore(this.currentList);

  @override
  List<Object?> get props => [currentList];
}

/// Refreshing state
class PokemonRefreshing extends PokemonState {
  final List<Pokemon> currentList;

  const PokemonRefreshing(this.currentList);

  @override
  List<Object?> get props => [currentList];
}
