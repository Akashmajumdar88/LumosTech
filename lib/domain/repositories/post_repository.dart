import '../../data/models/post_model.dart';

/// Post Repository Interface
/// Defines the contract for data operations
abstract class PostRepository {
  /// Fetch posts with pagination
  Future<List<Post>> getPosts({int start = 0, int? limit});
  
  /// Fetch all posts
  Future<List<Post>> getAllPosts();
  
  /// Get cached posts
  Future<List<Post>?> getCachedPosts();
  
  /// Check if offline data is available
  bool hasOfflineData();
}
