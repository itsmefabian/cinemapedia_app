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

The codebase follows a layered/clean-architecture split under `lib/`:

- **`domain/`** — pure abstractions with no external dependencies: `entities/` (e.g. `Movie`), plus abstract `datasources/` and `repositories/` interfaces. Nothing here talks to TMDB or Dio directly.
- **`infrastructure/`** — concrete implementations of the domain interfaces: `datasources/moviedb_datasource.dart` (Dio calls to `api.themoviedb.org`), `models/moviedb/` (raw JSON-serializable response/model classes), `mappers/` (convert infra models → domain entities, e.g. `MovieMapper.movieDbToEntity`), and `repositories/` (implements the domain repository by delegating to a datasource).
- **`presentation/`** — Flutter UI: `screens/` (one subfolder per feature, e.g. `movies/`, each exporting through a barrel file `screens.dart`) and `providers/` (Riverpod providers, also organized per-feature with a barrel file `providers.dart`).
- **`config/`** — cross-cutting app config: `router/` (go_router route table), `theme/` (`AppTheme`), `const/` (`Environment`).

Data flow for a feature is: `MoviesDatasource` (abstract) → `MoviedbDatasource` (infra, Dio + TMDB) → `MovieMapper` → `Movie` entity → `MoviesRepository` (abstract) → `MovieRepositoryImpl` (infra) → Riverpod provider (`movieRepositoryProvider`) → `Notifier` (e.g. `MoviesNotifier` in `movies_providers.dart`) → screen widget (`ConsumerState`/`ConsumerWidget`).

When adding a new feature (e.g. a new movie list or a details screen), mirror this same chain across all four layers rather than calling Dio or TMDB directly from a widget or provider.

### Riverpod conventions

- Repository providers are plain `Provider`s that construct a repository with a concrete datasource (see `movies_repository_provider.dart`).
- Feature state uses `NotifierProvider` classes (Riverpod 3 `Notifier`, not the older `StateNotifier`) that read a repository method in `build()` and expose feature-specific methods like `loadNextPage()`.
- New providers/screens should be added to the relevant barrel file (`providers.dart` / `screens.dart`) so imports elsewhere stay as `import '.../providers/providers.dart'` / `'.../screens/screens.dart'`.

### Constructor style

This codebase (Dart 3.13) uses the unnamed-constructor shorthand `new(...)` instead of repeating the class name (e.g. `const new({...})` inside `Movie`, `new(this.datasource)` inside `MovieRepositoryImpl`). This is intentional, not a typo — keep using this style for new unnamed constructors in this project rather than "fixing" it to `ClassName(...)`.
