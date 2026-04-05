import '../../core/api/api_client.dart';
import '../models/favorite_model.dart';
import '../models/location_model.dart';

class FavoriteService {
  final ApiClient _apiClient;

  FavoriteService(this._apiClient);

  /// Fetch all favorite locations.
  Future<List<FavoriteModel>> getFavorites() async {
    final response = await _apiClient.get('/favorites');
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => FavoriteModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Add a location to favorites.
  Future<FavoriteModel> addFavorite(LocationModel location) async {
    final Map<String, dynamic> body = {
      'location': location.toJson(),
      'addedAt': DateTime.now().toIso8601String(),
    };
    final response = await _apiClient.post('/favorites', data: body);
    return FavoriteModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Remove a favorite by ID.
  Future<void> removeFavorite(String id) async {
    await _apiClient.delete('/favorites/$id');
  }
}
