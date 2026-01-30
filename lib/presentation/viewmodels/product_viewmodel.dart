import 'package:flutter/foundation.dart';
import '../../data/models/product_model.dart';
import '../../domain/repositories/product_repository.dart';
import '../../core/constants/api_constants.dart';

/// Product ViewModel
/// Manages state and business logic for products using Provider
class ProductViewModel extends ChangeNotifier {
  final ProductRepository _repository;

  ProductViewModel({required ProductRepository repository})
      : _repository = repository;

  // State variables
  List<Product> _products = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  bool _hasMore = true;
  int _currentSkip = 0;
  bool _isOfflineMode = false;

  // Getters
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  bool get isOfflineMode => _isOfflineMode;
  bool get hasData => _products.isNotEmpty;

  /// Load initial products
  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      _currentSkip = 0;
      _hasMore = true;
      _products.clear();
    }

    _isLoading = true;
    _errorMessage = null;
    _isOfflineMode = false;
    notifyListeners();

    try {
      final fetchedProducts = await _repository.getProducts(
        skip: 0,
        limit: ApiConstants.itemsPerPage,
      );

      _products = fetchedProducts;
      _currentSkip = ApiConstants.itemsPerPage;
      _hasMore = fetchedProducts.length >= ApiConstants.itemsPerPage;
      _errorMessage = null;
    } catch (e) {
      // Try to load from cache
      final cachedProducts = await _repository.getCachedProducts();
      if (cachedProducts != null && cachedProducts.isNotEmpty) {
        _products = cachedProducts;
        _isOfflineMode = true;
        _errorMessage = null;
      } else {
        _errorMessage = _getErrorMessage(e);
        _products = [];
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load more products (pagination)
  Future<void> loadMoreProducts() async {
    if (_isLoadingMore || !_hasMore || _isOfflineMode) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final fetchedProducts = await _repository.getProducts(
        skip: _currentSkip,
        limit: ApiConstants.itemsPerPage,
      );

      if (fetchedProducts.isEmpty) {
        _hasMore = false;
      } else {
        _products.addAll(fetchedProducts);
        _currentSkip += fetchedProducts.length;
        _hasMore = fetchedProducts.length >= ApiConstants.itemsPerPage;
      }
    } catch (e) {
      // Show error but don't clear existing products
      _errorMessage = 'Failed to load more products. Please check your connection.';
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Refresh products (pull to refresh)
  Future<void> refreshProducts() async {
    await loadProducts(refresh: true);
  }

  /// Get error message from exception
  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('Network error')) {
      return 'No internet connection. Please check your network.';
    } else if (error.toString().contains('Failed to load')) {
      return 'Failed to load products. Please try again.';
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
