import 'package:equatable/equatable.dart';

abstract class PokemonEvent extends Equatable {
  const PokemonEvent();

  @override
  List<Object?> get props => [];
}

/// Event to get a specific Pokemon by ID
class GetPokemonEvent extends PokemonEvent {
  final int id;

  const GetPokemonEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to get a specific Pokemon by name
class GetPokemonByNameEvent extends PokemonEvent {
  final String name;

  const GetPokemonByNameEvent(this.name);

  @override
  List<Object?> get props => [name];
}

/// Event to get a list of Pokemon
class GetPokemonListEvent extends PokemonEvent {
  final int limit;
  final int offset;

  const GetPokemonListEvent({
    this.limit = 20,
    this.offset = 0,
  });

  @override
  List<Object?> get props => [limit, offset];
}

/// Event to refresh Pokemon data
class RefreshPokemonEvent extends PokemonEvent {
  const RefreshPokemonEvent();
}

/// Event to search Pokemon
class SearchPokemonEvent extends PokemonEvent {
  final String query;

  const SearchPokemonEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Event to clear search results
class ClearSearchEvent extends PokemonEvent {
  const ClearSearchEvent();
}
