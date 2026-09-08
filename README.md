# Cinemapedia

A Flutter movie-browsing app built on top of [The Movie DB (TMDB)](https://www.themoviedb.org/) API, using Riverpod for state management, go_router for navigation, Dio for networking, and a local Drift (SQLite) database for favorites. The app has a bottom-navigation shell with a Home tab (a slideshow plus horizontally scrolling, paginated lists for now-playing, popular, upcoming, and top-rated movies) and a Favorites tab (a masonry grid of movies saved locally). Tapping a movie opens a details screen with its cast and a favorite toggle, and the search icon opens a debounced movie search.

## Getting started

1. Install dependencies:

   ```
   flutter pub get
   ```

2. Create a `.env` file in the project root with a TMDB API key:

   ```
   API_KEY=<your_tmdb_api_key>
   ```

3. Run the app:

   ```
   flutter run
   ```

## Useful commands

```
dart analyze                                                # static analysis
flutter test                                                # run tests
dart run build_runner build --delete-conflicting-outputs    # regenerate the local database code after editing database.dart
```

## Architecture

The code under `lib/` follows a layered structure, with parallel movies, actors, and local-storage (favorites) domains plus a search feature:

- `domain/` — entities and abstract datasource/repository interfaces, no external dependencies.
- `infrastructure/` — concrete implementations: TMDB datasources (Dio), a Drift datasource for favorites, response/model classes, mappers to domain entities, and repository implementations.
- `presentation/` — screens (including the bottom-nav shell), per-tab views, reusable widgets, a search delegate, and Riverpod providers, organized per feature.
- `config/` — app-wide setup: router, theme, environment, static asset paths, small helpers (e.g. number formatting), and the Drift database schema.

Data flows: datasource (TMDB) → mapper → domain entity → repository → Riverpod provider → screen.
