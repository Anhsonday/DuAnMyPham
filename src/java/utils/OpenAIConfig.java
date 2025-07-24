package utils;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Properties;

public class OpenAIConfig {
    private static final String ENV_FILE = ".env";
    private static String apiKey;
    
    static {
        loadConfig();
    }
    
    private static void loadConfig() {
        // Thử đọc từ environment variable trước
        apiKey = System.getenv("OPENAI_API_KEY");
        
        // Nếu không có trong env, đọc từ file .env trong classpath
        if (apiKey == null || apiKey.isEmpty()) {
            Properties props = new Properties();
            try {
                // Đọc từ resources trong classpath
                InputStream input = Thread.currentThread().getContextClassLoader().getResourceAsStream(ENV_FILE);
                if (input != null) {
                    props.load(input);
                    apiKey = props.getProperty("OPENAI_API_KEY");
                    input.close();
                }
            } catch (IOException e) {
                System.err.println("Không thể đọc file .env từ classpath: " + e.getMessage());
            }
        }
        
        // Log để debug
        if (apiKey != null && !apiKey.isEmpty()) {
            System.out.println("Đã tìm thấy API key");
        } else {
            System.err.println("Không tìm thấy API key trong environment variables hoặc file .env");
        }
        
        if (apiKey == null || apiKey.isEmpty()) {
            System.err.println("WARNING: OPENAI_API_KEY không được thiết lập");
        }
    }
    
    public static String getApiKey() {
        if (apiKey == null || apiKey.isEmpty()) {
            throw new RuntimeException("Không tìm thấy API key. Vui lòng tạo file .env với OPENAI_API_KEY=your_key hoặc thiết lập biến môi trường OPENAI_API_KEY.");
        }
        return apiKey;
    }
}
