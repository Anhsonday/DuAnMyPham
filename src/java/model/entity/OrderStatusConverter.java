package model.entity;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter
public class OrderStatusConverter implements AttributeConverter<Order.OrderStatus, String> {
    
    @Override
    public String convertToDatabaseColumn(Order.OrderStatus status) {
        if (status == null) {
            return Order.OrderStatus.PENDING.getValue();
        }
        return status.getValue();
    }
    
    @Override
    public Order.OrderStatus convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.trim().isEmpty()) {
            return Order.OrderStatus.PENDING;
        }
        
        try {
            return Order.OrderStatus.fromString(dbData);
        } catch (Exception e) {
            System.err.println("Error converting database value '" + dbData + "' to OrderStatus. Defaulting to PENDING. Error: " + e.getMessage());
            return Order.OrderStatus.PENDING;
        }
    }
} 