import 'package:cinemapedia_app/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {
  final LocalStorageDatasource datasource;

  new({required this.datasource});

  @override
  Future<List<Movie>> getFavoriteMovies({int limit = 10, int offset = 0}) {
    return datasource.getFavoriteMovies(limit: limit, offset: offset);
  }

  @override
  Future<bool> isFavoriteMovie(int movieId) {
    return datasource.isFavoriteMovie(movieId);
  }

  @override
  Future<void> toggleFavoriteMovie(Movie movie) {
    return datasource.toggleFavoriteMovie(movie);
  }

  @override
  Future<bool?> getDarkModePreference() {
    return datasource.getDarkModePreference();
  }

  @override
  Future<void> setDarkModePreference(bool isDarkMode) {
    return datasource.setDarkModePreference(isDarkMode);
  }
}
