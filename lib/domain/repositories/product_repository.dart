import '../../data/models/product_model.dart';

/// Product Repository Interface
/// Defines the contract for data operations
abstract class ProductRepository {
  /// Fetch products with pagination
  Future<List<Product>> getProducts({int skip = 0, int? limit});
  
  /// Fetch all products
  Future<List<Product>> getAllProducts();
  
  /// Get cached products
  Future<List<Product>?> getCachedProducts();
  
  /// Check if offline data is available
  bool hasOfflineData();
}
