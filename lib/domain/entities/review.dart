class Review {
  final String id;
  final String author;
  final String content;
  final String? avatarPath;
  final double? rating;
  final DateTime createdAt;

  new({
    required this.id,
    required this.author,
    required this.content,
    this.avatarPath,
    this.rating,
    required this.createdAt,
  });
}
