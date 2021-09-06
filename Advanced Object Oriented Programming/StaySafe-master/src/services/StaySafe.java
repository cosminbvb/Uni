package services;

import models.*;
import dataAccess.DataAccess;
import dataAccess.DataAccessDatabase;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.*;

public class StaySafe {

    // for database storage:
    DataAccess dataAccess = DataAccessDatabase.getInstance();

    // for main memory storage + CSV persistence:
    // DataAccess dataAccess = DataAccessMainMemory.getInstance();

    private static StaySafe instance = null;

    private User user = null;

    public static StaySafe getInstance(){
        if(instance == null)
            instance = new StaySafe();
        return instance;
    }

    private StaySafe(){}

    public void signUp(){
        if(user != null){
            System.out.println("You are already logged in.\n");
            return;
        }
        System.out.println("Sign Up");
        Scanner input = new Scanner(System.in);
        System.out.println("Types of users: 1 - Patient, 2 - Doctor, 3 - Nurse\nEnter user code: ");
        int userCode = Integer.parseInt(input.nextLine());
        User newUser = null;

        // shared attributes:
        System.out.println("First name: ");
        String firstName = input.nextLine();
        System.out.println("Last name: ");
        String lastName = input.nextLine();
        System.out.println("CNP: ");
        long cnp = Long.parseLong(input.nextLine());
        System.out.println("Date of birth: ");
        String dateOfBirth = input.nextLine();
        System.out.println("Phone number: ");
        String phoneNumber = input.nextLine();
        System.out.println("Email: ");
        String email = input.nextLine();
        System.out.println("Password: ");
        String password = input.nextLine();

        if (userCode == 1){
            newUser = new Patient(User.getNextId(), firstName, lastName, cnp, dateOfBirth, phoneNumber, email, password);
            dataAccess.addPatient((Patient)newUser);
        }

        if (userCode == 2){
            System.out.println("Speciality: ");
            String speciality = input.nextLine();
            System.out.println("Salary: ");
            double salary = Double.parseDouble(input.nextLine());
            LocalDate hireDate = LocalDate.now();
            newUser = new Doctor(User.getNextId(), firstName, lastName, cnp, dateOfBirth, phoneNumber, email, password,
                    speciality, salary, hireDate);
            dataAccess.addDoctor((Doctor) newUser);
        }

        if (userCode == 3){
            System.out.println("Salary: ");
            double salary = Double.parseDouble(input.nextLine());
            LocalDate hireDate = LocalDate.now();
            newUser = new Nurse(User.getNextId(), firstName, lastName, cnp, dateOfBirth, phoneNumber, email, password, hireDate, salary);
            dataAccess.addNurse((Nurse) newUser);
        }

        dataAccess.addUser(newUser);

        // redirect to login
        logIn();

    }

    public void logIn(){
        if(user != null){
            System.out.println("You are already logged in.\n");
            return;
        }
        System.out.println("Log In");
        Scanner input = new Scanner(System.in);

        while(true) {
            System.out.println("Email: ");
            String email = input.nextLine();
            System.out.println("Password: ");
            String password = input.nextLine();

            User loggingIn = dataAccess.findUser(email);
            if (loggingIn == null){
                System.out.println("This email doesn't exist\n");
            }
            else{
                boolean verified = dataAccess.verifyInfo(loggingIn, email, password);
                if(!verified){
                    System.out.println("Password incorrect\n");
                }
                else{
                    System.out.println("Welcome!\n");
                    user = loggingIn;
                    break;
                }
            }

        }
    }

    public void logOut(){
        if (user != null){
            user = null;
            System.out.println("Goodbye and stay safe!\n");
        }
    }

    public void searchCenter(){
        Scanner input = new Scanner(System.in);
        while (true){
            System.out.println("Enter the Medical Center's name: ");
            String name = input.nextLine();
            MedicalCenter mc = dataAccess.findCenter(name);
            if (mc == null){
                System.out.println("Center not found, press 0 to exit or 1 to try again");
                int command = Integer.parseInt(input.nextLine());
                if(command == 0)
                    break;
            }
            else{
                System.out.println(mc.toString()+"\n");
                break;
            }
        }
    }

