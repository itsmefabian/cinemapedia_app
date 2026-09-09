import 'package:cinemapedia_app/domain/entities/review.dart';

abstract class ReviewsRepository {
  Future<List<Review>> getReviewsByMovie(String movieId);
}
