sealed class MoviesEvent {}

class LoadMovies extends MoviesEvent {}

class SearchMovies extends MoviesEvent {
  final String query;
  SearchMovies(this.query);
}

class FilterByGenre extends MoviesEvent {
  final String? genreName;
  FilterByGenre(this.genreName);
}