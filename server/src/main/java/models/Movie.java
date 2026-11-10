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
}
