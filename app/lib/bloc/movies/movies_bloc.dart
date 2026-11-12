import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinospot/data/exceptions/network_exception.dart';
import 'package:kinospot/data/exceptions/server_exception.dart';
import 'package:kinospot/data/repository/kino_spot_repository.dart';

import '../../data/models/movie.dart';
import 'movies_event.dart';
import 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final KinoSpotRepository _repository;

  MoviesBloc(this._repository) : super(MoviesInitial()) {
    on<LoadMovies>(_onLoadMovies);
    on<SearchMovies>(_onSearchMovies);
    on<FilterByGenre>(_onFilterByGenre);
  }

  Future<void> _onLoadMovies(
      LoadMovies event,
      Emitter<MoviesState> emit,
      ) async {
    emit(MoviesLoading());
    try {
      final List<Movie> movies = await _repository.getMovies();
      emit(MoviesLoaded(movies));
    } on ServerException catch (e) {
      emit(MoviesServerError(e.message));
    } on NetworkException catch (e) {
      emit(MoviesNetworkError(e.message));
    } catch (e) {
      emit(MoviesUnknownError(e.toString()));
    }
  }

  void _onSearchMovies(SearchMovies event, Emitter<MoviesState> emit) {
    final currentState = state;
    if (currentState is MoviesLoaded) {
      emit(MoviesLoaded(
        currentState.allMovies,
        searchQuery: event.query,
        selectedGenre: currentState.selectedGenre,
      ));
    }
  }

  void _onFilterByGenre(FilterByGenre event, Emitter<MoviesState> emit) {
    final currentState = state;
    if (currentState is MoviesLoaded) {
      emit(MoviesLoaded(
        currentState.allMovies,
        searchQuery: currentState.searchQuery,
        selectedGenre: event.genreName,
      ));
    }
  }
}