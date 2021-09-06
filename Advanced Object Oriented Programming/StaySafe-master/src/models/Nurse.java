package models;

import java.sql.Date;
import java.time.LocalDate;

public class Nurse extends User{

    private final LocalDate hireDate;
    private double salary;

    //TODO: add more attributes

    public Nurse(long id, String firstName, String lastName, long CNP, String dateOfBirth, String phoneNumber,
                 String emailAddress, String password, LocalDate hireDate, double salary) {
        super(id, firstName, lastName, CNP, dateOfBirth, phoneNumber, emailAddress, password);
        this.hireDate = hireDate;
        this.salary = salary;
    }

    public Date getHireDate() {
        return Date.valueOf(hireDate);
    }

    public double getSalary() {
        return salary;
    }

    public void setSalary(double salary) {
        this.salary = salary;
    }

    @Override
    public String toString() {
        return "Nurse{" +
                ", id=" + id +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                "hireDate=" + hireDate +
                ", salary=" + salary +
                '}';
    }

    public String getCSV(){
        String[] data = {String.valueOf(id), firstName, lastName, String.valueOf(CNP),
                dateOfBirth, phoneNumber, emailAddress, password, String.valueOf(salary), String.valueOf(hireDate)};
        return String.join(",", data);
    }

}
