import 'package:kinospot/data/api/api_service.dart';
import 'package:kinospot/data/exceptions/network_exception.dart';
import 'package:kinospot/data/exceptions/server_exception.dart';
import 'package:kinospot/data/models/movie.dart';
import 'package:kinospot/data/models/session.dart';

class KinoSpotRepository {
  final ApiService _apiService;

  KinoSpotRepository(this._apiService);

  Future<List<Movie>> getMovies() async {
    try {
      return await _apiService.getMovies();
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
  
  Future<List<Session>> getSessionFor(int movieId) async {
    try {
      return await _apiService.getSessionFor(movieId);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}