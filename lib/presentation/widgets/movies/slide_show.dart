import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cinemapedia_app/config/const/assets.dart';
import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SlideShow extends StatefulWidget {
  final List<Movie> movies;
  const new({super.key, required this.movies});

  @override
  State<SlideShow> createState() => _SlideShowState();
}

class _SlideShowState extends State<SlideShow> {
  final swiperController = SwiperController();
  Timer? timer;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (widget.movies.isEmpty) return;

      final isLastSlide = currentIndex == widget.movies.length - 1;
      isLastSlide ? swiperController.move(0) : swiperController.next();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 210,
      width: double.infinity,
      child: Swiper(
        controller: swiperController,
        itemCount: widget.movies.length,
        viewportFraction: 0.8,
        scale: 0.9,
        loop: false,
        onIndexChanged: (index) => currentIndex = index,
        pagination: SwiperPagination(
          margin: EdgeInsets.only(top: 0),
          builder: DotSwiperPaginationBuilder(
            activeColor: colors.primary,
            color: colors.secondary,
          ),
        ),
        itemBuilder: (context, index) => _Slide(movie: widget.movies[index]),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;

  const new({required this.movie});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 10)),
      ],
    );

    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: DecoratedBox(
        decoration: decoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: movie.backdropPath == Assets.noImagePath
              ? SvgPicture.asset(Assets.noImagePath, fit: BoxFit.cover)
              : Image.network(
                  movie.backdropPath,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress != null
                      ? const DecoratedBox(
                          decoration: BoxDecoration(color: Colors.black12),
                        )
                      : FadeIn(child: child),
                ),
        ),
      ),
    );
  }
}
