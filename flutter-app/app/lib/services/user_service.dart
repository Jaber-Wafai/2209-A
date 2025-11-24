import 'package:app/models/user.dart';
import 'api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();

  Future<List<User>> getAllUsers() async {
    final data = await _apiService.get('users');
    return (data as List).map((json) => User.fromJson(json)).toList();
  }

  Future<User> createUser(User user) async {
    final data = await _apiService.post('users', user.toJson());
    return User.fromJson(data);
  }
}
