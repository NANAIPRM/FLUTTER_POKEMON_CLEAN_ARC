import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/usecases/get_pokemon.dart';
import '../../domain/usecases/get_pokemon_by_name.dart';
import '../../domain/usecases/get_pokemon_list.dart';
import 'pokemon_event.dart';
import 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final GetPokemon _getPokemon;
  final GetPokemonByName _getPokemonByName;
  final GetPokemonList _getPokemonList;

  PokemonBloc({
    required GetPokemon getPokemon,
    required GetPokemonByName getPokemonByName,
    required GetPokemonList getPokemonList,
  })  : _getPokemon = getPokemon,
        _getPokemonByName = getPokemonByName,
        _getPokemonList = getPokemonList,
        super(const PokemonInitial()) {
    on<GetPokemonEvent>(_onGetPokemon);
    on<GetPokemonByNameEvent>(_onGetPokemonByName);
    on<GetPokemonListEvent>(_onGetPokemonList);
    on<RefreshPokemonEvent>(_onRefreshPokemon);
    on<SearchPokemonEvent>(_onSearchPokemon);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onGetPokemon(
    GetPokemonEvent event,
    Emitter<PokemonState> emit,
  ) async {
    emit(const PokemonLoading());

    final result = await _getPokemon(event.id);

    result.fold(
      (failure) => emit(PokemonError(
        failure: failure,
        message: _mapFailureToMessage(failure),
      )),
      (pokemon) => emit(PokemonLoaded(pokemon)),
    );
  }

  Future<void> _onGetPokemonByName(
    GetPokemonByNameEvent event,
    Emitter<PokemonState> emit,
  ) async {
    emit(const PokemonLoading());

    final result = await _getPokemonByName(event.name);

    result.fold(
      (failure) => emit(PokemonError(
        failure: failure,
        message: _mapFailureToMessage(failure),
      )),
      (pokemon) => emit(PokemonLoaded(pokemon)),
    );
  }

  Future<void> _onGetPokemonList(
    GetPokemonListEvent event,
    Emitter<PokemonState> emit,
  ) async {
    // Handle initial load vs pagination
    if (state is PokemonListLoaded && event.offset > 0) {
      final currentState = state as PokemonListLoaded;
      emit(PokemonLoadingMore(currentState.pokemonList));
    } else {
      emit(const PokemonLoading());
    }

    final result = await _getPokemonList(GetPokemonListParams(
      limit: event.limit,
      offset: event.offset,
    ));

    result.fold(
      (failure) => emit(PokemonError(
        failure: failure,
        message: _mapFailureToMessage(failure),
      )),
      (pokemonList) => _handlePokemonListSuccess(pokemonList, event, emit),
    );
  }

  void _handlePokemonListSuccess(
    List<Pokemon> newPokemonList,
    GetPokemonListEvent event,
    Emitter<PokemonState> emit,
  ) {
    if (state is PokemonLoadingMore && event.offset > 0) {
      // Pagination - append to existing list
      final currentState = state as PokemonLoadingMore;
      final updatedList = List<Pokemon>.from(currentState.currentList)
        ..addAll(newPokemonList);

      emit(PokemonListLoaded(
        pokemonList: updatedList,
        hasReachedMax: newPokemonList.length < event.limit,
        currentOffset: event.offset + newPokemonList.length,
      ));
    } else {
      // Initial load or refresh
      emit(PokemonListLoaded(
        pokemonList: newPokemonList,
        hasReachedMax: newPokemonList.length < event.limit,
        currentOffset: newPokemonList.length,
      ));
    }
  }

  Future<void> _onRefreshPokemon(
    RefreshPokemonEvent event,
    Emitter<PokemonState> emit,
  ) async {
    if (state is PokemonListLoaded) {
      final currentState = state as PokemonListLoaded;
      emit(PokemonRefreshing(currentState.pokemonList));

      // Refresh from the beginning
      add(const GetPokemonListEvent(limit: 20, offset: 0));
    } else {
      // If not in list state, just load fresh list
      add(const GetPokemonListEvent(limit: 20, offset: 0));
    }
  }

  Future<void> _onSearchPokemon(
    SearchPokemonEvent event,
    Emitter<PokemonState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(const ClearSearchEvent());
      return;
    }

    emit(const PokemonLoading());

    // For simplicity, we'll search by name
    // In a real app, you might want a dedicated search endpoint
    final result = await _getPokemonByName(event.query.toLowerCase());

    result.fold(
      (failure) => emit(PokemonError(
        failure: failure,
        message: _mapFailureToMessage(failure),
      )),
      (pokemon) => emit(PokemonSearchLoaded(
        searchResults: [pokemon],
        query: event.query,
      )),
    );
  }

  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<PokemonState> emit,
  ) {
    // Return to the last list state or load fresh list
    add(const GetPokemonListEvent(limit: 20, offset: 0));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred. Please try again later.';
      case NetworkFailure:
        return 'No internet connection. Showing cached data if available.';
      case CacheFailure:
        return 'Cache error occurred. Please check your storage.';
      case ValidationFailure:
        return failure.message; // Show specific validation message
      case TimeoutFailure:
        return 'Request timed out. Please check your connection.';
      case ConnectionFailure:
        return 'Connection failed. Please check your internet.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
