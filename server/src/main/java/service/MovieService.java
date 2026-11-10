package service;

import enums.SortField;
import models.Movie;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class MovieService {
    public List<Movie> sortMovies(List<Movie> movies, SortField sortField, boolean asc) {
        List<Movie> sortedMovie = new ArrayList<>(movies);
        Comparator<Movie> movieComparator = switch (sortField) {
            case NAME -> Comparator.comparing(Movie::getName);
            case YEAR -> Comparator.comparing(Movie::getYear);
            case RATING -> Comparator.comparing(Movie::getRating);
            };
        if (!asc) {
            movieComparator = movieComparator.reversed();
        }
        sortedMovie = sortedMovie.stream()
                .sorted(movieComparator)
                .toList();
        return sortedMovie;
    }

    public List<Movie> searchMovie(List<Movie> movies, String name) {
        List<Movie> movieMatches = new ArrayList<>(0);
        movieMatches = movies.stream()
                .filter(movie -> movie.getName().toLowerCase().contains(name.toLowerCase()))
                .toList();
        return movieMatches;
    }
}
