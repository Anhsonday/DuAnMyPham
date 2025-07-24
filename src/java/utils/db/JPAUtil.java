/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils.db;

/**
 *
 * @author DELL
 */

import jakarta.persistence.*;

public class JPAUtil {
    private static final EntityManagerFactory emf =
        Persistence.createEntityManagerFactory("MY_PHAM_PU"); // dùng đúng tên persistence-unit

    public static EntityManager getEntityManager() {
        return emf.createEntityManager(); // mỗi lần cần thao tác DB
    }

    public static void close() {
        emf.close(); // nếu cần tắt toàn bộ app
    }
}
