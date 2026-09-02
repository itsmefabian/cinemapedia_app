# Cinemapedia

A Flutter movie-browsing app built on top of [The Movie DB (TMDB)](https://www.themoviedb.org/) API, using Riverpod for state management, go_router for navigation, and Dio for networking.

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
dart analyze     # static analysis
flutter test     # run tests
```

## Architecture

The code under `lib/` follows a layered structure:

- `domain/` — entities and abstract datasource/repository interfaces, no external dependencies.
- `infrastructure/` — concrete implementations: TMDB datasource (Dio), response/model classes, mappers to domain entities, and repository implementations.
- `presentation/` — screens and Riverpod providers, organized per feature.
- `config/` — app-wide setup: router, theme, environment.

Data flows: datasource (TMDB) → mapper → domain entity → repository → Riverpod provider → screen.
