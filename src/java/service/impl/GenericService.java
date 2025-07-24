/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.impl;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.util.List;
import java.util.function.Consumer;
import java.util.function.Function;
import utils.db.JPAUtil;
import service.interfaces.IGenericService;

/**
 *
 * @author DELL
 */
public class GenericService<T> implements IGenericService<T> {

    @Override
    public void doInTransaction(Consumer<EntityManager> action, String errorMessage) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            action.accept(em);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw new RuntimeException(errorMessage, e);
        } finally {
            em.close();
        }
    }

    @Override
    public <R> R doInTransactionWithResult(Function<EntityManager, R> action, String errorMessage) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            R result = action.apply(em);
            tx.commit();
            return result;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw new RuntimeException(errorMessage, e);
        } finally {
            em.close();
        }
    }

    @Override
    public List<T> doInTransactionForList(Function<EntityManager, List<T>> action, String errorMessage) {
        return doInTransactionWithResult(action, errorMessage);
    }
}