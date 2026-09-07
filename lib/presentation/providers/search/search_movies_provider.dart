import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String value) {
    state = value;
  }
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

class SearchedMoviesNotifier extends Notifier<List<Movie>> {
  @override
  List<Movie> build() => [];

  Future<List<Movie>> searchMoviesByQuery(String query) async {
    final repository = ref.read(movieRepositoryProvider);

    final movies = await repository.searchMovie(query);

    ref.read(searchQueryProvider.notifier).update(query);

    state = movies;

    return movies;
  }
}

final searchedMoviesProvider =
    NotifierProvider<SearchedMoviesNotifier, List<Movie>>(
      SearchedMoviesNotifier.new,
    );
