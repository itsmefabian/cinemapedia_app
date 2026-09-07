# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Cinemapedia is a Flutter movie-browsing app that consumes The Movie DB (TMDB) API. State is managed with Riverpod, navigation with go_router, and networking with Dio.

## Commands

```
flutter pub get              # install dependencies
flutter run                  # run the app (device/emulator required)
dart analyze                 # static analysis (uses analysis_options.yaml / flutter_lints)
flutter test                 # run tests (no test/ directory exists yet)
```

There is no `test/` directory yet — `flutter test` currently has nothing to run.

## Environment setup

The app reads a TMDB API key from a `.env` file at the project root (loaded via `flutter_dotenv` in `main.dart` and declared as a flutter asset in `pubspec.yaml`):

```
API_KEY=<tmdb_api_key>
```

`Environment.apiKey` (`lib/config/const/environment.dart`) exposes this at runtime and is consumed directly in `MoviedbDatasource`'s Dio `BaseOptions`.

## Architecture

The codebase follows a layered/clean-architecture split under `lib/`, with two parallel domains — **movies** and **actors** — plus a **search** feature built on top of the movies domain:

- **`domain/`** — pure abstractions with no external dependencies: `entities/` (`Movie`, `Actor`), plus abstract `datasources/` and `repositories/` interfaces per domain — `MoviesDatasource`/`MoviesRepository` (`getNowPlaying`, `getPopular`, `getUpComing`, `getTopRated`, `getMovie` for details, `searchMovie`) and `ActorsDatasource`/`ActorsRepository` (`getActorsByMovie`). Nothing here talks to TMDB or Dio directly.
- **`infrastructure/`** — concrete implementations of the domain interfaces: `datasources/moviedb_datasource.dart` (Dio calls to `api.themoviedb.org`, one method per TMDB list endpoint sharing a private `_jsonToMovies` helper, plus `getMovie` for `/movie/{id}` and `searchMovie` for `/search/movie`) and `datasources/actors_moviedb_datasource.dart` (`/movie/{id}/credits`), `models/moviedb/` (raw JSON-serializable response/model classes, e.g. `MovieMovieDB`/`MovieDbResponse` for list endpoints, `MovieDetails` for the details endpoint, `CreditsResponse` for cast), `mappers/` (convert infra models → domain entities — `MovieMapper.movieDbToEntity`/`movieDetailsToEntity`, `ActorMapper`), and `repositories/` (implement the domain repositories by delegating to a datasource).
- **`presentation/`** — Flutter UI: `screens/` (one subfolder per feature, e.g. `movies/` containing both `home_screen.dart` and `movie_screen.dart`, exported through a barrel file `screens.dart`), `widgets/` (reusable UI split into `shared/` app-wide widgets like `CinemaAppBar`/`BottomNavigation`/`FullScreenLoader` and per-feature widgets like `movies/slide_show.dart`/`horizontal_listview.dart`, exported via `widgets.dart`), `delegates/` (`SearchMovieDelegate`, a `SearchDelegate` used with Flutter's `showSearch`), and `providers/` (Riverpod providers, organized per-feature — `movies/`, `movie/`, `actors/`, `search/` — barrel-exported via `providers.dart`).
- **`config/`** — cross-cutting app config: `router/` (go_router route table — home `/` with a nested `movie/:id` route to `MovieScreen`), `theme/` (`AppTheme`), `const/` (`Environment` for the TMDB API key, `Assets` for static asset paths like the "no image" placeholder), `helpers/` (small stateless utilities, e.g. `Formats.number` for compact number formatting via `intl`).

Data flow for a feature is: `XDatasource` (abstract) → `XMoviedbDatasource` (infra, Dio + TMDB) → mapper → domain entity → `XRepository` (abstract) → `XRepositoryImpl` (infra) → Riverpod provider (`xRepositoryProvider`) → `Notifier` → screen widget (`ConsumerState`/`ConsumerWidget`).

When adding a new feature, mirror this same chain across all four layers rather than calling Dio or TMDB directly from a widget or provider.

### Riverpod conventions

- Repository providers are plain `Provider`s that construct a repository with a concrete datasource (see `movies_repository_provider.dart`, `actors_repository_provider.dart`).
- List state uses `NotifierProvider` classes (Riverpod 3 `Notifier`, not the older `StateNotifier`). `MoviesNotifier` (`movies_providers.dart`) is generic over which repository method it calls: it takes a `MovieFetcherSelector` (`MoviesRepository -> MovieCallBack`) in its constructor, so each movie-list provider (`nowPlayingMoviesProvider`, `popularMoviesProvider`, `upcomingMoviesProvider`, `topRatedMoviesProvider`) is just a different selector passed to the same notifier class. It also guards `loadNextPage()` with an `isLoading` flag to avoid concurrent duplicate fetches.
- Derived state is composed with plain `Provider`s that `ref.watch` other providers rather than duplicating fetch logic — e.g. `moviesSlideShowProvider` slices the now-playing list, and `firstLoadingProvider` is `true` until all four movie-list providers have loaded at least once (used to gate the UI behind `FullScreenLoader`).
- Single-item lookups keyed by id use a `Map<String, T>` `Notifier` whose method is a no-op once that id is cached — `movieInfoProvider`/`MovieMapNotifier` (`movie/movie_provider.dart`, `loadMovie(id)`) and `actorInfoProvider`/`CastMapNotifier` (`actors/actors_by_movie_provider.dart`, `getCastByMovie(movieId)`) both follow this pattern; `MovieScreen` calls both in `initState` keyed by `movieId`.
- Search (`search/search_movies_provider.dart`) splits the query text (`searchQueryProvider`/`SearchQueryNotifier`) from the results (`searchedMoviesProvider`/`SearchedMoviesNotifier`); `SearchedMoviesNotifier.searchMoviesByQuery` both fetches and updates the query provider as a side effect. `SearchMovieDelegate` debounces query changes (500ms `Timer`) and streams results/loading state via broadcast `StreamController`s rather than calling `setState`.
- New providers/screens/widgets should be added to the relevant barrel file (`providers.dart` / `screens.dart` / `widgets.dart`) so imports elsewhere stay as `import '.../providers/providers.dart'` etc.

### Constructor style

This codebase (Dart 3.13) uses the unnamed-constructor shorthand `new(...)` instead of repeating the class name (e.g. `const new({...})` inside `Movie`, `new(this.datasource)` inside `MovieRepositoryImpl`). This is intentional, not a typo — keep using this style for new unnamed constructors in this project rather than "fixing" it to `ClassName(...)`.
