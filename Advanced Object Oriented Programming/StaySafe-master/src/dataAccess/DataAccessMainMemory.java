package dataAccess;

import models.*;
import services.CSV;

import java.io.IOException;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

// stores the relevant data in the main memory and uses csv files for persistence
// meanwhile DataAccessDatabase uses a database and does not store any heavy data in the main memory
public class DataAccessMainMemory implements DataAccess {

    private static DataAccessMainMemory instance = null;

    private List<User> allUsers = new ArrayList<>();
    private List<Patient> patients = new ArrayList<>();
    private List<Doctor> doctors = new ArrayList<>();
    private List<Nurse> nurses = new ArrayList<>();
    private List<MedicalCenter> centers = new ArrayList<>();
    private List<Drug> drugs = new ArrayList<>();
    private final TreeSet<Appointment> pendingAppointments = new TreeSet<>();
    //these represent the requested but not yet assigned to doctors and nurses appointments
    //fifo => they need to be ordered by date

    public static DataAccessMainMemory getInstance(){
        if(instance == null){
            instance = new DataAccessMainMemory();
        }
        return instance;
    }
    private DataAccessMainMemory(){
        loadDatabase();
    }

    // used at step 1
    private void initializeDatabase(){
        Patient p1 = new Patient(1,"Cosmin", "Petrescu", 5000000111111L, "05.09.2000",
                "0728000001", "cosmin.petrescu@my.fmi.unibuc.ro", "password1");
        Patient p2 = new Patient(2, "Tudor", "Plescaru", 5000000111121L, "09.11.2000",
                "0728000002", "tudor.plescaru@my.fmi.unibuc.ro", "password2");
        Patient p3 = new Patient(3, "Daniel", "Vlascenco", 5000000111131L, "29.01.2000",
                "0728000003", "daniel.vlascenco@my.fmi.unibuc.ro", "password3");

        patients.add(p1);
        patients.add(p2);
        patients.add(p3);
        allUsers.add(p1);
        allUsers.add(p2);
        allUsers.add(p3);

        for (Patient p : patients){
            CSV.writeCSV("patients.csv", p.getCSV());
        }

        Doctor d1 = new Doctor(4, "Andrei", "Pantea", 5000000111141L, "05.09.2000",
                "0728000004", "andrei.pantea@doctor.ro", "password4", "Cardio",
                5000, LocalDate.now());
        Doctor d2 = new Doctor(5, "Meredith", "Grey", 5000000111142L, "05.09.2000",
                "0728000005", "meredith.grey@doctor.ro", "password5", "Neuro",
                6000, LocalDate.now());

        doctors.add(d1);
        doctors.add(d2);
        allUsers.add(d1);
        allUsers.add(d2);

        for (Doctor d : doctors){
            CSV.writeCSV("doctors.csv", d.getCSV());
        }

        Nurse n1 = new Nurse(6, "Andreea", "Ionescu", 5000000111152L, "05.09.2000",
                "0728000006", "andreea.ionescu@nurse.ro", "password6", LocalDate.now(), 3000);

        Nurse n2 = new Nurse(7, "Ion", "Popescu", 5000000111161L, "05.09.2000",
                "0728000007", "ion.popescu@nurse.ro", "password7", LocalDate.now(), 3000);

        nurses.add(n1);
        nurses.add(n2);
        allUsers.add(n1);
        allUsers.add(n2);


        for (Nurse n : nurses){
            CSV.writeCSV("nurses.csv", n.getCSV());
        }


        MedicalCenter c1 = new MedicalCenter(1,"Spitalul Judetean", "Ploiesti", "Strada Spitalului nr 1", 1000);

        MedicalCenter c2 = new MedicalCenter(2,"Clinica Petrolul", "Ploiesti", "Bulevardul Republicii nr 21", 150);

        centers.add(c1);
        centers.add(c2);


        for(MedicalCenter mc : centers){
            CSV.writeCSV("centers.csv", mc.getCSV());
        }


        Drug drug1 = new Drug(1, "Nurofan", "Pfozar", 20,
                "Nurofan 400 mg drajeuri calmează eficace un spectru larg de dureri acute.",
                new HashMap<String, Double>(){{
                    put("Ibuprofen", 400.0);
                    put("Zahar", 0.0);
                    put("Glucoza", 0.0);
                }});

        Drug drug2 = new Drug(2, "Aspantar", "Pfozar", 30,
                """
                        Aspantar actioneaza prin prevenirea formarii cheagurilor de sange si este utilizat pentru:
                        prevenirea repetarii infarctului miocardic si a accidentului vascular cerebral """,
                new HashMap<String, Double>(){{
                    put("Acid acetilsalicilic", 75.0);
                    put("Celuloza microcristalina", 5.0);
                    put("Amidon pregelatinizat", 3.0);
                }});

        drugs.add(drug1);
        drugs.add(drug2);

        for (Drug d : drugs){
            CSV.writeCSV("drugs.csv", d.getCSV());
            for (Map.Entry<String, Double> entry : d.getIngredients().entrySet()){
                String data = d.getId() + "," + entry.getKey() + "," + entry.getValue();
                CSV.writeCSV("drugs_ingredients.csv", data);
            }
        }

    }

