import 'package:cinemapedia_app/config/const/environment.dart';
import 'package:cinemapedia_app/domain/datasources/videos_datasource.dart';
import 'package:cinemapedia_app/domain/entities/video.dart';
import 'package:cinemapedia_app/infrastructure/mappers/video_mapper.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/videos_response.dart';
import 'package:dio/dio.dart';

class VideosMovieDbDatasource extends VideosDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {'api_key': Environment.apiKey},
    ),
  );

  @override
  Future<List<Video>> getVideosByMovie(String movieId) async {
    final response = await dio.get('/movie/$movieId/videos');

    if (response.statusCode != 200) {
      throw Exception('Videos for movie $movieId not found');
    }

    final videosResponse = VideosResponse.fromJson(response.data);

    return videosResponse.results
        .where((video) => video.site == 'YouTube' && video.type == 'Trailer')
        .map((video) => VideoMapper.videoResultToEntity(video))
        .toList();
  }
}
