package controller.client;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.juleswhite.module1.CosmeticAIAgent;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.SessionUtils;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;
import java.util.Map;

@WebServlet(name = "ChatAgentController", urlPatterns = {"/chat-agent/*"})
public class ChatAgentController extends HttpServlet {
    
    private static final Map<String, CosmeticAIAgent> sessions = new ConcurrentHashMap<>();
    private static final Gson gson = new Gson();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        
        String pathInfo = request.getPathInfo();
        
        try {
            if ("/chat".equals(pathInfo)) {
                handleChat(request, response);
            } else if ("/greeting".equals(pathInfo)) {
                handleGreeting(request, response);
            } else if ("/summary".equals(pathInfo)) {
                handleSummary(request, response);
            } else {
                sendErrorResponse(response, 404, "Endpoint not found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, 500, "Internal server error: " + e.getMessage());
        }
    }
    
    private void handleChat(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // Đọc request body
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        
        JsonObject jsonRequest = gson.fromJson(sb.toString(), JsonObject.class);
        String message = jsonRequest.get("message").getAsString();
        String sessionId = jsonRequest.get("sessionId").getAsString();
        
        // Lấy userId từ session
        HttpSession session = request.getSession(false);
        final Integer userId = (session != null) ? SessionUtils.getUserId(session) : null;
        
        // Get or create AI agent
        CosmeticAIAgent agent = sessions.computeIfAbsent(sessionId, k -> new CosmeticAIAgent(userId));
        
        // Process message
        String aiResponse = agent.processUserInput(message);
        
        // Create response
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("response", aiResponse);
        jsonResponse.addProperty("sessionId", sessionId);
        jsonResponse.addProperty("userId", userId != null ? userId : 0);
        
        response.getWriter().write(gson.toJson(jsonResponse));
    }
    
    private void handleGreeting(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // Đọc request body
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        
        JsonObject jsonRequest = gson.fromJson(sb.toString(), JsonObject.class);
        String sessionId = jsonRequest.get("sessionId").getAsString();
        
        // Lấy userId từ session
        HttpSession session = request.getSession(false);
        final Integer userId = (session != null) ? SessionUtils.getUserId(session) : null;
        
        // Create new AI agent
        CosmeticAIAgent agent = new CosmeticAIAgent(userId);
        sessions.put(sessionId, agent);
        
        String greeting = agent.getGreeting();
        
        // Create response
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("message", greeting);
        jsonResponse.addProperty("sessionId", sessionId);
        jsonResponse.addProperty("userId", userId != null ? userId : 0);
        
        response.getWriter().write(gson.toJson(jsonResponse));
    }
    
    private void handleSummary(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // Đọc request body
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        
        JsonObject jsonRequest = gson.fromJson(sb.toString(), JsonObject.class);
        String sessionId = jsonRequest.get("sessionId").getAsString();
        
        CosmeticAIAgent agent = sessions.get(sessionId);
        String summary = (agent != null) ? agent.getConversationSummary() : "Không có cuộc trò chuyện nào được ghi nhận.";
        
        // Create response
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("summary", summary);
        jsonResponse.addProperty("sessionId", sessionId);
        
        response.getWriter().write(gson.toJson(jsonResponse));
    }
    
    private void sendErrorResponse(HttpServletResponse response, int statusCode, String message) 
            throws IOException {
        response.setStatus(statusCode);
        JsonObject errorResponse = new JsonObject();
        errorResponse.addProperty("error", message);
        response.getWriter().write(gson.toJson(errorResponse));
    }
    
    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setStatus(200);
    }
} 