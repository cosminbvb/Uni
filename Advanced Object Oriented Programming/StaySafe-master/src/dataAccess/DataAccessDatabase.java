package dataAccess;

import models.*;
import services.Database;

import java.sql.ResultSet;
import java.util.*;

// DataAccessDatabase uses a database for persistence and does not store any heavy data in the main memory
public class DataAccessDatabase implements DataAccess {

    private static DataAccessDatabase instance = null;

    Database db = Database.getInstance();

    public static DataAccessDatabase getInstance(){
        if(instance == null){
            instance = new DataAccessDatabase();
        }
        return instance;
    }

    private DataAccessDatabase(){
        // TODO initializarea bazei de date daca nu este deja facuta
        // adica mutarea codului ala sql aici si apelarea lui
    }

    @Override
    public void addPatient(Patient patient) {
        try {
            db.addPatient(patient);
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    public void addDoctor(Doctor doctor) {
        try {
            db.addDoctor(doctor);
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    public void addNurse(Nurse nurse) {
        try {
            db.addNurse(nurse);
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    public void addPendingAppointment(Appointment appointment) {
        try {
            db.addPendingAppointment(appointment);
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    public Appointment getFirstPendingAppointment() {
        // intended for appointment processing
        try {
            ResultSet rs = db.getFirstPendingAppointment();
            if(rs.next()){
                return new Appointment(
                    rs.getLong("id"),
                    getPatientById(rs.getLong("patient_id")),
                    getDoctorById(rs.getLong("doctor_id")),
                    getNurseById(rs.getLong("nurse_id")),
                    rs.getDate("date").toLocalDate(),
                    getCenterById(rs.getLong("center_id")),
                    rs.getString("issueDescription"),
                    getResponseById(rs.getLong("response_id")),
                    rs.getString("status")
                );
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public void updateAppointment(String oldData, Appointment appointment) {
        long oldId = Long.parseLong(oldData.split(",")[0]);
        try{
            db.updateAppointment(oldId, appointment);
        } catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    public Appointment getUserFirstUpcomingAppointment(User user) {
        try{
            ResultSet rs = db.pollUserFirstAppointment(user.getId());
            if(rs.next())
                return new Appointment(
                        rs.getLong("id"),
                        getPatientById(rs.getLong("patient_id")),
                        getDoctorById(rs.getLong("doctor_id")),
                        getNurseById(rs.getLong("nurse_id")),
                        rs.getDate("date").toLocalDate(),
                        getCenterById(rs.getLong("center_id")),
                        rs.getString("issueDescription"),
                        getResponseById(rs.getLong("response_id")),
                        rs.getString("status")
                );
        } catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public void addBillDrug(Bill bill, Drug drug) {
        try {
            db.addBillDrug(bill.getId(), drug.getId());
        } catch (Exception e){
            e.printStackTrace();
        }
    }
    @Override
    public void addBill(Bill bill) {
        try {
            db.addBill(bill);
        } catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    public void addResponseTreatments(Response response, Drug drug, Integer value) {
        try {
            db.addResponseTreatment(response.getId(), drug.getId(), value);
        } catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    public void addResponse(Response response) {
        try {
            db.addResponse(response);
        } catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    public User findUser(String email) {
        try{
            long id = db.findUserIdByMail(email);
            if(id == -1) return null;
            Patient patient = getPatientById(id);
            if (patient != null)
                return patient;
            Doctor doctor = getDoctorById(id);
            if (doctor != null)
                return doctor;
            return getNurseById(id);

        } catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public MedicalCenter findCenter(String name) {
        try{
            long id = db.findCenterByName(name);
            if(id == -1)
                return null;
            return getCenterById(id);
        } catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public Doctor findDoctor(String firstName, String lastName) {
        try{
            long id = db.findDoctorByName(firstName, lastName);
            if(id == -1)
                return null;
            return getDoctorById(id);
        } catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public Drug findDrug(String name) {
        try{
            long id = db.findDrugByName(name);
            if(id == -1)
                return null;
            return getDrugById(id);
        } catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public User findUserById(long id) {
        try{
            Patient patient = getPatientById(id);
            if (patient != null)
                return patient;
            Doctor doctor = getDoctorById(id);
            if (doctor != null)
                return doctor;
            return getNurseById(id);

        } catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public MedicalCenter findMedicalCenterById(long id) {
        return getCenterById(id);
    }

    @Override
    public Drug findDrugById(long id) {
        return getDrugById(id);
    }

    // verify login info:
    @Override
    public boolean verifyInfo(User user, String email, String password){
        try{
            int count = db.verifyInfoPatient(user.getId(), email, password);
            if (count == 1)
                return true;
            count = db.verifyInfoDoctor(user.getId(), email, password);
            if (count == 1)
                return true;
            count = db.verifyInfoNurse(user.getId(), email, password);
            return count == 1;

        } catch (Exception e){
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public TreeSet<Appointment> getAppointmentHistory(Patient patient){
        TreeSet<Appointment> set = new TreeSet<>();
        try{
            ResultSet rs = db.getAppointmentHistoryIds(patient.getId());
            while(rs.next()){
                long id = rs.getLong("id");
                set.add(getAppointmentById(id));
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        return set;
    }

    @Override
    public TreeSet<Appointment> getUpcomingAppointments(User user){
        TreeSet<Appointment> set = new TreeSet<>();
        try{
            ResultSet rs = db.getUpcomingAppointments(user.getId());
            while(rs.next())
                set.add(new Appointment(
                        rs.getLong("id"),
                        getPatientById(rs.getLong("patient_id")),
                        getDoctorById(rs.getLong("doctor_id")),
                        getNurseById(rs.getLong("nurse_id")),
                        rs.getDate("date").toLocalDate(),
                        getCenterById(rs.getLong("center_id")),
                        rs.getString("issueDescription"),
                        getResponseById(rs.getLong("response_id")),
                        rs.getString("status")
                ));
        } catch (Exception e){
            e.printStackTrace();
        }
        return set;
    }

    public Patient getPatientById(long id){
        try {
            ResultSet rs = db.getPatient(id);
            if(rs.next())
                return new Patient(
                    rs.getLong("id"),
                    rs.getString("firstName"),
                    rs.getString("lastName"),
                    rs.getLong("cnp"),
                    rs.getString("dateOfBirth"),
                    rs.getString("phoneNumber"),
                    rs.getString("emailAddress"),
                    rs.getString("password")
                );

        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    public Doctor getDoctorById(long id){
        try {
            ResultSet rs = db.getDoctor(id);
            if(rs.next())
                return new Doctor(
                        rs.getLong("id"),
                        rs.getString("firstName"),
                        rs.getString("lastName"),
                        rs.getLong("cnp"),
                        rs.getString("dateOfBirth"),
                        rs.getString("phoneNumber"),
                        rs.getString("emailAddress"),
                        rs.getString("password"),
                        rs.getString("speciality"),
                        rs.getDouble("salary"),
                        rs.getDate("hireDate").toLocalDate()
                );

        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    public Nurse getNurseById(long id){
        try {
            ResultSet rs = db.getNurse(id);
            if(rs.next())
                return new Nurse(
                        rs.getLong("id"),
                        rs.getString("firstName"),
                        rs.getString("lastName"),
                        rs.getLong("cnp"),
                        rs.getString("dateOfBirth"),
                        rs.getString("phoneNumber"),
                        rs.getString("emailAddress"),
                        rs.getString("password"),
                        rs.getDate("hireDate").toLocalDate(),
                        rs.getDouble("salary")
                );

        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    public MedicalCenter getCenterById(long id){
        try {
            ResultSet rs = db.getCenter(id);
            if(rs.next())
                return new MedicalCenter(
                        rs.getLong("id"),
                        rs.getString("name"),
                        rs.getString("city"),
                        rs.getString("address"),
                        rs.getInt("capacity")
                );

        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    public Drug getDrugById(long id){
        try {
            ResultSet rs = db.getDrug(id);
            if(rs.next())
                return new Drug(
                        rs.getLong("id"),
                        rs.getString("name"),
                        rs.getString("manufacturer"),
                        rs.getDouble("price"),
                        rs.getString("prospect"),
                        getIngredients(rs.getLong("id"))
                );

        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    public Response getResponseById(long id){
        try {
            ResultSet rs = db.getResponse(id);
            if(rs.next())
                return new Response(
                        rs.getLong("id"),
                        rs.getString("description"),
                        getTreatmentPlan(rs.getLong("id")),
                        getBillById(rs.getLong("bill_id"))
                );

        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    public Bill getBillById(long id){
        try{
            ResultSet rs = db.getBill(id);
            if(rs.next())
                return new Bill(
                    rs.getLong("id"),
                    getDrugsList(rs.getLong("id")),
                    rs.getDate("date").toLocalDate(),
                    rs.getInt("total")
                );

        } catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    public Appointment getAppointmentById(long id){
        try{
            ResultSet rs = db.getAppointment(id);
            if(rs.next())
                return new Appointment(
                        rs.getLong("id"),
                        getPatientById(rs.getLong("patient_id")),
                        getDoctorById(rs.getLong("doctor_id")),
                        getNurseById(rs.getLong("nurse_id")),
                        rs.getDate("date").toLocalDate(),
                        getCenterById(rs.getLong("center_id")),
                        rs.getString("issueDescription"),
                        getResponseById(rs.getLong("response_id")),
                        rs.getString("status")
                );
        } catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    public HashMap<String, Double> getIngredients(long id){
        HashMap<String, Double> map = new HashMap<>();
        try{
            ResultSet rs = db.getDrugIngredients(id);
            while(rs.next()){
                map.put(rs.getString("ingredient"), rs.getDouble("quantity"));
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        return map;
    }

    public List<Drug> getDrugsList(long id){
        List<Drug> list = new ArrayList<>();
        try{
            ResultSet rs = db.getBillsDrugs(id);
            while(rs.next()){
                list.add(getDrugById(rs.getLong("id_drug")));
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        return list;
    }

    public HashMap<Drug, Integer> getTreatmentPlan(long id){
        HashMap<Drug, Integer> map = new HashMap<>();
        try{
            ResultSet rs = db.getResponseTreatment(id);
            while(rs.next()){
                Drug drug = getDrugById(rs.getLong("drug_id"));
                map.put(drug, rs.getInt("hours"));
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        return map;
    }
}
