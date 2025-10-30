import 'package:flutter_pagination_caching_logging_theming/core/helper/api_error_handler.dart';
import 'package:flutter_pagination_caching_logging_theming/core/helper/api_result.dart';
import 'package:flutter_pagination_caching_logging_theming/data/local_data/local_data_source.dart';
import 'package:flutter_pagination_caching_logging_theming/data/model/movie_response.dart';
import 'package:flutter_pagination_caching_logging_theming/data/networking/api_service.dart';

class MovicesRepo {
  final ApiService _apiService;
  final LocalDataSource _localDataSource;

  MovicesRepo(this._apiService, this._localDataSource);
  Future<ApiResult<MovieResponse>> getAllMovies(int pageNumber) async {
    try {
      final response = await _apiService.getPopularMovies(page: pageNumber);
      await _localDataSource.cacheMovies(pageNumber, response.results);
      return ApiResult.success(response);
    } catch (error) {
      final cachedMovies = await _localDataSource.getCachedMovies(pageNumber);
      if (cachedMovies.isNotEmpty) {
        final cachedResponse = MovieResponse(
          page: pageNumber,
          results: cachedMovies,
          totalPages: 1,
          totalResults: cachedMovies.length,
        );
        return ApiResult.success(cachedResponse);
      }

      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  // Future<ApiResult<MovieResponse>> getAllMovies(int pageNumber) async {
  //   try {
  //     final response = await _apiService.getPopularMovies(page: pageNumber);
  //     await _localDataSource.cacheMovies(response.results);

  //     return ApiResult.success(response);
  //   } catch (error) {
  //     final cachedMovies = await _localDataSource.getCachedMovies();
  //     if (cachedMovies.isNotEmpty) {
  //       final cachedResponse = MovieResponse(
  //         page: 1,
  //         results: cachedMovies,
  //         totalPages: 1,
  //         totalResults: cachedMovies.length,
  //       );
  //       return ApiResult.success(cachedResponse);
  //     }

  //     return ApiResult.failure(ErrorHandler.handle(error));
  //   }
  // }
}
