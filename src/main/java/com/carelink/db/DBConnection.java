package com.carelink.db;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    
    private static final String URL      = "jdbc:mysql://localhost:3306/carelink?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER     = "root";
    private static final String PASSWORD = "root"; 
    
    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            System.err.println("[DBConnection] CRITICAL ERROR: Database connectivity handshake failed!");
            e.printStackTrace();
        }
        return con;
    }
}