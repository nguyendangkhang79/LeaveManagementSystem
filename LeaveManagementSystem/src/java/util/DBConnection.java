package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=LeaveManagementDB;trustServerCertificate=true;characterEncoding=UTF-8;sendStringParametersAsUnicode=true;";
    private static final String USER = "sa"; 
    private static final String PASSWORD = "12345678";

    public static Connection getConnection() throws SQLException {
        try {
            // Load the JDBC driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("SQL Server JDBC Driver not found", e);
        } catch (SQLException e) {
            System.err.println("Connection Error: " + e.getMessage());
            throw e;
        }
    }
}