package models;

public class MedicalCenter {

    private long id;
    private String name;
    private String city;
    private String address;
    private long capacity;

    private static long nextId;

    public MedicalCenter(long id, String name, String city, String address, long capacity) {
        this.id = id;
        this.name = name;
        this.city = city;
        this.address = address;
        this.capacity = capacity;
    }

    public static long getNextId() {
        return nextId++;
    }

    public static void setNextId(long nextId) {
        MedicalCenter.nextId = nextId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public long getCapacity() {
        return capacity;
    }

    public void setCapacity(long capacity) {
        this.capacity = capacity;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    @Override
    public String toString() {
        return "MedicalCenter{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", city='" + city + '\'' +
                ", address='" + address + '\'' +
                ", capacity=" + capacity +
                '}';
    }


    public String getCSV(){
        String[] data = {String.valueOf(id), name, city, address, String.valueOf(capacity)};
        return String.join(",", data);
    }

}
