package com.hospitalappointment;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/LoginHandler")
public class LoginHandler extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Initialize database connection
            conn = DatabaseConnection.initializeDatabase();

            // Select user by email
            String query = "SELECT user_id, username, password, role FROM users WHERE email = ?";
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            rs = ps.executeQuery();

            if (rs.next()) {
                String hashed = rs.getString("password");
                if (hashed != null && BCrypt.checkpw(password, hashed)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("user", rs.getString("user_id"));
                    session.setAttribute("role", rs.getString("role"));
                    String role = rs.getString("role");
                    if ("admin".equalsIgnoreCase(role)) {
                        response.sendRedirect("adminDashboard.jsp");
                    } else if ("doctor".equalsIgnoreCase(role)) {
                        response.sendRedirect("doctorDashboard.jsp");
                    } else {
                        response.sendRedirect("patientDashboard.jsp");
                    }
                    return;
                }
            }

            // Invalid login
            response.sendRedirect("login.jsp?error=Invalid+email+or+password");
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=An+error+occurred");
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
