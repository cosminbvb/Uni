package models;

import java.util.HashMap;
import java.util.Objects;

public class Drug {

    private long id;
    private String name;
    private String manufacturer;
    private double price;
    private String prospect;
    private HashMap<String, Double> ingredients;

    private static long nextId;

    //TODO: list of side effects

    public Drug(long id, String name, String manufacturer, double price, String prospect, HashMap<String, Double> ingredients) {
        this.id = id;
        this.name = name;
        this.manufacturer = manufacturer;
        this.price = price;
        this.prospect = prospect;
        this.ingredients = ingredients;
    }

    public long getId() {
        return id;
    }

    public static long getNextId() {
        return nextId++;
    }

    public static void setNextId(long nextId) {
        Drug.nextId = nextId;
    }

    public String getName() {
        return name;
    }

    public double getPrice() {
        return price;
    }

    public HashMap<String, Double> getIngredients() {
        return ingredients;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Drug drug = (Drug) o;
        return Double.compare(drug.price, price) == 0 && Objects.equals(name, drug.name) &&
                Objects.equals(manufacturer, drug.manufacturer) && Objects.equals(prospect, drug.prospect) &&
                Objects.equals(ingredients, drug.ingredients);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, manufacturer, price, prospect, ingredients);
    }

    @Override
    public String toString() {
        return "Drug{" +
                "name='" + name + '\'' +
                ", manufacturer='" + manufacturer + '\'' +
                ", price=" + price +
                ", ingredients=" + ingredients.toString() +
                '}';
    }

    public String getCSV(){
        String[] data = {String.valueOf(id), name, manufacturer, String.valueOf(price), prospect};
        return String.join(",", data);
    }

}
