import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/pokemon.dart';

part 'pokemon_model.g.dart';

/// Data model for Pokemon from the API.
///
/// This model handles JSON serialization/deserialization
/// and conversion to/from domain entities.
@JsonSerializable()
class PokemonModel extends Equatable {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'height')
  final int height;

  @JsonKey(name: 'weight')
  final int weight;

  @JsonKey(name: 'sprites')
  final PokemonSpritesModel sprites;

  @JsonKey(name: 'types')
  final List<PokemonTypeModel> types;

  const PokemonModel({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.sprites,
    required this.types,
  });

  /// Creates a PokemonModel from JSON.
  factory PokemonModel.fromJson(Map<String, dynamic> json) =>
      _$PokemonModelFromJson(json);

  /// Converts PokemonModel to JSON.
  Map<String, dynamic> toJson() => _$PokemonModelToJson(this);

  /// Converts the model to a domain entity.
  Pokemon toEntity() => Pokemon(
        id: id,
        name: name,
        imageUrl: sprites.frontDefault,
        types: types.map((type) => type.type.name).toList(),
        height: height,
        weight: weight,
      );

  @override
  List<Object> get props => [id, name, height, weight, sprites, types];

  /// Creates a PokemonModel from a domain entity.
  factory PokemonModel.fromEntity(Pokemon pokemon) => PokemonModel(
        id: pokemon.id,
        name: pokemon.name,
        height: pokemon.height,
        weight: pokemon.weight,
        sprites: PokemonSpritesModel(frontDefault: pokemon.imageUrl),
        types: pokemon.types
            .map((typeName) => PokemonTypeModel(
                  type: PokemonTypeDetailModel(name: typeName),
                ))
            .toList(),
      );
}

@JsonSerializable()
class PokemonSpritesModel extends Equatable {
  @JsonKey(name: 'front_default')
  final String frontDefault;

  const PokemonSpritesModel({
    required this.frontDefault,
  });

  factory PokemonSpritesModel.fromJson(Map<String, dynamic> json) =>
      _$PokemonSpritesModelFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonSpritesModelToJson(this);

  @override
  List<Object> get props => [frontDefault];
}

@JsonSerializable()
class PokemonTypeModel extends Equatable {
  @JsonKey(name: 'type')
  final PokemonTypeDetailModel type;

  const PokemonTypeModel({
    required this.type,
  });

  factory PokemonTypeModel.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonTypeModelToJson(this);

  @override
  List<Object> get props => [type];
}

@JsonSerializable()
class PokemonTypeDetailModel extends Equatable {
  @JsonKey(name: 'name')
  final String name;

  const PokemonTypeDetailModel({
    required this.name,
  });

  factory PokemonTypeDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonTypeDetailModelToJson(this);

  @override
  List<Object> get props => [name];
}

/// Model for Pokemon list response from the API.
@JsonSerializable()
class PokemonListResponseModel extends Equatable {
  @JsonKey(name: 'count')
  final int count;

  @JsonKey(name: 'next')
  final String? next;

  @JsonKey(name: 'previous')
  final String? previous;

  @JsonKey(name: 'results')
  final List<PokemonListItemModel> results;

  const PokemonListResponseModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PokemonListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PokemonListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonListResponseModelToJson(this);

  @override
  List<Object?> get props => [count, next, previous, results];
}

@JsonSerializable()
class PokemonListItemModel extends Equatable {
  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'url')
  final String url;

  const PokemonListItemModel({
    required this.name,
    required this.url,
  });

  factory PokemonListItemModel.fromJson(Map<String, dynamic> json) =>
      _$PokemonListItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonListItemModelToJson(this);

  @override
  List<Object> get props => [name, url];

  /// Extracts Pokemon ID from the URL.
  int get id {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    // URL format: https://pokeapi.co/api/v2/pokemon/1/
    final idString = segments[segments.length - 2];
    return int.parse(idString);
  }
}
