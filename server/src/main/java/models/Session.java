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

    public Session(int id, Cinema cinema, Movie movie, LocalDate date, LocalTime time, String hall, int price) {
        this.id = id;
        this.cinema = cinema;
        this.movie = movie;
        this.date = date;
        this.time = time;
        this.hall = hall;
        this.price = price;
    }

    public int getId() {
        return id;
    }


    public Cinema getCinema() {
        return cinema;
    }

    public void setCinema(Cinema cinema) {
        this.cinema = cinema;
    }

    public Movie getMovie() {
        return movie;
    }

    public void setMovie(Movie movie) {
        this.movie = movie;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public LocalTime getTime() {
        return time;
    }

    public void setTime(LocalTime time) {
        this.time = time;
    }

    public String getHall() {
        return hall;
    }

    public void setHall(String hall) {
        this.hall = hall;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    @Override
    public String toString() {
        return "Session{" +
                "id=" + id +
                ", cinema=" + cinema +
                ", movie=" + movie +
                ", date=" + date +
                ", time=" + time +
                ", hall='" + hall + '\'' +
                ", price=" + price +
                '}';
    }
}
