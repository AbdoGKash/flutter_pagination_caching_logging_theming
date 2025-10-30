import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagination_caching_logging_theming/core/helper/injection.dart';
import 'package:flutter_pagination_caching_logging_theming/presentation/cubit/theme/theme_cubit.dart';
import 'package:flutter_pagination_caching_logging_theming/presentation/cubit/theme/theme_state.dart';
import 'package:flutter_pagination_caching_logging_theming/presentation/cubit/movies_cubit.dart';
import 'package:flutter_pagination_caching_logging_theming/presentation/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initGetIt();
  runApp(const MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<MoviesCubit>()..getAllMovies()),
        BlocProvider(create: (_) => getIt<ThemeCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.indigo,
              scaffoldBackgroundColor: Colors.white,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.indigo,
              scaffoldBackgroundColor: Colors.black,
            ),
            themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
