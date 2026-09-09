import 'package:cinemapedia_app/domain/entities/video.dart';

abstract class VideosRepository {
  Future<List<Video>> getVideosByMovie(String movieId);
}
