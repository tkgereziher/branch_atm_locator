import '../../core/api/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../../core/services/secure_storage_service.dart';
import '../models/user_model.dart';

class UserService {
  final ApiClient _apiClient;
  final SecureStorageService _storageService;

  UserService(this._apiClient, this._storageService);

  Future<UserModel> getProfile() async {
    final token = await _storageService.getAccessToken();
    if (token == null) throw Exception("Not logged in");
    
    // We mock profile by fetching the user by their ID which is stored in "token"
    final response = await _apiClient.get('${ApiConstants.usersEndpoint}/$token');
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserModel> login(String email, String password) async {
    // Basic mock authentication against JSON Server
    final response = await _apiClient.get(
      ApiConstants.usersEndpoint,
      queryParameters: {'email': email},
    );
    
    final List<dynamic> users = response.data;
    if (users.isEmpty) {
      throw Exception('User not found.');
    }
    
    final userJson = users.first as Map<String, dynamic>;
    if (userJson['password'] != password) {
      throw Exception('Incorrect password.');
    }
    
    final user = UserModel.fromJson(userJson);
    
    // Simulate token with user ID
    await _storageService.saveTokens(accessToken: user.id);
    
    return user;
  }
  
  Future<UserModel> register(String name, String email, String password, String mobile) async {
    // Check if user already exists
    final checkRes = await _apiClient.get(
      ApiConstants.usersEndpoint,
      queryParameters: {'email': email},
    );
    if ((checkRes.data as List).isNotEmpty) {
      throw Exception('Email already exists.');
    }
    
    // Create new user
    final response = await _apiClient.post(
      ApiConstants.usersEndpoint,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'mobile': mobile,
      },
    );
    
    final user = UserModel.fromJson(response.data as Map<String, dynamic>);
    
    // Login automatically
    await _storageService.saveTokens(accessToken: user.id);
    
    return user;
  }

  Future<void> logout() async {
    await _storageService.clearTokens();
  }
  
  Future<bool> isLoggedIn() async {
    final token = await _storageService.getAccessToken();
    return token != null;
  }
}