    // used at step 2 (loading data from csv)
    private void loadDatabase(){
        List<String []> data = CSV.readCSV("patients.csv");
        patients = data.stream().map(line -> new Patient(Long.parseLong(line[0]),
                line[1], line[2], Long.parseLong(line[3]), line[4], line[5], line[6], line[7]))
                .collect(Collectors.toList());
        // build the objects and put them in the list

        long userLastId = patients.get(patients.size()-1).getId(); // remembering the last id (also the biggest one)

        data = CSV.readCSV("doctors.csv");
        doctors = data.stream().map(line -> new Doctor(Long.parseLong(line[0]), line[1],
                line[2], Long.parseLong(line[3]), line[4], line[5], line[6], line[7],
                line[8], Double.parseDouble(line[9]), LocalDate.parse(line[10])))
                .collect(Collectors.toList());

        userLastId = Math.max(userLastId, doctors.get(doctors.size()-1).getId());
        // since all the users share the same id generator, we need to find the biggest id
        // towards all types of users

        data = CSV.readCSV("nurses.csv");
        nurses = data.stream().map(line -> new Nurse(Long.parseLong(line[0]), line[1],
                line[2], Long.parseLong(line[3]), line[4], line[5], line[6], line[7],
                LocalDate.parse(line[9]), Double.parseDouble(line[8])))
                .collect(Collectors.toList());

        userLastId = Math.max(userLastId, nurses.get(nurses.size()-1).getId());
        User.setNextId(userLastId + 1); // set the next User id

        // finally, concatenate all types of users into a single additional list
        allUsers = Stream.concat(patients.stream(), doctors.stream()).collect(Collectors.toList());
        allUsers = Stream.concat(allUsers.stream(), nurses.stream()).collect(Collectors.toList());


        data = CSV.readCSV("centers.csv");
        centers = data.stream().map(line -> new MedicalCenter(Long.parseLong(line[0]),
                line[1], line[2], line[3], Long.parseLong(line[4])))
                .collect(Collectors.toList());

        MedicalCenter.setNextId(centers.get(centers.size()-1).getId() + 1);


        data = CSV.readCSV("drugs.csv");
        List<String []> ingredientsData = CSV.readCSV("drugs_ingredients.csv");
        for (String[] line : data){
            long id = Long.parseLong(line[0]);
            List<String []> ingredients = ingredientsData.stream().filter(l -> Long.parseLong(l[0]) == id)
                    .collect(Collectors.toList());
            // now ingredients is a list of string arrays, each array containing a drug id an ingredient name and the quantity
            HashMap<String, Double> ingredientsMap = new HashMap<>();
            // build the ingredient -> quantity map
            for (String[] ingr : ingredients){
                String name = ingr[1];
                Double quantity = Double.parseDouble(ingr[2]);
                ingredientsMap.put(name, quantity);
            }
            // build the drug and add it to the list
            Drug drug = new Drug(id, line[1], line[2], Double.parseDouble(line[3]), line[4], ingredientsMap);
            drugs.add(drug);
        }
        Drug.setNextId(Long.parseLong(data.get(data.size()-1)[0]) + 1);


        data = CSV.readCSV("appointments.csv");
        List<String []> responses = CSV.readCSV("responses.csv");
        List<String[]> bills = CSV.readCSV("bills.csv");
        List<String[]> treatments = CSV.readCSV("response_treatments.csv");
        List<String[]> billsDrugs = CSV.readCSV("bill_drugs.csv");
        for (String[] line : data){
            long id = Long.parseLong(line[0]);

            long patientId = Long.parseLong(line[2]);
            String status = line[1];
            Patient patient = (Patient) findUserById(patientId);

            long centerId = Long.parseLong(line[6]);
            MedicalCenter mc = findMedicalCenterById(centerId);

            Appointment appointment = new Appointment(id, patient, LocalDate.parse(line[5]), mc, line[7], status);

            Doctor doctor = null;
            Nurse nurse = null;
            Response response = null;

            if (status.equals("assigned") || status.equals("completed")){
                long doctorId = Long.parseLong(line[3]);
                doctor = (Doctor) findUserById(doctorId);
                long nurseId = Long.parseLong(line[4]);
                nurse = (Nurse) findUserById(nurseId);
                appointment.setDoctor(doctor);
                appointment.setNurse(nurse);
                if (status.equals("assigned")){
                    doctor.addUpcomingAppointment(appointment);
                    nurse.addUpcomingAppointment(appointment);
                    patient.addUpcomingAppointment(appointment);
                }
            }
            else{
                pendingAppointments.add(appointment);
            }
            if (status.equals("completed")){
                // read response with the coresponding id
                long responseId = Long.parseLong(line[8]);
                String[] resp = responses.stream().filter(x -> Long.parseLong(x[0]) == responseId).collect(Collectors.toList()).get(0);

                // build the treatment plan:
                List<String []> plan = treatments.stream().filter(l -> Long.parseLong(l[0]) == responseId)
                        .collect(Collectors.toList());
                HashMap<Drug, Integer> treatmentPlan = new HashMap<>();
                // build the ingredient -> quantity map
                for (String[] p : plan){
                    long drugId = Long.parseLong(p[1]);
                    Drug drug = findDrugById(drugId);
                    Integer interval = Integer.parseInt(p[2]);
                    treatmentPlan.put(drug, interval);
                }

                // in order to construct the response, we first have to build the bill
                // and the treatment plan
                long billId = Long.parseLong(resp[2]);
                String[] bill = bills.stream().filter(x -> Long.parseLong(x[0]) == billId).collect(Collectors.toList()).get(0);

                // build the drug list for the bill
                List<Drug> billDrugList = new ArrayList<>();
                List<String[]> drugsStrings = billsDrugs.stream().filter(l -> Long.parseLong(l[0]) == billId)
                        .collect(Collectors.toList());
                for(String[] d : drugsStrings){
                    Drug drug = findDrugById(Long.parseLong(d[1]));
                    billDrugList.add(drug);
                }

                Bill finalBill = new Bill(Long.parseLong(bill[0]), billDrugList, LocalDate.parse(bill[2]));

                response = new Response(responseId, resp[1], treatmentPlan, finalBill);
                appointment.setResponse(response);

                patient.addToHistory(appointment);
            }
        }
        // set the next id for each class
        if (data.size() > 0)
            Appointment.setNextId(Long.parseLong(data.get(data.size()-1)[0]) + 1);
        else
            Appointment.setNextId(1);
        if (responses.size() > 0)
            Response.setNextId(Long.parseLong(responses.get(responses.size()-1)[0]) + 1);
        else
            Response.setNextId(1);
        if (bills.size() > 0)
            Bill.setNextId(Long.parseLong(bills.get(bills.size()-1)[0]) + 1);
        else
            Bill.setNextId(1);
    }

