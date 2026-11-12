import 'package:flutter/material.dart';
import 'package:kinospot/data/api/api_service.dart';
import 'package:kinospot/data/repository/kino_spot_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final apiService = ApiService();
    final repository = KinoSpotRepository(apiService);
    final movies = await repository.getMovies();
    print('Успешно загружено фильмов: ${movies.length}');
    for (var movie in movies) {
      print('- ${movie.name} (${movie.year})');
    }

    final sessions = await repository.getSessionFor(1);
    print('Успешно загружено сеансов: ${movies.length}');
    for (var session in sessions) {
      print('- ${session.movie.name} (${session.time})');
    }
  } catch (e) {
    print('Ошибка при запросе: $e');
  }
}