import 'package:cinemapedia_app/infrastructure/datasources/reviews_moviedb_datasource.dart';
import 'package:cinemapedia_app/infrastructure/repositories/reviews_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reviewsRepositoryProvider = Provider(
  (ref) => ReviewsRepositoryImpl(ReviewsMovieDbDatasource()),
);
