/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.client;

import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Address;
import model.entity.User;
import service.impl.AddressService;
import service.interfaces.IAddressService;

/**
 *
 * @author DELL
 */
@WebServlet(name = "AddressServlet", urlPatterns = {"/addresses"})
public class AddressServlet extends HttpServlet {
    IAddressService addrService;
    
    public void init() {
        addrService = new AddressService();
    }
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddressServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddressServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if(user == null) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        if(action == null)
            action = "";
        switch(action) {
            case "create" -> showNewForm(request, response);
            case "update" -> showEditForm(request, response, user);
            case "listShipAddr" -> listShipAddr(request, response, user);
            default -> listBillAddr(request, response, user);
        }
        
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if(user == null) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        if(action == null)
            action = "";
        switch(action) {
            case "create" -> createAddress(request, response, user);
            case "update" -> updateAddress(request, response, user);
            case "delete" -> deleteAddress(request, response, user);
        }
            
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private boolean isOwner(Address addr, User user) {
        return addr != null && addr.getUser() != null && addr.getUser().getUserId() == user.getUserId();
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("user/createAddress.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String idStr = request.getParameter("addressID");
        if (idStr == null || idStr.isEmpty()) {
            request.setAttribute("errorMsg", "Thiếu mã địa chỉ.");
            listBillAddr(request, response, user);
            return;
        }
        int id = Integer.parseInt(idStr);
        Address addr = null;
        try {
            addr = addrService.getAddressById(id);
            if (!isOwner(addr, user)) {
                request.setAttribute("errorMsg", "Bạn không có quyền sửa địa chỉ này.");
                listBillAddr(request, response, user);
                return;
            }
        } catch (Exception e) {
            request.setAttribute("errorMsg", e.getMessage());
            listBillAddr(request, response, user);
            return;
        }
        request.setAttribute("addr", addr);
        // Thêm thông tin về loại địa chỉ để form biết redirect về đâu
        request.setAttribute("addressType", addr.getAddressType());
        RequestDispatcher dispatcher = request.getRequestDispatcher("user/updateAddress.jsp");
        dispatcher.forward(request, response);
    }

    private void createAddress(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String recipientName = request.getParameter("recipientName");
        String phone = request.getParameter("phone");
        String province = request.getParameter("province");
        String district = request.getParameter("district");
        String ward = request.getParameter("ward");
        String addressDetail = request.getParameter("addressDetail");
        boolean isDefault = request.getParameter("isDefault") != null;
        String addressType = request.getParameter("addressType");

        // Validate dữ liệu đầu vào
        if (recipientName == null || recipientName.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            province == null || province.trim().isEmpty() ||
            district == null || district.trim().isEmpty() ||
            ward == null || ward.trim().isEmpty() ||
            addressDetail == null || addressDetail.trim().isEmpty()) {
            request.setAttribute("errorMsg", "Vui lòng nhập đầy đủ thông tin địa chỉ.");
            // Thêm thông tin về loại địa chỉ để form biết redirect về đâu
            request.setAttribute("addressType", addressType);
            showNewForm(request, response);
            return;
        }

        Address addr = new Address(recipientName, phone, province, district, ward, addressDetail, isDefault, addressType, false, user);
        try {
            addrService.createAddress(addr);
            // Redirect về controller checkout sau khi tạo địa chỉ thành công
            response.sendRedirect(request.getContextPath() + "/checkout?success=address_created");
        } catch (Exception e) {
            request.setAttribute("errorMsg", e.getMessage());
            // Thêm thông tin về loại địa chỉ để form biết redirect về đâu
            request.setAttribute("addressType", addressType);
            showNewForm(request, response);
        }
    }

    private void updateAddress(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String idStr = request.getParameter("addressID");
        if (idStr == null || idStr.isEmpty()) {
            request.setAttribute("errorMsg", "Thiếu mã địa chỉ.");
            listBillAddr(request, response, user);
            return;
        }
        int id = Integer.parseInt(idStr);
        String recipientName = request.getParameter("recipientName");
        String phone = request.getParameter("phone");
        String province = request.getParameter("province");
        String district = request.getParameter("district");
        String ward = request.getParameter("ward");
        String addressDetail = request.getParameter("addressDetail");
        boolean isDefault = request.getParameter("isDefault") != null;
        String addressType = request.getParameter("addressType");

        // Validate dữ liệu đầu vào
        if (recipientName == null || recipientName.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            province == null || province.trim().isEmpty() ||
            district == null || district.trim().isEmpty() ||
            ward == null || ward.trim().isEmpty() ||
            addressDetail == null || addressDetail.trim().isEmpty()) {
            request.setAttribute("errorMsg", "Vui lòng nhập đầy đủ thông tin địa chỉ.");
            // Lấy địa chỉ gốc để hiển thị lại form với dữ liệu cũ
            try {
                Address originalAddr = addrService.getAddressById(id);
                request.setAttribute("addr", originalAddr);
                request.setAttribute("addressType", originalAddr.getAddressType());
            } catch (Exception ex) {
                // Nếu không lấy được địa chỉ gốc, redirect về list
                if ("shipping".equalsIgnoreCase(addressType)) {
                    response.sendRedirect("addresses?action=listShipAddr");
                } else {
                    response.sendRedirect("addresses?action=listBillAddr");
                }
                return;
            }
            RequestDispatcher dispatcher = request.getRequestDispatcher("user/updateAddress.jsp");
            dispatcher.forward(request, response);
            return;
        }

        Address addr = null;
        try {
            addr = addrService.getAddressById(id);
            if (!isOwner(addr, user)) {
                request.setAttribute("errorMsg", "Bạn không có quyền sửa địa chỉ này.");
                listBillAddr(request, response, user);
                return;
            }
        } catch (Exception e) {
            request.setAttribute("errorMsg", e.getMessage());
            listBillAddr(request, response, user);
            return;
        }

        addr = new Address(id, recipientName, phone, province, district, ward, addressDetail, isDefault, addressType, false, user);
        try {
            addrService.updateAddress(addr);
            // Redirect về controller checkout sau khi cập nhật địa chỉ thành công
            response.sendRedirect(request.getContextPath() + "/checkout?success=address_updated");
        } catch (Exception e) {
            request.setAttribute("errorMsg", e.getMessage());
            // Lấy địa chỉ gốc để hiển thị lại form với dữ liệu cũ
            try {
                Address originalAddr = addrService.getAddressById(id);
                request.setAttribute("addr", originalAddr);
                request.setAttribute("addressType", originalAddr.getAddressType());
            } catch (Exception ex) {
                // Nếu không lấy được địa chỉ gốc, redirect về list
                if ("shipping".equalsIgnoreCase(addressType)) {
                    response.sendRedirect("addresses?action=listShipAddr");
                } else {
                    response.sendRedirect("addresses?action=listBillAddr");
                }
                return;
            }
            RequestDispatcher dispatcher = request.getRequestDispatcher("user/updateAddress.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void deleteAddress(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String idStr = request.getParameter("addressID");
        if (idStr == null || idStr.isEmpty()) {
            request.setAttribute("errorMsg", "Thiếu mã địa chỉ.");
            listBillAddr(request, response, user);
            return;
        }
        int id = Integer.parseInt(idStr);
        Address addr = null;
        try {
            addr = addrService.getAddressById(id);
            if (!isOwner(addr, user)) {
                request.setAttribute("errorMsg", "Bạn không có quyền xóa địa chỉ này.");
                listBillAddr(request, response, user);
                return;
            }
            // Lưu loại địa chỉ trước khi xóa để redirect về đúng list
            String addressType = addr.getAddressType();
            addrService.deleteAddress(id);
            // Redirect về controller checkout sau khi xóa địa chỉ thành công
            response.sendRedirect(request.getContextPath() + "/checkout?success=address_deleted");
        } catch (Exception e) {
            request.setAttribute("errorMsg", e.getMessage());
            listBillAddr(request, response, user);
        }
    }

    private void listShipAddr(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            request.setAttribute("addresses", addrService.getShipAddrByUserID(user.getUserId()));
            RequestDispatcher dispatcher = request.getRequestDispatcher("user/listAddresses.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMsg", e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("user/listAddresses.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void listBillAddr(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            request.setAttribute("addresses", addrService.getBillAddrByUserID(user.getUserId()));
            RequestDispatcher dispatcher = request.getRequestDispatcher("user/listAddresses.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMsg", e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("user/listAddresses.jsp");
            dispatcher.forward(request, response);
        }
    }

}
