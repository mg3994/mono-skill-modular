import 'package:core/core.dart';
import 'package:domain/domain.dart';

/// Sample repository implementation for PostEntity operations.
final class InMemoryPostRepository implements PostRepository {
  InMemoryPostRepository([List<PostEntity>? initialPosts])
      : _posts = initialPosts ?? _samplePosts;

  final List<PostEntity> _posts;

  static final List<PostEntity> _samplePosts = [
    PostEntity(
      id: '1',
      title: 'Building Modular Applications with Dart Workspaces',
      content:
          'Dart Pub Workspaces provide an elegant way to organize monorepos into clean LEGO-like packages...',
      authorName: 'Jules Architect',
      publishedAt: DateTime(2026, 2, 20, 10, 0),
      readTimeMinutes: 4,
    ),
    PostEntity(
      id: '2',
      title: 'Clean Architecture Principles in Flutter',
      content:
          'By separating Domain, Infrastructure, and Presentation layers, codebases remain testable and maintainable...',
      authorName: 'Kaisel Engineer',
      publishedAt: DateTime(2026, 2, 21, 14, 30),
      readTimeMinutes: 6,
    ),
  ];

  @override
  Future<Result<List<PostEntity>, Failure>> getPosts() async {
    return Result.success(List.unmodifiable(_posts));
  }

  @override
  Future<Result<List<PostEntity>, Failure>> searchPosts(String query) async {
    final lower = query.toLowerCase();
    final filtered = _posts.where((post) {
      return post.title.toLowerCase().contains(lower) ||
          post.content.toLowerCase().contains(lower) ||
          post.authorName.toLowerCase().contains(lower);
    }).toList();
    return Result.success(filtered);
  }

  @override
  Future<Result<PostEntity?, Failure>> getPostById(String id) async {
    try {
      final post = _posts.firstWhere((p) => p.id == id);
      return Result.success(post);
    } catch (_) {
      return Result.success(null);
    }
  }
}
