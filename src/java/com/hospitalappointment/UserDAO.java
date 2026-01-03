package com.hospitalappointment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;

public class UserDAO {
    private Connection conn;

    // Constructor to establish database connection
    public UserDAO() throws SQLException, ClassNotFoundException {
        conn = DatabaseConnection.initializeDatabase();
    }

    // Method to check if a user with a given username or email exists
    public boolean userExists(String username, String email) throws SQLException {
        String query = "SELECT 1 FROM users WHERE username = ? OR email = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, username);
        ps.setString(2, email);
        ResultSet rs = ps.executeQuery();
        boolean exists = rs.next();
        rs.close();
        ps.close();
        return exists;
    }

    // Method to save a new user to the database
    public boolean saveUser(User user) throws SQLException {
        String query = "INSERT INTO users (username, password, email, role) VALUES (?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, user.getUsername());
        ps.setString(2, user.getPassword());  // Assumes password is already hashed
        ps.setString(3, user.getEmail());
        ps.setString(4, user.getRole());
        int rowsInserted = ps.executeUpdate();
        ps.close();
        return rowsInserted > 0;
    }

    // Method to check if login credentials are valid
    public User validateUser(String email, String password) throws SQLException {
        String query = "SELECT user_id, username, password, role FROM users WHERE email = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            String hashed = rs.getString("password");
            if (hashed != null && BCrypt.checkpw(password, hashed)) {
                User u = new User(rs.getString("username"), email, hashed, rs.getString("role"));
                rs.close();
                ps.close();
                return u;
            }
        }
        rs.close();
        ps.close();
        return null;
    }

    // Close the connection
    public void close() throws SQLException {
        if (conn != null) {
            conn.close();
        }
    }
}
