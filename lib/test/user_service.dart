// user_service.dart
import 'package:dio/dio.dart';
import 'user_model.dart';

class UserService {
  final Dio _dio = Dio();

  Future<List<Usermodel1>> fetchUsers() async {
    try {
      final response = await _dio.get('http://192.168.1.7/api/users/active');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Usermodel1.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }
}
