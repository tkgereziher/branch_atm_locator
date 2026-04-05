import '../../core/api/api_client.dart';
import '../models/location_model.dart';

class LocationService {
  final ApiClient _apiClient;

  LocationService(this._apiClient);

  /// Fetch all locations, optionally filtered by type and/or bank.
  Future<List<LocationModel>> getLocations({String? type, String? bank}) async {
    final Map<String, dynamic> queryParams = {};
    if (type != null && type != 'All') queryParams['type'] = type;
    if (bank != null && bank != 'All Banks') queryParams['bank'] = bank;

    final response = await _apiClient.get('/locations', queryParameters: queryParams);
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => LocationModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Fetch a single location by ID.
  Future<LocationModel> getLocationById(String id) async {
    final response = await _apiClient.get('/locations/$id');
    return LocationModel.fromJson(response.data as Map<String, dynamic>);
  }
}
