import 'package:bloc/bloc.dart';
import 'package:flutter_pagination_caching_logging_theming/core/helper/api_result.dart';
import 'package:flutter_pagination_caching_logging_theming/data/model/movie_response.dart';
import 'package:flutter_pagination_caching_logging_theming/data/repo/movices_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'movies_state.dart';
part 'movies_cubit.freezed.dart';

class MoviesCubit extends Cubit<MoviesState> {
  final MovicesRepo _movicesRepo;

  MoviesCubit(this._movicesRepo) : super(MoviesState.initial());

  int _currentPage = 1;
  bool _isLoadingMore = false;
  final List<Movie> _allMovies = [];

  Future<void> getAllMovies({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (_isLoadingMore) return;
      _isLoadingMore = true;
    } else {
      emit(MoviesState.loading());
      _currentPage = 1;
      _allMovies.clear();
    }

    final response = await _movicesRepo.getAllMovies(_currentPage);

    response.when(
      success: (moviesResponse) {
        _allMovies.addAll(moviesResponse.results);

        final updatedResponse = MovieResponse(
          page: _currentPage,
          results: List<Movie>.from(_allMovies),
          totalPages: moviesResponse.totalPages,
          totalResults: moviesResponse.totalResults,
        );

        emit(MoviesState.loaded(moviesResponse: updatedResponse));
        _currentPage++;
      },
      failure: (error) {
        emit(
          MoviesState.error(
            message: error.apiErrorModel.statusMessage ?? 'Unknown error',
          ),
        );
      },
    );

    _isLoadingMore = false;
  }
}
