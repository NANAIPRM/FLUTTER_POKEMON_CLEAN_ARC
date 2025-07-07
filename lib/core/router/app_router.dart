import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection_container.dart' as di;
import '../../features/pokemon/domain/entities/pokemon.dart';
import '../../features/pokemon/presentation/bloc/bloc.dart';
import '../../features/pokemon/presentation/pages/pokemon_list_page.dart';
import '../../features/pokemon/presentation/pages/pokemon_detail_page.dart';

/// App Router Configuration using GoRouter
class AppRouter {
  static const String home = '/';
  static const String pokemonDetail = '/pokemon/:id';
  static const String pokemonDetailName = 'pokemon-detail';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: true,
    routes: [
      // Home Route - Pokemon List
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => BlocProvider(
          create: (_) => di.sl<PokemonBloc>(),
          child: const PokemonListPage(),
        ),
      ),

      // Pokemon Detail Route
      GoRoute(
        path: pokemonDetail,
        name: pokemonDetailName,
        builder: (context, state) {
          final pokemonId = int.tryParse(state.pathParameters['id'] ?? '');
          final pokemon = state.extra as Pokemon?;

          if (pokemon != null) {
            // If Pokemon object is passed directly
            return PokemonDetailPage(pokemon: pokemon);
          } else if (pokemonId != null) {
            // If only ID is passed, create a loading page and fetch Pokemon
            return BlocProvider(
              create: (_) =>
                  di.sl<PokemonBloc>()..add(GetPokemonEvent(pokemonId)),
              child: PokemonDetailPageWithLoader(pokemonId: pokemonId),
            );
          } else {
            // Invalid route - redirect to home
            return const PokemonListPage();
          }
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
        backgroundColor: Colors.red[600],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go(home),
              icon: const Icon(Icons.home),
              label: const Text('Go Home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// A widget that shows loading while fetching Pokemon by ID
class PokemonDetailPageWithLoader extends StatelessWidget {
  final int pokemonId;

  const PokemonDetailPageWithLoader({
    super.key,
    required this.pokemonId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonBloc, PokemonState>(
      builder: (context, state) {
        if (state is PokemonLoaded) {
          return PokemonDetailPage(pokemon: state.pokemon);
        }

        if (state is PokemonError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load Pokemon',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.go(AppRouter.home),
                    icon: const Icon(Icons.home),
                    label: const Text('Go Back'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Loading state
        return Scaffold(
          appBar: AppBar(
            title: const Text('Loading...'),
            backgroundColor: Colors.red[600],
            foregroundColor: Colors.white,
          ),
          body: const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          ),
        );
      },
    );
  }
}
