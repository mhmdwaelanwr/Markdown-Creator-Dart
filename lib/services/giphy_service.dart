import 'dart:convert';
import 'package:http/http.dart' as http;

class GiphyService {
  GiphyService({String? apiKey})
      : _apiKey = apiKey ??
            const String.fromEnvironment(
              'GIPHY_API_KEY',
              defaultValue: '',
            );

  String _apiKey;

  set apiKey(String key) => _apiKey = key.trim();

  bool get isConfigured => _apiKey.trim().isNotEmpty;

  static const String _host = 'api.giphy.com';
  static const String _apiPath = '/v1/gifs';

  void _ensureConfigured() {
    if (!isConfigured) {
      throw StateError(
        'GIPHY API key is not configured. '
        'Start the app with --dart-define=GIPHY_API_KEY=YOUR_KEY.',
      );
    }
  }

  Future<List<String>> searchGifs(String query) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) return [];

    _ensureConfigured();

    try {
      final response = await http.get(
        Uri.https(
          _host,
          '$_apiPath/search',
          <String, String>{
            'api_key': _apiKey,
            'q': normalizedQuery,
            'limit': '20',
            'rating': 'g',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('GIPHY search failed with status ${response.statusCode}');
      }

      return _extractGifUrls(response.body);
    } catch (e) {
      throw Exception('Error searching GIPHY: $e');
    }
  }

  Future<List<String>> getTrendingGifs() async {
    _ensureConfigured();

    try {
      final response = await http.get(
        Uri.https(
          _host,
          '$_apiPath/trending',
          <String, String>{
            'api_key': _apiKey,
            'limit': '20',
            'rating': 'g',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'GIPHY trending request failed with status ${response.statusCode}',
        );
      }

      return _extractGifUrls(response.body);
    } catch (e) {
      throw Exception('Error loading trending GIFs: $e');
    }
  }

  List<String> _extractGifUrls(String responseBody) {
    final decoded = jsonDecode(responseBody);
    if (decoded is! Map<String, dynamic>) return const [];

    final rawResults = decoded['data'];
    if (rawResults is! List) return const [];

    return rawResults
        .map((gif) {
          if (gif is! Map<String, dynamic>) return null;
          final images = gif['images'];
          if (images is! Map<String, dynamic>) return null;
          final fixedHeight = images['fixed_height'];
          if (fixedHeight is! Map<String, dynamic>) return null;
          final url = fixedHeight['url'];
          return url is String && url.isNotEmpty ? url : null;
        })
        .whereType<String>()
        .toList(growable: false);
  }
}
