import 'package:core/core.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

/// Interactor for searching blog posts by query string.
final class SearchPosts {
  const SearchPosts(this._repository);

  final PostRepository _repository;

  Future<Result<List<PostEntity>, Failure>> call(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return _repository.getPosts();
    }
    return _repository.searchPosts(trimmed);
  }
}
