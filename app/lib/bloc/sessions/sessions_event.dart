sealed class SessionsEvent {}

class LoadSessions extends SessionsEvent {
  final int movieId;

  LoadSessions(this.movieId);
}
class SelectDate extends SessionsEvent {
  final DateTime? date; // null = «все даты»

  SelectDate(this.date);
}

class SelectCinema extends SessionsEvent {
  final int? cinemaId; // null = «все кинотеатры»

  SelectCinema(this.cinemaId);
}

