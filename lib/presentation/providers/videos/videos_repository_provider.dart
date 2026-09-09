import 'package:cinemapedia_app/infrastructure/datasources/videos_moviedb_datasource.dart';
import 'package:cinemapedia_app/infrastructure/repositories/videos_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final videosRepositoryProvider = Provider(
  (ref) => VideosRepositoryImpl(VideosMovieDbDatasource()),
);
