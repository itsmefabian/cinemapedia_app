import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef MovieCallBack = Future<List<Movie>> Function({int page});

class MoviesNotifier extends Notifier<List<Movie>> {
  int currentPage = 0;
  late MovieCallBack fetchMovies;

  @override
  build() {
    fetchMovies = ref.read(movieRepositoryProvider).getNowPlaying;
    return [];
  }

  Future<void> loadNextPage() async {
    currentPage++;

    final List<Movie> movies = await fetchMovies(page: currentPage);
    state = [...state, ...movies];
  }
}

final nowPlayingMoviesProvider = NotifierProvider<MoviesNotifier, List<Movie>>(
  MoviesNotifier.new,
);
