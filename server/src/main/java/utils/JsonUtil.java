package utils;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.TypeAdapter;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonWriter;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;

public class JsonUtil {
    private final Gson gson;

    public JsonUtil() {
        this.gson = new GsonBuilder().registerTypeAdapter(LocalDate.class, new TypeAdapter<LocalDate>() {
                    @Override
                    public void write(JsonWriter jsonWriter, LocalDate date) throws IOException {
                        jsonWriter.value(date != null ? date.toString() : null);
                    }

                    @Override
                    public LocalDate read(JsonReader jsonReader) throws IOException {
                        return LocalDate.parse(jsonReader.nextString());
                    }
                })
                .registerTypeAdapter(LocalTime.class, new TypeAdapter<LocalTime>() {
                    @Override
                    public void write(JsonWriter jsonWriter, LocalTime localTime) throws IOException {
                        jsonWriter.value(localTime != null ? localTime.toString() : null);
                    }

                    @Override
                    public LocalTime read(JsonReader jsonReader) throws IOException {
                        return LocalTime.parse(jsonReader.nextString());
                    }
                }).create();
    }

    public String toJson(Object object) {
        return gson.toJson(object);
    }
}
