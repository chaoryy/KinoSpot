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

        // 2. Создаем фильмы (5 штук с разными жанрами)
        Movie m1 = new Movie(
                1,
                "Интерстеллар",
                "Фантастическая драма о путешествии сквозь червоточину в поисках нового дома для человечества.",
                2014,
                169,
                "https://cdnrrviubnyuntopbez5.svc.cdn.yandex.net/get-kinopoisk-image/1600647/4bd1d574-4166-4128-a0a5-e52c8a0538e6/3840x",
                List.of(Genres.SCIFI, Genres.DRAMA),
                8.6
        );

        Movie m2 = new Movie(
                2,
                "Дюна: Часть вторая",
                "Пол Атридес объединяется с фрименами, чтобы отомстить заговорщикам.",
                2024,
                166,
                "https://cdnrrviubnyuntopbez5.svc.cdn.yandex.net/get-ott/1652588/2a0000019ae9fc0d582ed774557fe22ee6df/600x900",
                List.of(Genres.ACTION, Genres.SCIFI, Genres.ADVENTURE),
                8.3
        );

        Movie m3 = new Movie(
                3,
                "Побег из Шоушенка",
                "История о надежде, дружбе и долгих годах в стенах тюрьмы строгого режима.",
                1994,
                142,
                "https://cdnrrviubnyuntopbez5.svc.cdn.yandex.net/get-kinopoisk-image/1599028/0b76b2a2-d1c7-4f04-a284-80ff7bb709a4/600x900",
                List.of(Genres.DRAMA),
                9.3
        );

        Movie m4 = new Movie(
                4,
                "Человек-паук: Паутина вселенных",
                "Майлз Моралес отправляется в путешествие по мультивселенной.",
                2023,
                140,
                "https://cdnrrviubnyuntopbez5.svc.cdn.yandex.net/get-kinopoisk-image/10893610/4df6ae79-1fef-4a72-b55d-9be66233af1e/600x900",
                List.of(Genres.ACTION, Genres.ADVENTURE),
                8.7
        );

        Movie m5 = new Movie(
                5,
                "Оппенгеймер",
                "Биографическая драма о создании атомной бомбы под руководством Роберта Оппенгеймера.",
                2023,
                180,
                "https://cdnrrviubnyuntopbez5.svc.cdn.yandex.net/get-kinopoisk-image/4486454/c5292109-642c-4ab0-894a-cc304e1bcec4/600x900",
                List.of(Genres.DRAMA, Genres.THRILLER),
                8.9
        );

        movies.add(m1);
        movies.add(m2);
        movies.add(m3);
        movies.add(m4);
        movies.add(m5);

        // 3. Создаем сеансы на несколько дней вперед
        LocalDate today = LocalDate.of(2026, 11, 11);
        LocalDate tomorrow = LocalDate.of(2026, 11, 12);
        LocalDate dayAfter = LocalDate.of(2026, 11, 13);

        // Сеансы в Asia Mall (c1)
        sessions.add(new Session(1, c1, m1, today, LocalTime.of(14, 30), "Зал 1 (IMAX)", 450));
        sessions.add(new Session(2, c1, m1, today, LocalTime.of(18, 00), "Зал 1 (IMAX)", 550));
        sessions.add(new Session(3, c1, m2, tomorrow, LocalTime.of(15, 00), "Зал 2", 400));
        sessions.add(new Session(4, c1, m4, dayAfter, LocalTime.of(12, 00), "Зал 3", 350));
        sessions.add(new Session(5, c1, m5, tomorrow, LocalTime.of(19, 30), "Зал 1 (IMAX)", 500));

        // Сеансы в Bishkek Park (c2)
        sessions.add(new Session(6, c2, m2, today, LocalTime.of(19, 00), "Зал 2", 400));
        sessions.add(new Session(7, c2, m3, today, LocalTime.of(21, 30), "Зал 1", 350));
        sessions.add(new Session(8, c2, m4, tomorrow, LocalTime.of(16, 30), "Зал 2", 380));
        sessions.add(new Session(9, c2, m5, dayAfter, LocalTime.of(18, 00), "Зал 1", 450));
        sessions.add(new Session(10, c2, m1, dayAfter, LocalTime.of(21, 00), "Зал 2", 480));
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
