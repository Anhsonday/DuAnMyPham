package com.juleswhite.module1;

import com.google.gson.JsonObject;
import com.google.gson.JsonArray;
import com.google.gson.JsonParser;
import com.google.gson.Gson;
import utils.OpenAIConfig;

import java.util.List;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class LLM {
    private final String apiKey;

    public LLM() {
        this.apiKey = OpenAIConfig.getApiKey();
    }

    public String generateResponse(List<Message> messages) {
        try {
            if (apiKey == null || apiKey.isEmpty()) {
                String errorMsg = "Không tìm thấy API key. Vui lòng tạo file .env với OPENAI_API_KEY=your_key "
                        + "hoặc thiết lập biến môi trường OPENAI_API_KEY.";
                System.err.println(errorMsg);
                throw new IllegalStateException(errorMsg);
            }
            System.out.println("Đã tìm thấy API key: " + apiKey.substring(0, 10) + "...");

            // Build JSON messages bằng Gson
            Gson gson = new Gson();
            JsonArray msgArr = new JsonArray();
            for (Message m : messages) {
                JsonObject obj = new JsonObject();
                obj.addProperty("role", m.getRole());
                obj.addProperty("content", m.getContent());
                msgArr.add(obj);
            }
            JsonObject body = new JsonObject();
            body.addProperty("model", "gpt-4o");
            body.add("messages", msgArr);
            body.addProperty("max_tokens", 1024);
            String jsonBody = gson.toJson(body);

            // Gửi request tới OpenAI API
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("https://api.openai.com/v1/chat/completions"))
                    .header("Authorization", "Bearer " + apiKey)
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
                    .build();

            HttpClient client = HttpClient.newHttpClient();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            // Kiểm tra status code
            if (response.statusCode() != 200) {
                String err = "OpenAI API trả về lỗi: " + response.statusCode() + " - " + response.body();
                System.err.println(err);
                return err;
            }

            // Parse nội dung trả lời từ JSON (dùng Gson)
            String raw = response.body();
            JsonObject root = JsonParser.parseString(raw).getAsJsonObject();
            JsonArray choices = root.getAsJsonArray("choices");
            if (choices != null && choices.size() > 0) {
                JsonObject message = choices.get(0).getAsJsonObject().getAsJsonObject("message");
                if (message != null && message.has("content")) {
                    return message.get("content").getAsString();
                }
            }
            // Nếu lỗi parse, trả nguyên JSON để dễ debug
            return raw;

        } catch (Exception e) {
            String errorMsg = "OpenAI API lỗi: " + e.getMessage();
            System.err.println(errorMsg);
            return "Xin lỗi, tôi gặp sự cố kỹ thuật: " + e.getMessage();
        }
    }
}


