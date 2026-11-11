import models.Server;
import repository.InMemoryMovieRepository;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        InMemoryMovieRepository test = new InMemoryMovieRepository();
        try {
            Server server = new Server("0.0.0.0", 9889, test);
            server.start();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
