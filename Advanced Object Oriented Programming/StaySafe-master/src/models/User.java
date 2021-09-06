package models;

import java.util.Objects;
import java.util.TreeSet;

public abstract class User {

    protected long id;
    protected String firstName, lastName;
    protected long CNP;
    protected String dateOfBirth;
    protected String phoneNumber;
    protected String emailAddress; // unique
    protected String password;
    protected final TreeSet<Appointment> upcomingAppointments = new TreeSet<>();

    protected static long nextId;

    public User(long id, String firstName, String lastName, long CNP, String dateOfBirth, String phoneNumber, String emailAddress, String password) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.CNP = CNP;
        this.dateOfBirth = dateOfBirth;
        this.phoneNumber = phoneNumber;
        this.emailAddress = emailAddress;
        this.password = password;
    }

    public void addUpcomingAppointment(Appointment appointment){
        upcomingAppointments.add(appointment);
    }

    public TreeSet<Appointment> getUpcomingAppointments() {
        return upcomingAppointments;
    }

    public long getId() {
        return id;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public String getEmailAddress() {
        return emailAddress;
    }

    public String getPassword() {
        return password;
    }

    public static long getNextId() {
        return nextId++;
    }

    public static void setNextId(long nextId) {
        User.nextId = nextId;
    }

    public long getCNP() {
        return CNP;
    }

    public String getDateOfBirth() {
        return dateOfBirth;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return id == user.id;
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
