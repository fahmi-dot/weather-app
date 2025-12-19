import 'package:http/http.dart';
import 'package:weather_app/core/config/env.dart';

class ApiClient {
  final Client _client;
  final String _baseUrl = Env.baseUrl;
  final String _apiKey = Env.apiKey;

  ApiClient(this._client);

  Future<Response> get(String path, {Map<String, String>? queryParameters}) {
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
