import 'package:cinemapedia_app/config/const/assets.dart';
import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieMapper {
  static Movie movieDbToEntity(MovieMovieDB movie) => Movie(
    adult: movie.adult,
    backdropPath: movie.backdropPath != ''
        ? 'https://image.tmdb.org/t/p/w500/${movie.backdropPath}'
        : Assets.noImagePath,
    genreIds: movie.genreIds.map((e) => e.toString()).toList(),
    id: movie.id,
    originalLanguage: movie.originalLanguage,
    originalTitle: movie.originalTitle,
    overview: movie.overview,
    popularity: movie.popularity,
    posterPath: movie.posterPath != ''
        ? 'https://image.tmdb.org/t/p/w500/${movie.posterPath}'
        : Assets.noImagePath,
    releaseDate: movie.releaseDate,
    title: movie.title,
    video: movie.video,
    voteAverage: movie.voteAverage,
    voteCount: movie.voteCount,
  );

  static Movie movieDetailsToEntity(MovieDetails movie) => Movie(
    adult: movie.adult,
    backdropPath: movie.backdropPath != ''
        ? 'https://image.tmdb.org/t/p/original/${movie.backdropPath}'
        : Assets.noImagePath,
    genreIds: movie.genres.map((e) => e.name).toList(),
    id: movie.id,
    originalLanguage: movie.originalLanguage,
    originalTitle: movie.originalTitle,
    overview: movie.overview,
    popularity: movie.popularity,
    posterPath: movie.posterPath != ''
        ? 'https://image.tmdb.org/t/p/original/${movie.posterPath}'
        : Assets.noImagePath,
    releaseDate: movie.releaseDate,
    title: movie.title ?? '',
    video: movie.video,
    voteAverage: movie.voteAverage,
    voteCount: movie.voteCount,
  );
}
