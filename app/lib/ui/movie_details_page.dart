import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinospot/bloc/sessions/sessions_bloc.dart';
import 'package:kinospot/bloc/sessions/sessions_event.dart';
import 'package:kinospot/bloc/sessions/sessions_state.dart';
import 'package:kinospot/data/models/cinema.dart';
import 'package:kinospot/data/models/movie.dart';
import 'package:kinospot/data/models/session.dart';
import 'package:kinospot/data/repository/kino_spot_repository.dart';
import 'package:kinospot/ui/widgets/poster_image.dart';

const _dark = Color(0xFF0B1030);
const _bg = Color(0xFFF5F5F5);

const _weekdays = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];
const _months = [
  'янв', 'фев', 'мар', 'апр', 'мая', 'июн',
  'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'
];

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;
  const MovieDetailsPage({super.key, required this.movie});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  int _tab = 0; // 0 — расписание, 1 — описание

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    return BlocProvider(
      create: (context) =>
      SessionsBloc(context.read<KinoSpotRepository>())
        ..add(LoadSessions(movie.id)),
      child: Scaffold(
        backgroundColor: _bg,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(movie: movie),
              _InfoRow(movie: movie),
              _Tabs(
                index: _tab,
                onChanged: (i) => setState(() => _tab = i),
              ),
              if (_tab == 0)
                BlocBuilder<SessionsBloc, SessionsState>(
                  builder: (context, state) => switch (state) {
                    SessionsInitial() || SessionsLoading() => const Padding(
                      padding: EdgeInsets.all(48),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    SessionsLoaded loaded => _SessionsContent(state: loaded),
                    SessionsError(:final message) => Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline,
                              size: 48, color: Colors.red),
                          const SizedBox(height: 12),
                          Text(message, textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => context
                                .read<SessionsBloc>()
                                .add(LoadSessions(movie.id)),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Повторить'),
                          ),
                        ],
                      ),
                    ),
                  },
                )
              else
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(movie.description,
                      style: const TextStyle(fontSize: 16, height: 1.5)),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Movie movie;
  const _Header({required this.movie});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 280),
      child: Stack(
        children: [
          Positioned.fill(child: PosterImage(url: movie.posterLink)),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black38, Colors.black87],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 72),
                  Text(
                    movie.name.toUpperCase(),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 20),
                      const SizedBox(width: 6),
                      Text('${movie.rating.toStringAsFixed(1)} / 10',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final g in movie.genres)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(g.russianName),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final Movie movie;
  const _InfoRow({required this.movie});

  @override
  Widget build(BuildContext context) {
    final h = movie.duration ~/ 60;
    final m = movie.duration % 60;
    final duration = h > 0 ? '$h ч $m мин' : '$m мин';

    Widget row(String k, String v) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(k,
              style: const TextStyle(fontSize: 13, color: Colors.black54)),
          Text(v,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 100,
              height: 145,
              child: PosterImage(url: movie.posterLink),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                row('Год', '${movie.year}'),
                row('Длительность', duration),
                row('Рейтинг', movie.rating.toStringAsFixed(1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const _Tabs({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget tab(String title, int i) => Expanded(
      child: InkWell(
        onTap: () => onChanged(i),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: index == i ? _dark : Colors.black12,
                width: index == i ? 2 : 1,
              ),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: index == i ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [tab('Расписание', 0), tab('Описание', 1)]),
    );
  }
}

class _SessionsContent extends StatelessWidget {
  final SessionsLoaded state;
  const _SessionsContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SessionsBloc>();
    final filtered = state.filteredSessions;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Даты
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _DateChip(
                  top: 'Все',
                  bottom: 'даты',
                  selected: state.selectedDate == null,
                  onTap: () => bloc.add(SelectDate(null)),
                ),
                for (final d in state.availableDates)
                  _DateChip(
                    top: '${d.day} ${_months[d.month - 1]}',
                    bottom: _weekdays[d.weekday - 1],
                    selected: state.selectedDate == d,
                    onTap: () => bloc.add(SelectDate(d)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Кинотеатр',
              style: TextStyle(fontSize: 14, color: Colors.black54)),
          DropdownButton<int?>(
            isExpanded: true,
            value: state.selectedCinemaId,
            items: [
              const DropdownMenuItem<int?>(
                  value: null, child: Text('Все кинотеатры')),
              for (final c in state.availableCinemas)
                DropdownMenuItem<int?>(value: c.id, child: Text(c.name)),
            ],
            onChanged: (id) => bloc.add(SelectCinema(id)),
          ),
          const SizedBox(height: 8),
          if (filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: Text('Нет сеансов по выбранным фильтрам')),
            )
          else
            ..._buildGroups(filtered),
        ],
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final String top;
  final String bottom;
  final bool selected;
  final VoidCallback onTap;

  const _DateChip({
    required this.top,
    required this.bottom,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fg = selected ? Colors.white : Colors.black87;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 64,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? _dark : Colors.transparent,
            border: Border.all(color: selected ? _dark : Colors.black26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(top, style: TextStyle(fontSize: 13, color: fg)),
              const SizedBox(height: 2),
              Text(bottom,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600, color: fg)),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}';

List<Widget> _buildGroups(List<Session> sessions) {
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
    widgets.add(Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(cinema.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    ));
    widgets.add(
        Text(cinema.address, style: const TextStyle(color: Colors.grey)));

    final dates = entry.value.keys.toList()..sort();
    for (final date in dates) {
      final list = entry.value[date]!..sort((a, b) => a.time.compareTo(b.time));
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        child: Text(_formatDate(date),
            style: const TextStyle(fontWeight: FontWeight.w600)),
      ));
      widgets.add(Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final s in list)
            Container(
              width: 150,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: _dark),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    s.time,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${s.hall}\n${s.price} сом',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],

              ),
            ),
        ],
      ));
    }
  }
  return widgets;
}