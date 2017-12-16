<%@ page language="java" import="java.util.*,java.sql.*,java.net.URLEncoder,java.net.URLDecoder" 
         contentType="text/html; charset=utf-8"%>
<%	
	request.setCharacterEncoding("utf-8");



	String username="";	
	Cookie[] cookies = request.getCookies();
	int ifAdmin=0;
	if(cookies!=null) {
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
	
	String mode="1";//mode=1,用户;mode=2,
	String msg="";
	int setmode=1;
	try{
		mode = request.getParameter("mode");
		setmode = mode.charAt(0)-'0';
		if(setmode>2||setmode<1)	setmode=1;

	} catch (Exception e){
		msg = e.getMessage();
	}



%>
<!DOCTYPE HTML>
<html>
<head>
<title><%=ifAdmin==1?"管理员页面":"出错啦" %></title>
<style>
   table{
          border-collapse: collapse;
          border: none;
          width: 500px;
   }
   td,th{
          border: solid grey 1px;            
          margin: 0 0 0 0;
          padding: 5px 5px 5px 5px 
  }
  .c1 {
    width:100px
  }
  .c2 {
    width:200px
  }
  a:link,a:visited {
    color:blue
  }
  
  .container{  
    margin:0 auto;   
    width:980px;  
    text-align:center;  
    font-size:16px;
  }  
  p {text-align:left;  }
  .frameset {
  		width:900px;
		height:600px;
		border:solid 10px gray;
		margin:40px auto;
  }
  .frame {
		width:100%;
		height:100%;
		border:solid 1px transparent;
		
	}
  a.mode {
  	padding:5px;
  }
  input.logout {
  	border:none;background:none;cursor:pointer;color:blue;
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
		height:860px;
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
			<img src="./RES/logo.png" alt="1">
		</div>
	</div>
	<div class="main"> 
	   <div class="container" style="<%=ifAdmin==1?"display:none;":"" %>>">
	   <br/><br/><h2>这位同学你走错片场啦</h2><br/><br/>
	   <a href='Main.jsp'>返回主页</a>
	   </div>
	  	<div class="container" style="<%=ifAdmin!=1?"display:none;":"" %>>">
	  	  <h1>管理者模式</h1>
	  	  <br/>
	  	  <a class="mode" href='AdminPage.jsp?mode=1' style="<%=setmode==1?"border:2px dashed black;":""%>">管理用户</a>
	  	  &nbsp; &nbsp; &nbsp; &nbsp; 
	  	  <a class="mode" href='AdminPage.jsp?mode=2' style="<%=setmode==2?"border:2px dashed black;":""%>">管理评价</a>
	  	  <br/>
	  	  <div class="frameset">
	  	  <iframe class="frame" src="AdminUser.jsp" style="<%=setmode!=1?"display:none;":""%>"></iframe>
		  <iframe class="frame" src="AdminMark.jsp" style="<%=setmode!=2?"display:none;":""%>"></iframe>
	  	  </div>
		  <a href='Main.jsp?'>返回主页</a>
	  </div>
	</div>
	<footer id="ft">
		<div class="footer"><span>专注在线阅读的图书网站</span></div>
	</footer>
</body>
</html>