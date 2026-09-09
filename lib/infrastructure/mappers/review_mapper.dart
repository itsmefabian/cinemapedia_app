import 'package:cinemapedia_app/domain/entities/review.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/reviews_response.dart';

class ReviewMapper {
  static Review reviewResultToEntity(ReviewResult reviewResult) {
    final avatarPath = reviewResult.authorDetails.avatarPath;

    return Review(
      id: reviewResult.id,
      author: reviewResult.author,
      content: reviewResult.content,
      avatarPath: avatarPath == null || avatarPath.isEmpty
          ? null
          : avatarPath.startsWith('/http')
          ? avatarPath.substring(1)
          : 'https://image.tmdb.org/t/p/w500$avatarPath',
      rating: reviewResult.authorDetails.rating,
      createdAt: reviewResult.createdAt,
    );
  }
}
