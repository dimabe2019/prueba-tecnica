package karate.utils;

import java.io.IOException;
import java.nio.file.*;
import java.util.*;

public class CSVModificar {

    public static boolean modifyDueDate(String filePath, String nuevaFecha) {
        try {
            List<String> lineas = Files.readAllLines(Paths.get(filePath));
            List<String> resultado = new ArrayList<>();

            if (lineas.isEmpty()) {
                System.out.println("El archivo está vacío");
                return false;
            }

            String encabezado = lineas.get(0);
            String[] columnas = encabezado.split(",");

            int indiceFecha = -1;
            for (int i = 0; i < columnas.length; i++) {
                if (columnas[i].trim().equalsIgnoreCase("fecha_vencimiento")) {
                    indiceFecha = i;
                    break;
                }
            }

            if (indiceFecha == -1) {
                System.err.println("No se encontró la columna 'fecha_vencimiento'.");
                return false;
            }

            resultado.add(encabezado);

            for (int i = 1; i < lineas.size(); i++) {
                String[] datos = lineas.get(i).split(",");
                if (datos.length <= indiceFecha) {
                    System.err.println("La línea no contiene suficientes columnas: " + lineas.get(i));
                    continue;
                }
                datos[indiceFecha] = nuevaFecha;
                resultado.add(String.join(",", datos));
            }

            Files.write(Paths.get(filePath), resultado);
            System.out.println("Archivo modificado correctamente.");
            return true;

        } catch (IOException e) {
            System.err.println("Error al modificar el archivo: " + e.getMessage());
            return false;
        }
    }
}



