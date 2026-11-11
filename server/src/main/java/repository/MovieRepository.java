package repository;

import enums.Genres;
import models.Cinema;
import models.Movie;
import models.Session;

import java.time.LocalDate;
import java.util.List;

public interface MovieRepository {
    List<Movie> getAllMovies();
    Movie getMovieById(int id);
    List<Session> getSessionsFor(Integer cinemaId, Integer movieId, LocalDate date);
    Session getSessionById(int id);
    List<Movie> getMoviesByGenre(Genres genres);
    List<Cinema> getAllCinemas();
    Cinema getCinemaById(int id);
}