    public void requestAppointment(){
        // users can request appointments which will be stored in pending appointments
        // until a nurse assigns it
        if (user == null) {
            System.out.println("You need to log in first (Press 2 to Log In or 1 to create a new account)");
        }
        else if (user instanceof Doctor || user instanceof Nurse) {
                System.out.println("You need to log in with a Patient account");
        }
        else {
            Scanner input = new Scanner(System.in);
            MedicalCenter mc;
            while(true) {
                System.out.println("Enter the name of the preferred center:");
                String centerName = input.nextLine();
                mc = dataAccess.findCenter(centerName);
                if (mc != null){
                    break;
                }
                else{
                    System.out.println("Center not found. Press 0 to exit or 1 to try again");
                    int command = Integer.parseInt(input.nextLine());
                    if(command == 0){
                        return;
                    }
                }
            }
            System.out.println("Start by describing the issue:");
            String description = input.nextLine();

            Appointment requested = new Appointment(Appointment.getNextId(), (Patient) user, LocalDate.now(), mc, description, "pending");
            dataAccess.addPendingAppointment(requested);
            System.out.println("Appointment requested. You will be contacted shortly, once your request has been processed\n");
        }
    }

    public void getUpcomingAppointments(){
        // every type of user can see his upcoming appointments //
        if (user == null) {
            System.out.println("You need to log in first (Press 2 to Log In or 1 to create a new account)");
        }
        else{
            //TreeSet<Appointment> upcomingAppointments = user.getUpcomingAppointments();
            TreeSet<Appointment> upcomingAppointments = dataAccess.getUpcomingAppointments(user);
            if(upcomingAppointments.size() == 0){
                System.out.println("You have no upcoming appointments\n");
            }
            else {
                System.out.println("Here are your upcoming appointments:\n");
                for (Appointment appointment : upcomingAppointments) {
                    System.out.println(appointment);
                }
            }
        }
    }

    public void getAppointmentHistory(){
        if (user == null) {
            System.out.println("You need to log in first (Press 2 to Log In or 1 to create a new account)");
        }
        else if (user instanceof Doctor || user instanceof Nurse) {
            System.out.println("You need to log in with a Patient account");
        }
        else{
            TreeSet<Appointment> history = dataAccess.getAppointmentHistory((Patient) user);
            if(history.size() == 0){
                System.out.println("You have no past appointments\n");
            }
            else{
                System.out.println("Here are you past appointments:\n");
                for(Appointment appointment : history){
                    System.out.println(appointment);
                }
            }
        }
    }

    public void processAppointment(){
        // Doctors and Nurses have the ability to process appointments
        // Meaning that a staff member will read the issue description and will
        // make an assignment based on the given description
        if (user == null) {
            System.out.println("You need to log with a staff member account\n");
        }
        else if (user instanceof Patient) {
            System.out.println("Patients not allowed\n");
        }
        else{
            Scanner input = new Scanner(System.in);
            Appointment appointment = dataAccess.getFirstPendingAppointment();
            if(appointment == null){
                System.out.println("There are no requested appointments\n");
                return;
            }
            String oldData = appointment.getCSV(); // needed when updating the CSV
            Patient patient = appointment.getPatient();
            System.out.printf("Patient: %s %s\nDescription: %s\n%n", patient.getFirstName(),
                    patient.getLastName(), appointment.getPatientIssueDescription());
            System.out.println("You must assign a doctor");
            while (true){
                System.out.println("Doctor's first name: ");
                String firstName = input.nextLine();
                System.out.println("Doctor's last name: ");
                String lastName = input.nextLine();
                Doctor doc = dataAccess.findDoctor(firstName, lastName);
                if (doc == null){
                    System.out.println("Doctor not found. Press 1 to try again or 0 to abort request processing");
                    int command = Integer.parseInt(input.nextLine());
                    if(command == 0){
                        System.out.println("Request processing aborted\n");
                        dataAccess.addPendingAppointment(appointment); // add appointment back in line
                        return;
                    }
                }
                else{
                    appointment.setDoctor(doc); // assign doctor to the current appointment
                    doc.addUpcomingAppointment(appointment); // insert it into the doctor's schedule
                    break;
                }
            }
            appointment.setNurse((Nurse) user); // assign nurse to the current appointment
            user.addUpcomingAppointment(appointment); // assuming that the nurse that is processing the request will attend it

            System.out.println("Set a date (YYYY-MM-DD):");
            String stringDate = input.nextLine();
            LocalDate date = LocalDate.parse(stringDate);
            appointment.setDate(date); // set the scheduled date of the appointment

            patient.addUpcomingAppointment(appointment); // insert it into the patient's schedule

            appointment.setStatus("assigned");

            // update appointment:
            dataAccess.updateAppointment(oldData, appointment);

            System.out.println("The request has been processed.");
            System.out.println(appointment.toString());

        }
    }

