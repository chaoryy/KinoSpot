package utils;


import com.sun.net.httpserver.HttpExchange;
import enums.ContentType;
import enums.HttpCode;
import models.Cinema;
import models.Movie;
import models.Session;
import repository.MovieRepository;

import java.nio.charset.StandardCharsets;

public class RequestHandler {
    private final MovieRepository repository;
    private final JsonUtil jsonUtil = new JsonUtil();
    private final ResponseWriter responseWriter = new ResponseWriter();

    public RequestHandler(MovieRepository repository) {
        this.repository = repository;
    }

    public void handlePath(HttpExchange exchange) {
        if (!"GET".equals(exchange.getRequestMethod())) {
            responseWriter.sendResponse(exchange, ContentType.PLAIN, HttpCode.METHOD_NOT_ALLOWED, getBytesFrom(HttpCode.METHOD_NOT_ALLOWED));
            return;
        }
        String[] splitedPath = splitPath(exchange);
        if (splitedPath.length == 0) {
            sendNotFound(exchange);
            return;
        }
        switch (splitedPath[0]) {
            case "movies" -> handleMovies(splitedPath, exchange);
            case "sessions" -> handleSessions(splitedPath, exchange);
            case "cinemas" -> handleCinemas(splitedPath, exchange);
            default -> sendNotFound(exchange);
        }

    }

    private void handleMovies(String[] path, HttpExchange exchange) {
        int length = path.length;
        String response;
        if (length == 1) {
            response = jsonUtil.toJson(repository.getAllMovies());
            responseWriter.sendResponse(exchange, ContentType.JSON, HttpCode.OK, getBytesFrom(response));
            return;
        }
        if (length == 2 || length == 3) {
            Integer movieId = parseId(exchange, path[1]);
            if (movieId == null) return;
            Movie movie = repository.getMovieById(movieId);
            if (movie == null) {
                sendNotFound(exchange);
                return;
            }
            if (length == 2) {
                response = jsonUtil.toJson(movie);
                responseWriter.sendResponse(exchange, ContentType.JSON, HttpCode.OK, getBytesFrom(response));
                return;
            }
            if ("sessions".equals(path[2])) {
                response = jsonUtil.toJson(repository.getSessionsFor(null, movieId, null));
                responseWriter.sendResponse(exchange, ContentType.JSON, HttpCode.OK, getBytesFrom(response));
                return;
            }

        }
        sendNotFound(exchange);
    }

    private void handleSessions(String[] path, HttpExchange exchange) {
        int length = path.length;
        String response;
        if (length == 1) {
            response = jsonUtil.toJson(repository.getSessionsFor(null, null, null));
            responseWriter.sendResponse(exchange, ContentType.JSON, HttpCode.OK, getBytesFrom(response));
            return;
        }
        if (length == 2) {
            Integer sessionId = parseId(exchange, path[1]);
            if (sessionId == null) return;
            Session session = repository.getSessionById(sessionId);
            if (session == null) {
                sendNotFound(exchange);
                return;
            }
            response = jsonUtil.toJson(session);
            responseWriter.sendResponse(exchange, ContentType.JSON, HttpCode.OK, getBytesFrom(response));
            return;
        }
        sendNotFound(exchange);
    }

    private void handleCinemas(String[] path, HttpExchange exchange) {
        int length = path.length;
        String response;
        if (length == 1) {
            response = jsonUtil.toJson(repository.getAllCinemas());
            responseWriter.sendResponse(exchange, ContentType.JSON, HttpCode.OK, getBytesFrom(response));
            return;
        }
        if (length == 2 || length == 3) {
            Integer cinemaId = parseId(exchange, path[1]);
            if (cinemaId == null) return;
            Cinema cinema = repository.getCinemaById(cinemaId);
            if (cinema == null) {
                sendNotFound(exchange);
                return;
            }
            if (length == 2) {
                response = jsonUtil.toJson(cinema);
                responseWriter.sendResponse(exchange, ContentType.JSON, HttpCode.OK, getBytesFrom(response));
                return;
            }
            if ("sessions".equals(path[2])) {
                response = jsonUtil.toJson(repository.getSessionsFor(cinemaId, null, null));
                responseWriter.sendResponse(exchange, ContentType.JSON, HttpCode.OK, getBytesFrom(response));
                return;
            }

        }
        sendNotFound(exchange);
    }

    private void sendNotFound(HttpExchange exchange) {
        responseWriter.sendResponse(exchange, ContentType.PLAIN, HttpCode.NOT_FOUND, getBytesFrom(HttpCode.NOT_FOUND));
    }

    private String[] splitPath(HttpExchange exchange) {
        String uriPath = exchange.getRequestURI().getPath();
        if (uriPath == null || uriPath.equals("/")) {
            return new String[0];
        }
        return uriPath.replaceAll("^/+", "").split("/");
    }

    private byte[] getBytesFrom(String body) {
        return body.getBytes(StandardCharsets.UTF_8);
    }

    private byte[] getBytesFrom(HttpCode code) {
        return code.toString().getBytes(StandardCharsets.UTF_8);
    }

    private Integer parseId(HttpExchange exchange, String strId) {
        try {
            return Integer.parseInt(strId);
        } catch (NumberFormatException e) {
            responseWriter.sendResponse(exchange, ContentType.PLAIN, HttpCode.BAD_REQUEST, getBytesFrom(HttpCode.BAD_REQUEST));
            return null;
        }

    }
}
