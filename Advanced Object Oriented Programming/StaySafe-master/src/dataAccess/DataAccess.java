package dataAccess;

import models.*;

import java.util.TreeSet;

public interface DataAccess {

    void addPatient(Patient patient);
    void addDoctor(Doctor doctor);
    void addNurse(Nurse nurse);
    default void addUser(User user){} // default pentru ca in DataAccessMainMem se foloseste lista tuturor userilor
                                      // dar in DataAccessDB nu exista tabel cu toti userii

    void addPendingAppointment(Appointment appointment);
    Appointment getFirstPendingAppointment();
    void updateAppointment(String oldData, Appointment appointment);
    Appointment getUserFirstUpcomingAppointment(User user);

    void addBillDrug(Bill bill, Drug drug);
    void addBill(Bill bill);
    void addResponseTreatments(Response response, Drug drug, Integer value);
    void addResponse(Response response);

    User findUser(String email);
    MedicalCenter findCenter(String name);
    Doctor findDoctor(String firstName, String lastName);
    Drug findDrug(String name);
    User findUserById(long id);
    MedicalCenter findMedicalCenterById(long id);
    Drug findDrugById(long id);

    // verify login info:
    boolean verifyInfo(User user, String email, String password);

    TreeSet<Appointment> getAppointmentHistory(Patient patient);
    TreeSet<Appointment> getUpcomingAppointments(User user);

}
