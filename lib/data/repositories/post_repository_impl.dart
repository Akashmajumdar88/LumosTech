import '../../domain/repositories/post_repository.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

/// Post Repository Implementation
/// Implements the repository interface with offline-first approach
class PostRepositoryImpl implements PostRepository {
  final ApiService _apiService;
  final CacheService _cacheService;

  PostRepositoryImpl({
    required ApiService apiService,
    required CacheService cacheService,
  })  : _apiService = apiService,
        _cacheService = cacheService;

  @override
  Future<List<Post>> getPosts({int start = 0, int? limit}) async {
    try {
      // Try to fetch from API
      final posts = await _apiService.fetchPost(start: start, limit: limit);
      
      // Cache the data if it's the first page
      if (start == 0) {
        await _cacheService.savePost(posts);
      }
      
      return posts;
    } catch (e) {
      // If API fails and it's the first page, try to load from cache
      if (start == 0) {
        final cachedPosts = await _cacheService.getCachedPosts();
        if (cachedPosts != null && cachedPosts.isNotEmpty) {
          return cachedPosts;
        }
      }
      
      // If no cache available, rethrow the error
      rethrow;
    }
  }

  @override
  Future<List<Post>> getAllPosts() async {
    try {
      // Try to fetch from API
      final posts = await _apiService.fetchAllPosts();
      
      // Cache the data
      await _cacheService.savePosts(posts);
      
      return posts;
    } catch (e) {
      // If API fails, try to load from cache
      final cachedPosts = await _cacheService.getCachedPosts();
      if (cachedPosts != null && cachedPosts.isNotEmpty) {
        return cachedPosts;
      }
      
      // If no cache available, rethrow the error
      rethrow;
    }
  }

  @override
  Future<List<Post>?> getCachedPosts() async {
    return await _cacheService.getCachedPosts();
  }

  @override
  bool hasOfflineData() {
    return _cacheService.hasCachedData();
  }
}
