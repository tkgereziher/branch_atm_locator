import 'location_model.dart';

class FavoriteModel {
  final String id; // This is the favorite entry ID in JSON Server
  final LocationModel location;
  final String addedAt;

  const FavoriteModel({
    required this.id,
    required this.location,
    required this.addedAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'].toString(),
      location: LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      addedAt: json['addedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location.toJson(),
      'addedAt': addedAt,
    };
  }
}
