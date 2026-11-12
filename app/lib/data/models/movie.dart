import 'genre.dart';

class Movie {
  final int id;
  final String name;
  final String description;
  final int year;
  final int duration;
  final String posterLink;
  final List<Genre> genres;
  final double rating;

  const Movie({
    required this.id,
    required this.name,
    required this.description,
    required this.year,
    required this.duration,
    required this.posterLink,
    required this.genres,
    required this.rating
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String,
        year: json['year'] as int,
        duration: json['duration'] as int,
        posterLink: json['posterLink'] as String,
        genres: (json['genres'] as List<dynamic>)
            .map((e) => Genre.fromJson(e as String))
        .toList(),
        rating: (json['rating'] as num).toDouble(),
    );
  }
}