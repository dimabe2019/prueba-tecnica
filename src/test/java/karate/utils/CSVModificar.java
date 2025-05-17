package karate.utils;

import java.nio.file.*;
import java.util.*;

public class CSVModificar {

    public static boolean modifyDueDate(String filePath, String newDueDate) {
        try {
            List<String> lines = Files.readAllLines(Paths.get(filePath));
            List<String> updated = new ArrayList<>();

            int dueDateIndex = -1;
            String[] headers = lines.get(0).split(",");
            for (int i = 0; i < headers.length; i++) {
                if (headers[i].trim().equalsIgnoreCase("fecha_vencimiento")) {
                    dueDateIndex = i;
                    break;
                }
            }

            if (dueDateIndex == -1) throw new RuntimeException("No se encontró la columna 'fecha_vencimiento'");

            updated.add(lines.get(0)); // encabezado
            for (int i = 1; i < lines.size(); i++) {
                String[] cols = lines.get(i).split(",");
                cols[dueDateIndex] = newDueDate;
                updated.add(String.join(",", cols));
            }

            Files.write(Paths.get(filePath), updated);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
