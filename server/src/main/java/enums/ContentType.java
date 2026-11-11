package enums;

public enum ContentType {
    HTML ("text/html; charset=utf-8"),
    CSS ("text/css; charset=utf-8"),
    PLAIN("text/plain; charset=utf-8"),
    PNG ("image/png"),
    JPEG ("image/jpeg"),
    JPG ("image/jpeg"),
    JSON("application/json; charset=utf-8");

    private final String mimeType;

    ContentType(String mimeType) {
        this.mimeType = mimeType;
    }

    public static ContentType getContentTypeFrom(String path) {
        path = path.toLowerCase();
        if (path.endsWith(".html")) return HTML;
        if (path.endsWith(".css")) return CSS;
        if (path.endsWith(".png")) return PNG;
        if (path.endsWith(".jpeg")) return JPEG;
        if (path.endsWith(".jpg")) return JPG;
        return PLAIN;
    }

    public String getMimeType() {
        return mimeType;
    }
}

