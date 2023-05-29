<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<head><title> 수강신청 취소 </title></head>
<body>

<%
	Connection myConn = null;    String	result = null;	
	String dburl  = "jdbc:oracle:thin:@localhost:1521:xe";
	String user="c##ysy";   String passwd="1234";
	String dbdriver = "oracle.jdbc.driver.OracleDriver";    
	CallableStatement cstmt;

	try {
		Class.forName(dbdriver);
	    myConn =  DriverManager.getConnection (dburl, user, passwd);
	} catch(SQLException ex) {
    	 System.err.println("SQLException: " + ex.getMessage());
	}
	
	boolean stu_mode = true;
	String session_id= (String)session.getAttribute("user");
	if(session_id == null) {
		session_id = (String)session.getAttribute("prof");
	if(session_id != null) stu_mode = false;
	}
	
	if(stu_mode == false){
		String c_id = request.getParameter("c_id");
		int c_id_no = Integer.parseInt(request.getParameter("c_id_no"));
		cstmt = myConn.prepareCall("{call DeleteTeach(?,?,?,?)}");
		cstmt.setString(1, session_id);
		cstmt.setString(2, c_id);
		cstmt.setInt(3,c_id_no);
		cstmt.registerOutParameter(4, java.sql.Types.VARCHAR);	
		try  {  	
			cstmt.execute();
			result = cstmt.getString(4);		
%>
	<script>	
		alert("<%= result %>"); 
		alert("냥"); 
		location.href="delete.jsp";
	</script>
<%		
		} catch(SQLException ex) {		
			 System.err.println("SQLException: " + ex.getMessage());
			 out.println("SQLException: " + ex.getMessage());
		}  
		finally {
		    if (cstmt != null) 
	            try { myConn.commit(); cstmt.close();  myConn.close(); }
	 	      catch(SQLException ex) {out.println("SQLException: " + ex.getMessage()); }
	     }
	}
	else{
		String s_id=session_id;
		//String s_id = (String)session.getAttribute("user");
		String c_id = request.getParameter("c_id");
		int c_id_no = Integer.parseInt(request.getParameter("c_id_no"));		

	    cstmt = myConn.prepareCall("{call DeleteEnroll(?,?,?,?)}");
		cstmt.setString(1, s_id);
		cstmt.setString(2, c_id);
		cstmt.setInt(3, c_id_no);
		cstmt.registerOutParameter(4, java.sql.Types.VARCHAR);	
		try  {  	
			cstmt.execute();
			result = cstmt.getString(4);		
%>
	<script>	
		alert("<%=result%>"); 
		location.href="delete.jsp";
		
	</script>
<%		
		} catch(SQLException ex) {		
			 System.err.println("SQLException: " + ex.getMessage());
		}  
		finally {
		    if (cstmt != null) 
	            try { myConn.commit(); cstmt.close();  myConn.close(); }
	 	      catch(SQLException ex) { }
	     }
 }
%>
</form></body></html>