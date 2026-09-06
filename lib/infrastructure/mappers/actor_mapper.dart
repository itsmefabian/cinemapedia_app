import 'package:cinemapedia_app/domain/entities/actor.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/credits_response.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
    id: cast.id,
    name: cast.name,
    photoPath: cast.profilePath != null
        ? 'https://image.tmdb.org/t/p/w500/${cast.profilePath}'
        : 'https://pixabay.com/images/download/wanderercreative-blank-profile-picture-973460_1920.png',
    character: cast.character,
  );
}
