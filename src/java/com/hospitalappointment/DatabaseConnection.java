package com.hospitalappointment;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class DatabaseConnection {

    public static Connection initializeDatabase() throws SQLException, ClassNotFoundException {
        // Try JNDI DataSource first (configure in web/META-INF/context.xml)
        try {
            Context initCtx = new InitialContext();
            Context envCtx = (Context) initCtx.lookup("java:comp/env");
            DataSource ds = (DataSource) envCtx.lookup("jdbc/hospitalappointmentsystem");
            if (ds != null) {
                return ds.getConnection();
            }
        } catch (NamingException e) {
            // fall back to DriverManager below
        }

        // Fallback: direct DriverManager connection (update credentials as needed)
        String dbDriver = "com.mysql.cj.jdbc.Driver";
        String dbURL = "jdbc:mysql://localhost:3306/";
        String dbName = "hospitalappointmentsystem";
        String dbUsername = "root";
        String dbPassword = "";

        Class.forName(dbDriver);
        return DriverManager.getConnection(dbURL + dbName + "?serverTimezone=UTC", dbUsername, dbPassword);
    }
}
