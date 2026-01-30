import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/product_model.dart';
import '../models/post_model.dart';

/// API Service
/// Handles all HTTP requests to the DummyJSON REST API
class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch products with pagination
  /// [skip] - Number of items to skip for pagination
  /// [limit] - Number of items to fetch
  Future<List<Product>> fetchProducts({int skip = 0, int? limit}) async {
    try {
      final itemLimit = limit ?? ApiConstants.itemsPerPage;
      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}?skip=$skip&limit=$itemLimit',
      );

      final response = await _client
          .get(url)
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> products = jsonData['products'] as List;
        return products.map((json) => Product.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Failed to load products. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  /// Fetch all products (for initial load and caching)
  Future<List<Product>> fetchAllProducts() async {
    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}?limit=100',
      );

      final response = await _client
          .get(url)
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> products = jsonData['products'] as List;
        return products.map((json) => Product.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Failed to load products. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  /// Fetch posts with pagination (JSONPlaceholder API)
  /// [start] - Starting index for pagination
  /// [limit] - Number of items to fetch
  Future<List<Post>> fetchPost({int start = 0, int? limit}) async {
    try {
      final itemLimit = limit ?? ApiConstants.itemsPerPage;
      final url = Uri.parse(
        'https://jsonplaceholder.typicode.com/posts?_start=$start&_limit=$itemLimit',
      );

      final response = await _client
          .get(url)
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Post.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Failed to load posts. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  /// Fetch all posts (for initial load and caching)
  Future<List<Post>> fetchAllPosts() async {
    try {
      final url = Uri.parse(
        'https://jsonplaceholder.typicode.com/posts?_limit=100',
      );

      final response = await _client
          .get(url)
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Post.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Failed to load posts. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  /// Dispose the HTTP client
  void dispose() {
    _client.close();
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
