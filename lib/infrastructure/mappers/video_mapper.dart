import 'package:cinemapedia_app/domain/entities/video.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/videos_response.dart';

class VideoMapper {
  static Video videoResultToEntity(VideoResult videoResult) => Video(
    id: videoResult.id,
    name: videoResult.name,
    youtubeKey: videoResult.key,
    publishedAt: videoResult.publishedAt,
  );
}
