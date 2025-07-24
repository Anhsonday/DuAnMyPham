/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.interfaces;

import jakarta.persistence.EntityManager;
import java.util.List;
import java.util.function.Consumer;
import java.util.function.Function;

/**
 *
 * @author DELL
 */
public interface IGenericService<T> {
    void doInTransaction(Consumer<EntityManager> action, String errorMessage);
    <R> R doInTransactionWithResult(Function<EntityManager, R> action, String errorMessage);
    List<T> doInTransactionForList(Function<EntityManager, List<T>> action, String errorMessage);
}