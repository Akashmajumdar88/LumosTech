import 'package:flutter/foundation.dart';
import '../../data/models/post_model.dart';
import '../../domain/repositories/post_repository.dart';
import '../../core/constants/api_constants.dart';

/// Post ViewModel
/// Manages state and business logic for posts using Provider
class PostViewModel extends ChangeNotifier {
  final PostRepository _repository;

  PostViewModel({required PostRepository repository})
      : _repository = repository;

  // State variables
  List<Post> _posts = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  bool _hasMore = true;
  int _currentPage = 0;
  bool _isOfflineMode = false;

  // Getters
  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  bool get isOfflineMode => _isOfflineMode;
  bool get hasData => _posts.isNotEmpty;

  /// Load initial posts
  Future<void> loadPosts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _hasMore = true;
      _posts.clear();
    }

    _isLoading = true;
    _errorMessage = null;
    _isOfflineMode = false;
    notifyListeners();

    try {
      final fetchedPosts = await _repository.getPosts(
        start: 0,
        limit: ApiConstants.itemsPerPage,
      );

      _posts = fetchedPosts;
      _currentPage = 1;
      _hasMore = fetchedPosts.length >= ApiConstants.itemsPerPage;
      _errorMessage = null;
    } catch (e) {
      // Try to load from cache
      final cachedPosts = await _repository.getCachedPosts();
      if (cachedPosts != null && cachedPosts.isNotEmpty) {
        _posts = cachedPosts;
        _isOfflineMode = true;
        _errorMessage = null;
      } else {
        _errorMessage = _getErrorMessage(e);
        _posts = [];
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load more posts (pagination)
  Future<void> loadMorePosts() async {
    if (_isLoadingMore || !_hasMore || _isOfflineMode) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final start = _currentPage * ApiConstants.itemsPerPage;
      final fetchedPosts = await _repository.getPosts(
        start: start,
        limit: ApiConstants.itemsPerPage,
      );

      if (fetchedPosts.isEmpty) {
        _hasMore = false;
      } else {
        _posts.addAll(fetchedPosts);
        _currentPage++;
        _hasMore = fetchedPosts.length >= ApiConstants.itemsPerPage;
      }
    } catch (e) {
      // Show error but don't clear existing posts
      _errorMessage = 'Failed to load more posts. Please check your connection.';
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Refresh posts (pull to refresh)
  Future<void> refreshPosts() async {
    await loadPosts(refresh: true);
  }

  /// Get error message from exception
  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('Network error')) {
      return 'No internet connection. Please check your network.';
    } else if (error.toString().contains('Failed to load')) {
      return 'Failed to load posts. Please try again.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Check if offline data is available
  bool hasOfflineData() {
    return _repository.hasOfflineData();
  }
}
