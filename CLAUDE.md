# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Cinemapedia is a Flutter movie-browsing app that consumes The Movie DB (TMDB) API. State is managed with Riverpod, navigation with go_router, and networking with Dio.

## Commands

```
flutter pub get              # install dependencies
flutter run                  # run the app (device/emulator required; also supports -d windows)
dart analyze                 # static analysis (uses analysis_options.yaml / flutter_lints)
flutter test                 # run tests
dart run build_runner build --delete-conflicting-outputs   # regenerate lib/config/database/database.g.dart after editing database.dart
```

`test/widget_test.dart` is still the default `flutter create` counter-app smoke test — it doesn't exercise this app (`MainApp` has no counter/`+` button) and will fail if run as-is. Replace or delete it rather than treating it as coverage.

## Environment setup

The app reads a TMDB API key from a `.env` file at the project root (loaded via `flutter_dotenv` in `main.dart` and declared as a flutter asset in `pubspec.yaml`):

```
API_KEY=<tmdb_api_key>
```

`Environment.apiKey` (`lib/config/const/environment.dart`) exposes this at runtime and is consumed directly in `MoviedbDatasource`'s Dio `BaseOptions`.

## Architecture

The codebase follows a layered/clean-architecture split under `lib/`, with five parallel domains — **movies**, **actors**, **videos** (trailers), **reviews**, and **local storage** (favorites + settings) — plus **search** and **similar movies** features built on top of the movies domain:

