import 'package:kinospot/data/models/cinema.dart';
import 'package:kinospot/data/models/movie.dart';

class Session {
  final int id;
  final Cinema cinema;
  final Movie movie;
  final DateTime date;
  final String time;
  final String hall;
  final int price;
  
  const Session({
    required this.id,
    required this.cinema,
    required this.movie,
    required this.date,
    required this.time,
    required this.hall,
    required this.price,
});
  
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
        id: json['id'] as int, 
        cinema: Cinema.fromJson(json['cinema'] as Map<String, dynamic>),
        movie: Movie.fromJson(json['movie'] as Map<String, dynamic>),
        date: DateTime.parse(json['date'] as String),
        time: json['time'] as String,
        hall: json['hall'] as String,
        price: json['price'] as int,
    );
  } 
}