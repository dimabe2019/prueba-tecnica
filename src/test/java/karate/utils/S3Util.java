package karate.utils;

public class S3Util {
    public void uploadFileToBucket(String bucket, String folder, String fileName, String localPath) {
        System.out.println("Simulación de carga: " + bucket + "/" + folder + "/" + fileName + " desde " + localPath);
    }
}
