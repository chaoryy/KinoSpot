import enums.Genres;
import repository.InMemoryMovieRepository;

import java.time.LocalDate;

public class Main {
    public static void main(String[] args) {
        InMemoryMovieRepository test = new InMemoryMovieRepository();
        System.out.println(test.getAllMovies());
        System.out.println(test.getMoviesByGenre(Genres.DRAMA));
        System.out.println(test.getMovieById(2));
        System.out.println(test.getSessionsFor(null, 1, LocalDate.now()));
    }
}
