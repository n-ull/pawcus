import 'package:dio/dio.dart';
import 'package:pawcus/core/services/api/api_client.dart';

class ApiService {
  final ApiClient _apiClient;

  ApiService(this._apiClient);

  Future<Response<dynamic>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _apiClient.dio.get(
      path,
      queryParameters: queryParameters,
    );
    return response;
  }

  Future<Response<dynamic>> post<T>(String path, {dynamic data}) async {
    final response = await _apiClient.dio.post(path, data: data);
    return response;
  }

  Future<Response<dynamic>> put<T>(String path, {dynamic data}) async {
    final response = await _apiClient.dio.put(path, data: data);
    return response;
  }

  Future<Response<dynamic>> delete<T>(String path) async {
    final response = await _apiClient.dio.delete(path);
    return response.data;
  }
}
