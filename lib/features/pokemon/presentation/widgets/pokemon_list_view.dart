import 'package:flutter/material.dart';
import '../../domain/entities/pokemon.dart';
import 'pokemon_card.dart';

class PokemonListView extends StatelessWidget {
  final List<Pokemon> pokemonList;
  final ScrollController scrollController;
  final VoidCallback onRefresh;
  final bool isLoadingMore;
  final bool isRefreshing;
  final bool isSearchResult;
  final String? searchQuery;

  const PokemonListView({
    super.key,
    required this.pokemonList,
    required this.scrollController,
    required this.onRefresh,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.isSearchResult = false,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    if (pokemonList.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      color: Colors.red,
      child: Column(
        children: [
          // Search Result Header
          if (isSearchResult && searchQuery != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Search results for "$searchQuery"',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Pokemon List
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: pokemonList.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= pokemonList.length) {
                  // Loading more indicator
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    ),
                  );
                }

                return PokemonCard(pokemon: pokemonList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    if (isSearchResult) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Pokémon found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching for a different Pokémon name',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      color: Colors.red,
      child: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.catching_pokemon,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Pokémon available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pull down to refresh',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
