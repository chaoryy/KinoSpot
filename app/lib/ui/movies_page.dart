import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinospot/bloc/movies/movies_bloc.dart';
import 'package:kinospot/bloc/movies/movies_event.dart';
import 'package:kinospot/bloc/movies/movies_state.dart';
import 'package:kinospot/data/models/movie.dart';
import 'package:kinospot/ui/movie_details_page.dart';
import 'package:kinospot/ui/widgets/poster_image.dart';

const kAccent = Color(0xFFE4E0FF);
const kBg = Color(0xFFF5F5F5);
const kDark = Color(0xFF0B1030);

class MoviesPage extends StatelessWidget {
  const MoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          switch (state) {
            case MoviesInitial() || MoviesLoading():
              return const Center(child: CircularProgressIndicator());
            case MoviesLoaded():
              return _MoviesContent(state: state);
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
                      onPressed: () =>
                          context.read<MoviesBloc>().add(LoadMovies()),
                      child: const Text('Повторить'),
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

class _MoviesContent extends StatelessWidget {
  final MoviesLoaded state;

  const _MoviesContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final movies = state.filteredMovies;
    final genres = state.availableGenres;
    final isFiltering = state.searchQuery.isNotEmpty || state.selectedGenre != null;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                    children: [
                      const TextSpan(
                        text: 'КИНО',
                        style: TextStyle(color: Colors.black87),
                      ),
                      TextSpan(
                        text: 'SPOT',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: TextField(
              controller: TextEditingController(text: state.searchQuery)
                ..selection = TextSelection.collapsed(offset: state.searchQuery.length),
              onChanged: (query) {
                context.read<MoviesBloc>().add(SearchMovies(query));
              },
              decoration: InputDecoration(
                hintText: 'Поиск фильма...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: const Text('Все'),
                    selected: state.selectedGenre == null,
                    onSelected: (_) {
                      context.read<MoviesBloc>().add(FilterByGenre(null));
                    },
                  ),
                ),
                for (final genre in genres)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(genre),
                      selected: state.selectedGenre == genre,
                      onSelected: (_) {
                        context.read<MoviesBloc>().add(FilterByGenre(genre));
                      },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: movies.isEmpty
                ? const Center(
              child: Text('Фильмы не найдены',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
            )
                : isFiltering
                ? ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: movies.length,
              itemBuilder: (context, i) {
                final m = movies[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 50,
                        height: 75,
                        child: PosterImage(url: m.posterLink),
                      ),
                    ),
                    title: Text(
                      m.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.orange, size: 16),
                            const SizedBox(width: 4),
                            Text(m.rating.toStringAsFixed(1)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          m.genres.map((g) => g.russianName).join(' · '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MovieDetailsPage(movie: m),
                      ),
                    ),
                  ),
                );
              },
            )
                : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 8, 24, 12),
                    child: Text(
                      'Сейчас в кино',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ),
                  _HomeCarousel(movies: movies),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeCarousel extends StatefulWidget {
  final List<Movie> movies;

  const _HomeCarousel({required this.movies});

  @override
  State<_HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<_HomeCarousel> {
  final _controller = PageController(viewportFraction: 0.55);
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movies = widget.movies;
    if (_index >= movies.length) _index = 0;
    final current = movies[_index];

    return Column(
      children: [
        Container(
          height: 400,
          decoration: const BoxDecoration(
            color: kAccent,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(48),
            ),
          ),
          child: PageView.builder(
            controller: _controller,
            itemCount: movies.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) {
              final m = movies[i];
              final selected = i == _index;

              return AnimatedScale(
                scale: selected ? 1 : 0.85,
                duration: const Duration(milliseconds: 250),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 24,
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MovieDetailsPage(movie: m),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: PosterImage(url: m.posterLink),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  current.name.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 22),
                    const SizedBox(width: 6),
                    Text(
                      current.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  current.genres.map((g) => g.russianName).join(' · '),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}