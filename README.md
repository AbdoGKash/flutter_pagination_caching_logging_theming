# Flutter Pagination + Caching + Theming (Test Project)

### Overview  
This Flutter project is a demo application designed to experiment with three essential features often used in production-grade apps:  
- **Pagination** — Loading and displaying data page-by-page from an API or local source as the user scrolls.  
- **Caching** — Storing fetched data and remote images locally to improve performance and enable offline access.  
- **Theming** — Applying dynamic themes (light/dark/custom) to enhance UI consistency and user experience.

The goal of this project is to provide a simple and practical reference for developers learning how to implement these functionalities in a structured Flutter codebase.

---

### Features  
- 📜 **Pagination:** Smooth infinite scrolling with automatic page loading.  
- 💾 **Caching:** Uses `flutter_cache_manager` and `cached_network_image` for efficient image and data caching.  
- 🎨 **Dynamic Theming:** Toggle between light and dark modes with theme persistence.  
- ⚙️ **Clean Architecture:** Well-organized and modular Dart code for easy scalability and maintenance.  
- 🚀 **Hot Reload Friendly:** Fully compatible with Flutter’s development workflow.

---

### Technologies Used  
**Flutter** (latest stable version)
* **State Management :** [Bloc](https://pub.dev/packages/bloc) | [Flutter Bloc](https://pub.dev/packages/flutter_bloc)
* **Api Integration :** [Dio](https://pub.dev/packages/dio) | [Retrofit](https://pub.dev/packages/retrofit) | [Retrofit Generator](https://pub.dev/packages/retrofit_generator)| [pretty_dio_logger](https://pub.dev/packages/pretty_dio_logger)<br>
* **Code Generation and Serialization :** [json_annotation](https://pub.dev/packages/json_annotation) | [json_serializable](https://pub.dev/packages/json_serializable) | [freezed](https://pub.dev/packages/freezed) | [freezed_annotation](https://pub.dev/packages/freezed_annotation) | [build_runner](https://pub.dev/packages/build_runner)<br>
* **dependency injection :** [get_it](https://pub.dev/packages/get_it)<br>
**cached_network_image** for image caching  
**flutter_cache_manager** for data caching  
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



