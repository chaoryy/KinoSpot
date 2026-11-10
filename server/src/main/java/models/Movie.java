package models;

import enums.Genres;

import java.util.List;

public class Movie {
    private int id;
    private String name;
    private String description;
    private int year;
    private int duration;
    private String posterLink;
    private List<Genres> genres;
    private double rating;

    public Movie(int id, String name, String description, int year, int duration, String posterLink, List<Genres> genres, double rating) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.year = year;
        this.duration = duration;
        this.posterLink = posterLink;
        this.genres = genres;
        this.rating = rating;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getPosterLink() {
        return posterLink;
    }

    public void setPosterLink(String posterLink) {
        this.posterLink = posterLink;
    }

    public List<Genres> getGenres() {
        return genres;
    }

    public void setGenres(List<Genres> genres) {
        this.genres = genres;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    @Override
    public String toString() {
        return "Movie{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", year=" + year +
                ", duration=" + duration +
                ", posterLink='" + posterLink + '\'' +
                ", genres=" + genres +
                ", rating=" + rating +
                '}';
    }
}
