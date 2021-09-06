package models;

import java.util.TreeSet;

public class Patient extends User{

    private final TreeSet<Appointment> appointmentsHistory = new TreeSet<>();

    //TODO: add more attributes (e.g. pendingAppointments)

    public Patient(long id, String firstName, String lastName, long CNP, String dateOfBirth, String phoneNumber, String emailAddress, String password) {
        super(id, firstName, lastName, CNP, dateOfBirth, phoneNumber, emailAddress, password);
    }

    public void addToHistory(Appointment appointment){
        appointmentsHistory.add(appointment);
    }

    public TreeSet<Appointment> getAppointmentsHistory() {
        return appointmentsHistory;
    }

    @Override
    public String toString() {
        return "Patient{" +
                "id=" + id +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", CNP=" + CNP +
                ", dateOfBirth='" + dateOfBirth + '\'' +
                ", phoneNumber='" + phoneNumber + '\'' +
                ", emailAddress='" + emailAddress + '\'' +
                ", password='" + password + '\'' +
                '}';
    }

    public String getCSV(){
        String[] data = {String.valueOf(id), firstName, lastName, String.valueOf(CNP),
                dateOfBirth, phoneNumber, emailAddress, password};
        return String.join(",", data);
    }
}
