import 'package:flutter_pokemon_clean_arc/features/pokemon/domain/entities/pokemon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Pokemon Entity', () {
    final tPokemon = Pokemon(
      id: 1,
      name: 'Pikachu',
      imageUrl: 'https://example.com/pikachu.png',
      types: ['Electric'],
      height: 4,
      weight: 60,
    );

    test(
      'should be a subclass of Equatable (for value comparison)',
      () async {
        // assert
        expect(tPokemon, isA<Pokemon>());

        // Test equality
        final tPokemon2 = Pokemon(
          id: 1,
          name: 'Pikachu',
          imageUrl: 'https://example.com/pikachu.png',
          types: ['Electric'],
          height: 4,
          weight: 60,
        );

        expect(tPokemon, equals(tPokemon2));
      },
    );

    test(
      'should have all required properties',
      () async {
        // assert
        expect(tPokemon.id, 1);
        expect(tPokemon.name, 'Pikachu');
        expect(tPokemon.imageUrl, 'https://example.com/pikachu.png');
        expect(tPokemon.types, ['Electric']);
        expect(tPokemon.height, 4);
        expect(tPokemon.weight, 60);
      },
    );

    test(
      'should support Pokemon with multiple types',
      () async {
        // arrange
        final tMultiTypePokemon = Pokemon(
          id: 6,
          name: 'Charizard',
          imageUrl: 'https://example.com/charizard.png',
          types: ['Fire', 'Flying'],
          height: 17,
          weight: 905,
        );

        // assert
        expect(tMultiTypePokemon.types.length, 2);
        expect(tMultiTypePokemon.types, contains('Fire'));
        expect(tMultiTypePokemon.types, contains('Flying'));
      },
    );
  });
}
