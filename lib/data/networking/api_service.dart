import 'package:dio/dio.dart';
import 'package:flutter_pagination_caching_logging_theming/data/model/movie_response.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://api.themoviedb.org/3")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("/movie/popular")
  Future<MovieResponse> getPopularMovies({
    @Query("language") String language = "en-US",
    @Query("page") required int page,
  });
}
