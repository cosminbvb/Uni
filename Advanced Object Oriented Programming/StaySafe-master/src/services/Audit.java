package services;

import java.io.FileWriter;
import java.io.IOException;
import java.sql.Timestamp;

public class Audit {

    public static Audit instance = null;

    public static Audit getInstance(){
        if (instance == null){
            instance = new Audit();
        }
        return instance;
    }

    public void log(String action){
        try {
            FileWriter fileWriter = new FileWriter("data/log.csv", true); // append = true
            Timestamp timestamp = new Timestamp(System.currentTimeMillis());
            fileWriter.write(action + ", " + timestamp.toString() + ", " + Thread.currentThread().getName() + "\n");
            fileWriter.close();
        } catch (IOException e) {
            System.out.println("Couldn't open the log file.");
        }
    }

}
