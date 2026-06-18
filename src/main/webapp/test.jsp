<%@ page import="java.sql.*" %>
<%@ page import="com.carelink.db.DBConnection" %>

<%

Connection con = DBConnection.getConnection();

if(con != null){

out.println("Database Connected Successfully");

}else{

out.println("Connection Failed");

}

%>