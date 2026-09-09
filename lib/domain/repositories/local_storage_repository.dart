import 'package:cinemapedia_app/domain/entities/movie.dart';

abstract class LocalStorageRepository {
  Future<void> toggleFavoriteMovie(Movie movie);
  Future<bool> isFavoriteMovie(int movieId);
  Future<List<Movie>> getFavoriteMovies({int limit = 10, int offset = 0});
  Future<bool> isDarkMode();
  Future<void> toggleDarkMode();
}
