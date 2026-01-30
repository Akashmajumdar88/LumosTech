import 'package:flutter/material.dart';
import '../../data/models/post_model.dart';

/// Post Detail Screen
/// Displays full details of a selected post
class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post ID and User ID badges
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.tag,
                          size: 16,
                          color: Colors.blue[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Post ID: ${post.id}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 16,
                          color: Colors.green[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'User ID: ${post.userId}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Title section
              Text(
                'Title',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.grey[600],
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                post.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
              ),
              const SizedBox(height: 24),

              // Divider
              Divider(
                color: Colors.grey[300],
                thickness: 1,
              ),
              const SizedBox(height: 24),

              // Body section
              Text(
                'Content',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.grey[600],
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                post.body,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      fontSize: 16,
                    ),
              ),
              const SizedBox(height: 32),

              // Info card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue[200]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[700],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This post was created by user ${post.userId} and has been assigned ID ${post.id}.',
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
