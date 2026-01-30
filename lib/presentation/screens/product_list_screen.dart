import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_viewmodel.dart';
import '../widgets/loading_widget.dart';
import '../widgets/post_error_widget.dart';
import '../widgets/empty_widget.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

/// Product List Screen
/// Displays a list of products with pagination and offline support
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    // Load products when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductViewModel>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        elevation: 2,
        actions: [
          // Offline indicator
          Consumer<ProductViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isOfflineMode) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.cloud_off,
                        color: Colors.orange[300],
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Offline',
                        style: TextStyle(
                          color: Colors.orange[300],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<ProductViewModel>(
        builder: (context, viewModel, child) {
          // Loading state (initial load)
          if (viewModel.isLoading && !viewModel.hasData) {
            return const CustomLoadingWidget(
              message: 'Loading products...',
            );
          }

          // Error state (no cached data)
          if (viewModel.errorMessage != null && !viewModel.hasData) {
            return PostErrorWidget(
              message: viewModel.errorMessage!,
              onRetry: () => viewModel.loadProducts(),
            );
          }

          // Empty state
          if (!viewModel.hasData) {
            return const CustomEmptyWidget(
              message: 'No products available',
              icon: Icons.shopping_bag_outlined,
            );
          }

          // Success state - show list
          return RefreshIndicator(
            onRefresh: () => viewModel.refreshProducts(),
            child: Column(
              children: [
                // Offline mode banner
                if (viewModel.isOfflineMode)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: Colors.orange[100],
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.orange[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'You are viewing cached data. Connect to internet for latest updates.',
                            style: TextStyle(
                              color: Colors.orange[700],
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Products list
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.products.length + 1,
                    itemBuilder: (context, index) {
                      // Last item - Load More button
                      if (index == viewModel.products.length) {
                        if (viewModel.isOfflineMode) {
                          return const SizedBox.shrink();
                        }
                        
                        if (!viewModel.hasMore) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                'No more products',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: viewModel.isLoadingMore
                                ? const CircularProgressIndicator()
                                : ElevatedButton.icon(
                                    onPressed: () => viewModel.loadMoreProducts(),
                                    icon: const Icon(Icons.arrow_downward),
                                    label: const Text('Load More'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                          ),
                        );
                      }

                      // Product card
                      final product = viewModel.products[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(product: product),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
