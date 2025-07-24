package com.juleswhite.module1;

import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpExchange;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import java.io.*;
import java.net.InetSocketAddress;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Simple HTTP Server for Home Service Chat Application
 */
public class CosmeticsWebServer {
    private static final int PORT = 8080;
    private static final Map<String, CosmeticAIAgent> sessions = new ConcurrentHashMap<>();
    private static final Map<String, Integer> sessionToUserId = new ConcurrentHashMap<>(); // Mapping sessionId -> userId
    private static final Gson gson = new Gson();

    public static void main(String[] args) throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress(PORT), 0);

        

        // API endpoints
        server.createContext("/api/chat", new ChatHandler());
        server.createContext("/api/greeting", new GreetingHandler());
        server.createContext("/api/summary", new SummaryHandler());

        server.setExecutor(null);
        server.start();

        System.out.println("Server started on http://localhost:" + PORT);
        System.out.println("Open your browser and navigate to http://localhost:" + PORT);
    }

    /**
     * Handler for serving static files (HTML, CSS, JS)
     */

    /**
     * Handler for chat messages
     */
    static class ChatHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange exchange) throws IOException {
            if (!"POST".equals(exchange.getRequestMethod())) {
                sendResponse(exchange, 405, "text/plain", "Method not allowed");
                return;
            }

            try {
                // Read request body
                String requestBody = readRequestBody(exchange);
                JsonObject jsonRequest = gson.fromJson(requestBody, JsonObject.class);

                String message = jsonRequest.get("message").getAsString();
                String sessionId = jsonRequest.get("sessionId").getAsString();
                
                // Lấy userId từ request (nếu có)
                final Integer userId;
                if (jsonRequest.has("userId") && !jsonRequest.get("userId").isJsonNull()) {
                    userId = jsonRequest.get("userId").getAsInt();
                    sessionToUserId.put(sessionId, userId);
                } else {
                    // Lấy userId từ mapping nếu đã có
                    userId = sessionToUserId.get(sessionId);
                }

                // Get or create AI agent for this session
                CosmeticAIAgent agent = sessions.computeIfAbsent(sessionId, k -> new CosmeticAIAgent(userId));

                // Process message
                String response = agent.processUserInput(message);

                // Create response JSON
                JsonObject jsonResponse = new JsonObject();
                jsonResponse.addProperty("response", response);
                jsonResponse.addProperty("sessionId", sessionId);

                sendResponse(exchange, 200, "application/json", gson.toJson(jsonResponse));

            } catch (Exception e) {
                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("error", "Internal server error");
                sendResponse(exchange, 500, "application/json", gson.toJson(errorResponse));
            }
        }
    }

    /**
     * Handler for greeting message
     */
    static class GreetingHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange exchange) throws IOException {
            if (!"POST".equals(exchange.getRequestMethod())) {
                sendResponse(exchange, 405, "text/plain", "Method not allowed");
                return;
            }

            try {
                String requestBody = readRequestBody(exchange);
                JsonObject jsonRequest = gson.fromJson(requestBody, JsonObject.class);
                String sessionId = jsonRequest.get("sessionId").getAsString();
                
                // Lấy userId từ request (nếu có)
                final Integer userId;
                if (jsonRequest.has("userId") && !jsonRequest.get("userId").isJsonNull()) {
                    userId = jsonRequest.get("userId").getAsInt();
                    sessionToUserId.put(sessionId, userId);
                } else {
                    userId = null;
                }

                // Create new AI agent for this session
                CosmeticAIAgent agent = new CosmeticAIAgent(userId);
                sessions.put(sessionId, agent);

                String greeting = agent.getGreeting();

                JsonObject jsonResponse = new JsonObject();
                jsonResponse.addProperty("message", greeting);
                jsonResponse.addProperty("sessionId", sessionId);

                sendResponse(exchange, 200, "application/json", gson.toJson(jsonResponse));

            } catch (Exception e) {
                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("message", "Xin chào! Tôi là AI Agent tư vấn mỹ phẩm. Bạn muốn tìm hiểu về sản phẩm nào hoặc có vấn đề gì về da không?");
                sendResponse(exchange, 200, "application/json", gson.toJson(errorResponse));
            }
        }
    }

    /**
     * Handler for conversation summary
     */
    static class SummaryHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange exchange) throws IOException {
            if (!"POST".equals(exchange.getRequestMethod())) {
                sendResponse(exchange, 405, "text/plain", "Method not allowed");
                return;
            }

            try {
                String requestBody = readRequestBody(exchange);
                JsonObject jsonRequest = gson.fromJson(requestBody, JsonObject.class);
                String sessionId = jsonRequest.get("sessionId").getAsString();

                CosmeticAIAgent agent = sessions.get(sessionId);
                String summary = (agent != null) ? agent.getConversationSummary() : "Không có cuộc trò chuyện nào được ghi nhận.";

                JsonObject jsonResponse = new JsonObject();
                jsonResponse.addProperty("summary", summary);
                jsonResponse.addProperty("sessionId", sessionId);

                sendResponse(exchange, 200, "application/json", gson.toJson(jsonResponse));

            } catch (Exception e) {
                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("summary", "Không thể tạo tóm tắt cuộc trò chuyện.");
                sendResponse(exchange, 200, "application/json", gson.toJson(errorResponse));
            }
        }
    }

    /**
     * Utility method to read request body
     */
    private static String readRequestBody(HttpExchange exchange) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(exchange.getRequestBody(), "UTF-8"))) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        return sb.toString();
    }

    /**
     * Utility method to send HTTP response
     */
    private static void sendResponse(HttpExchange exchange, int statusCode,
                                     String contentType, String response) throws IOException {
        // Set CORS headers
        exchange.getResponseHeaders().set("Access-Control-Allow-Origin", "*");
        exchange.getResponseHeaders().set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        exchange.getResponseHeaders().set("Access-Control-Allow-Headers", "Content-Type");
        exchange.getResponseHeaders().set("Content-Type", contentType + "; charset=UTF-8");

        byte[] responseBytes = response.getBytes("UTF-8");
        exchange.sendResponseHeaders(statusCode, responseBytes.length);

        try (OutputStream os = exchange.getResponseBody()) {
            os.write(responseBytes);
        }
    }
}


            