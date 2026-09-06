import 'package:cinemapedia_app/config/const/environment.dart';
import 'package:cinemapedia_app/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia_app/domain/entities/actor.dart';
import 'package:cinemapedia_app/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorsMovieDbDatasource extends ActorsDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {'api_key': Environment.apiKey},
    ),
  );

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
  final response = await dio.get('/movie/$movieId/credits');

    if (response.statusCode != 200) throw Exception('Cast $movieId not found');

    final creditsResponse = CreditsResponse.fromJson(response.data);

    return creditsResponse.cast
        .map((cast) => ActorMapper.castToEntity(cast))
        .toList();
  }
}
