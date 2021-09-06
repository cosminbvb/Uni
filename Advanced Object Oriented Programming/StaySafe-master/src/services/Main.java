package services;

import java.util.Scanner;

public class Main {

    public static void main(String[] args) {

        StaySafe app = StaySafe.getInstance();
        Audit audit = Audit.getInstance();

        listCommands();

        Scanner input = new Scanner(System.in);
        while(true){

            System.out.println("Enter command code (enter 0 to look at them again):");
            int commandCode = Integer.parseInt(input.nextLine());

            switch (commandCode) {
                case 0 -> { listCommands(); audit.log("List commands"); }
                case 1 -> { app.signUp(); audit.log("Sign up"); }
                case 2 -> { app.logIn(); audit.log("Sign in"); }
                case 3 -> { app.logOut(); audit.log("Sign out"); }
                case 4 -> { app.searchCenter(); audit.log("Search center"); }
                case 5 -> { app.searchDoctor(); audit.log("Search doctor"); }
                case 6 -> { app.getUpcomingAppointments(); audit.log("See upcoming appointments"); }
                case 7 -> { System.exit(1); audit.log("Exit"); }
                case 8 -> { app.requestAppointment(); audit.log("Request appointment"); }
                case 9 -> { app.getAppointmentHistory(); audit.log("See appointments history"); }
                case 10 -> { app.processAppointment(); audit.log("Process appointment"); }
                case 11 -> { app.searchDrug(); audit.log("Search drug"); }
                case 12 -> { app.giveResponse(); audit.log("Doctor - give response"); }
            }

        }
    }

    private static void listCommands(){
        System.out.println("----Available commands----\n");
        System.out.println("--General commands:");
        System.out.println("0. Help");
        System.out.println("1. Sign up");
        System.out.println("2. Log in");
        System.out.println("3. Log out");
        System.out.println("4. Search Medical Center");
        System.out.println("5. Search Doctor");
        System.out.println("6. See your upcoming appointments");
        System.out.println("7. Exit");

        System.out.println("--Patients only commands:");
        System.out.println("8. Request an appointment");
        System.out.println("9. See your appointments history");

        System.out.println("--Staff only commands:");
        System.out.println("10. Process Appointment");
        System.out.println("11. Search Drug");
        System.out.println("12. Give response");
    }

}
