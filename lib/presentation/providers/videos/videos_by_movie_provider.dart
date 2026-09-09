import 'package:cinemapedia_app/domain/entities/video.dart';
import 'package:cinemapedia_app/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoMapNotifier extends Notifier<Map<String, List<Video>>> {
  @override
  Map<String, List<Video>> build() => {};

  Future<void> loadVideosByMovie(String movieId) async {
    if (state.containsKey(movieId)) return;

    final videos = await ref
        .read(videosRepositoryProvider)
        .getVideosByMovie(movieId);

    state = {...state, movieId: videos};
  }
}

final videoInfoProvider =
    NotifierProvider<VideoMapNotifier, Map<String, List<Video>>>(
      VideoMapNotifier.new,
    );
