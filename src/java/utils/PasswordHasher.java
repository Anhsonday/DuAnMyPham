/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Utility class for password hashing and verification
 */
public class PasswordHasher {
    
    private static final int SALT_LENGTH = 16;
    private static final String HASH_ALGORITHM = "SHA-256";
    private static final int HASH_ITERATIONS = 10000;
    
    /**
     * Hash a password using salt and multiple iterations
     * @param password plain text password
     * @return hashed password with embedded salt
     */
    public static String hashPassword(String password) {
        try {
            // Generate random salt
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);
            
            // Create hash
            byte[] hash = hashWithSalt(password.toCharArray(), salt, HASH_ITERATIONS, HASH_ALGORITHM);
            
            // Format: iterations:algorithm:base64(salt):base64(hash)
            return HASH_ITERATIONS + ":" + 
                   HASH_ALGORITHM + ":" + 
                   Base64.getEncoder().encodeToString(salt) + ":" + 
                   Base64.getEncoder().encodeToString(hash);
            
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
    
    /**
     * Verify a password against a stored hash
     * @param password plain text password to verify
     * @param storedHash previously hashed password
     * @return true if password matches
     */
    public static boolean verifyPassword(String password, String storedHash) {
    try {
        String[] parts = storedHash.split(":");
        if (parts.length == 4) {
            // Định dạng hash mới
            int iterations;
            try {
                iterations = Integer.parseInt(parts[0]);
            } catch (NumberFormatException e) {
                return false;
            }
            String algorithm = parts[1];
            byte[] salt = Base64.getDecoder().decode(parts[2]);
            byte[] originalHash = Base64.getDecoder().decode(parts[3]);
            byte[] testHash = hashWithSalt(password.toCharArray(), salt, iterations, algorithm);
            int diff = originalHash.length ^ testHash.length;
            for (int i = 0; i < originalHash.length && i < testHash.length; i++) {
                diff |= originalHash[i] ^ testHash[i];
            }
            return diff == 0;
        } else {
            // Định dạng cũ: so sánh trực tiếp (plain text hoặc base64)
            return password.equals(storedHash);
        }
    } catch (Exception e) {
        return false;
    }
}
    
    /**
     * Hash a password with salt
     * @param password password as char array
     * @param salt salt bytes
     * @param iterations number of iterations
     * @param algorithm hash algorithm
     * @return hashed password bytes
     * @throws NoSuchAlgorithmException if algorithm not available
     */
    private static byte[] hashWithSalt(char[] password, byte[] salt, int iterations, String algorithm) 
            throws NoSuchAlgorithmException {
        
        MessageDigest digest = MessageDigest.getInstance(algorithm);
        digest.reset();
        digest.update(salt);
        
        byte[] passwordBytes = new byte[password.length * 2];
        for (int i = 0; i < password.length; i++) {
            passwordBytes[i * 2] = (byte) (password[i] >> 8);
            passwordBytes[i * 2 + 1] = (byte) password[i];
        }
        
        byte[] result = digest.digest(passwordBytes);
        
        // Apply iterations
        for (int i = 0; i < iterations - 1; i++) {
            digest.reset();
            result = digest.digest(result);
        }
        
        return result;
    }
}