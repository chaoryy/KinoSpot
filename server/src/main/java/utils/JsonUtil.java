package utils;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class JsonUtil {
    Gson gson = new GsonBuilder().setPrettyPrinting().create();

    public String toJson(Object object) {
        return gson.toJson(object);
    }
}
