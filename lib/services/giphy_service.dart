import 'dart:convert';
import 'package:http/http.dart' as http;

class GiphyService {
  String _apiKey;

  GiphyService({String? apiKey}) : _apiKey = apiKey ?? 'uf5faUuQOSnXJksmoUsbpSypk1SS7hQK';

  set apiKey(String key) => _apiKey = key;
  static const String _baseUrl = 'https://api.giphy.com/v1/gifs';

  Future<List<String>> searchGifs(String query) async {
    if (query.isEmpty) return [];
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/search?api_key=$_apiKey&q=$query&limit=20&rating=g'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> results = data['data'];
        return results.map<String>((gif) => gif['images']['fixed_height']['url'] as String).toList();
      } else {
        throw Exception('Failed to load GIFs');
      }
    } catch (e) {
      throw Exception('Error searching GIPHY: $e');
    }
  }

  Future<List<String>> getTrendingGifs() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/trending?api_key=$_apiKey&limit=20&rating=g'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> results = data['data'];
        return results.map<String>((gif) => gif['images']['fixed_height']['url'] as String).toList();
      } else {
        throw Exception('Failed to load GIFs');
      }
    } catch (e) {
      throw Exception('Error loading trending GIFs: $e');
    }
  }
}

