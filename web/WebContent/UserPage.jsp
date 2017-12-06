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
	body{
		    font-family: Arial,sans-serif;
            color: #000000;
            font-size: 12px;
            margin: 0px;
            padding: 0px;
            background:url("./RES/xiangrikui.JPG");
            background-size: cover;
		}
	table{border-collapse: collapse; border: none; width: 500px;
			text-align:center;margin:0px auto;} 
	td,th{border: solid grey 1px;margin: 0 0 0 0; padding: 5px 5px 5px 5px}
	.container{	border:1px solid rgba(255,255,204,0.02);  
	background-color:rgba(255,190,70,0.55);
	margin:0 auto;width:960px;height:600px;} 
	#table{
	float:right;
	margin-right:90px;
	border:1px solid yellow;
	height:210px;font-size:18px;
	background-color:rgba(255,190,30,0.60);
	padding-top:10px;
	padding-bottom:10px;
	width:570px;font-family:楷体;}
	#action{
	float:left;
	margin-left:90px;
	height:210px;width:180px;
	font-size:18px;
	background-color:rgba(255,190,0,0.60);
	position:relative;
	font-family:楷体;
	border:1px solid white;
	padding:10px;
	}
	.act{
		border:1px solid white;
		background-color:rgba(255,150,1,0.8);
		width:100px;
		height:25px;
		padding:auto;
		margin:30px;
		font-size:20px;
		text-align:center;
		border-radius:5px;
	}
	#page{margin:10px 225px;
	}
	.footer{
			background:rgba(117,157,48,0.01);
			text-align:center;
			border:1px solid rgba(117,157,48,0.01);
			width:980px;
			height:60px;
			margin-left:100px;
			margin-right:auto;
		}
	header{
			
			border:1px solid rgba(117,157,48,0.01);
			width:980px;
			height:60px;
			margin-left:auto;
			margin-right:auto;
		}
	#h-text{
		padding:20px;
		text-align:center;
		float:right;
		margin-right:40px;
		font-family:楷体;
		font-size:25px;
		color: green; 
	}
	#user{
		height:200px;
		width:750px;
		margin:10px auto;
		padding:10px;
		border:1px solid white;
		background-color:rgba(255,255,255,0.4);
	}
	#user_img{
		float:left;
		height:170px;
		width:170px;
		margin:8px 30px;
		border:2px solid white;
		background:url("./RES/user_img.jpg");
	}
	#user_word{
		padding:30px;
		float:left;
		height:170px;
		width:340px;
		margin:8px 50px;
		font-size:30px;
		font-family:楷体;
		texe-align:center;
	}

	 </style> 
</head>
	<body><%request.setCharacterEncoding("utf-8");%>
	 <header id="header">
		<img src="./RES/logo.png" alt="1">
		<div id="h-text">只做最好的在线图书阅读网站</div>
	</header>
	 <div class="container"> 
	 	<div></div>
	 	<h1>&nbsp;&nbsp;&nbsp;&nbsp;<%=userName %>的主页</h1> 
	 	<div id ="user">
	 		<div id="user_img"></div>
	 		<div id="user_word">生活<br/><br/>是一次最深的阅读！</div>
	 	</div>
	 	
	 	<div id="action">
	 	用户操作：
	 		<div class="act"><a href="bookUpdate.jsp">上传图书</a></div>
	 		<div class="act"><a href="changeKey.jsp">修改密码</a></div>
	 	</div>
	 	
	 	<div id = "table">
	 	评分/上传作品：
	 	<%=table%> 
	 	<div id="page">
		<a href="UserPage.jsp?pgno=<%=pgprev %>&pgcnt=<%=pgcnt %>">上一页</a>
		<a href="UserPage.jsp?pgno=<%=pgnext %>&pgcnt=<%=pgcnt %>">下一页</a>
		</div>
	 	</div>	
	 	<div style="clear:both;"></div>
	 	<br></br>
		<%=msg %>
		<br><a href='Main.jsp'>返回书虫网</a> 
	 </div>
	 <footer id="footer">
		<div class="footer"><img src="./RES/logo.png" alt="1"></div>
	</footer>
	</body>
</html>
