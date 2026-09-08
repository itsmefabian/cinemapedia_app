import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/presentation/providers/storage/local_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageMoviesNotifier extends Notifier<Map<int, Movie>> {
  int page = 0;

  @override
  Map<int, Movie> build() => {};

  Future<void> toggle(Movie movie) async {
    final repository = ref.watch(localStorageRepositoryProvider);

    final isFavorite = await repository.isFavoriteMovie(movie.id);
    await repository.toggleFavoriteMovie(movie);

    if (isFavorite) {
      state.remove(movie.id);
      state = {...state};
      return;
    }

    state = {...state, movie.id: movie};
  }

  Future<List<Movie>> loadNextPage() async {
    final repository = ref.watch(localStorageRepositoryProvider);
    final movies = await repository.getFavoriteMovies(
      limit: 10,
      offset: page * 10,
    );

    page++;

    final tmpMovies = <int, Movie>{};

    for (var movie in movies) {
      tmpMovies[movie.id] = movie;
    }

    state = {...state, ...tmpMovies};

    return movies;
  }
}

final favoriteMoviesProvider =
    NotifierProvider<StorageMoviesNotifier, Map<int, Movie>>(
      StorageMoviesNotifier.new,
    );
