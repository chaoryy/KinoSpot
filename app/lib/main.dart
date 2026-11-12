import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinospot/bloc/movies/movies_bloc.dart';
import 'package:kinospot/bloc/movies/movies_event.dart';
import 'package:kinospot/data/api/api_service.dart';
import 'package:kinospot/data/repository/kino_spot_repository.dart';
import 'package:kinospot/ui/movies_page.dart';

void main() {
  final repository = KinoSpotRepository(ApiService());
  runApp(KinoSpotApp(repository: repository));
}

class KinoSpotApp extends StatelessWidget {
  final KinoSpotRepository repository;

  const KinoSpotApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repository,
      child: MaterialApp(
        title: 'КиноSpot',
        home: BlocProvider(
          create: (_) => MoviesBloc(repository)..add(LoadMovies()),
          child: const MoviesPage(),
        ),
      ),
    );
  }
}