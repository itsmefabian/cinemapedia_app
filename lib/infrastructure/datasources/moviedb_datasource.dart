import 'package:cinemapedia_app/config/const/environment.dart';
import 'package:cinemapedia_app/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MoviedbDatasource extends MoviesDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {'api_key': Environment.apiKey},
    ),
  );

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final dbResponse = MovieDbResponse.fromJson(json).results
        .map((movie) => MovieMapper.movieDbToEntity(movie))
        .toList();

    return dbResponse;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get(
      '/movie/now_playing',
      queryParameters: {'page': page},
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await dio.get(
      '/movie/popular',
      queryParameters: {'page': page},
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpComing({int page = 1}) async {
    final response = await dio.get(
      '/movie/upcoming',
      queryParameters: {'page': page},
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get(
      '/movie/top_rated',
      queryParameters: {'page': page},
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<Movie> getMovie(String id) async {
    final response = await dio.get('/movie/$id');

    if (response.statusCode != 200) throw Exception('Movie $id not found');

    return MovieMapper.movieDetailsToEntity(
      MovieDetails.fromJson(response.data),
    );
  }

  @override
  Future<List<Movie>> searchMovie(String query) async {
    if (query.isEmpty) return [];

    final response = await dio.get(
      '/search/movie',
      queryParameters: {'query': query},
    );

    if (response.statusCode != 200) throw Exception('Movie $query not found');

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getSimilarMovies(String id) async {
    final response = await dio.get('/movie/$id/similar');

    return _jsonToMovies(response.data);
  }
}
