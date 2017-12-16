<%@ page language="java" import="java.util.*,java.sql.*,java.net.URLEncoder,java.net.URLDecoder" 
         contentType="text/html; charset=utf-8"%>

<% 
request.setCharacterEncoding("utf-8");
String msg = "  ";
String connectString = "jdbc:mysql://172.18.187.234:53306/boke15352405"
+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8&useSSL=false";
String user="user"; String pwd="123";
String id = "";
String num = "";
String name = "";
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
	    	if(uname.equals("admin")) ifAdmin=1;
	    	break;
	    }
	 }
}

//从上一个文件得到url参数
if(request.getMethod().equalsIgnoreCase("get")){
	if(ifAdmin==1){
		try{
			id = request.getParameter("uid");
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(connectString,user, pwd);
			Statement stmt = con.createStatement();
			
			String fmt="delete from user_info where user_id=%s";
			String sql = String.format(fmt,id);
			int cnt = stmt.executeUpdate(sql);
			if(cnt>0)	msg = "成功清理该用户!";
			stmt.close(); con.close();
		} catch (Exception e){
			msg = e.getMessage();
		}
	}
}


%>
<!DOCTYPE HTML>
<html>
<head>
<title><%=ifAdmin==1?"删除用户":"出错啦" %></title>
  <style>
      a:link,a:visited {color:blue}
     .container{  
    	margin:0 auto;   
    	width:500px;  
    	text-align:center;  
     }  
  </style>  

</head>
<body>
  <div class="container" style="<%=ifAdmin==1?"display:none;":"" %>>">
  <br/><br/><h2>这位同学你走错片场啦</h2><br/><br/>
  </div>
  <div class="container" style="<%=ifAdmin!=1?"display:none;":"" %>>">
<h1>删除用户</h1>
<br/>

<%=msg%><br/><br/>
<a href='AdminUser.jsp'>返回</a>
</div>
</body>
</html>