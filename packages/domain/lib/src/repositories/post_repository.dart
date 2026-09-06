import 'package:core/core.dart';
import '../entities/post.dart';

/// Contract interface for blog post operations.
abstract interface class PostRepository {
  Future<Result<List<PostEntity>, Failure>> getPosts();
  Future<Result<List<PostEntity>, Failure>> searchPosts(String query);
  Future<Result<PostEntity?, Failure>> getPostById(String id);
}
