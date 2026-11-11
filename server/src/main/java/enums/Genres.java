package enums;

public enum Genres {
    ACTION ("Action"),
    COMEDY ("Comedy"),
    DRAMA ("Drama"),
    SCIFI ("Sci-Fi"),
    FANTASY ("Fantasy"),
    HORROR ("Horror"),
    THRILLER ("Thriller"),
    ROMANCE ("Romance"),
    ADVENTURE ("Adventure");

    private final String name;

    Genres(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}
