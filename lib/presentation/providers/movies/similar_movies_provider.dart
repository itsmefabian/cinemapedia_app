import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SimilarMoviesMapNotifier extends Notifier<Map<String, List<Movie>>> {
  @override
  Map<String, List<Movie>> build() => {};

  Future<void> loadSimilarMovies(String movieId) async {
    if (state.containsKey(movieId)) return;

    final similarMovies = await ref
        .read(movieRepositoryProvider)
        .getSimilarMovies(movieId);

    state = {...state, movieId: similarMovies};
  }
}

final similarMoviesProvider =
    NotifierProvider<SimilarMoviesMapNotifier, Map<String, List<Movie>>>(
      SimilarMoviesMapNotifier.new,
    );
