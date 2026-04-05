import '../../core/api/api_client.dart';
import '../models/bank_model.dart';

class BankService {
  final ApiClient _apiClient;

  BankService(this._apiClient);

  /// Fetch the full list of banks from the API.
  Future<List<BankModel>> getBanks() async {
    final response = await _apiClient.get('/banks');
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => BankModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Fetch a single bank by its ID.
  Future<BankModel> getBankById(String id) async {
    final response = await _apiClient.get('/banks/$id');
    return BankModel.fromJson(response.data as Map<String, dynamic>);
  }
}
