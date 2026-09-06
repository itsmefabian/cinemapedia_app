import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class MovieMapNotifier extends Notifier<Map<String, Movie>> {
  @override
  Map<String, Movie> build() => {};

  Future<void> loadMovie(String movieId) async {
    if (state.containsKey(movieId)) return;

    final movie = await ref.read(movieRepositoryProvider).getMovie(movieId);

    state = {...state, movieId: movie};
  }
}

final movieInfoProvider =
    NotifierProvider<MovieMapNotifier, Map<String, Movie>>(
      MovieMapNotifier.new,
    );
