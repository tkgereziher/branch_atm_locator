import '../../core/api/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';

class UserService {
  final ApiClient _apiClient;

  UserService(this._apiClient);

  Future<UserModel> getProfile() async {
    final response = await _apiClient.get(ApiConstants.profileEndpoint);
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> login(String email, String password) async {
    // In a real app, this would return a token which we'd save to secure storage.
    // final response = await _apiClient.post(ApiConstants.loginEndpoint, data: {'email': email, 'password': password});
    // final token = response.data['token'];
    // await _storageService.saveTokens(accessToken: token);
  }
}
