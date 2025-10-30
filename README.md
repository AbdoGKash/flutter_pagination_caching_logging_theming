# Flutter Pagination + Caching + Theming (Test Project)

**Project name:** `flutter_pagination_caching_logging_theming` (test)

---

## Overview

This project is a test/demo Flutter application that demonstrates three core concerns often needed in real-world apps:

1. **Pagination** — loading data page-by-page from a backend API and appending results as the user scrolls.  
2. **Caching** — caching remote images and local data to improve performance and offline experience (uses `flutter_cache_manager`, `cached_network_image`, and `sqflite` local storage).  
3. **Theming** — supporting light/dark themes and persisting the selected theme using `shared_preferences`.

The app appears to use The Movie Database (TMDB)-style data (a `movie_response` model was found), loads pages of movies via a network service, caches images and (optionally) movie data locally, and provides a details screen for items. The project is structured using a clean-ish architecture with `core`, `data`, and `presentation` layers, plus a `main.dart` entry.

---

## Features

- Infinite scroll / pagination (fetch next page on scroll end).  
- Network layer using `dio` with `retrofit`-style annotations (retrofit imports found).  
- Repository abstraction (`movices_repo.dart`) with a local data source (`local_data_source.dart`).  
- Image caching via `flutter_cache_manager` + `cached_network_image` for remote images.  
- Local data persistence using `sqflite` (SQLite) for caching app data.  
- Theme switching (light/dark) persisted with `shared_preferences`. Theme helpers are present.  
- Error handling utilities (`api_error_handler.dart`, `api_result.dart`).  
- Dependency injection bootstrap (`injection.dart`) to register services/repositories.  
- Uses `bloc` / `flutter_bloc` for state management — there's a `movies_cubit.dart` (Cubit) handling movie-related state.

---

## Architecture & Folder Map (inferred)

```
lib/
├─ main.dart
├─ core/
│  ├─ helper/
│  │  ├─ api_error_handler.dart
│  │  ├─ api_result.dart
│  │  ├─ injection.dart        # DI / service locator bootstrap
│  │  └─ theme_helper.dart     # Theme packing and persistence helpers
├─ data/
│  ├─ networking/
│  │  └─ api_service.dart      # Dio / Retrofit service
│  ├─ model/
│  │  └─ movie_response.dart   # Response / model classes for movies
│  ├─ local_data/
│  │  └─ local_data_source.dart# SQLite helpers (sqflite)
│  └─ repo/
│     └─ movices_repo.dart     # Repository implementing remote+local strategies
├─ presentation/
│  ├─ cubit/
│  │  └─ movies_cubit.dart    # Cubit handling pagination + state
│  └─ screens/
│     ├─ home_screen.dart     # List / pagination UI
│     └─ details_movies.dart  # Details UI
```


---

## Key Classes & Responsibilities (inferred)

- **`ApiService`** (`data/networking/api_service.dart`): configures `Dio`, defines endpoints (likely `getMovies(page)`), and handles low-level HTTP interactions.
- **`MovicesRepo`** (`data/repo/movices_repo.dart`): repository that coordinates between `ApiService` (remote) and `LocalDataSource` (local cache). Exposes methods like `fetchMovies(page)` returning an `ApiResult` or domain model.
- **`LocalDataSource`** (`data/local_data/local_data_source.dart`): handles SQLite operations via `sqflite` — table creation, inserts, queries for cached movie data.
- **`MoviesCubit`** (`presentation/cubit/movies_cubit.dart`): Bloc/Cubit that manages UI state (loading, loaded, error), current page number, list of loaded items, and pagination triggers (loadMore). Uses repository to fetch pages and decides whether to save data locally.
- **`ThemeHelper`** & **`SharedPreferences`**: responsible for reading/writing the selected theme and exposing utilities to `main.dart` to initialize the app theme.
- **`CachedNetworkImage`** + **`FlutterCacheManager`**: used in item tiles to display poster/backdrop images with offline cache & disk cache control.
- **`api_error_handler.dart`** & **`api_result.dart`**: small wrappers to unify error handling and network result representation across the app.

