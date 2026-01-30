import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/post_viewmodel.dart';
import '../widgets/loading_widget.dart';
import '../widgets/post_error_widget.dart';
import '../widgets/empty_widget.dart';
import '../widgets/post_card.dart';
import 'post_detail_screen.dart';

/// Post List Screen
/// Displays a list of posts with pagination and offline support
class PostListScreen extends StatefulWidget {
  const PostListScreen({Key? key}) : super(key: key);

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  @override
  void initState() {
    super.initState();
    // Load posts when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostViewModel>().loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        elevation: 2,
        actions: [
          // Offline indicator
          Consumer<PostViewModel>(
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
      body: Consumer<PostViewModel>(
        builder: (context, viewModel, child) {
          // Loading state (initial load)
          if (viewModel.isLoading && !viewModel.hasData) {
            return const CustomLoadingWidget(
              message: 'Loading posts...',
            );
          }

          // Error state (no cached data)
          if (viewModel.errorMessage != null && !viewModel.hasData) {
            return PostErrorWidget(
              message: viewModel.errorMessage!,
              onRetry: () => viewModel.loadPosts(),
            );
          }

          // Empty state
          if (!viewModel.hasData) {
            return const CustomEmptyWidget(
              message: 'No posts available',
            );
          }

          // Success state - show list
          return RefreshIndicator(
            onRefresh: () => viewModel.refreshPosts(),
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
                
                // Posts list
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.posts.length + 1,
                    itemBuilder: (context, index) {
                      // Last item - Load More button
                      if (index == viewModel.posts.length) {
                        if (viewModel.isOfflineMode) {
                          return const SizedBox.shrink();
                        }
                        
                        if (!viewModel.hasMore) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                'No more posts',
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
                                    onPressed: () => viewModel.loadMorePosts(),
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

                      // Post card
                      final post = viewModel.posts[index];
                      return PostCard(
                        post: post,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostDetailScreen(post: post),
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
