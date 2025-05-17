package karate.utils;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

public class FileUtils {
    public static File renameFile(String currentPath, String fileName, String newPath, String uuid, String ext) {
        File originalFile = new File(currentPath + File.separator + fileName);
        File renamedFile = new File(newPath + File.separator + uuid + ext);

        try {
            Files.copy(originalFile.toPath(), renamedFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            return renamedFile;
        } catch (IOException e) {
            System.err.println("Error al renombrar el archivo: " + e.getMessage());
            return null;
        }
    }
}
