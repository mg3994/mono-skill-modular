/// Domain entity representing a Blog Post.
class PostEntity {
  const PostEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    required this.publishedAt,
    this.readTimeMinutes = 1,
  });

  final String id;
  final String title;
  final String content;
  final String authorName;
  final DateTime publishedAt;
  final int readTimeMinutes;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          content == other.content &&
          authorName == other.authorName &&
          publishedAt == other.publishedAt &&
          readTimeMinutes == other.readTimeMinutes;

  @override
  int get hashCode => Object.hash(
        id,
        title,
        content,
        authorName,
        publishedAt,
        readTimeMinutes,
      );
}
