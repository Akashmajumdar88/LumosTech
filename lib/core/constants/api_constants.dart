/// API Constants for the application
/// Contains all API endpoints and configuration
class ApiConstants {
  // Base URL for DummyJSON API (Working and reliable)
  static const String baseUrl = 'https://dummyjson.com';
  
  // Endpoints
  static const String productsEndpoint = '/products';
  
  // Pagination
  static const int itemsPerPage = 10;
  
  // Cache Keys
  static const String cacheKeyProducts = 'cached_products';
  static const String cacheKeyTimestamp = 'cache_timestamp';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
