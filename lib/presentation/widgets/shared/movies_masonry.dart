import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class MoviesMasonry extends StatefulWidget {
  final List<Movie> movies;
  final Future<List<Movie>> Function()? loadNextPage;
  const new({super.key, required this.movies, this.loadNextPage});

  @override
  State<MoviesMasonry> createState() => _MoviesMasonryState();
}

class _MoviesMasonryState extends State<MoviesMasonry> {
  bool isLastPage = false;
  bool isLoading = false;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels + 200 >
          scrollController.position.maxScrollExtent) {
        loadNextPageMovies();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void loadNextPageMovies() async {
    if (isLoading || isLastPage) return;
    if (widget.loadNextPage == null) return;

    isLoading = true;
    final movies = await widget.loadNextPage!();

    isLoading = false;

    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        controller: scrollController,
        crossAxisSpacing: 10,
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          if (index == 1) {
            return Column(
              children: [
                const SizedBox(height: 30),
                _MoviePostLink(movie: widget.movies[index]),
              ],
            );
          }
          return _MoviePostLink(movie: widget.movies[index]);
        },
      ),
    );
  }
}

class _MoviePostLink extends StatelessWidget {
  final Movie movie;

  const new({required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('movie/${movie.id}'),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(20),
        child: Image.network(movie.posterPath),
      ),
    );
  }
}
