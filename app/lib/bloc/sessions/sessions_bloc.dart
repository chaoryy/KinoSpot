import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinospot/data/models/session.dart';
import 'package:kinospot/data/repository/kino_spot_repository.dart';

import '../../data/exceptions/network_exception.dart';
import '../../data/exceptions/server_exception.dart';
import 'sessions_event.dart';
import 'sessions_state.dart';

class SessionsBloc extends Bloc<SessionsEvent, SessionsState> {
  final KinoSpotRepository _repository;

  SessionsBloc(this._repository) : super(SessionsInitial()) {
    on<LoadSessions>(_onLoadSessions);
    on<SelectDate>(_onSelectDate);
    on<SelectCinema>(_onSelectCinema);
  }

  Future<void> _onLoadSessions(
      LoadSessions event,
      Emitter<SessionsState> emit,
      ) async {
    emit(SessionsLoading());
    try {
      final List<Session> sessions = await _repository.getSessionFor(event.movieId);
      emit(SessionsLoaded(sessions));
    } on ServerException catch (e) {
      emit(SessionsError(e.message));
    } on NetworkException catch (e) {
      emit(SessionsError(e.message));
    } catch (e) {
      emit(SessionsError("Неизвестная ошибка: $e"));
    }
  }

  void _onSelectDate(SelectDate event, Emitter<SessionsState> emit) {
    final current = state;
    if (current is SessionsLoaded) {
      emit(SessionsLoaded(
        current.allSessions,
        selectedDate: event.date,
        selectedCinemaId: current.selectedCinemaId,
      ));
    }
  }

  void _onSelectCinema(SelectCinema event, Emitter<SessionsState> emit) {
    final current = state;
    if (current is SessionsLoaded) {
      emit(SessionsLoaded(
        current.allSessions,
        selectedDate: current.selectedDate,
        selectedCinemaId: event.cinemaId,
      ));
    }
  }
}