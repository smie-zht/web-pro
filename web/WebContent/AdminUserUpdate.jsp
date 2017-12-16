<%@ page language="java" import="java.util.*,java.sql.*,java.net.URLEncoder,java.net.URLDecoder" 
         contentType="text/html; charset=utf-8"%>
<% request.setCharacterEncoding("utf-8");
String msg = "  ";
String connectString = "jdbc:mysql://172.18.187.234:53306/boke15352405"
+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8&useSSL=false";
String user="user"; String pwd="123";
String id = "";
String username = "";
String password = "";
String status = "";
String newsts = "";
int ifnormal=-1;
//得到cookie
Cookie[] cookies = request.getCookies();
int ifAdmin=0;
if(cookies!=null){
	for(int i=cookies.length-1; i>=0; i--) {
		  // 获得具体的Cookie
		  Cookie cookie = cookies[i];
		  // 获得Cookie的名称
		  String cookien = cookie.getName();
		  //out.print("Cookie名:"+name+" &nbsp; Cookie值:"+value+"<br>");
		  if(cookien.equals("scuname")){
		  	String uname= URLDecoder.decode(cookie.getValue(), "UTF-8");
		  	if(uname.equals("Admin")) ifAdmin=1;
		  	break;
		  }
		}
}

//从上一个文件得到url参数
if(ifAdmin==1){
	try{
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection(connectString,user, pwd);
		Statement stmt = con.createStatement();
		id = request.getParameter("uid");
		String fmt="select * from user_info where user_id = %s";
		String sql = String.format(fmt,id);
		ResultSet rs=stmt.executeQuery(sql);
		
		if(rs.next()){
			username = rs.getString("user_name");
			password = rs.getString("user_password");
			ifnormal = rs.getInt("user_able");
		}
	} catch (Exception e){
		msg = e.getMessage();
	}
		
	//点击按钮
	if(request.getMethod().equalsIgnoreCase("post")){
		//id = request.getParameter("uid");
		//点击修改
		if(request.getParameter("revise") != null){
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(connectString,user, pwd);
			Statement stmt = con.createStatement();
			try{
				password = request.getParameter("password");
				status = request.getParameter("status");
				if(status.equals("normal")) {
					newsts="1";
					ifnormal=1;
				}
				else if(status.equals("forbidden")) {
					newsts="0";
					ifnormal=0;
				}
				String fmt="update user_info set user_password='%s',user_able=%s where user_id=%s";
				String sql = String.format(fmt,password,newsts,id);
				int cnt = stmt.executeUpdate(sql);
				if(cnt>0)	msg = "成功修改用户信息!";
				stmt.close(); con.close();
			} catch (Exception e){
				msg = e.getMessage();
			}
		}
	}
}

%>
<!DOCTYPE HTML>
<html>
<head>
<title><%=ifAdmin==1?"修改用户信息":"出错啦" %></title>
  <style>
      a:link,a:visited {color:blue}
     .container{  
    	margin:0 auto;   
    	width:500px;  
    	text-align:center;  
     }  
  </style>  

</head><body>
<div class="container" style="<%=ifAdmin==1?"display:none;":"" %>>">
  <br/><br/><h2>这位同学你走错片场啦</h2><br/><br/>
  </div>
 <div class="container" style="<%=ifAdmin!=1?"display:none;":"" %>>">
<h3>修改用户<%=username %>的设定</h3>
<form action="AdminUserUpdate.jsp?uid=<%=id%>" method="post" name="f">
<br/>
密码:&nbsp;&nbsp;<input id="name" type="text" name="password" value="<%=password %>"><br/><br/>

状态: &nbsp;&nbsp;正常访问<input type="radio" name="status" value="normal" <%=ifnormal==1?"checked":"" %>/>
  &nbsp;&nbsp;禁止登陆<input type="radio" name="status" value="forbidden" <%=ifnormal!=1?"checked":"" %>>
<br/><br/><br/><br/>
<input type="submit" name="revise" value=" 修改 "><br/>
</form><br/>
<%=msg%><br/><br/>
<a href='AdminUser.jsp'>返回</a>
</div>
</body>
</html>