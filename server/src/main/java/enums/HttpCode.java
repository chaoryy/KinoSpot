package enums;

public enum HttpCode {
    OK (200),
    NO_CONTENT (204),
    NOT_FOUND(404),
    SERVER_ERROR(500),
    SERVER_UNAVAILABLE(505),
    BAD_REQUEST(400),
    METHOD_NOT_ALLOWED(405);

    private final int statusCode;

    HttpCode(int statusCode) {
        this.statusCode = statusCode;
    }

    public int getStatusCode() {
        return statusCode;
    }
}
