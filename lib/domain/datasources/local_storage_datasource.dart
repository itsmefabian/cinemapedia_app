import 'package:cinemapedia_app/domain/entities/movie.dart';

abstract class LocalStorageDatasource {
  Future<void> toggleFavoriteMovie(Movie movie);
  Future<bool> isFavoriteMovie(int movieId);
  Future<List<Movie>> getFavoriteMovies({int limit = 10, int offset = 0});
}
