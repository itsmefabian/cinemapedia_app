import 'package:cinemapedia_app/config/const/environment.dart';
import 'package:cinemapedia_app/domain/datasources/reviews_datasource.dart';
import 'package:cinemapedia_app/domain/entities/review.dart';
import 'package:cinemapedia_app/infrastructure/mappers/review_mapper.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/reviews_response.dart';
import 'package:dio/dio.dart';

class ReviewsMovieDbDatasource extends ReviewsDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {'api_key': Environment.apiKey},
    ),
  );

  @override
  Future<List<Review>> getReviewsByMovie(String movieId) async {
    final response = await dio.get('/movie/$movieId/reviews');

    final reviewsResponse = ReviewsResponse.fromJson(response.data);

    return reviewsResponse.results
        .map((review) => ReviewMapper.reviewResultToEntity(review))
        .toList();
  }
}
