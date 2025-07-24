/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util.db;

import java.util.Properties;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.internet.AddressException;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.InternetAddress;



/**
 *
 * @author DELL
 */
public class EmailUtil {

    public static void sendMail(String email, String subject, String content) {
        final String username = "hieuvo.23102004@gmail.com";
        final String password = "uzkb hsdi exik urrx";
        
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        
        Session session = Session.getInstance(props,
            new jakarta.mail.Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            });
            
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
            message.setSubject(subject);
            message.setText(content);

            Transport.send(message);
            System.out.println("Email sent to " + email);
        } catch (AddressException e) {
            System.err.println("Email address sai định dạng: " + email);
            e.printStackTrace();
        } catch (MessagingException e) {
            System.err.println("Lỗi khi gửi email");
            e.printStackTrace();
        }
    }
    
}
