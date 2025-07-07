import 'package:equatable/equatable.dart';

class Pokemon extends Equatable {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int height; // in decimeters
  final int weight; // in hectograms

  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
  });

  @override
  List<Object> get props => [
        id,
        name,
        imageUrl,
        types,
        height,
        weight,
      ];

  @override
  String toString() {
    return 'Pokemon(id: $id, name: $name, types: $types, height: $height, weight: $weight)';
  }
}
