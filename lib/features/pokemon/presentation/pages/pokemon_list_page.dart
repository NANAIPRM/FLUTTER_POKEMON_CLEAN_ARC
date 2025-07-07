import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc.dart';
import '../widgets/pokemon_list_view.dart';
import '../widgets/pokemon_search_bar.dart';
import '../widgets/error_display.dart';
import '../widgets/loading_display.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load initial Pokemon list
    context.read<PokemonBloc>().add(const GetPokemonListEvent());

    // Setup infinite scroll
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<PokemonBloc>().state;
      if (state is PokemonListLoaded && !state.hasReachedMax) {
        context.read<PokemonBloc>().add(GetPokemonListEvent(
              limit: 20,
              offset: state.currentOffset,
            ));
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      context.read<PokemonBloc>().add(const ClearSearchEvent());
    } else {
      context.read<PokemonBloc>().add(SearchPokemonEvent(query));
    }
  }

  void _onRefresh() {
    context.read<PokemonBloc>().add(const RefreshPokemonEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pokédex',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.red[600],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[600],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: PokemonSearchBar(
              controller: _searchController,
              onChanged: _onSearchChanged,
            ),
          ),

          // Pokemon List
          Expanded(
            child: BlocBuilder<PokemonBloc, PokemonState>(
              builder: (context, state) {
                return _buildBody(state);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(PokemonState state) {
    if (state is PokemonLoading) {
      return const LoadingDisplay();
    }

    if (state is PokemonError) {
      return ErrorDisplay(
        message: state.message,
        onRetry: () => context.read<PokemonBloc>().add(
              const GetPokemonListEvent(),
            ),
      );
    }

    if (state is PokemonListLoaded) {
      return PokemonListView(
        pokemonList: state.pokemonList,
        scrollController: _scrollController,
        onRefresh: _onRefresh,
        isLoadingMore: false,
      );
    }

    if (state is PokemonLoadingMore) {
      return PokemonListView(
        pokemonList: state.currentList,
        scrollController: _scrollController,
        onRefresh: _onRefresh,
        isLoadingMore: true,
      );
    }

    if (state is PokemonRefreshing) {
      return PokemonListView(
        pokemonList: state.currentList,
        scrollController: _scrollController,
        onRefresh: _onRefresh,
        isRefreshing: true,
      );
    }

    if (state is PokemonSearchLoaded) {
      return PokemonListView(
        pokemonList: state.searchResults,
        scrollController: _scrollController,
        onRefresh: _onRefresh,
        isSearchResult: true,
        searchQuery: state.query,
      );
    }

    // Initial state
    return const Center(
      child: Text(
        'Welcome to Pokédex!\nPull down to refresh or search for Pokémon.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}
