package services;

import models.*;//

import java.sql.*;

public final class Database {

    private static Database db = null;
    private final Connection connection;

    public static Database getInstance(){
        if (db == null){
            try{
                db = new Database();
            } catch (Exception e){
                e.printStackTrace();
            }
        }
        return db;
    }

    private Database() throws SQLException {
        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/stay_safe",
                "admin","adminIDHN289R#");

        // getting the last User id, and setting the next one
        // similar to the csv "load database" function
        Statement stmt = connection.createStatement();
        String query = "SELECT MAX(id) FROM patients";
        ResultSet rs = stmt.executeQuery(query);
        rs.next();
        long lastId = rs.getLong(1);
        query = "SELECT MAX(id) FROM doctors";
        rs = stmt.executeQuery(query);
        rs.next();
        lastId = Math.max(rs.getLong(1), lastId);
        query = "SELECT MAX(id) FROM nurses";
        rs = stmt.executeQuery(query);
        rs.next();
        lastId = Math.max(rs.getLong(1), lastId);
        User.setNextId(lastId + 1);

        // for medical centers
        query = "SELECT MAX(id) FROM centers";
        rs = stmt.executeQuery(query);
        rs.next();
        MedicalCenter.setNextId(rs.getLong(1) + 1);

        // for drugs
        query = "SELECT MAX(id) FROM drugs";
        rs = stmt.executeQuery(query);
        rs.next();
        Drug.setNextId(rs.getLong(1) + 1);

        // for bills
        query = "SELECT MAX(id) FROM bills";
        rs = stmt.executeQuery(query);
        rs.next();
        Bill.setNextId(rs.getLong(1) + 1);

        // for responses
        query = "SELECT MAX(id) FROM responses";
        rs = stmt.executeQuery(query);
        rs.next();
        Response.setNextId(rs.getLong(1) + 1);

