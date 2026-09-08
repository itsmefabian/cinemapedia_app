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
dart run build_runner build --delete-conflicting-outputs   # regenerate lib/config/database/database.g.dart after editing database.dart
```

There is no `test/` directory yet — `flutter test` currently has nothing to run.

## Environment setup

The app reads a TMDB API key from a `.env` file at the project root (loaded via `flutter_dotenv` in `main.dart` and declared as a flutter asset in `pubspec.yaml`):

```
API_KEY=<tmdb_api_key>
```

`Environment.apiKey` (`lib/config/const/environment.dart`) exposes this at runtime and is consumed directly in `MoviedbDatasource`'s Dio `BaseOptions`.

## Architecture

The codebase follows a layered/clean-architecture split under `lib/`, with three parallel domains — **movies**, **actors**, and **local storage** (favorites) — plus a **search** feature built on top of the movies domain:

- **`domain/`** — pure abstractions with no external dependencies: `entities/` (`Movie`, `Actor`), plus abstract `datasources/` and `repositories/` interfaces per domain — `MoviesDatasource`/`MoviesRepository` (`getNowPlaying`, `getPopular`, `getUpComing`, `getTopRated`, `getMovie` for details, `searchMovie`), `ActorsDatasource`/`ActorsRepository` (`getActorsByMovie`), and `LocalStorageDatasource`/`LocalStorageRepository` (`toggleFavoriteMovie`, `isFavoriteMovie`, `getFavoriteMovies`). Nothing here talks to TMDB, Dio, or Drift directly.
- **`infrastructure/`** — concrete implementations of the domain interfaces: `datasources/moviedb_datasource.dart` (Dio calls to `api.themoviedb.org`, one method per TMDB list endpoint sharing a private `_jsonToMovies` helper, plus `getMovie` for `/movie/{id}` and `searchMovie` for `/search/movie`), `datasources/actors_moviedb_datasource.dart` (`/movie/{id}/credits`), and `datasources/drift_datasource.dart` (`DriftDatasource`, queries the local `AppDatabase`), `models/moviedb/` (raw JSON-serializable response/model classes, e.g. `MovieMovieDB`/`MovieDbResponse` for list endpoints, `MovieDetails` for the details endpoint, `CreditsResponse` for cast), `mappers/` (convert infra models → domain entities — `MovieMapper.movieDbToEntity`/`movieDetailsToEntity`, `ActorMapper`; the favorites path builds a `Movie` by hand from a `FavoritesMovies` row instead, since drift rows aren't a moviedb model), and `repositories/` (implement the domain repositories by delegating to a datasource).
- **`presentation/`** — Flutter UI: `screens/` (top-level screens pushed by the router — `HomeScreen`, the bottom-nav shell itself, and `MovieScreen`, a full-screen route — exported through a barrel file `screens.dart`), `views/` (the per-tab bodies rendered inside the shell, under `tabs/` — `HomeView`, `FavoritesView` — exported via `views.dart`), `widgets/` (reusable UI split into `shared/` app-wide widgets like `CinemaAppBar`/`BottomNavigation`/`FullScreenLoader`/`MoviesMasonry` and per-feature widgets like `movies/slide_show.dart`/`horizontal_listview.dart`, exported via `widgets.dart`), `delegates/` (`SearchMovieDelegate`, a `SearchDelegate` used with Flutter's `showSearch`), and `providers/` (Riverpod providers, organized per-feature — `movies/`, `movie/`, `actors/`, `search/`, `storage/` — barrel-exported via `providers.dart`).
- **`config/`** — cross-cutting app config: `router/` (go_router route table — a `StatefulShellRoute.indexedStack` with one branch per bottom-nav tab (`/` → `HomeView`, `/favorites` → `FavoritesView`), plus a nested `movie/:id` route pushed on top of the `/` branch to `MovieScreen`), `theme/` (`AppTheme`), `const/` (`Environment` for the TMDB API key, `Assets` for static asset paths like the "no image"/"no profile" placeholders), `helpers/` (small stateless utilities, e.g. `Formats.number` for compact number formatting via `intl`), `database/` (`database.dart` — the drift `AppDatabase` and `FavoritesMovies` table schema — plus the generated `database.g.dart`, produced by `build_runner`/`drift_dev`; never hand-edit `database.g.dart`).

Data flow for a feature is: `XDatasource` (abstract) → `XMoviedbDatasource` (infra, Dio + TMDB) → mapper → domain entity → `XRepository` (abstract) → `XRepositoryImpl` (infra) → Riverpod provider (`xRepositoryProvider`) → `Notifier` → screen widget (`ConsumerState`/`ConsumerWidget`).

When adding a new feature, mirror this same chain across all four layers rather than calling Dio or TMDB directly from a widget or provider.

### Riverpod conventions

- Repository providers are plain `Provider`s that construct a repository with a concrete datasource (see `movies_repository_provider.dart`, `actors_repository_provider.dart`).
- List state uses `NotifierProvider` classes (Riverpod 3 `Notifier`, not the older `StateNotifier`). `MoviesNotifier` (`movies_providers.dart`) is generic over which repository method it calls: it takes a `MovieFetcherSelector` (`MoviesRepository -> MovieCallBack`) in its constructor, so each movie-list provider (`nowPlayingMoviesProvider`, `popularMoviesProvider`, `upcomingMoviesProvider`, `topRatedMoviesProvider`) is just a different selector passed to the same notifier class. It also guards `loadNextPage()` with an `isLoading` flag to avoid concurrent duplicate fetches.
- Derived state is composed with plain `Provider`s that `ref.watch` other providers rather than duplicating fetch logic — e.g. `moviesSlideShowProvider` slices the now-playing list, and `firstLoadingProvider` is `true` until all four movie-list providers have loaded at least once (used to gate the UI behind `FullScreenLoader`).
- Single-item lookups keyed by id use a `Map<String, T>` `Notifier` whose method is a no-op once that id is cached — `movieInfoProvider`/`MovieMapNotifier` (`movie/movie_provider.dart`, `loadMovie(id)`) and `actorInfoProvider`/`CastMapNotifier` (`actors/actors_by_movie_provider.dart`, `getCastByMovie(movieId)`) both follow this pattern; `MovieScreen` calls both in `initState` keyed by `movieId`.
- Search (`search/search_movies_provider.dart`) splits the query text (`searchQueryProvider`/`SearchQueryNotifier`) from the results (`searchedMoviesProvider`/`SearchedMoviesNotifier`); `SearchedMoviesNotifier.searchMoviesByQuery` both fetches and updates the query provider as a side effect. `SearchMovieDelegate` debounces query changes (500ms `Timer`) and streams results/loading state via broadcast `StreamController`s rather than calling `setState`.
- Favorites (`storage/`) split writes from reads: `favoriteMoviesProvider`/`StorageMoviesNotifier` holds the paginated `Map<int, Movie>` of favorites and exposes `toggle(movie)`/`loadNextPage()` (same paginated-map shape as the movie/actor caches above), while `isFavoriteMovieProvider` is a `FutureProvider.family<bool, int>` per movie id used only to drive the heart icon in `MovieScreen`. Toggling a favorite must call `ref.invalidate(isFavoriteMovieProvider(movie.id))` afterwards — the two providers don't otherwise know about each other.
- New providers/screens/widgets should be added to the relevant barrel file (`providers.dart` / `screens.dart` / `widgets.dart` / `views.dart`) so imports elsewhere stay as `import '.../providers/providers.dart'` etc.

### Navigation

`HomeScreen` (`screens/movies/home_screen.dart`) is the `StatefulShellRoute.indexedStack` builder: it wraps whichever tab view is active (`navigationShell`) in a `Scaffold` with `BottomNavigation` as the `bottomNavigationBar`. `BottomNavigation` doesn't index bottom-nav items 1:1 with shell branches — `_branchByItemIndex` maps only the wired-up items (`0` → Home, `2` → Favorites) to `navigationShell.goBranch(branchIndex)`; item `1` ("Categories") has no branch yet. When adding a new tab, add a `StatefulShellBranch` in `router.dart`, a view under `views/tabs/`, and a `_branchByItemIndex` entry together.

### Constructor style

This codebase (Dart 3.13) uses the unnamed-constructor shorthand `new(...)` instead of repeating the class name (e.g. `const new({...})` inside `Movie`, `new(this.datasource)` inside `MovieRepositoryImpl`). This is intentional, not a typo — keep using this style for new unnamed constructors in this project rather than "fixing" it to `ClassName(...)`.
