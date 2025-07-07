// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PokemonModel _$PokemonModelFromJson(Map<String, dynamic> json) => PokemonModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      height: (json['height'] as num).toInt(),
      weight: (json['weight'] as num).toInt(),
      sprites:
          PokemonSpritesModel.fromJson(json['sprites'] as Map<String, dynamic>),
      types: (json['types'] as List<dynamic>)
          .map((e) => PokemonTypeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PokemonModelToJson(PokemonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'height': instance.height,
      'weight': instance.weight,
      'sprites': instance.sprites,
      'types': instance.types,
    };

PokemonSpritesModel _$PokemonSpritesModelFromJson(Map<String, dynamic> json) =>
    PokemonSpritesModel(
      frontDefault: json['front_default'] as String,
    );

Map<String, dynamic> _$PokemonSpritesModelToJson(
        PokemonSpritesModel instance) =>
    <String, dynamic>{
      'front_default': instance.frontDefault,
    };

PokemonTypeModel _$PokemonTypeModelFromJson(Map<String, dynamic> json) =>
    PokemonTypeModel(
      type:
          PokemonTypeDetailModel.fromJson(json['type'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PokemonTypeModelToJson(PokemonTypeModel instance) =>
    <String, dynamic>{
      'type': instance.type,
    };

PokemonTypeDetailModel _$PokemonTypeDetailModelFromJson(
        Map<String, dynamic> json) =>
    PokemonTypeDetailModel(
      name: json['name'] as String,
    );

Map<String, dynamic> _$PokemonTypeDetailModelToJson(
        PokemonTypeDetailModel instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

PokemonListResponseModel _$PokemonListResponseModelFromJson(
        Map<String, dynamic> json) =>
    PokemonListResponseModel(
      count: (json['count'] as num).toInt(),
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((e) => PokemonListItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PokemonListResponseModelToJson(
        PokemonListResponseModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };

PokemonListItemModel _$PokemonListItemModelFromJson(
        Map<String, dynamic> json) =>
    PokemonListItemModel(
      name: json['name'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$PokemonListItemModelToJson(
        PokemonListItemModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
    };