---

## Pagination Logic (how it likely works)

- `MoviesCubit` keeps track of:
  - `currentPage` (e.g., starting at 1)
  - `isLoadingMore` / `isLoading`
  - `List<Movie> movies` — accumulated list of results

- UI (`HomeScreen`) uses a `ListView.builder` (or `ListView.separated`) with a `ScrollController` or `NotificationListener<ScrollNotification>` to detect when the scroll reaches near the bottom. When detected and `hasMore` is true, it calls `moviesCubit.fetchNextPage()` or similar.

- On fetch: Cubit sets loading states, calls `MovicesRepo.fetchMovies(page)`, appends results to `movies`, updates `currentPage`, updates `hasMore` depending on result size/total pages, and emits new state to the UI. Errors are wrapped using `ApiResult`/`ApiErrorHandler`.

- The code supports both initial load and incremental loads (infinite scroll). Loading indicators and a bottom loader widget are used in the list while `isLoadingMore` is true.

---

## Caching Strategy

- **Image caching**: `CachedNetworkImage` + `flutter_cache_manager` caches images on disk with configurable max age and size. The code uses a custom `CacheManager` in certain files (seen `cacheManager:` in usages).
- **Data caching**: `LocalDataSource` + `sqflite` stores movie items locally (likely to speed up subsequent loads and allow offline access). The repository decides when to read from local cache vs hitting the network (e.g., on startup, or when offline/no-connection).
- **Preferences**: `SharedPreferences` is used to persist the selected theme and possibly simple user preferences (e.g., last fetched page, last query).

---

## Packages used (extracted from imports)

Below are the main external packages found in the code and their roles:

- `flutter_bloc` / `bloc` — state management (Cubit).  
- `dio` — HTTP client.  
- `retrofit` — Retrofit annotations for API interface (works with Dio).  
- `cached_network_image` — image widget with caching capability.  
- `flutter_cache_manager` — controlling image cache rules.  
- `sqflite` — local SQLite database.  
- `shared_preferences` — persistent simple key-value storage.  
- `path_provider` & `path` — file system locations for caches / DB.  
- `bloc` — core bloc utilities.  
- (platform and generated plugins) — `shared_preferences_*`, `path_provider_*`, `sqflite_*` for desktop/web/mobile support.  

If you publish `pubspec.yaml`, ensure these dependencies are present with compatible versions.

---

## How to run (dev)

1. Make sure you have the Flutter SDK installed (compatible with **Dart 2.13** as indicated by the header). Prefer using a recent Flutter stable channel that still supports null-safety or adapt code if necessary.
2. From the project root:
```bash
flutter pub get
# build an APK:
flutter build apk
```

Notes:
- The concatenated file includes generated plugin registrant code for web/desktop — treat the original project as a normal Flutter project created with `flutter create`.
- If any compile errors appear, check SDK constraints in `pubspec.yaml` and update dependencies to null-safe versions if necessary.

---

## Important Files to Review / Edit (suggested mapping)

- `lib/main.dart` — app entry, theme init, DI bootstrap call (`injection.dart`).
- `lib/core/helper/injection.dart` — dependency registrations; adjust lifecycles and mocks for testing.
- `lib/core/helper/theme_helper.dart` — theme constants, ThemeData definitions, and persistence keys.
- `lib/data/networking/api_service.dart` — Dio + Retrofit configuration. Add API key/timeouts/interceptors as needed.
- `lib/data/repo/movices_repo.dart` — repository logic; adjust caching strategy here (when to write/read from SQLite).
- `lib/data/local_data/local_data_source.dart` — DB schema & migrations for `sqflite`.
- `lib/presentation/cubit/movies_cubit.dart` — pagination and state transitions; main place to tweak loadMore behavior.
- `lib/presentation/screens/home_screen.dart` — list UI, scroll detection, and connection to cubit.
- `lib/presentation/screens/details_movies.dart` — details screen UI and navigation arguments.
- `lib/core/helper/api_error_handler.dart` — unify errors (optional: add Sentry / logging integration).

---

