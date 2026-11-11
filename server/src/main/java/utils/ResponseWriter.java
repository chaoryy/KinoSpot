package utils;

import com.sun.net.httpserver.HttpExchange;
import enums.ContentType;
import enums.HttpCode;

import java.io.*;

public class ResponseWriter {
    public void sendResponse(HttpExchange exchange, ContentType contentType, HttpCode code, byte[] bytes) {
        try (OutputStream outputStream = exchange.getResponseBody() ){
            exchange.getResponseHeaders().add("Content-Type", contentType.getMimeType());
            exchange.sendResponseHeaders(code.getStatusCode(), bytes.length);
            outputStream.write(bytes);
            outputStream.flush();
        } catch (IOException e) {
            System.out.println("Error while sending");
            e.printStackTrace();
        }

    }
}
