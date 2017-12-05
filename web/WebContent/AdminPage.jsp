<%@ page language="java" import="java.util.*,java.sql.*,java.net.URLEncoder,java.net.URLDecoder" 
         contentType="text/html; charset=utf-8"%>
<%
	request.setCharacterEncoding("utf-8");
	Cookie[] cookies = request.getCookies();
	int ifAdmin=0;
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
    width:1000px;  
    text-align:center;  
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
</style>
</head>
<body>
   <div class="container" style="<%=ifAdmin==1?"display:none;":"" %>>">
   <br/><br/><h2>这位同学你走错片场啦</h2><br/><br/>
   <a href='Main.jsp'>返回主页</a>
   </div>
  <div class="container" style="<%=ifAdmin!=1?"display:none;":"" %>>">
  	  <h1>管理者模式</h1>
  	  <br/>
  	  <a class="mode" href='AdminPage.jsp?mode=1' style="<%=setmode==1?"border:2px dashed black;":""%>">管理用户</a>&nbsp; &nbsp; 
  	  &nbsp; &nbsp; 
  	  <a class="mode" href='AdminPage.jsp?mode=2' style="<%=setmode==2?"border:2px dashed black;":""%>">管理评价</a>
  	  <br/>
  	  <div class="frameset">
  	  <iframe class="frame" src="AdminUser.jsp" style="<%=setmode!=1?"display:none;":""%>"></iframe>
	  <iframe class="frame" src="AdminMark.jsp" style="<%=setmode!=2?"display:none;":""%>"></iframe>
  	  </div>
	  
	  <a href='Main.jsp?'>返回主页</a>
  </div>
  
</body>
</html>