<%@ page language="java" import="java.io.*,java.util.*,java.sql.*,
	org.apache.commons.io.*,org.apache.commons.fileupload.*,
	org.apache.commons.fileupload.disk.*,
	org.apache.commons.fileupload.servlet.*
	,java.net.URLEncoder,java.net.URLDecoder"
 contentType="text/html; charset=utf-8"%>

<% request.setCharacterEncoding("utf-8"); 
	int isAdmin = 0;
	int user_id = 0;
	String userName = "XXX";
	//获取cookid流：从中获取用名和用户id
	Cookie[] cookies = request.getCookies();
	for(int i=0;i<cookies.length;i++){
		Cookie cookie = cookies[i];
		String cokName = cookie.getName();
		if(cokName.equals("scuid")){
			user_id = Integer.parseInt(cookie.getValue());
			if(user_id==1) isAdmin = 1;
		}
		if(cokName.equals("scuname")){
    		userName = URLDecoder.decode(cookie.getValue(), "UTF-8");
    	}
	}
	//页码操作
	Integer pgno = 0;
	Integer pgcnt = 4;
	String param = request.getParameter("pgno");
	if(param != null && !param.isEmpty()){
		pgno = Integer.parseInt(param);
	}
	param = request.getParameter("pgcnt");
	if(param != null && !param.isEmpty()){
		pgcnt = Integer.parseInt(param);
	}
	int pgprev = (pgno>0)?pgno-1:0;
	int pgnext = pgno+1;
	String msg = ""; 
	StringBuilder table=new StringBuilder("");//建表语句
	String connectString = "jdbc:mysql://172.18.187.234:53306/boke15352405"
		+ "?autoReconnect=true&useUnicode=true"
		+ "&characterEncoding=UTF-8&useSSL=false";  
 	String user="user"; String pwd="123"; 
 	
 	try{
 		  Class.forName("com.mysql.jdbc.Driver");
 		  Connection con=DriverManager.getConnection(connectString, "user", "123");
 		  Statement stmt=con.createStatement();
 		  String sql = String.format("select * from book_point where user_id = '%s' limit %d,%d ",String.valueOf(user_id),pgno*pgcnt,pgcnt);
 		  ResultSet rs=stmt.executeQuery(sql);
 		  table.append("<table><tr><th>书名</th><th>评分</th><th>操作</th></tr>");
 		  while(rs.next()) 
 		  { 
 			
 			table.append(String.format( "<tr><td>%s</td><td>%s</td><td>%s</td></tr>", 
 	 		  	rs.getString("book_name"),String.valueOf(rs.getFloat("book_point")),
 	 		  	"<a href='Read.jsp?bookName="+rs.getString("book_name")+"'>阅读</a>"  ) ); }
 		    table.append("</table>");
 		    rs.close();
 		    stmt.close();
 		    con.close();
 		}
 		catch (Exception e){
 		  msg = e.getMessage();
 		} %>

<!DOCTYPE HTML>
<html>
<head>
	<title>用户主页</title>
	 <style> a:link,a:visited {color:blue;} 
	table{border-collapse: collapse; border: none; width: 500px;
			margin:0px auto;} 
	td,th{border: solid grey 1px;margin: 0 0 0 0; padding: 5px 5px 5px 5px}
	.container{	border:1px solid red;  
	margin:0 auto;width:960px;text-align:center;} 
	
	 </style> 
</head>
	<body><%request.setCharacterEncoding("utf-8");%>
	 <div class="container"> 
	 	<div></div>
	 	<h1><%=userName %>的主页</h1> 
	 	<%=table%> 
	 	<br></br>
	<div id="page">
		<a href="UserPage.jsp?pgno=<%=pgprev %>&pgcnt=<%=pgcnt %>">上一页</a>
		<a href="UserPage.jsp?pgno=<%=pgnext %>&pgcnt=<%=pgcnt %>">下一页</a>
	</div>
		<br></br>		
		<%=msg %>
		<br><a href='Main.jsp'>返回</a> 
	 </div>

</html>
