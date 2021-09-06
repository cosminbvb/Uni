package services;

import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

public final class CSV {

    private CSV(){}

    public static void writeCSV(String file, String data){
        try{
            FileWriter fileWriter = new FileWriter("data/"+file, true); // append = true
            fileWriter.write(data + "\n");
            fileWriter.close();
        } catch (IOException e){
            System.out.println(file + "failed to open\n");
        }
    }

    public static List<String []> readCSV(String file){
        List<String []> content = null;
        try{
            content = Files.readAllLines(Paths.get("data/"+file)).stream().
                    map(line -> line.split(",")).collect(Collectors.toList());
        } catch (IOException e){
            e.printStackTrace();
        }
        return content;
    }

    public static void updateCSV(String file, String oldData, String newData) throws IOException {
        Path path = Paths.get("data/"+file);
        //find the line number of the oldData (line number indexed from 1)
        int lineNumber = 1;
        List<String> lines = Files.readAllLines(path);
        for (String line : lines){
            if (line.equals(oldData))
                break;
            else
                lineNumber++;
        }
        //update the file:
        if(lineNumber <= lines.size()){
            lines.set(lineNumber - 1, newData);
            Files.write(path, lines);
        }
    }

}
