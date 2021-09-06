package models;

import java.util.HashMap;

public class Response {

    private long id;
    private String description; // notes given by the doctor
    private HashMap<Drug, Integer> treatmentPlan; // Drug -> Time interval
    // TODO: Drug -> Dosage + Time interval
    private Bill bill;

    private static long nextId;

    public Response(long id, String description, HashMap<Drug, Integer> treatmentPlan, Bill bill) {
        this.id = id;
        this.description = description;
        this.treatmentPlan = treatmentPlan;
        this.bill = bill;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public static long getNextId() {
        return nextId++;
    }

    public static void setNextId(long nextId) {
        Response.nextId = nextId;
    }

    public String getDescription() {
        return description;
    }

    public Bill getBill() {
        return bill;
    }

    @Override
    public String toString() {
        return "Response{" +
                "description='" + description + '\'' +
                ", treatmentPlan=" + treatmentPlan.toString() +
                ", bill=" + bill.toString() +
                '}';
    }

    public String getCSV(){
        String[] data = {String.valueOf(id), description, String.valueOf(bill.getId())};
        return String.join(",", data);
    }
}
