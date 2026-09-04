import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/domain/repositories/movies_repository.dart';
import 'package:cinemapedia_app/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef MovieCallBack = Future<List<Movie>> Function({int page});
typedef MovieFetcherSelector = MovieCallBack Function(MoviesRepository);

class MoviesNotifier extends Notifier<List<Movie>> {
  MoviesNotifier(this.fetcherSelector);

  final MovieFetcherSelector fetcherSelector;
  int currentPage = 0;
  bool isLoading = false;
  late MovieCallBack fetchMovies;

  @override
  build() {
    fetchMovies = fetcherSelector(ref.read(movieRepositoryProvider));
    return [];
  }

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    currentPage++;

    final List<Movie> movies = await fetchMovies(page: currentPage);
    state = [...state, ...movies];
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}

final nowPlayingMoviesProvider = NotifierProvider<MoviesNotifier, List<Movie>>(
  () => MoviesNotifier((repository) => repository.getNowPlaying),
);

final popularMoviesProvider = NotifierProvider<MoviesNotifier, List<Movie>>(
  () => MoviesNotifier((repository) => repository.getPopular),
);

final upcomingMoviesProvider = NotifierProvider<MoviesNotifier, List<Movie>>(
  () => MoviesNotifier((repository) => repository.getUpComing),
);

final topRatedMoviesProvider = NotifierProvider<MoviesNotifier, List<Movie>>(
  () => MoviesNotifier((repository) => repository.getTopRated),
);
