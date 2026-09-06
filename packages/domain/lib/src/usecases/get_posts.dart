import 'package:core/core.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

/// Interactor for retrieving blog posts.
final class GetPosts {
  const GetPosts(this._repository);

  final PostRepository _repository;

  Future<Result<List<PostEntity>, Failure>> call() {
    return _repository.getPosts();
  }
}
