import 'package:kinospot/data/models/session.dart';
import 'package:kinospot/data/models/cinema.dart';
import 'package:kinospot/data/models/session.dart';

sealed class SessionsState {}

class SessionsInitial extends SessionsState {}

class SessionsLoading extends SessionsState {}

class SessionsLoaded extends SessionsState {
  final List<Session> allSessions;
  final DateTime? selectedDate;
  final int? selectedCinemaId;

  SessionsLoaded(
      this.allSessions, {
        this.selectedDate,
        this.selectedCinemaId,
      });

  List<Session> get filteredSessions {
    return allSessions.where((s) {
      final dateOk = selectedDate == null || s.date == selectedDate;
      final cinemaOk =
          selectedCinemaId == null || s.cinema.id == selectedCinemaId;
      return dateOk && cinemaOk;
    }).toList();
  }

  List<DateTime> get availableDates {
    final dates = allSessions.map((s) => s.date).toSet().toList();
    dates.sort();
    return dates;
  }

  List<Cinema> get availableCinemas {
    final byId = <int, Cinema>{};
    for (final s in allSessions) {
      byId[s.cinema.id] = s.cinema;
    }
    return byId.values.toList();
  }
}

class SessionsError extends SessionsState {
  final String message;

  SessionsError(this.message);
}