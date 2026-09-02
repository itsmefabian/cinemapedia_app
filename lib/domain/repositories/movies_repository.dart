import 'package:cinemapedia_app/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia_app/domain/entities/movie.dart';

abstract class MoviesRepository implements MoviesDatasource {
  Future<Movie> getNowPlaying({int page = 1});
}
