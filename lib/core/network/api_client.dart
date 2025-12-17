import 'package:http/http.dart';
import 'package:weather_app/core/config/env.dart';

class ApiClient {
  final Client _client;
  final String _baseUrl;
  final String _apiKey;

  ApiClient({Client? client, String? baseUrl, String? apiKey})
    : _client = client ?? Client(),
      _baseUrl = baseUrl ?? Env.baseUrl,
      _apiKey = apiKey ?? Env.apiKey;

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    final uri = Uri.parse('$_baseUrl/$path').replace(
      queryParameters: {
        'appid': _apiKey,
        'units': 'metric',
        ...?queryParameters,
      }
    );

    return _client.get(uri);
  }
}
