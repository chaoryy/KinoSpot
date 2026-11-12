import 'package:kinospot/data/models/movie.dart';

sealed class MoviesState {}

class MoviesInitial extends MoviesState {}
class MoviesLoading extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final List<Movie> allMovies;
  final String searchQuery;
  final String? selectedGenre;

  MoviesLoaded(
      this.allMovies, {
        this.searchQuery = '',
        this.selectedGenre,
      });

  List<Movie> get filteredMovies {
    return allMovies.where((movie) {
      final matchesQuery = searchQuery.isEmpty ||
          movie.name.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesGenre = selectedGenre == null ||
          movie.genres.any((g) => g.russianName == selectedGenre);

      return matchesQuery && matchesGenre;
    }).toList();
  }

  List<String> get availableGenres {
    final genres = <String>{};
    for (var movie in allMovies) {
      for (var genre in movie.genres) {
        genres.add(genre.russianName);
      }
    }
    return genres.toList();
  }
}

class MoviesNetworkError extends MoviesState {
  final String message;
  MoviesNetworkError(this.message);
}

class MoviesServerError extends MoviesState {
  final String message;
  MoviesServerError(this.message);
}

class MoviesUnknownError extends MoviesState {
  final String message;
  MoviesUnknownError(this.message);
}