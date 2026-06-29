package com.carelink.db;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;


public class DBConnection {

    private static String URL;
    private static String USER;
    private static String PASSWORD;

    static {
        try (InputStream input = DBConnection.class
                .getClassLoader()
                .getResourceAsStream("db.properties")) {

            if (input != null) {
                Properties props = new Properties();
                props.load(input);
                URL      = props.getProperty("db.url");
                USER     = props.getProperty("db.user");
                PASSWORD = props.getProperty("db.password");
            } else {
                System.err.println("[DBConnection] WARNING: db.properties not found! Using fallback credentials.");
                URL      = "jdbc:mysql://localhost:3306/carelink";
                USER     = "root";
                PASSWORD = "root";
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return con;
    }
}