/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils.db;

/**
 *
 * @author DELL
 */
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class Test {
    public static void main(String[] args) {
        try {
            System.out.println("Dang khoi tao EntityManagerFactory...");
            EntityManagerFactory emf = Persistence.createEntityManagerFactory("DU_AN_MY_PHAM");

            System.out.println("EntityManagerFactory tao thanh cong!");

            EntityManager em = emf.createEntityManager();
            System.out.println("Ket noi EntityManager thanh cong!");

            em.close();
            emf.close();
        } catch (Exception e) {
            System.out.println("Loi ket noi:");
            e.printStackTrace();
        }
    }
}

