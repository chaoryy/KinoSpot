package models;
import com.sun.net.httpserver.HttpServer;
import repository.MovieRepository;
import utils.RequestHandler;

import java.io.IOException;
import java.net.InetSocketAddress;

public class Server {
    private final InetSocketAddress address;
    private final HttpServer httpServer;
    private final RequestHandler requestHandler;


    public Server(String host, int port, MovieRepository repository) throws IOException {
        this.address = new InetSocketAddress(host, port);
        this.httpServer = HttpServer.create(address, 50);
        this.requestHandler = new RequestHandler(repository);
        initRoutes(httpServer);
    }

    public void start() {
        httpServer.start();
        System.out.printf(
                "Server started on %s:%d%n",
                address.getHostName(),
                address.getPort()
        );
        System.out.println("      successfully started");
    }

    private void initRoutes(HttpServer server) {
        server.createContext("/", requestHandler::handlePath);
    }
}
