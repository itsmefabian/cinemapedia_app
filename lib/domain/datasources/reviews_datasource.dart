import 'package:cinemapedia_app/domain/entities/review.dart';

abstract class ReviewsDatasource {
  Future<List<Review>> getReviewsByMovie(String movieId);
}
