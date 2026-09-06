import 'package:cinemapedia_app/domain/entities/actor.dart';
import 'package:cinemapedia_app/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CastMapNotifier extends Notifier<Map<String, List<Actor>>> {
  @override
  Map<String, List<Actor>> build() => {};

  Future<void> getCastByMovie(String movieId) async {
    if (state.containsKey(movieId)) return;

    final actors = await ref
        .read(actorsRepositoryProvider)
        .getActorsByMovie(movieId);

    state = {...state, movieId: actors};
  }
}

final actorInfoProvider =
    NotifierProvider<CastMapNotifier, Map<String, List<Actor>>>(
      CastMapNotifier.new,
    );
