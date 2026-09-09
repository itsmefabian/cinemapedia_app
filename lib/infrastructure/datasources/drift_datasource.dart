import 'package:cinemapedia_app/config/database/database.dart';
import 'package:cinemapedia_app/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:drift/drift.dart' as drift;

class DriftDatasource extends LocalStorageDatasource {
  final AppDatabase database;

  new({required this.database});

  @override
  Future<List<Movie>> getFavoriteMovies({
    int limit = 10,
    int offset = 0,
  }) async {
    final query = database.select(database.favoritesMovies)
      ..limit(limit, offset: offset);

    final favoriteMovies = await query.get();

    final movies = favoriteMovies
        .map(
          (row) => Movie(
            adult: false,
            backdropPath: row.backdropPath,
            genreIds: const [],
            id: row.movieId,
            originalLanguage: '',
            originalTitle: row.originalTitle,
            overview: '',
            popularity: 0,
            posterPath: row.posterPath,
            title: row.title,
            video: false,
            voteAverage: row.voteAverage,
            voteCount: 0,
          ),
        )
        .toList();

    return movies;
  }

  @override
  Future<bool> isFavoriteMovie(int movieId) async {
    final query = database.select(database.favoritesMovies)
      ..where((table) => table.movieId.equals(movieId));

    final favoriteMovies = await query.getSingleOrNull();

    return favoriteMovies != null;
  }

  @override
  Future<void> toggleFavoriteMovie(Movie movie) async {
    final isFavorite = await isFavoriteMovie(movie.id);

    if (isFavorite) {
      final deleteQuery = database.delete(database.favoritesMovies)
        ..where((table) => table.movieId.equals(movie.id));

      await deleteQuery.go();
      return;
    }

    await database
        .into(database.favoritesMovies)
        .insert(
          FavoritesMoviesCompanion.insert(
            movieId: movie.id,
            backdropPath: movie.backdropPath,
            posterPath: movie.posterPath,
            originalTitle: movie.originalTitle,
            title: movie.title,
            voteAverage: drift.Value(movie.voteAverage),
          ),
        );
  }

  @override
  Future<bool?> getDarkModePreference() async {
    final settings = await database
        .select(database.appSettings)
        .getSingleOrNull();
    return settings?.isDarkMode;
  }

  @override
  Future<void> setDarkModePreference(bool isDarkMode) async {
    final settings = await database
        .select(database.appSettings)
        .getSingleOrNull();

    if (settings == null) {
      await database
          .into(database.appSettings)
          .insert(
            AppSettingsCompanion.insert(isDarkMode: drift.Value(isDarkMode)),
          );
      return;
    }

    await (database.update(database.appSettings)
          ..where((table) => table.id.equals(settings.id)))
        .write(AppSettingsCompanion(isDarkMode: drift.Value(isDarkMode)));
  }
}
