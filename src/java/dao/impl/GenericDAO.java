/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.impl;

import dao.interfaces.IGenericDAO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityNotFoundException;
import java.util.List;

/**
 *
 * @author DELL
 */
public abstract class GenericDAO<T, ID> implements IGenericDAO<T, ID> {
    protected EntityManager em;
    private final Class<T> clazz;

    public GenericDAO(EntityManager em, Class<T> clazz) {
        this.em = em;
        this.clazz = clazz;
    }

    @Override
    public void add(T entity) {
        em.persist(entity);
    }

    @Override
    public void update(T entity) {
        em.merge(entity);
    }

    @Override
    public void delete(ID id) {
        T entity = em.find(clazz, id);
        if (entity != null) {
            em.remove(entity);
        } else {
            throw new EntityNotFoundException("Entity not found with id = " + id);
        }
    }

    @Override
    public T findById(ID id) {
        return em.find(clazz, id);
    }

    @Override
    public List<T> findAll() {
        return em.createQuery("SELECT e FROM " + clazz.getSimpleName() + " e", clazz)
                 .getResultList();
    }
    
    @Override
    public List<T> findByField(String fieldName, Object obj) {
        return em.createQuery("SELECT e FROM " + clazz.getSimpleName() + " e WHERE e." + fieldName + " = :value", clazz)
                .setParameter("value", obj)
                .getResultList();
    }
    
}
