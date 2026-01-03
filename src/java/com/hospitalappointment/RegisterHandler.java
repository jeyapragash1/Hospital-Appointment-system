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
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/RegisterHandler")
public class RegisterHandler extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = "patient";  // Default role for registration
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Initialize database connection (JNDI or fallback)
            conn = DatabaseConnection.initializeDatabase();

            // Check if email already exists
            ps = conn.prepareStatement("SELECT user_id FROM users WHERE email = ?");
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) {
                response.sendRedirect("register.jsp?error=Email+already+registered");
                return;
            }
            rs.close();
            ps.close();

            // Hash password
            String hashed = BCrypt.hashpw(password, BCrypt.gensalt());

            // Insert new user
            String query = "INSERT INTO users (username, password, email, role) VALUES (?, ?, ?, ?)";
            ps = conn.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, hashed);
            ps.setString(3, email);
            ps.setString(4, role);

            int result = ps.executeUpdate();
            if (result > 0) {
                response.sendRedirect("login.jsp?success=Registration+successful");
            } else {
                response.sendRedirect("register.jsp?error=Registration+failed");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=An+error+occurred");
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
