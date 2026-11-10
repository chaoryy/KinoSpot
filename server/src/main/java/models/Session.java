package models;

import java.time.LocalDate;
import java.time.LocalTime;

public class Session {
    private int id;
    private Cinema cinema;
    private Movie movie;
    private LocalDate date;
    private LocalTime time;
    private String hall;
    private int price;
}
