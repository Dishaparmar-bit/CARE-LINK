package com.carelink.db;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/carelink";

    private static final String USER = "";

    private static final String PASSWORD = "";

    public static Connection getConnection() {

        Connection con = null;

        try {

            Class.forName(
                "com.mysql.cj.jdbc.Driver"
            );

            con = DriverManager.getConnection(
                    URL,
                    USER,
                    PASSWORD
            );

        } catch(Exception e) {

            e.printStackTrace();

        }

        return con;
    }
}