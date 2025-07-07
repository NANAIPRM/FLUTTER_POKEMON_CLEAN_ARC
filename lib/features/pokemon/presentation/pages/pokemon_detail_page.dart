import 'package:flutter/material.dart';
import '../../domain/entities/pokemon.dart';

class PokemonDetailPage extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailPage({
    super.key,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Pokemon Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: _getTypeColor(pokemon.types.first),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _capitalizeName(pokemon.name),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _getTypeColor(pokemon.types.first),
                      _getTypeColor(pokemon.types.first).withOpacity(0.8),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Background Pattern
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.1,
                        child: Image.asset(
                          'assets/images/pokeball_pattern.png',
                          repeat: ImageRepeat.repeat,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox();
                          },
                        ),
                      ),
                    ),
                    // Pokemon Image
                    Center(
                      child: Hero(
                        tag: 'pokemon-${pokemon.id}',
                        child: Container(
                          width: 200,
                          height: 200,
                          margin: const EdgeInsets.only(top: 50),
                          child: Image.network(
                            pokemon.imageUrl,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.white,
                                  size: 80,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    // Pokemon ID
                    Positioned(
                      top: 100,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '#${pokemon.id.toString().padLeft(3, '0')}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Pokemon Details
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Types Section
                  _buildSection(
                    'Types',
                    child: Wrap(
                      spacing: 12,
                      children: pokemon.types.map((type) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeColor(type),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: _getTypeColor(type).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            _capitalizeName(type),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Physical Stats Section
                  _buildSection(
                    'Physical Stats',
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Height',
                            '${(pokemon.height / 10).toStringAsFixed(1)} m',
                            Icons.height,
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            'Weight',
                            '${(pokemon.weight / 10).toStringAsFixed(1)} kg',
                            Icons.monitor_weight_outlined,
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Additional Info
                  _buildSection(
                    'Pokemon Information',
                    child: Column(
                      children: [
                        _buildInfoRow('ID', '#${pokemon.id}'),
                        _buildInfoRow('Name', _capitalizeName(pokemon.name)),
                        _buildInfoRow(
                          'Types',
                          pokemon.types.map(_capitalizeName).join(', '),
                        ),
                        _buildInfoRow(
                          'Height',
                          '${(pokemon.height / 10).toStringAsFixed(1)} meters',
                        ),
                        _buildInfoRow(
                          'Weight',
                          '${(pokemon.weight / 10).toStringAsFixed(1)} kilograms',
                        ),
                      ],
                    ),
                  ),

                  // Bottom spacing
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, {required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalizeName(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'normal':
        return const Color(0xFFA8A878);
      case 'fire':
        return const Color(0xFFF08030);
      case 'water':
        return const Color(0xFF6890F0);
      case 'electric':
        return const Color(0xFFF8D030);
      case 'grass':
        return const Color(0xFF78C850);
      case 'ice':
        return const Color(0xFF98D8D8);
      case 'fighting':
        return const Color(0xFFC03028);
      case 'poison':
        return const Color(0xFFA040A0);
      case 'ground':
        return const Color(0xFFE0C068);
      case 'flying':
        return const Color(0xFFA890F0);
      case 'psychic':
        return const Color(0xFFF85888);
      case 'bug':
        return const Color(0xFFA8B820);
      case 'rock':
        return const Color(0xFFB8A038);
      case 'ghost':
        return const Color(0xFF705898);
      case 'dragon':
        return const Color(0xFF7038F8);
      case 'dark':
        return const Color(0xFF705848);
      case 'steel':
        return const Color(0xFFB8B8D0);
      case 'fairy':
        return const Color(0xFFEE99AC);
      default:
        return const Color(0xFF68A090);
    }
  }
}
