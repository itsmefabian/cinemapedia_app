import 'package:cinemapedia_app/config/const/environment.dart';
import 'package:cinemapedia_app/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MoviedbDatasource extends MoviesDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {'api_key': Environment.apiKey},
    ),
  );

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing');

    return MovieDbResponse.fromJson(response.data).results
        .map((movie) => MovieMapper.movieDbToEntity(movie))
        .toList();
  }
}
