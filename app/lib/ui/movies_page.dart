import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinospot/bloc/movies/movies_bloc.dart';
import 'package:kinospot/bloc/movies/movies_event.dart';
import 'package:kinospot/bloc/movies/movies_state.dart';
import 'package:kinospot/ui/movie_details_page.dart';

class MoviesPage extends StatelessWidget {
  const MoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('КИНОSPOT')),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          switch (state) {
            case MoviesInitial() || MoviesLoading():
              return const Center(child: CircularProgressIndicator());
            case MoviesLoaded(:final movies):
              return ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  final genresString = movie.genres
                      .map((genre) => genre.russianName)
                      .join(', ');
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailsPage(movie: movie),
                          ),
                        );
                      },
                      title: Text(movie.name),
                      subtitle: Text(
                        "Год: ${movie.year} \nЖанры: $genresString",
                      ),
                    ),
                  );
                },
              );

            case MoviesNetworkError(message: final msg):
            case MoviesServerError(message: final msg):
            case MoviesUnknownError(message: final msg):
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(msg),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MoviesBloc>().add(LoadMovies());
                      },
                      child: const Text("Повторить"),
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
