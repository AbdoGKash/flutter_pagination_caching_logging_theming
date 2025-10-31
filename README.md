# Flutter Pagination + Caching + Theming + Error Logging (Test Project)

### Overview  
This Flutter project is a demo application designed to experiment with three essential features often used in production-grade apps:  
- **Pagination** — Loading and displaying data page-by-page from an API or local source as the user scrolls.  
- **Caching** — Storing fetched data and remote images locally to improve performance and enable offline access.  
- **Theming** — Applying dynamic themes (light/dark/custom) to enhance UI consistency and user experience.
- **Error Logging**  — Capturing and reporting runtime errors and crashes in real-time using Firebase Crashlytics for better debugging and app stability monitoring.
  
>The goal of this project is to provide a simple and practical reference for developers learning how to implement these functionalities in a structured Flutter codebase.

---

### Features  
- 📜 **Pagination:** Efficiently loads data page-by-page from the backend using an API, triggering the fetch of the next page automatically upon reaching the list's end (Scroll-Based Loading).  
- 💾 **Caching:** Utilizes flutter_cache_manager and cached_network_image for efficient image and data caching, alongside SQLite for structured local database management and Shared Preferences for simple key-value storage.  
- 🎨 **Dynamic Theming:** Toggle between light and dark modes with theme persistence.  
- 🐞 **Error Logging:** Integrated Firebase Crashlytics to automatically log uncaught exceptions, errors, and crashes — providing real-time insights for debugging and improving app reliability.

---

### Technologies Used  
**Flutter** (latest stable version)
* **State Management :** [Bloc](https://pub.dev/packages/bloc) | [Flutter Bloc](https://pub.dev/packages/flutter_bloc)
* **Api Integration :** [Dio](https://pub.dev/packages/dio) | [Retrofit](https://pub.dev/packages/retrofit) | [Retrofit Generator](https://pub.dev/packages/retrofit_generator)| [pretty_dio_logger](https://pub.dev/packages/pretty_dio_logger)<br>
* **Code Generation and Serialization :** [json_annotation](https://pub.dev/packages/json_annotation) | [json_serializable](https://pub.dev/packages/json_serializable) | [freezed](https://pub.dev/packages/freezed) | [freezed_annotation](https://pub.dev/packages/freezed_annotation) | [build_runner](https://pub.dev/packages/build_runner)<br>
* **dependency injection :** [get_it](https://pub.dev/packages/get_it)<br>
* **Caching :** [shared_preferences](https://pub.dev/packages/shared_preferences) | [sqflite](https://pub.dev/packages/sqflite) | [cached_network_image](https://pub.dev/packages/cached_network_image) | [flutter_cache_manager](https://pub.dev/packages/flutter_cache_manager)<br>
* **Error Logging:** [firebase_core](https://pub.dev/packages/firebase_core) | [firebase_crashlytics](https://pub.dev/packages/firebase_crashlytics)<br>

---


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



