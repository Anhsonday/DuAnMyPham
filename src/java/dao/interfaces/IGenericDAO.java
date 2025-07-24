/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.interfaces;

import java.util.List;

/**
 *
 * @author DELL
 */
public interface IGenericDAO<T, ID> {
    void add(T entity);
    void update(T entity);
    void delete(ID id);
    T findById(ID id);
    List<T> findAll();
    List<T> findByField(String fieldName, Object value);
}
