import 'package:cinemapedia_app/domain/datasources/videos_datasource.dart';
import 'package:cinemapedia_app/domain/entities/video.dart';
import 'package:cinemapedia_app/domain/repositories/videos_repository.dart';

class VideosRepositoryImpl extends VideosRepository {
  final VideosDatasource datasource;

  new(this.datasource);

  @override
  Future<List<Video>> getVideosByMovie(String movieId) {
    return datasource.getVideosByMovie(movieId);
  }
}
