<%@ page language="java" import="java.util.*,java.sql.*,java.net.URLEncoder,java.net.URLDecoder" 
         contentType="text/html; charset=utf-8"%>
<%
	request.setCharacterEncoding("utf-8");
//	String path = request.getContextPath();
//	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	String systemmsg = "";
	String msg = "";
	String username = "";
	String password = ""; 
	int user_id=-1;
	
	
	
	//得到cookie
	Cookie[] cookies = request.getCookies();
	int ifLogin=0;
	String loutname="";
	String tmpname="";
	if(cookies!=null){
		for(int i=cookies.length-1; i>=0; i--) {
			int ifbreak=0;
		  // 获得具体的Cookie
			Cookie cookie = cookies[i];
		  // 获得Cookie的名称
			String cookien = cookie.getName();
			if(cookien.equals("scuname")){
				ifLogin=1;
				msg="您已登录!返回主页开始阅读吧!";
				break;
		  	}
		}
	}
	String connectString = "jdbc:mysql://172.18.187.234:53306/boke15352405"
					+ "?autoReconnect=true&useUnicode=true"
					+ "&characterEncoding=UTF-8&userSSL=false"; 
	try{
		Class.forName("com.mysql.jdbc.Driver");
		Connection con=DriverManager.getConnection(connectString, 
		               "user", "123");
		Statement stmt=con.createStatement();
		if (request.getMethod().equalsIgnoreCase("post")) {
			username = request.getParameter("username");
			password = request.getParameter("password");
			if(request.getParameter("login")!=null){
				String fmt="select * from user_info where binary user_name='%s' and binary user_password='%s'";
				String sql = String.format(fmt,username,password);
				ResultSet rs=stmt.executeQuery(sql);
				if(rs.next()){
					if(rs.getInt("user_able")==1) {
						user_id=rs.getInt("user_id");
						Cookie cookie1 = new Cookie("scuname",URLEncoder.encode(username, "UTF-8")); 
						Cookie cookie2 = new Cookie("scuid",String.valueOf(user_id));
						cookie1.setMaxAge(5000);//设置保留时间 5000秒。
						cookie2.setPath("/"); 
						cookie1.setPath("/"); //设置路径。未设置路径使用当前路径。
						response.addCookie(cookie2);
						response.addCookie(cookie1);
						msg="登录成功,返回主页开始阅读吧!";
						ifLogin=1;
					}
					else 
						msg="您的账号被关小黑屋啦，请联系管理员!";
				}
				else
					msg="帐户名或登录密码不正确，请重新输入!";
				rs.close();
			  }
			else if(request.getParameter("register")!=null){
				if(username.trim().equals("")){
					msg="注册失败,用户名不能为空!";
				}
				else if(password.trim().equals("")){
					msg="注册失败，密码不能为空!";
				}
				else{
					String fmt1="select * from user_info where binary user_name='%s'";
					String sql1 = String.format(fmt1,username);
					ResultSet rs1=stmt.executeQuery(sql1);
					
					if(rs1.next()){
						msg="注册失败,用户名已被注册!";
					}
					else{
						String fmt="insert into user_info(user_name,user_password) values('%s', '%s')";
						String sql = String.format(fmt,username,password);
						int cnt = stmt.executeUpdate(sql);
						if(cnt>0){
							msg = "注册成功,赶快登录开始阅读吧!";
						}
					}
					rs1.close();
				}
			
			}
			stmt.close();
			con.close();
		  }
		}
		catch (Exception e){
		  systemmsg = e.getMessage();
		}
%> 

<!DOCTYPE>
<html  lang="zh-cn">
<head>
  
  <meta charset="utf-8">
  <title>欢迎来到书虫网</title>
  <link rel="stylesheet" type="text/css" href="./Font-Awesome/css/font-awesome.css" />
  <style>
	div#lr {
		width:200px;
		height: 120px;
		background:linear-gradient(to right,rgb(51,204,255) 0%,rgb(51,255,255) 100%);
		border: 1px solid gray;
		border-radius: 5px;
		margin:60px auto ;
		padding-top:5px;
		padding-left:30px;
		padding-right:20px;
		box-shadow: inset 2px 2px 1px rgba(0,0,0,0.2),4px 4px 3px rgba(0,0,0,0.2);
	}
	
	p>input {
		width: 160px;
		height: 1.5em;
		margin: 2px;
		background:rgb(51,255,255);
		border-radius: 6px;
		border: 1px;
		box-shadow: 1px 1px 3px #505050;
		text-indent: 1em;
	}
	
	#btn {
		margin:0 auto;
	}
	div#btn {
		width:200px;
		margin:0 auto;
	}
	div#clear {clear:both;}
	input#login {
		float:left;
	}
	input#register {
		float:right;
	}
	div#btm {
		position:absolute;
		top:350px;
		left: 240px;
		width: 500px;
		text-align:center;
		font-size:16px;
	}
	.header2{
		margin:0 auto;
		width:100%;
		height:80px;
		background:rgba(174,143,038,0.5);
		border:1px solid black;
		min-width:980px;
	}
	#header{
		border : 1px solid black;
		text-align:right;
		width:100%;
		height:20px;
		min-width:980px;
		margin: 0 auto;
        position:relative;
        background:rgba(174,143,038,1);
        border-bottom:none;
    }
	body{
		    
        color: #000000;
        font-size: 12px;
        margin: 0px;
        padding: 0px;
        background:url("./RES/background.jpg");
        background-size: cover;
	}
	.main {
		position:relative;
		width:980px;
		height:520px;
		background:rgba(247,238,214,0.8);
		margin:0 auto;
		
		border:1px solid rgba(51,0,0,0.8);
		border-top:1px solid transparent;
		border-bottom:1px solid rgba(51,0,0,0.4);
	}
	#ft{
		height:30px;
		line-height:30px;
		border : 1px solid gray;
		background:rgba(0,204,102,0.8);
		margin:0px auto 0 auto;
		text-align:center;
	}
	.navbar_img{  
	    margin:10px auto;   
	    width:980px;  
	    text-align:center;  
  	} 
  </style>
</head>
<body>
	<header id="header" ></header>
		
	<div class="header2" >
		<div class="navbar_img">
			<a href="Main.jsp"><img src="./RES/logo.png" alt="1"></a>
		</div>	
	</div>
	<div class="main"> 
		<div class="container" style="<%=ifLogin==1?"visibility:hidden;":"" %>>">
		<form   action="LR.jsp" method="post">
		<div id="lr">
		<p id="user">
			<i id="u" class="fa fa-user-circle" aria-hidden="true"></i>
			<input type="text"  name="username" placeholder="用户名" value="<%=username %>"/>
			
		</p>
		<p id="pass">
			<i id="p" class="fa fa-key" aria-hidden="true" ></i>
			<input type="password" name="password" placeholder="密码"/>
		</p>
		</div>
		<div id="btn">
		<input id="login" type="submit" name="login" value="登录"/>
		<input id="register" type="submit" name="register" value="注册"/>
		</div>
		<div id="clear"></div>
		</form>
		</div>
		<div id="btm">
		<%=msg %><br/><br/>
		<a href='Main.jsp'>返回主页</a><br/><br/>
		</div>
	
	</div>
	<footer id="ft">
		<div class="footer"><span>专注在线阅读的图书网站</span></div>
	</footer>
	
</body>
</html>