- **`domain/`** — pure abstractions with no external dependencies: `entities/` (`Movie`, `Actor`, `Video`, `Review`), plus abstract `datasources/` and `repositories/` interfaces per domain — `MoviesDatasource`/`MoviesRepository` (`getNowPlaying`, `getPopular`, `getUpComing`, `getTopRated`, `getMovie` for details, `searchMovie`, `getSimilarMovies`), `ActorsDatasource`/`ActorsRepository` (`getActorsByMovie`), `VideosDatasource`/`VideosRepository` (`getVideosByMovie`), `ReviewsDatasource`/`ReviewsRepository` (`getReviewsByMovie`), and `LocalStorageDatasource`/`LocalStorageRepository` (`toggleFavoriteMovie`, `isFavoriteMovie`, `getFavoriteMovies`, plus `getDarkModePreference`/`setDarkModePreference` for the dark-mode setting). Nothing here talks to TMDB, Dio, or Drift directly.
- **`infrastructure/`** — concrete implementations of the domain interfaces: `datasources/moviedb_datasource.dart` (Dio calls to `api.themoviedb.org`, one method per TMDB list endpoint sharing a private `_jsonToMovies` helper, plus `getMovie` for `/movie/{id}`, `searchMovie` for `/search/movie`, and `getSimilarMovies` for `/movie/{id}/similar`), `datasources/actors_moviedb_datasource.dart` (`/movie/{id}/credits`), `datasources/videos_moviedb_datasource.dart` (`/movie/{id}/videos`), `datasources/reviews_moviedb_datasource.dart` (`/movie/{id}/reviews`), and `datasources/drift_datasource.dart` (`DriftDatasource`, queries the local `AppDatabase` — both the favorites table and the app-settings table), `models/moviedb/` (raw JSON-serializable response/model classes, e.g. `MovieMovieDB`/`MovieDbResponse` for list endpoints, `MovieDetails` for the details endpoint, `CreditsResponse` for cast, `VideosResponse` for trailers, `ReviewsResponse` for reviews), `mappers/` (convert infra models → domain entities — `MovieMapper.movieDbToEntity`/`movieDetailsToEntity`, `ActorMapper`, `VideoMapper`, `ReviewMapper`; the favorites path builds a `Movie` by hand from a `FavoritesMovies` row instead, since drift rows aren't a moviedb model), and `repositories/` (implement the domain repositories by delegating to a datasource).
- **`presentation/`** — Flutter UI: `screens/` (top-level screens pushed by the router — `HomeScreen`, the bottom-nav shell itself, and `MovieScreen`, a full-screen route — exported through a barrel file `screens.dart`), `views/` (the per-tab bodies rendered inside the shell, under `tabs/` — `HomeView`, `PopularView`, `FavoritesView`, `SettingsView` — exported via `views.dart`), `widgets/` (reusable UI split into `shared/` app-wide widgets like `CinemaAppBar`/`BottomNavigation`/`FullScreenLoader`/`MoviesMasonry`, per-feature widgets like `movies/slide_show.dart`/`horizontal_listview.dart`, and `video/trailer_from_movie.dart` (`TrailerFromMovie`, wraps `youtube_player_flutter`), exported via `widgets.dart`), `delegates/` (`SearchMovieDelegate`, a `SearchDelegate` used with Flutter's `showSearch`), and `providers/` (Riverpod providers, organized per-feature — `movies/`, `movie/`, `actors/`, `videos/`, `reviews/`, `search/`, `storage/` — barrel-exported via `providers.dart`).
- **`config/`** — cross-cutting app config: `router/` (go_router route table — a `StatefulShellRoute.indexedStack` with one branch per bottom-nav tab (`/` → `HomeView`, `/popular` → `PopularView`, `/favorites` → `FavoritesView`, `/settings` → `SettingsView`), plus a nested `movie/:id` route pushed on top of the `/` branch to `MovieScreen`), `theme/` (`AppTheme` — `getTheme()`/`getDarkTheme()`, both share `colorSchemeSeed`), `const/` (`Environment` for the TMDB API key, `Assets` for static asset paths — the "no image"/"no profile" PNG placeholders under `assets/images/`, rendered with `Image.asset`), `helpers/` (small stateless utilities, e.g. `Formats.number` for compact number formatting via `intl`), `database/` (`database.dart` — the drift `AppDatabase` with the `FavoritesMovies` and `AppSettings` (`@DataClassName('AppSettingsData')`, dark-mode flag) tables, `schemaVersion` currently `2` with a `MigrationStrategy` that adds `AppSettings` when upgrading from `1` — plus the generated `database.g.dart`, produced by `build_runner`/`drift_dev`; never hand-edit `database.g.dart`; bump `schemaVersion` and extend `migration` together whenever the schema changes).

Data flow for a feature is: `XDatasource` (abstract) → `XMoviedbDatasource` (infra, Dio + TMDB) → mapper → domain entity → `XRepository` (abstract) → `XRepositoryImpl` (infra) → Riverpod provider (`xRepositoryProvider`) → `Notifier` → screen widget (`ConsumerState`/`ConsumerWidget`).

When adding a new feature, mirror this same chain across all four layers rather than calling Dio or TMDB directly from a widget or provider.

### Riverpod conventions

- Repository providers are plain `Provider`s that construct a repository with a concrete datasource (see `movies_repository_provider.dart`, `actors_repository_provider.dart`).
- List state uses `NotifierProvider` classes (Riverpod 3 `Notifier`, not the older `StateNotifier`). `MoviesNotifier` (`movies_providers.dart`) is generic over which repository method it calls: it takes a `MovieFetcherSelector` (`MoviesRepository -> MovieCallBack`) in its constructor, so each movie-list provider (`nowPlayingMoviesProvider`, `popularMoviesProvider`, `upcomingMoviesProvider`, `topRatedMoviesProvider`) is just a different selector passed to the same notifier class. It also guards `loadNextPage()` with an `isLoading` flag to avoid concurrent duplicate fetches.
- Derived state is composed with plain `Provider`s that `ref.watch` other providers rather than duplicating fetch logic — e.g. `moviesSlideShowProvider` slices the now-playing list, and `firstLoadingProvider` is `true` until all four movie-list providers have loaded at least once (used to gate the UI behind `FullScreenLoader`).
- Single-item lookups keyed by id use a `Map<String, T>` `Notifier` whose method is a no-op once that id is cached — `movieInfoProvider`/`MovieMapNotifier` (`movie/movie_provider.dart`, `loadMovie(id)`), `actorInfoProvider`/`CastMapNotifier` (`actors/actors_by_movie_provider.dart`, `getCastByMovie(movieId)`), `videoInfoProvider`/`VideoMapNotifier` (`videos/videos_by_movie_provider.dart`, `loadVideosByMovie(movieId)`), `reviewInfoProvider`/`ReviewMapNotifier` (`reviews/reviews_by_movie_provider.dart`, `loadReviewsByMovie(movieId)`), and `similarMoviesProvider`/`SimilarMoviesMapNotifier` (`movies/similar_movies_provider.dart`, `loadSimilarMovies(movieId)`) all follow this pattern; `MovieScreen` calls all five in `initState` keyed by `movieId`.
- Search (`search/search_movies_provider.dart`) splits the query text (`searchQueryProvider`/`SearchQueryNotifier`) from the results (`searchedMoviesProvider`/`SearchedMoviesNotifier`); `SearchedMoviesNotifier.searchMoviesByQuery` both fetches and updates the query provider as a side effect. `SearchMovieDelegate` debounces query changes (500ms `Timer`) and streams results/loading state via broadcast `StreamController`s rather than calling `setState`.
- Favorites (`storage/`) split writes from reads: `favoriteMoviesProvider`/`StorageMoviesNotifier` holds the paginated `Map<int, Movie>` of favorites and exposes `toggle(movie)`/`loadNextPage()` (same paginated-map shape as the movie/actor caches above), while `isFavoriteMovieProvider` is a `FutureProvider.family<bool, int>` per movie id used only to drive the heart icon in `MovieScreen`. Toggling a favorite must call `ref.invalidate(isFavoriteMovieProvider(movie.id))` afterwards — the two providers don't otherwise know about each other.
- Theming (`storage/theme_mode_provider.dart`): `themeModeProvider`/`ThemeModeNotifier` defaults to `ThemeMode.system`, then `loadThemeMode()` overrides it from the persisted dark-mode flag (via `LocalStorageRepository.getDarkModePreference()`, `null` means "no preference set yet, leave it as system"). `MainApp` (`main.dart`) is a `ConsumerStatefulWidget` that calls `loadThemeMode()` once in `initState` and watches `themeModeProvider` to feed `MaterialApp.router`'s `themeMode`; `SettingsView`'s dark-mode switch calls `setDarkMode(bool)`, which persists via `setDarkModePreference` and updates `state` directly (no separate reload needed).
- New providers/screens/widgets should be added to the relevant barrel file (`providers.dart` / `screens.dart` / `widgets.dart` / `views.dart`) so imports elsewhere stay as `import '.../providers/providers.dart'` etc.

### Navigation

`HomeScreen` (`screens/movies/home_screen.dart`) is the `StatefulShellRoute.indexedStack` builder: it wraps whichever tab view is active (`navigationShell`) in a `Scaffold` with `BottomNavigation` as the `bottomNavigationBar`. It also wraps that `Scaffold` in a `PopScope` that only lets the system back gesture pop the app when already on branch `0` (Home) — from any other branch, back navigates to Home (`navigationShell.goBranch(0)`) instead of exiting. There are four branches/tabs, all wired 1:1 via `BottomNavigation`'s `_branchByItemIndex` (`0` → Home `/`, `1` → Popular `/popular`, `2` → Favorites `/favorites`, `3` → Settings `/settings`) to `navigationShell.goBranch(branchIndex)`. When adding a new tab, add a `StatefulShellBranch` in `router.dart`, a view under `views/tabs/`, and a `_branchByItemIndex` entry (plus a `BottomNavigationBarItem`) together.

### Constructor style

This codebase (Dart 3.13) uses the unnamed-constructor shorthand `new(...)` instead of repeating the class name (e.g. `const new({...})` inside `Movie`, `new(this.datasource)` inside `MovieRepositoryImpl`). This is intentional, not a typo — keep using this style for new unnamed constructors in this project rather than "fixing" it to `ClassName(...)`.
