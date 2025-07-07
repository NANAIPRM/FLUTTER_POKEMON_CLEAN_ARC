/// API Constants for Pokemon Application
/// Contains all the API endpoints and configuration values
class ApiConstants {
  // Base URL for PokeAPI
  static const String baseUrl = 'https://pokeapi.co/api/v2/';

  // Endpoints
  static const String pokemon = 'pokemon';

  // Timeout configurations
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  static const Duration sendTimeout = Duration(seconds: 10);

  // Pagination defaults
  static const int defaultLimit = 20;
  static const int defaultOffset = 0;

  // Helper methods for building URLs
  static String pokemonById(int id) => '$pokemon/$id';
  static String pokemonList(
      {int limit = defaultLimit, int offset = defaultOffset}) {
    return '$pokemon?limit=$limit&offset=$offset';
  }
}
