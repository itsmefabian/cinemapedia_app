import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia_app/config/const/assets.dart';
import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/domain/entities/review.dart';
import 'package:cinemapedia_app/presentation/providers/providers.dart';
import 'package:cinemapedia_app/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';

  final String movieId;

  const new({super.key, required this.movieId});

  @override
  ConsumerState<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorInfoProvider.notifier).getCastByMovie(widget.movieId);
    ref.read(videoInfoProvider.notifier).loadVideosByMovie(widget.movieId);
    ref.read(similarMoviesProvider.notifier).loadSimilarMovies(widget.movieId);
    ref.read(reviewInfoProvider.notifier).loadReviewsByMovie(widget.movieId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetails(movie: movie),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;

  const new({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isFavoriteFuture = ref.watch(isFavoriteMovieProvider(movie.id));

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async {
            await ref.read(favoriteMoviesProvider.notifier).toggle(movie);
            ref.invalidate(isFavoriteMovieProvider(movie.id));
          },

          icon: isFavoriteFuture.when(
            data: (isFavorite) => isFavorite
                ? const Icon(Icons.favorite, color: Colors.red)
                : const Icon(Icons.favorite_border_outlined),
            error: (_, _) => throw Exception('Error loading favorite movies'),
            loading: () => SizedBox(),
          ),

          // Icon(Icons.favorite_border_outlined, color: Colors.red),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            SizedBox.expand(
              child: movie.backdropPath == Assets.noImagePath
                  ? Image.asset(Assets.noImagePath, fit: BoxFit.cover)
                  : Image.network(
                      movie.backdropPath,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress != null) {
                          final expected = loadingProgress.expectedTotalBytes;
                          final loaded = loadingProgress.cumulativeBytesLoaded;

                          return Container(
                            color: Colors.grey.shade900,
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                value: expected != null
                                    ? loaded / expected
                                    : null,
                                strokeWidth: 2,
                                color: Colors.white54,
                              ),
                            ),
                          );
                        }

                        return FadeIn(child: child);
                      },
                    ),
            ),

            const _CustomGradient(
              alignmentBegin: Alignment.topCenter,
              alignmentEnd: Alignment.bottomCenter,
              stops: [0.8, 1.0],
              colors: [Colors.transparent, Colors.black38],
            ),

            const _CustomGradient(
              alignmentBegin: Alignment.topLeft,
              alignmentEnd: Alignment.bottomRight,
              stops: [0.0, 0.2],
              colors: [Colors.black87, Colors.transparent],
            ),

            const _CustomGradient(
              alignmentBegin: Alignment.topRight,
              alignmentEnd: Alignment.bottomLeft,
              stops: [0.0, 0.4],
              colors: [Colors.black87, Colors.transparent],
            ),

            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;

  const new({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: movie.posterPath == Assets.noImagePath
                    ? Image.asset(Assets.noImagePath, width: size.width * 0.3)
                    : Image.network(movie.posterPath, width: size.width * 0.3),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title, style: titleStyle.titleLarge),
                    Text(movie.overview),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map(
                (gender) => Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Chip(
                    label: Text(gender),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        _ActorsByMovie(movieId: movie.id.toString()),
        TrailerFromMovie(movieId: movie.id.toString()),
        _SimilarMovies(movieId: movie.id.toString()),
        _ReviewsByMovie(movieId: movie.id.toString()),
        const SizedBox(height: 50),
      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;

  const new({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    final actorsByMovie = ref.watch(actorInfoProvider);

    if (actorsByMovie[movieId] == null) {
      return const CircularProgressIndicator(strokeWidth: 2);
    }

    final actors = actorsByMovie[movieId];

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors!.length,
        itemBuilder: (context, index) {
          final actor = actors[index];
          return Container(
            padding: const EdgeInsetsGeometry.all(8.0),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInRight(
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(20),
                    child: actor.photoPath == Assets.noProfilePath
                        ? Image.asset(
                            Assets.noProfilePath,
                            height: 180,
                            width: 135,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            actor.photoPath,
                            height: 180,
                            width: 135,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(actor.name, maxLines: 2),
                Text(
                  actor.character!,
                  maxLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SimilarMovies extends ConsumerWidget {
  final String movieId;

  const new({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    final similarMoviesByMovie = ref.watch(similarMoviesProvider);
    final similarMovies = similarMoviesByMovie[movieId];

    if (similarMovies == null) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (similarMovies.isEmpty) return const SizedBox();

    return HorizontalListView(movies: similarMovies, title: 'Similar movies');
  }
}

class _ReviewsByMovie extends ConsumerWidget {
  final String movieId;

  const new({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    final reviewsByMovie = ref.watch(reviewInfoProvider);
    final reviews = reviewsByMovie[movieId];

    if (reviews == null) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (reviews.isEmpty) return const SizedBox();

    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reviews', style: titleStyle),
          const SizedBox(height: 10),
          ...reviews.map((review) => _ReviewCard(review: review)),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;

  const new({required this.review});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: review.avatarPath != null
                    ? NetworkImage(review.avatarPath!)
                    : null,
                child: review.avatarPath == null
                    ? const Icon(Icons.person)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.author, style: textStyles.titleSmall),
                    if (review.rating != null)
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.yellow.shade800,
                          ),
                          const SizedBox(width: 4),
                          Text('${review.rating}', style: textStyles.bodySmall),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.content,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            style: textStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry alignmentBegin;
  final AlignmentGeometry alignmentEnd;
  final List<double> stops;
  final List<Color> colors;

  const new({
    required this.alignmentBegin,
    required this.alignmentEnd,
    required this.stops,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: alignmentBegin,
            end: alignmentEnd,
            stops: stops,
            colors: colors,
          ),
        ),
      ),
    );
  }
}
