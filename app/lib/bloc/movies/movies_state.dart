import 'package:kinospot/data/models/movie.dart';

sealed class MoviesState {}

class MoviesInitial extends MoviesState {}
class MoviesLoading extends MoviesState {}
class MoviesLoaded extends MoviesState {
  final List<Movie> movies;
  MoviesLoaded(this.movies);
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