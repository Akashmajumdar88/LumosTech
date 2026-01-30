import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';
import '../models/product_model.dart';
import '../models/post_model.dart';

/// Cache Service
/// Handles local storage using SharedPreferences
class CacheService {
  final SharedPreferences _prefs;

  CacheService(this._prefs);

  /// Save products to cache
  Future<bool> saveProducts(List<Product> products) async {
    try {
      final jsonList = products.map((product) => product.toJson()).toList();
      final jsonString = json.encode(jsonList);
      
      // Save products
      final result = await _prefs.setString(
        ApiConstants.cacheKeyProducts,
        jsonString,
      );
      
      // Save timestamp
      await _prefs.setInt(
        ApiConstants.cacheKeyTimestamp,
        DateTime.now().millisecondsSinceEpoch,
      );
      
      return result;
    } catch (e) {
      throw CacheException('Failed to save products: ${e.toString()}');
    }
  }

  /// Get cached products
  Future<List<Product>?> getCachedProducts() async {
    try {
      final jsonString = _prefs.getString(ApiConstants.cacheKeyProducts);
      
      if (jsonString == null) {
        return null;
      }
      
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw CacheException('Failed to load cached products: ${e.toString()}');
    }
  }

  /// Check if cache exists
  bool hasCachedData() {
    return _prefs.containsKey(ApiConstants.cacheKeyProducts);
  }

  /// Get cache timestamp
  DateTime? getCacheTimestamp() {
    final timestamp = _prefs.getInt(ApiConstants.cacheKeyTimestamp);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Save a single post to cache (for compatibility)
  Future<bool> savePost(List<Post> posts) async {
    return await savePosts(posts);
  }

  /// Save posts to cache
  Future<bool> savePosts(List<Post> posts) async {
    try {
      final jsonList = posts.map((post) => post.toJson()).toList();
      final jsonString = json.encode(jsonList);
      
      // Save posts with a different key
      final result = await _prefs.setString(
        'cached_posts',
        jsonString,
      );
      
      // Save timestamp
      await _prefs.setInt(
        'cache_posts_timestamp',
        DateTime.now().millisecondsSinceEpoch,
      );
      
      return result;
    } catch (e) {
      throw CacheException('Failed to save posts: ${e.toString()}');
    }
  }

  /// Get cached posts
  Future<List<Post>?> getCachedPosts() async {
    try {
      final jsonString = _prefs.getString('cached_posts');
      
      if (jsonString == null) {
        return null;
      }
      
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Post.fromJson(json)).toList();
    } catch (e) {
      throw CacheException('Failed to load cached posts: ${e.toString()}');
    }
  }

  /// Clear all cached data
  Future<bool> clearCache() async {
    try {
      await _prefs.remove(ApiConstants.cacheKeyProducts);
      await _prefs.remove(ApiConstants.cacheKeyTimestamp);
      await _prefs.remove('cached_posts');
      await _prefs.remove('cache_posts_timestamp');
      return true;
    } catch (e) {
      throw CacheException('Failed to clear cache: ${e.toString()}');
    }
  }
}

/// Custom exception for cache errors
class CacheException implements Exception {
  final String message;
  CacheException(this.message);

  @override
  String toString() => message;
}
