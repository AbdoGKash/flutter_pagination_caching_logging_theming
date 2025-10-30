part of 'movies_cubit.dart';

@freezed
class MoviesState with _$MoviesState {
  const factory MoviesState.initial() = _Initial;
  const factory MoviesState.loading() = _Loading;
  const factory MoviesState.loaded({required MovieResponse moviesResponse}) =
      _Loaded;
  const factory MoviesState.error({required String message}) = _Error;
}
