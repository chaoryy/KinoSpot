package enums;

public enum Genres {
    ACTION ("Боевик"),
    COMEDY ("Комедия"),
    DRAMA ("Драма"),
    SCIFI ("Научная фантастика"),
    FANTASY ("Фантастика"),
    HORROR ("Хоррор"),
    THRILLER ("Триллер"),
    ROMANCE ("Романтика"),
    ADVENTURE ("Приключения");

    private final String name;

    Genres(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}
