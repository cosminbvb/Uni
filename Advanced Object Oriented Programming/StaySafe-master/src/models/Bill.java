package models;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

public class Bill {

    private long id;
    private List<Drug> drugs;
    //private Patient patient;
    //private Doctor doctor;
    private LocalDate date;
    private final long total;

    private static long nextId;

    public Bill(long id, List<Drug> drugs, LocalDate date) {
        this.id = id;
        this.drugs = drugs;
        // this.patient = patient;
        // this.doctor = doctor;
        this.date = date;
        this.total = computeTotal();
    }

    public Bill(long id, List<Drug> drugs, LocalDate date, long total) {
        this.id = id;
        this.drugs = drugs;
        this.date = date;
        this.total = total;
    }

    protected long computeTotal(){
        long price = 0;
        for (Drug d : drugs) {
            price += d.getPrice();
        }
        return price;
    }

    public long getTotal() {
        return total;
    }

    public static long getNextId() {
        return nextId++;
    }

    public static void setNextId(long nextId) {
        Bill.nextId = nextId;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public Date getDate() {
        return Date.valueOf(date);
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    @Override
    public String toString() {
        return "Bill{" +
                "id=" + id +
                ", drugs=" + drugs.toString() +
                ", date=" + date +
                '}';
    }

    public String getCSV(){
        String[] data = {String.valueOf(id), String.valueOf(total), String.valueOf(date)};
        return String.join(",", data);
    }

}
