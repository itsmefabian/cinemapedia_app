import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieMapper {
  static Movie movieDbToEntity(MovieMovieDB movie) => Movie(
    adult: movie.adult,
    backdropPath: movie.backdropPath != ''
        ? 'https://image.tmdb.org/t/p/w500/${movie.backdropPath}'
        : 'https://pixabay.com/images/download/draguth-not-found-2384304_1280.jpg',
    genreIds: movie.genreIds.map((e) => e.toString()).toList(),
    id: movie.id,
    originalLanguage: movie.originalLanguage,
    originalTitle: movie.originalTitle,
    overview: movie.overview,
    popularity: movie.popularity,
    posterPath: movie.posterPath != ''
        ? 'https://image.tmdb.org/t/p/w500/${movie.posterPath}'
        : 'https://pixabay.com/images/download/draguth-not-found-2384304_1280.jpg',
    releaseDate: movie.releaseDate,
    title: movie.title,
    video: movie.video,
    voteAverage: movie.voteAverage,
    voteCount: movie.voteCount,
  );

  static Movie movieDetailsToEntity(MovieDetails movie) => Movie(
    adult: movie.adult,
    backdropPath: movie.backdropPath != ''
        ? 'https://image.tmdb.org/t/p/w500/${movie.backdropPath}'
        : 'https://pixabay.com/images/download/draguth-not-found-2384304_1280.jpg',
    genreIds: movie.genres.map((e) => e.name).toList(),
    id: movie.id,
    originalLanguage: movie.originalLanguage,
    originalTitle: movie.originalTitle,
    overview: movie.overview,
    popularity: movie.popularity,
    posterPath: movie.posterPath != ''
        ? 'https://image.tmdb.org/t/p/w500/${movie.posterPath}'
        : 'https://pixabay.com/images/download/draguth-not-found-2384304_1280.jpg',
    releaseDate: movie.releaseDate,
    title: movie.title,
    video: movie.video,
    voteAverage: movie.voteAverage,
    voteCount: movie.voteCount,
  );
}
