import 'package:cinemapedia_app/domain/entities/review.dart';
import 'package:cinemapedia_app/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReviewMapNotifier extends Notifier<Map<String, List<Review>>> {
  @override
  Map<String, List<Review>> build() => {};

  Future<void> loadReviewsByMovie(String movieId) async {
    if (state.containsKey(movieId)) return;

    final reviews = await ref
        .read(reviewsRepositoryProvider)
        .getReviewsByMovie(movieId);

    state = {...state, movieId: reviews};
  }
}

final reviewInfoProvider =
    NotifierProvider<ReviewMapNotifier, Map<String, List<Review>>>(
      ReviewMapNotifier.new,
    );
