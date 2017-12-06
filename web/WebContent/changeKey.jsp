<%@ page language="java" import="java.io.*,java.util.*,java.sql.*,
	org.apache.commons.io.*,org.apache.commons.fileupload.*,
	org.apache.commons.fileupload.disk.*,
	org.apache.commons.fileupload.servlet.*
	,java.net.URLEncoder,java.net.URLDecoder"
 contentType="text/html; charset=utf-8"%>

<% request.setCharacterEncoding("utf-8"); 
	//使用cookie确定用户
	int isAdmin = 0;
	int user_id = 0;
	String userName = "未登录";
	//获取cookid流
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
	
String msg = ""; //输出信息
String connectString = "jdbc:mysql://172.18.187.234:53306/boke15352405"
		+ "?autoReconnect=true&useUnicode=true"
		+ "&characterEncoding=UTF-8&useSSL=false";  
 String user="user"; 
 String pwd="123"; 
 //获取用户输入的密码信息
 String userKey="---";
 String oldKey = request.getParameter("oldKey");
 String newKey = request.getParameter("newKey");
 String keyAck = request.getParameter("keyAck");

 //表单提交
 if(request.getMethod().equalsIgnoreCase("post")){ 
	 Class.forName("com.mysql.jdbc.Driver");
	 Connection con = DriverManager.getConnection(connectString,user,pwd); 
	 Statement stmt = con.createStatement(); 
	 //查询用户名对应的密码
	 try{ 
		 System.out.println(String.valueOf(user_id));
		 String sql="select * from user_info where user_name = '"+userName+"'"; 
		 ResultSet rs = stmt.executeQuery(sql); 
		 if(rs.next()){
			System.out.println("select ok");
			userKey=rs.getString("user_password");
		 }
			
		}catch (Exception e){ msg = e.getMessage(); } 
	 System.out.println(userKey);
	 //旧密码确认成功
	 if(userKey.equals(oldKey)){
		//新密码确认成功
		if(newKey.equals(keyAck)){
			try{
				String fmt="update user_info set user_password='%s' where user_name='%s'";
				String sql1 = String.format(fmt,newKey,userName);
				int cnt = stmt.executeUpdate(sql1);
				if(cnt>0)	msg = "密码修改成功!";
			}catch(Exception e){
				msg=e.getMessage();	
			}
		}
		else{
			msg="确认密码不正确";
		}
	 }else{
		 msg="曾用密码输入有误！";
	 }stmt.close(); 
	 con.close(); 
   } %>


<!DOCTYPE HTML>
<html>
<head>
	<title>修改密码</title>
	
	 <style> a:link,a:visited {color:blue;} 
	 body{background:url("./RES/background.jpg");}
	.container{  margin:100px  auto;width:500px;text-align:center;
			background-color:rgba(255,255,255,0.7);
			border:2px solid white;
			border-radius:2px;} 
	#user{
	 		width:150px;height:40px;float:left;
	 		font-family:楷体;font-size:20px;
	 	}
	 </style> 
</head>
	<body><%request.setCharacterEncoding("utf-8");%>
	<div id="user">当前用户：<%=userName %></div>
	 <div class="container"> 
	 	<h1>用户密码修改</h1> 
	 	<form action="changeKey.jsp" method="post">
	 	曾用密码:<input id="oldKey" type="password" name="oldKey">
	 	<br></br>
	 	更改密码:<input id="newKey" type="password" name="newKey">
	 	<br></br>
	 	确认密码:<input id="keyAck" type="password" name="keyAck">
	 	<br></br>
	 	<input type="submit" name="submit" value="上传">
	 	<input type="reset"  name="reset"  value="重置"> 
		</form> 
		<br></br>
		<%=msg %>
		<br><a href='UserPage.jsp'>返回</a> 
	 </div>

</html>
