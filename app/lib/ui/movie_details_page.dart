import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinospot/bloc/sessions/sessions_bloc.dart';
import 'package:kinospot/bloc/sessions/sessions_event.dart';
import 'package:kinospot/bloc/sessions/sessions_state.dart';
import 'package:kinospot/data/models/cinema.dart';
import 'package:kinospot/data/models/movie.dart';
import 'package:kinospot/data/models/session.dart';
import 'package:kinospot/data/repository/kino_spot_repository.dart';

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SessionsBloc(context.read<KinoSpotRepository>())
            ..add(LoadSessions(movie.id)),
      child: Scaffold(
        appBar: AppBar(title: Text(movie.name)),
        body: BlocBuilder<SessionsBloc, SessionsState>(
          builder: (context, state) {
            return switch (state) {
              SessionsInitial() || SessionsLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              SessionsLoaded loaded => _SessionsContent(state: loaded),
              SessionsError(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<SessionsBloc>().add(
                            LoadSessions(movie.id),
                          );
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Повторить'),
                      ),
                    ],
                  ),
                ),
              ),
            };
          },
        ),
      ),
    );
  }
}

String _formatDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}';

class _SessionsContent extends StatelessWidget {
  final SessionsLoaded state;

  const _SessionsContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SessionsBloc>();
    final filtered = state.filteredSessions;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButton<int?>(
            isExpanded: true,
            value: state.selectedCinemaId,
            items: [
              const DropdownMenuItem<int?>(
                value: null,
                child: Text('Все кинотеатры'),
              ),
              for (final c in state.availableCinemas)
                DropdownMenuItem<int?>(value: c.id, child: Text(c.name)),
            ],
            onChanged: (id) => bloc.add(SelectCinema(id)),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('Все даты'),
                selected: state.selectedDate == null,
                onSelected: (_) => bloc.add(SelectDate(null)),
              ),
              for (final d in state.availableDates) ...[
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text(_formatDate(d)),
                  selected: state.selectedDate == d,
                  onSelected: (_) => bloc.add(SelectDate(d)),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text('Нет сеансов по выбранным фильтрам'))
              : ListView(
                  padding: const EdgeInsets.all(12),
                  children: _buildGroups(filtered),
                ),
        ),
      ],
    );
  }
}

List<Widget> _buildGroups(List<Session> sessions) {
  // id кинотеатра -> (дата -> сеансы)
  final grouped = <int, Map<DateTime, List<Session>>>{};
  final cinemas = <int, Cinema>{};

  for (final s in sessions) {
    cinemas[s.cinema.id] = s.cinema;
    grouped
        .putIfAbsent(s.cinema.id, () => {})
        .putIfAbsent(s.date, () => [])
        .add(s);
  }

  final widgets = <Widget>[];
  for (final entry in grouped.entries) {
    final cinema = cinemas[entry.key]!;
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text(
          cinema.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
    widgets.add(
      Text(cinema.address, style: const TextStyle(color: Colors.grey)),
    );

    final dates = entry.value.keys.toList()..sort();
    for (final date in dates) {
      final list = entry.value[date]!..sort((a, b) => a.time.compareTo(b.time));
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 6),
          child: Text(
            _formatDate(date),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      );
      widgets.add(
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final s in list)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      s.time,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('${s.hall}, ${s.price} сом'),
                  ],
                ),
              ),
          ],
        ),
      );
    }
  }
  return widgets;
}
