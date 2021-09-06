package models;

import java.time.LocalDate;
import java.sql.Date;

public class Appointment implements Comparable<Appointment>{

    private long id;
    private Patient patient;
    private Doctor doctor; // or maybe an array too
    private Nurse nurse;
    private LocalDate date;
    private MedicalCenter medicalCenter;
    private String patientIssueDescription;
    private Response response;
    private String status; // pending / assigned / completed (will be available in the history section)

    private static long nextId;

    public Appointment(long id, Patient patient, LocalDate date, MedicalCenter medicalCenter,
                       String patientIssueDescription, String status) {
        this.id = id;
        this.patient = patient;
        this.date = date;
        this.medicalCenter = medicalCenter;
        this.patientIssueDescription = patientIssueDescription;
        this.status = status;
    }

    public Appointment(long id, Patient patient, Doctor doctor, Nurse nurse, LocalDate date,
                       MedicalCenter medicalCenter, String patientIssueDescription,
                       Response response, String status) {
        this.id = id;
        this.patient = patient;
        this.doctor = doctor;
        this.nurse = nurse;
        this.date = date;
        this.medicalCenter = medicalCenter;
        this.patientIssueDescription = patientIssueDescription;
        this.response = response;
        this.status = status;
    }

    public String getPatientIssueDescription() {
        return patientIssueDescription;
    }

    public void setPatientIssueDescription(String patientIssueDescription) {
        this.patientIssueDescription = patientIssueDescription;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public Doctor getDoctor() {
        return doctor;
    }

    public void setDoctor(Doctor doctor) {
        this.doctor = doctor;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Nurse getNurse() {
        return nurse;
    }

    public void setNurse(Nurse nurse) {
        this.nurse = nurse;
    }

    public Date getDate() {
        return Date.valueOf(date);
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public MedicalCenter getMedicalCenter() {
        return medicalCenter;
    }

    public void setMedicalCenter(MedicalCenter medicalCenter) {
        this.medicalCenter = medicalCenter;
    }

    public Response getResponse() {
        return response;
    }

    public void setResponse(Response response) {
        this.response = response;
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
        Appointment.nextId = nextId;
    }

    @Override
    public String toString() {
        return "Appointment{" +
                "id="+id +
                ", patient=" + patient.toString() +
                ", doctor=" + doctor.toString() +
                ", nurses=" + nurse.toString() +
                ", date=" + date.toString() +
                ", medicalCenter=" + medicalCenter.toString() +
                ", response=" + (response == null ? " " : response.toString()) +
                '}';
    }

    @Override
    public int compareTo(Appointment o) {
        return this.date.compareTo(o.getDate().toLocalDate());
    }


    public String getCSV(){
        String[] data;
        switch (status) {
            case "pending" -> data = new String[]{String.valueOf(id), status,
                    String.valueOf(patient.getId()), "not assigned", "not assigned",
                    String.valueOf(date), String.valueOf(medicalCenter.getId()),
                    patientIssueDescription, "not evaluated"};
            case "assigned" -> data = new String[]{String.valueOf(id), status,
                    String.valueOf(patient.getId()),
                    String.valueOf(doctor.getId()), String.valueOf(nurse.getId()),
                    String.valueOf(date), String.valueOf(medicalCenter.getId()),
                    patientIssueDescription, "not evaluated"};
            case "completed" -> data = new String[]{String.valueOf(id), status,
                    String.valueOf(patient.getId()),
                    String.valueOf(doctor.getId()), String.valueOf(nurse.getId()),
                    String.valueOf(date), String.valueOf(medicalCenter.getId()),
                    patientIssueDescription, String.valueOf(response.getId())};
            default -> throw new IllegalStateException("Unexpected value: " + status);
        }
        return String.join(",", data);
    }

}
