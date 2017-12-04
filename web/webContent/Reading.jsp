<%@ page language="java" import="java.io.*,java.util.*,java.sql.*,
	org.apache.commons.io.*,org.apache.commons.fileupload.*,
	org.apache.commons.fileupload.disk.*,
	org.apache.commons.fileupload.servlet.*"
 contentType="text/html; charset=utf-8"%>

<% request.setCharacterEncoding("utf-8"); 
String msg = ""; 
String connectString = "jdbc:mysql://172.18.187.234:53306/boke15352405"
		+ "?autoReconnect=true&useUnicode=true"
		+ "&characterEncoding=UTF-8&useSSL=false";  
 String user="user"; 
 String pwd="123"; 
 String bname="lover";  //book_name
 String bk_dir="";
 StringBuffer buffer = new StringBuffer();
 
	 Class.forName("com.mysql.jdbc.Driver");
	 Connection con = DriverManager.getConnection(connectString,user, pwd); 
	 Statement stmt = con.createStatement(); 
	 try{ 
		 //处理转义字符
		 String sql = "select * from book_info where book_name = '"+bname+"'" ; 
		 ResultSet rs=stmt.executeQuery(sql);
		 //out.print("查询！");
		 if(rs.next()){
			 //out.print("查询成功！");
			 bk_dir = rs.getString("book_url");
			 Scanner scan = new Scanner(new FileInputStream(bk_dir));
		      scan.useDelimiter("\n");
		      while(scan.hasNext()){
		          buffer.append(scan.next()).append("\n");
		      }
		      scan.close();
		 }
		 stmt.close(); 
		 con.close(); 
		}catch (Exception e){ msg = e.getMessage(); } 
 %>


<!DOCTYPE HTML>
<html>
<head>
	<title>阅读图书</title>
	 <style> a:link,a:visited {color:blue;} 
	.container{  margin:0 auto;width:500px;text-align:center;} 
	 </style> 
</head>
	<body><%request.setCharacterEncoding("utf-8");%>
	 <div class="container"> 
	 	<h1>Reading</h1> 
	 	<div style="margin:0px auto">
	 	 图书内容:<textarea name="filecontent" cols="100" rows="40">
	 	 <%=buffer %>
	 	 </textarea>
	 	</div>
		<br/><a href='Main.jsp'>返回</a> 
	 </div>	 
</html>
