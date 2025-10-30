import 'package:dio/dio.dart';
import 'package:flutter_pagination_caching_logging_theming/core/helper/theme_helper.dart';
import 'package:flutter_pagination_caching_logging_theming/data/local_data/local_data_source.dart';
import 'package:flutter_pagination_caching_logging_theming/data/networking/api_service.dart';
import 'package:flutter_pagination_caching_logging_theming/data/repo/movices_repo.dart';
import 'package:flutter_pagination_caching_logging_theming/presentation/cubit/theme/theme_cubit.dart';
import 'package:flutter_pagination_caching_logging_theming/presentation/cubit/movies_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> initGetIt() async {
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(createAndSetupDio()),
  );
  // ✅ LocalDataSource
  getIt.registerLazySingleton<LocalDataSource>(() => LocalDataSource());

  // ✅ MovicesRepo يحتاج ApiService و LocalDataSource
  getIt.registerLazySingleton<MovicesRepo>(
    () => MovicesRepo(getIt<ApiService>(), getIt<LocalDataSource>()),
  );
  getIt.registerFactory<MoviesCubit>(() => MoviesCubit(getIt()));
  final prefs = await SharedPreferences.getInstance();
  final themeStorage = ThemeStorage(prefs);
  getIt.registerLazySingleton<ThemeStorage>(() => themeStorage);

  // ✅ تسجيل ThemeCubit
  getIt.registerFactory<ThemeCubit>(() => ThemeCubit(getIt<ThemeStorage>()));
}

Dio createAndSetupDio() {
  Dio dio = Dio();
  dio
    ..options.connectTimeout = const Duration(seconds: 10)
    ..options.receiveTimeout = const Duration(seconds: 20);
  dio.options.headers = {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlMjkwY2ViMjkzNWQwYjkxZDc0YmNjZTcyYTliNGU0OCIsIm5iZiI6MTc2MTczODg3Ni4wNTUsInN1YiI6IjY5MDIwMDdjZDdhN2Y0OWJiNDQyYzMyNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.cQ8xqKZDw2iLaAQ0xzfehdNyDE34_3wjeR13o4WUYbc',
    'accept': 'application/json',
  };
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      error: true,
      requestHeader: true,
      responseHeader: true,
      request: true,
      responseBody: true,
    ),
  );
  return dio;
}