        // for appointments
        query = "SELECT MAX(id) FROM appointments";
        rs = stmt.executeQuery(query);
        rs.next();
        Appointment.setNextId(rs.getLong(1) + 1);
    }


    // PATIENTS
    public void addPatient(Patient patient) throws SQLException {
        PreparedStatement stmt = connection.prepareStatement("INSERT INTO patients VALUES" +
                "(?, ?, ?, ?, ?, ?, ?, SHA1(?))");
        stmt.setLong(1, patient.getId());
        stmt.setString(2, patient.getFirstName());
        stmt.setString(3, patient.getLastName());
        stmt.setLong(4, patient.getCNP());
        stmt.setString(5, patient.getDateOfBirth());
        stmt.setString(6, patient.getPhoneNumber());
        stmt.setString(7, patient.getEmailAddress());
        stmt.setString(8, patient.getPassword());
        stmt.executeUpdate();
    }

    public ResultSet getPatient(long id) throws SQLException{
        PreparedStatement stmt = connection.prepareStatement(
            "SELECT * FROM patients WHERE id = ?"
        );
        stmt.setLong(1, id);
        return stmt.executeQuery();
    }


    // DOCTORS
    public void addDoctor(Doctor doctor) throws SQLException {
        PreparedStatement stmt = connection.prepareStatement("INSERT INTO doctors VALUES" +
                "(?, ?, ?, ?, ?, ?, ?, SHA1(?), ?, ?, ?)");
        stmt.setLong(1, doctor.getId());
        stmt.setString(2, doctor.getFirstName());
        stmt.setString(3, doctor.getLastName());
        stmt.setLong(4, doctor.getCNP());
        stmt.setString(5, doctor.getDateOfBirth());
        stmt.setString(6, doctor.getPhoneNumber());
        stmt.setString(7, doctor.getEmailAddress());
        stmt.setString(8, doctor.getPassword());
        stmt.setString(9, doctor.getSpeciality());
        stmt.setDouble(10, doctor.getSalary());
        stmt.setDate(11, doctor.getHireDate());
        stmt.executeUpdate();
    }

    public ResultSet getDoctor(long id) throws SQLException{
        PreparedStatement stmt = connection.prepareStatement(
                "SELECT * FROM doctors WHERE id = ?"
        );
        stmt.setLong(1, id);
        return stmt.executeQuery();
    }

    public long findDoctorByName(String firstName, String lastName) throws SQLException {
        PreparedStatement stmt = connection.prepareStatement("" +
                "SELECT id FROM doctors WHERE " +
                "lower(firstName) = lower(?) AND lower(lastName) = lower(?)"
        );
        stmt.setString(1, firstName);
        stmt.setString(2, lastName);
        ResultSet rs = stmt.executeQuery();
        if(rs.next()){
            return rs.getLong("id");
        }
        return -1;
    }


    // NURSES
    public void addNurse(Nurse nurse) throws SQLException {
        PreparedStatement stmt = connection.prepareStatement("INSERT INTO doctors VALUES" +
                "(?, ?, ?, ?, ?, ?, ?, SHA1(?), ?, ?)");
        stmt.setLong(1, nurse.getId());
        stmt.setString(2, nurse.getFirstName());
        stmt.setString(3, nurse.getLastName());
        stmt.setLong(4, nurse.getCNP());
        stmt.setString(5, nurse.getDateOfBirth());
        stmt.setString(6, nurse.getPhoneNumber());
        stmt.setString(7, nurse.getEmailAddress());
        stmt.setString(8, nurse.getPassword());
        stmt.setDouble(9, nurse.getSalary());
        stmt.setDate(10, nurse.getHireDate());
        stmt.executeUpdate();
    }

    public ResultSet getNurse(long id) throws SQLException{
        PreparedStatement stmt = connection.prepareStatement(
                "SELECT * FROM nurses WHERE id = ?"
        );
        stmt.setLong(1, id);
        return stmt.executeQuery();
    }


    // CENTERS
    public ResultSet getCenter(long id) throws SQLException{
        PreparedStatement stmt = connection.prepareStatement(
                "SELECT * FROM centers WHERE id = ?"
        );
        stmt.setLong(1, id);
        return stmt.executeQuery();
    }

    public long findCenterByName(String name) throws SQLException{
        PreparedStatement stmt = connection.prepareStatement("" +
                "SELECT id FROM centers WHERE lower(name) = lower(?)"
        );
        stmt.setString(1, name);
        ResultSet rs = stmt.executeQuery();
        if(rs.next()){
            return rs.getLong("id");
        }
        return -1;
    }


    // APPOINTMENT
    public ResultSet getAppointment(long id) throws SQLException{
        PreparedStatement stmt = connection.prepareStatement(
                "SELECT * FROM appointments WHERE id = ?"
        );
        stmt.setLong(1, id);
        return stmt.executeQuery();
    }

    public void addPendingAppointment(Appointment appointment) throws SQLException {
        PreparedStatement stmt = connection.prepareStatement(
                "INSERT INTO appointments VALUES" + "(?, ?, NULL, NULL, ?, ?, ?, NULL, ?)");
        stmt.setLong(1, appointment.getId());
        stmt.setLong(2, appointment.getPatient().getId());
        stmt.setDate(3, appointment.getDate());
        stmt.setLong(4, appointment.getMedicalCenter().getId());
        stmt.setString(5, appointment.getPatientIssueDescription());
        stmt.setString(6, appointment.getStatus());
        stmt.executeUpdate();
    }

    public ResultSet getFirstPendingAppointment() throws SQLException {
        String query = "SELECT * FROM appointments WHERE status = 'pending' ORDER BY date LIMIT 1";
        return connection.createStatement().executeQuery(query);

//        query = "SELECT * FROM appointments WHERE status = 'pending' ORDER BY date LIMIT 1";
//
//        if(rs.next()){
//            PreparedStatement stmt = connection.prepareStatement("DELETE FROM appointments WHERE id = ?");
//            stmt.setLong(1, rs.getLong("id"));
//            stmt.executeUpdate();
//        }

    }

    public void updateAppointment(long id, Appointment appointment) throws SQLException {
        PreparedStatement stmt = connection.prepareStatement(
                "UPDATE appointments SET " +
                        "patient_id = ?," +
                        "doctor_id = ?," +
                        "nurse_id = ?," +
                        "date = ?," +
                        "center_id = ?," +
                        "issueDescription = ?," +
                        "response_id = ?," +
                        "status = ?" +
                        "WHERE id = ? "
        );
        stmt.setLong(1, appointment.getPatient().getId());
        stmt.setLong(2, appointment.getDoctor().getId());
        stmt.setLong(3, appointment.getNurse().getId());
        stmt.setDate(4, appointment.getDate());
        stmt.setLong(5, appointment.getMedicalCenter().getId());
        stmt.setString(6, appointment.getPatientIssueDescription());
        Response resp = appointment.getResponse();
        if(resp == null)
            stmt.setNull(7, Types.BIGINT);
        else
            stmt.setLong(7, appointment.getResponse().getId());
        stmt.setString(8, appointment.getStatus());
        stmt.setLong(9, id);
        stmt.executeUpdate();
    }

    public ResultSet pollUserFirstAppointment(long id) throws SQLException {
//        PreparedStatement stmt = connection.prepareStatement(
//                "SELECT id FROM appointments WHERE" +
//                        "patient_id = ? or" +
//                        "doctor_id = ? or" +
//                        "nurse_id = ? ORDER BY date LIMIT 1"
//        );
//        stmt.setLong(1, id);
//        stmt.setLong(2, id);
//        stmt.setLong(3, id);
//        ResultSet rs = stmt.executeQuery();

        PreparedStatement stmt = connection.prepareStatement(
                "SELECT * FROM appointments WHERE status = 'assigned' AND " +
                        "(patient_id = ? or " +
                        "doctor_id = ? or " +
                        "nurse_id = ?) ORDER BY date LIMIT 1"
        );
        stmt.setLong(1, id);
        stmt.setLong(2, id);
        stmt.setLong(3, id);

//        if(rs.next()){
//            stmt = connection.prepareStatement(
//                    "DELETE FROM appointments WHERE id = ?"
//            );
//            stmt.setLong(1, rs.getLong("id"));
//            stmt.executeUpdate();
//        }

        return stmt.executeQuery();
    }

    public ResultSet getUpcomingAppointments(long id) throws SQLException{
        PreparedStatement stmt = connection.prepareStatement(
                "SELECT * FROM appointments WHERE " +
                        "status = 'assigned' AND " +
                        "(patient_id = ? or " +
                        "doctor_id = ? or " +
                        "nurse_id = ?) ORDER BY date"
        );
        stmt.setLong(1, id);
        stmt.setLong(2, id);
        stmt.setLong(3, id);
        return stmt.executeQuery();
    }

    public ResultSet getAppointmentHistoryIds(long id) throws SQLException {
        PreparedStatement stmt = connection.prepareStatement(
                "SELECT id FROM appointments WHERE patient_id = ? AND status = 'completed'"
        );
        stmt.setLong(1, id);
        return stmt.executeQuery();
    }

    // RESPONSES
    public ResultSet getResponse(long id) throws SQLException{
        PreparedStatement stmt = connection.prepareStatement(
                "SELECT * FROM responses WHERE id = ?"
        );
        stmt.setLong(1, id);
        return stmt.executeQuery();
    }

    public void addResponse(Response response) throws SQLException{
        PreparedStatement stmt = connection.prepareStatement(
                "INSERT INTO responses VALUE (?, ?, ?)"
        );
        stmt.setLong(1, response.getId());
        stmt.setString(2, response.getDescription());
        stmt.setLong(3, response.getBill().getId());
        stmt.executeUpdate();
    }


    // DRUGS
    public ResultSet getDrug(long id) throws SQLException{
        PreparedStatement stmt = connection.prepareStatement(
                "SELECT * FROM drugs WHERE id = ?"
        );
        stmt.setLong(1, id);
        return stmt.executeQuery();
    }

    public long findDrugByName(String name) throws SQLException{
        PreparedStatement stmt = connection.prepareStatement("" +
                "SELECT id FROM drugs WHERE " +
                "lower(name) = lower(?)"
        );
        stmt.setString(1, name);
        ResultSet rs = stmt.executeQuery();
        if(rs.next()){
            return rs.getLong("id");
        }
        return -1;
    }


    // BILLS
    public ResultSet getBill(long id) throws SQLException{
        PreparedStatement stmt = connection.prepareStatement(
                "SELECT * FROM bills WHERE id = ?"
        );
        stmt.setLong(1, id);
        return stmt.executeQuery();
    }

    public void addBill(Bill bill) throws SQLException{
        PreparedStatement stmt = connection.prepareStatement(
                "INSERT INTO bills VALUE (?, ?, ?)"
        );
        stmt.setLong(1, bill.getId());
        stmt.setInt(2, (int) bill.getTotal());
        stmt.setDate(3, bill.getDate());
        stmt.executeUpdate();
    }


    // BILLS_DRUGS
    public ResultSet getBillsDrugs(long id) throws SQLException{
        PreparedStatement stmt = connection.prepareStatement(
                "SELECT * FROM bills_drugs WHERE id_bill = ?"
        );
        stmt.setLong(1, id);
        return stmt.executeQuery();
    }

    public void addBillDrug(long id_bill, long id_drug) throws SQLException{
        PreparedStatement stmt = connection.prepareStatement(
                "INSERT INTO bills_drugs VALUE (?, ?)"
        );
        stmt.setLong(1, id_bill);
        stmt.setLong(2, id_drug);
        stmt.executeUpdate();
    }


    // DRUGS_INGREDIENTS
    public ResultSet getDrugIngredients(long id) throws SQLException{
        PreparedStatement stmt = connection.prepareStatement(
                "SELECT * FROM drugs_ingredients WHERE id_drug = ?"
        );
        stmt.setLong(1, id);
        return stmt.executeQuery();
    }


    // RESPONSES_TREATMENTS
    public ResultSet getResponseTreatment(long id) throws SQLException{
        PreparedStatement stmt = connection.prepareStatement(
                "SELECT * FROM responses_treatments WHERE response_id = ?"
        );
        stmt.setLong(1, id);
        return stmt.executeQuery();
    }

    public void addResponseTreatment(long id_response, long id_drug, Integer value) throws SQLException {
        PreparedStatement stmt = connection.prepareStatement(
                "INSERT INTO responses_treatments VALUE (?, ?, ?)"
        );
        stmt.setLong(1, id_response);
        stmt.setLong(2, id_drug);
        stmt.setInt(3, value);
        stmt.executeUpdate();
    }


    // USERS
    public long findUserIdByMail(String email) throws SQLException {
        PreparedStatement stmt = connection.prepareStatement(
                "SELECT COUNT(*) FROM doctors WHERE emailAddress = ?"
        );
        stmt.setString(1, email);
        ResultSet rs = stmt.executeQuery();
        rs.next();
        if(rs.getInt(1) > 0){
            // exista un doctor cu acel email
            PreparedStatement stmt2 = connection.prepareStatement(
                    "SELECT id FROM doctors WHERE emailAddress = ? LIMIT 1"
            );
            stmt2.setString(1, email);
            ResultSet rs2 = stmt2.executeQuery();
            rs2.next();
            return rs2.getLong("id");
        }

        stmt = connection.prepareStatement(
                "SELECT COUNT(*) FROM nurses WHERE emailAddress = ?"
        );
        stmt.setString(1, email);
        rs = stmt.executeQuery();
        rs.next();
        if(rs.getInt(1) > 0){
            // exista un nurse cu acel email
            PreparedStatement stmt2 = connection.prepareStatement(
                    "SELECT id FROM nurses WHERE emailAddress = ? LIMIT 1"
            );
            stmt2.setString(1, email);
            ResultSet rs2 = stmt2.executeQuery();
            rs2.next();
            return rs2.getLong("id");
        }

        stmt = connection.prepareStatement(
                "SELECT COUNT(*) FROM patients WHERE emailAddress = ?"
        );
        stmt.setString(1, email);
        rs = stmt.executeQuery();
        rs.next();
        if(rs.getInt(1) > 0){
            // exista un pacient cu acel email
            PreparedStatement stmt2 = connection.prepareStatement(
                    "SELECT id FROM patients WHERE emailAddress = ? LIMIT 1"
            );
            stmt2.setString(1, email);
            ResultSet rs2 = stmt2.executeQuery();
            rs2.next();
            return rs2.getLong("id");
        }
        return -1;
    }


    // LOGIN
    public int verifyInfoPatient(long userId, String email, String password) throws SQLException{
        PreparedStatement stmt = connection.prepareStatement(
                "SELECT COUNT(*) FROM patients WHERE emailAddress = ? AND password = SHA1(?)"
        );
        stmt.setString(1, email);
        stmt.setString(2, password);
        ResultSet rs = stmt.executeQuery();
        rs.next();
        return rs.getInt(1);
    }
    public int verifyInfoDoctor(long userId, String email, String password) throws SQLException{
        PreparedStatement stmt = connection.prepareStatement(
                "SELECT COUNT(*) FROM doctors WHERE emailAddress = ? AND password = SHA1(?)"
        );
        stmt.setString(1, email);
        stmt.setString(2, password);
        ResultSet rs = stmt.executeQuery();
        rs.next();
        return rs.getInt(1);
    }
    public int verifyInfoNurse(long userId, String email, String password) throws SQLException{
        PreparedStatement stmt = connection.prepareStatement(
                "SELECT COUNT(*) FROM nurses WHERE emailAddress = ? AND password = SHA1(?)"
        );
        stmt.setString(1, email);
        stmt.setString(2, password);
        ResultSet rs = stmt.executeQuery();
        rs.next();
        return rs.getInt(1);
    }
}
