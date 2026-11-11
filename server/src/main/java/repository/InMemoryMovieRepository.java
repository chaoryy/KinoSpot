package repository;

import enums.Genres;
import models.Cinema;
import models.Movie;
import models.Session;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class InMemoryMovieRepository implements MovieRepository{
    private List<Movie> movies = new ArrayList<>();
    private List<Session> sessions = new ArrayList<>();
    private List<Cinema> cinemas = new ArrayList<>();

    public InMemoryMovieRepository() {
        Cinema c1 = new Cinema(1, "Asia Mall (Cinema Park)", "Чынгыза Айтматова, 3");
        Cinema c2 = new Cinema(2, "Bishkek Park", "Киевская, 148");
        cinemas.add(c1);
        cinemas.add(c2);

        Movie m1 = new Movie(
                1,
                "Интерстеллар",
                "Фантастическая драма о путешествии сквозь червоточину в поисках нового дома для человечества.",
                2014,
                169,
                "https://example.com/interstellar.jpg",
                List.of(Genres.SCIFI, Genres.DRAMA),
                8.6
        );

        Movie m2 = new Movie(
                2,
                "Дюна: Часть вторая",
                "Пол Атридес объединяется с фремененами, чтобы отомстить заговорщикам.",
                2024,
                166,
                "https://example.com/dune2.jpg",
                List.of(Genres.ACTION, Genres.SCIFI, Genres.ADVENTURE),
                8.3
        );
        movies.add(m1);
        movies.add(m2);

        LocalDate today = LocalDate.now();
        LocalDate tomorrow = LocalDate.now().plusDays(1);

        sessions.add(new Session(1, c1, m1, today, LocalTime.of(14, 30), "Зал 1 (IMAX)", 450));
        sessions.add(new Session(2, c1, m1, today, LocalTime.of(18, 0), "Зал 1 (IMAX)", 550));
        sessions.add(new Session(3, c2, m2, today, LocalTime.of(19, 0), "Зал 2", 400));
        sessions.add(new Session(4, c2, m2, tomorrow, LocalTime.of(15, 0), "Зал 2", 350));
    }

    @Override
    public List<Movie> getAllMovies() {
        List<Movie> moviesCopy = new ArrayList<>(movies);
        return moviesCopy;
    }

    @Override
    public Movie getMovieById(int id) {
        return movies.stream().filter(movie -> movie.getId() == id)
                .findFirst()
                .orElse(null);
    }

    @Override
    public List<Session> getSessionsFor(Integer cinemaId, Integer movieId, LocalDate date) {
        return sessions.stream().filter(session -> {
            boolean isNeededCinema = cinemaId == null || session.getCinema().getId() == cinemaId;
            boolean isNeededMovie = movieId == null || session.getMovie().getId() == movieId;
            boolean isNeededDate = date == null || session.getDate().equals(date);
            return isNeededDate && isNeededCinema && isNeededMovie;
        }).toList();
    }

    @Override
    public Session getSessionById(int id) {
        return sessions.stream().filter(session -> session.getId() == id)
                .findFirst()
                .orElse(null);
    }

    @Override
    public List<Movie> getMoviesByGenre(Genres genre) {
        return movies.stream()
                .filter(movie -> movie.getGenres().contains(genre))
                .toList();

    }

    @Override
    public List<Cinema> getAllCinemas() {
        List<Cinema> cinemasCopy = new ArrayList<>(cinemas);
        return cinemasCopy;
    }

    @Override
    public Cinema getCinemaById(int id) {
        return cinemas.stream().filter(cinema -> cinema.getId() == id)
                .findFirst()
                .orElse(null);
    }
}