    public void searchDoctor(){
        Scanner input = new Scanner(System.in);
        while (true){
            System.out.println("Enter first name: ");
            String firstName = input.nextLine();
            System.out.println("Enter last name: ");
            String lastName = input.nextLine();
            Doctor doc = dataAccess.findDoctor(firstName, lastName);
            if (doc == null){
                System.out.println("Doctor not found. Press 0 to exit or 1 to try again");
                int command = Integer.parseInt(input.nextLine());
                if(command == 0)
                    break;
            }
            else{
                System.out.println(doc.toString()+"\n");
                break;
            }
        }
    }

    public void searchDrug(){
        if (user == null) {
            System.out.println("You need to log with a staff member account\n");
        }
        else if (user instanceof Patient) {
            System.out.println("Patients not allowed\n");
        }
        else{
            Scanner input = new Scanner(System.in);
            while (true){
                System.out.println("Enter drug name: ");
                String name = input.nextLine();
                Drug drug = dataAccess.findDrug(name);
                if (drug == null){
                    System.out.println("Drug not found. Press 0 to exit or 1 to try again");
                    int command = Integer.parseInt(input.nextLine());
                    if(command == 0)
                        break;
                }
                else{
                    System.out.println(drug.toString()+"\n");
                    break;
                }
            }
        }
    }

    public void giveResponse(){
        // Intended for staff members - here they can give a treatment and leave notes for the patient
        // This was designed for a f2f situation
        if (user == null) {
            System.out.println("You need to log with a staff member account\n");
        }
        else if (user instanceof Patient){
            System.out.println("Patients not allowed\n");
        }
        else{
            // first we need get the most recent appointment
            Appointment currentAppointment = dataAccess.getUserFirstUpcomingAppointment(user);
            if (currentAppointment == null){
                System.out.println("No upcoming appointments");
                return;
            }
            String oldData = currentAppointment.getCSV(); // needed when updating the CSV
            // construct a response:
            Scanner input = new Scanner(System.in);
            System.out.println("Enter description: ");
            String description = input.nextLine();
            HashMap<Drug, Integer> treatmentPlan = new HashMap<>();
            List<Drug> givenDrugs = new ArrayList<>(); // for the bill

            while (true){
                System.out.println("Drug name: ");
                String name = input.nextLine();
                Drug drug = dataAccess.findDrug(name);
                if (drug == null){
                    System.out.println("Drug not found, try again");
                }
                else{
                    System.out.println("Enter hour interval:");
                    int interval = Integer.parseInt(input.nextLine());
                    treatmentPlan.put(drug, interval);
                    givenDrugs.add(drug);
                    System.out.println("Press 0 to add another drug or 1 to finish");
                    int command = Integer.parseInt(input.nextLine());
                    if(command == 1)
                        break;
                }
            }

            // construct the bill
            Bill bill = new Bill(Bill.getNextId(), givenDrugs, LocalDate.now());
            dataAccess.addBill(bill);

            for(Drug drug : givenDrugs){
                dataAccess.addBillDrug(bill, drug);
            }

            Response response = new Response(Response.getNextId(), description, treatmentPlan, bill);
            dataAccess.addResponse(response);

            for(Map.Entry<Drug, Integer> e : treatmentPlan.entrySet()){
                dataAccess.addResponseTreatments(response, e.getKey(), e.getValue());
            }

            // add all the response the current appointment
            currentAppointment.setResponse(response);


            currentAppointment.setStatus("completed");

            // update the appointment
            dataAccess.updateAppointment(oldData, currentAppointment);

            // remove the appointment from the upcoming set for the doctor, nurse and patient
            // add it to the patient's history
            Patient patient = currentAppointment.getPatient();
            Doctor doctor = currentAppointment.getDoctor();
            Nurse nurse = currentAppointment.getNurse();
            patient.getUpcomingAppointments().remove(currentAppointment);
            patient.getAppointmentsHistory().add(currentAppointment);
            doctor.getUpcomingAppointments().remove(currentAppointment);
            nurse.getUpcomingAppointments().remove(currentAppointment);

            //TODO: works but need further testing

            System.out.println("Response submitted.\n");

        }
    }

}
