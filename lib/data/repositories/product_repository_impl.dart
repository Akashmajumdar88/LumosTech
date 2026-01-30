import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

/// Product Repository Implementation
/// Implements the repository interface with offline-first approach
class ProductRepositoryImpl implements ProductRepository {
  final ApiService _apiService;
  final CacheService _cacheService;

  ProductRepositoryImpl({
    required ApiService apiService,
    required CacheService cacheService,
  })  : _apiService = apiService,
        _cacheService = cacheService;

  @override
  Future<List<Product>> getProducts({int skip = 0, int? limit}) async {
    try {
      // Try to fetch from API
      final products = await _apiService.fetchProducts(skip: skip, limit: limit);
      
      // Cache the data if it's the first page
      if (skip == 0) {
        await _cacheService.saveProducts(products);
      }
      
      return products;
    } catch (e) {
      // If API fails and it's the first page, try to load from cache
      if (skip == 0) {
        final cachedProducts = await _cacheService.getCachedProducts();
        if (cachedProducts != null && cachedProducts.isNotEmpty) {
          return cachedProducts;
        }
      }
      
      // If no cache available, rethrow the error
      rethrow;
    }
  }

  @override
  Future<List<Product>> getAllProducts() async {
    try {
      // Try to fetch from API
      final products = await _apiService.fetchAllProducts();
      
      // Cache the data
      await _cacheService.saveProducts(products);
      
      return products;
    } catch (e) {
      // If API fails, try to load from cache
      final cachedProducts = await _cacheService.getCachedProducts();
      if (cachedProducts != null && cachedProducts.isNotEmpty) {
        return cachedProducts;
      }
      
      // If no cache available, rethrow the error
      rethrow;
    }
  }

  @override
  Future<List<Product>?> getCachedProducts() async {
    return await _cacheService.getCachedProducts();
  }

  @override
  bool hasOfflineData() {
    return _cacheService.hasCachedData();
  }
}