    @Override
    public void addPatient(Patient patient){
        patients.add(patient);
        CSV.writeCSV("patients.csv", patient.getCSV());
    }

    @Override
    public void addDoctor(Doctor doctor){
        doctors.add(doctor);
        CSV.writeCSV("doctors.csv", doctor.getCSV());
    }

    @Override
    public void addNurse(Nurse nurse){
        nurses.add(nurse);
        CSV.writeCSV("nurses.csv", nurse.getCSV());
    }

    @Override
    public void addUser(User user){
        allUsers.add(user);
    }

    @Override
    public void addPendingAppointment(Appointment appointment){
        pendingAppointments.add(appointment);
        CSV.writeCSV("appointments.csv", appointment.getCSV());
    }

    @Override
    public Appointment getFirstPendingAppointment(){
        // retrieve and remove
        return pendingAppointments.pollFirst();
    }

    @Override
    public void updateAppointment(String oldData, Appointment appointment){
        // update the appointment details in the csv file
        try {
            CSV.updateCSV("appointments.csv", oldData, appointment.getCSV());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Appointment getUserFirstUpcomingAppointment(User user){
        // retrieve and remove
        return user.getUpcomingAppointments().pollFirst();
    }

    @Override
    public void addBillDrug(Bill bill, Drug drug){
        CSV.writeCSV("bill_drugs.csv", bill.getId() + "," + drug.getId());
    }

    @Override
    public void addBill(Bill bill){
        CSV.writeCSV("bills.csv", bill.getCSV());
    }

    @Override
    public void addResponseTreatments(Response response, Drug drug, Integer value){
        CSV.writeCSV("response_treatments.csv", response.getId() + ","
                + drug.getId() + "," + value);
    }

    @Override
    public void addResponse(Response response){
        CSV.writeCSV("responses.csv", response.getCSV());
    }

    // find user by email:
    @Override
    public User findUser(String email){
        for(User user : allUsers){
            if(Objects.equals(user.getEmailAddress(), email))
                return user;
        }
        return null;
    }

    // find center by name:
    @Override
    public MedicalCenter findCenter(String name){
        for(MedicalCenter center : centers){
            if(Objects.equals(center.getName().toLowerCase(Locale.ROOT), name.toLowerCase(Locale.ROOT)))
                return center;
        }
        return null;
    }

    // find doctor by name:
    @Override
    public Doctor findDoctor(String firstName, String lastName){
        for(Doctor doc : doctors){
            //TODO: search after transforming to lowercase
            if(Objects.equals(doc.getFirstName(), firstName) && Objects.equals(doc.getLastName(), lastName))
                return doc;
        }
        return null;
    }

    // find drug by name:
    @Override
    public Drug findDrug(String name){
        for(Drug drug : drugs){
            //TODO: search after transforming to lowercase
            if(Objects.equals(drug.getName(), name))
                return drug;
        }
        return null;
    }

    @Override
    public User findUserById(long id){
        for(User user : allUsers){
            if(user.getId() == id)
                return user;
        }
        return null;
    }

    @Override
    public MedicalCenter findMedicalCenterById(long id){
        for(MedicalCenter m : centers){
            if(m.getId() == id)
                return m;
        }
        return null;
    }

    @Override
    public Drug findDrugById(long id){
        for(Drug d : drugs){
            if (d.getId() == id){
                return d;
            }
        }
        return null;
    }

    // verify login info:
    @Override
    public boolean verifyInfo(User user, String email, String password){
        return Objects.equals(user.getEmailAddress(), email) && Objects.equals(user.getPassword(), password);
    }

    @Override
    public TreeSet<Appointment> getAppointmentHistory(Patient patient){
        return patient.getAppointmentsHistory();
    }

    @Override
    public TreeSet<Appointment> getUpcomingAppointments(User user){
        return user.getUpcomingAppointments();
    }

}
