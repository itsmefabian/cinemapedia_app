class ReviewsResponse {
  final int id;
  final List<ReviewResult> results;

  ReviewsResponse({required this.id, required this.results});

  factory ReviewsResponse.fromJson(Map<String, dynamic> json) =>
      ReviewsResponse(
        id: json["id"],
        results: List<ReviewResult>.from(
          json["results"].map((x) => ReviewResult.fromJson(x)),
        ),
      );
}

class ReviewResult {
  final String id;
  final String author;
  final AuthorDetails authorDetails;
  final String content;
  final DateTime createdAt;

  ReviewResult({
    required this.id,
    required this.author,
    required this.authorDetails,
    required this.content,
    required this.createdAt,
  });

  factory ReviewResult.fromJson(Map<String, dynamic> json) => ReviewResult(
    id: json["id"],
    author: json["author"],
    authorDetails: AuthorDetails.fromJson(json["author_details"]),
    content: json["content"],
    createdAt: DateTime.parse(json["created_at"]),
  );
}

class AuthorDetails {
  final String name;
  final String username;
  final String? avatarPath;
  final double? rating;

  AuthorDetails({
    required this.name,
    required this.username,
    this.avatarPath,
    this.rating,
  });

  factory AuthorDetails.fromJson(Map<String, dynamic> json) => AuthorDetails(
    name: json["name"],
    username: json["username"],
    avatarPath: json["avatar_path"],
    rating: json["rating"]?.toDouble(),
  );
}
