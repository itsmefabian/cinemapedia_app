import 'package:cinemapedia_app/domain/datasources/reviews_datasource.dart';
import 'package:cinemapedia_app/domain/entities/review.dart';
import 'package:cinemapedia_app/domain/repositories/reviews_repository.dart';

class ReviewsRepositoryImpl extends ReviewsRepository {
  final ReviewsDatasource datasource;

  new(this.datasource);

  @override
  Future<List<Review>> getReviewsByMovie(String movieId) {
    return datasource.getReviewsByMovie(movieId);
  }
}
