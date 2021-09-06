package models;

import java.sql.Date;
import java.time.LocalDate;

public class Doctor extends User {

    private String speciality;
    private double salary;
    private final LocalDate hireDate;

    public Doctor(long id, String firstName, String lastName, long CNP, String dateOfBirth, String phoneNumber,
                  String emailAddress, String password, String speciality, double salary, LocalDate hireDate) {
        super(id, firstName, lastName, CNP, dateOfBirth, phoneNumber, emailAddress, password);
        this.speciality = speciality;
        this.salary = salary;
        this.hireDate = hireDate;
    }

    public String getSpeciality() {
        return speciality;
    }

    public void setSpeciality(String speciality) {
        this.speciality = speciality;
    }

    public double getSalary() {
        return salary;
    }

    public void setSalary(double salary) {
        this.salary = salary;
    }

    public Date getHireDate() {
        return Date.valueOf(hireDate);
    }

    @Override
    public String toString() {
        return "Doctor{" +
                "id=" + id +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", speciality='" + speciality + '\'' +
                ", hireDate=" + hireDate +
                '}';
    }

    public String getCSV(){
        String[] data = {String.valueOf(id), firstName, lastName, String.valueOf(CNP),
                dateOfBirth, phoneNumber, emailAddress, password, speciality,
                String.valueOf(salary), String.valueOf(hireDate)};
        return String.join(",", data);
    }

}
