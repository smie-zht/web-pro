<%@ page language="java" import="java.util.*,java.sql.*,java.net.URLEncoder,java.net.URLDecoder" 
         contentType="text/html; charset=utf-8"%>
<%		
		Cookie[] cookies = request.getCookies();
		int identity=0;//0游客，1一般用户，2Admin
		if(cookies!=null){
			for(int i=cookies.length-1; i>=0; i--) {
	    		Cookie cookie = cookies[i];
	    		String cookien = cookie.getName();
	    		if(cookien.equals("scuname")){
	    			String uname= URLDecoder.decode(cookie.getValue(), "UTF-8");
	    			identity=1;
	    			if(uname.equals("Admin")) identity=2;
	    			break;
	    		}
	 		}
		}
		
		
		Integer cout=0; 
		request.setCharacterEncoding("utf-8");
		String msg ="";
		Integer pgno = 0; //当前页号
		Integer pgcnt = 12; //每页行数
		String param = request.getParameter("pgno");
		String key=request.getParameter("keywords");
		String cout1=request.getParameter("cout");
		String query=request.getParameter("keywords");
		String query1=request.getParameter("keywordsave");
		String op1=request.getParameter("op");
		String op2="";
		if(op1==null||op1.isEmpty())
		{
			op1="qb";
			op2="全部";
			
		}
		if(cout1!=null&&!cout1.isEmpty())
		{
			cout=Integer.parseInt(cout1);
			if(query==null||query.isEmpty())
				query=query1;
		}
		if(param != null && !param.isEmpty()){ 
			pgno = Integer.parseInt(param);
			}
			param = request.getParameter("pgcnt");
			if(param != null && !param.isEmpty()){
			pgcnt = Integer.parseInt(param);
			}
			int pgprev = (pgno>0)?pgno-1:0;
			int pgnext = pgno+1;
		String connectString = "jdbc:mysql://172.18.187.234:53306/boke15352405"
			+ "?autoReconnect=true&useUnicode=true"
			+ "&characterEncoding=UTF-8&useSSL=false"; 
		StringBuilder list=new StringBuilder("");
		StringBuilder list2=new StringBuilder("");
		StringBuilder list3=new StringBuilder("");
		StringBuilder list4=new StringBuilder("");
		try{
				 Class.forName("com.mysql.jdbc.Driver");
				 Connection con=DriverManager.getConnection(connectString, 
				                 "user", "123");
				 Statement stmt=con.createStatement();
			if(request.getMethod().equalsIgnoreCase("post")||cout==1) {
				if(request.getParameter("search")!=null) {
					cout=1;
					 query1=query;
					 String sql=String.format("select book_id,book_image,round(avg(book_point),1) as point,book_info.book_name,book_author from book_info,book_point where book_point.book_name=book_info.book_name "
			 					+" and  book_info.book_name like '%%"+query+"%%' group by book_info.book_name limit %d,%d",pgno*pgcnt,pgcnt);
				
					 ResultSet rs=stmt.executeQuery(sql);
					
				while(rs.next()){
					list.append(String.format("<li ><a href=\"Read.jsp?bookid=%s class=\"image\"\" title=\"nihao\">"
							 +"<img  src=\"%s\"height=\"200\" width=\"143\">"
							 +"<span class=\"point\">%s</span></a>"
							 +"<h3 class=\"bookname\"><a>%s</a></h3>"
							 +"<span class=\"tip\" >%s</span></li>",
							 rs.getString("book_id"),rs.getString("book_image"),rs.getString("point"), rs.getString("book_info.book_name"),rs.getString("book_author")
							 )
						);
					}
					rs.close();
				}
				 
			  
			//  stmt.close();
			//  con.close();
			}
			else if(request.getMethod().equalsIgnoreCase("get")){
				if(op1.equals("qb"))
				{	op2="全部";	
						String sql=String.format("select book_id,book_image,round(avg(book_point),1) as point,book_info.book_name,book_author from book_info,book_point where book_point.book_name=book_info.book_name"
				 					+" group by book_info.book_name limit %d,%d",pgno*pgcnt,pgcnt);
						ResultSet rs=stmt.executeQuery(sql);
						while(rs.next()){
						list.append(String.format("<li ><a href=\"Read.jsp?bookid=%s class=\"image\"\" title=\"nihao\">"
								 +"<img  src=\"%s\"height=\"200\" width=\"143\">"
								 +"<span class=\"point\">%s</span></a>"
								 +"<h3 class=\"bookname\"><a>%s</a></h3>"
								 +"<span class=\"tip\" >%s</span></li>",
								 rs.getString("book_id"),rs.getString("book_image"),rs.getString("point"), rs.getString("book_info.book_name"),rs.getString("book_author")
								 )
							);
						}
					  rs.close();
				//	  stmt.close();
				//	  con.close();
				}
				else 
				{   //qb,yq,js,xy,jd,et,kx,ls,xh
					if(op1.equals("yq"))
					{
						op2="言情";
					}
					else if(op1.equals("js"))
					{
						op2="惊悚";
					}
					else if(op1.equals("xy"))
					{
						op2="校园";
					}
					else if(op1.equals("jd"))
					{
						op2="经典";
					}
					else if(op1.equals("et"))
					{
						op2="儿童";
					}
					else if(op1.equals("kx"))
					{
						op2="科学";
					}
					else if(op1.equals("ls"))
					{
						op2="历史";
					}
					else if(op1.equals("xh"))
					{
						op2="玄幻";
					}
					String sql=String.format("select book_id,book_image,round(avg(book_point),1) as point,book_info.book_name,book_author from book_info,book_point where book_point.book_name=book_info.book_name"
		 					+" and book_type='%s'  group by book_info.book_name limit %d,%d",op2,pgno*pgcnt,pgcnt);
					
					ResultSet rs=stmt.executeQuery(sql);
					while(rs.next()){
						
					list.append(String.format("<li ><a href=\"Read.jsp?bookid=%s class=\"image\"\" title=\"nihao\">"
						 +"<img  src=\"%s\"height=\"200\" width=\"143\">"
						 +"<span class=\"point\">%s</span></a>"
						 +"<h3 class=\"bookname\"><a>%s</a></h3>"
						 +"<span class=\"tip\" >%s</span></li>",
						 rs.getString("book_id"),rs.getString("book_image"),rs.getString("point"), rs.getString("book_info.book_name"),rs.getString("book_author")
						 )	
					);
				}
			  rs.close();
			 // stmt.close();
			 // con.close();
				}
			}
			
			 Class.forName("com.mysql.jdbc.Driver");
			 con=DriverManager.getConnection(connectString, 
			                 "user", "123");
			 stmt=con.createStatement();
			 String sql=String.format("select book_id,book_image,round(avg(book_point),1) as point,book_info.book_name,book_author from book_info,book_point where book_point.book_name=book_info.book_name "
	 					+" group by book_info.book_name order by point desc");
			 ResultSet rs=stmt.executeQuery(sql);
			 //ResultSet rs2=stmt.executeQuery(sql2);
			int countnum=0;
			while(rs.next()&&countnum<4){
				System.out.print("hi\n");
				list2.append(String.format("<li ><a href=\"Read.jsp?bookid=%s class=\"image2\"\" title=\"nihao\">"
						 +"<img  src=\"%s\"height=\"200\" width=\"143\">"
						 +"<span class=\"point2\">%s</span></a>"
						 +"<h3 class=\"bookname2\"><a>%s</a></h3>"
						 +"<span class=\"tip2\" >%s</span></li>",
						 rs.getString("book_id"),rs.getString("book_image"),rs.getString("point"), rs.getString("book_info.book_name"),rs.getString("book_author")
						 )
					);countnum++;
				}
			  rs.close();
			  
			  
			 
			 String sql2="select book_id,book_image,round(avg(book_point),1) as point,book_info.book_name,book_author from book_info,book_point where book_point.book_name=book_info.book_name "
	 					+" group by book_info.book_name order by book_id desc";
			 ResultSet rs2=stmt.executeQuery(sql2);
			 //ResultSet rs2=stmt.executeQuery(sql2);
			int countnum2=0;
			while(rs2.next()&&countnum2<4){
				//System.out.print(rs2.getString("book_info.book_name"));
				list3.append(String.format("<li ><a href=\"Read.jsp?bookid=%s class=\"image2\"\" title=\"nihao\">"
						 +"<img  src=\"%s\"height=\"200\" width=\"143\">"
						 +"<span class=\"point2\">%s</span></a>"
						 +"<h3 class=\"bookname2\"><a>%s</a></h3>"
						 +"<span class=\"tip2\" >%s</span></li>",
						 rs2.getString("book_id"),rs2.getString("book_image"),rs2.getString("point"), rs2.getString("book_info.book_name"),rs2.getString("book_author")
						 )
					);countnum2++;
				}
			  rs2.close();		
			  
		  
			 String sql3=String.format("select book_id,book_image,round(avg(book_point),1) as point,book_info.book_name,book_author from book_info,book_point where book_point.book_name=book_info.book_name "
	 					+" group by book_info.book_name order by book_id ");
			 ResultSet rs3=stmt.executeQuery(sql3);
			 System.out.print("rs3");
			 //ResultSet rs2=stmt.executeQuery(sql2);
			int countnum3=0;
		while(rs3.next()&&countnum3<4){
			System.out.print("rs3");
			list4.append(String.format("<li ><a href=\"Read.jsp?bookid=%s class=\"image2\"\" title=\"nihao\">"
					 +"<img  src=\"%s\"height=\"200\" width=\"143\">"
					 +"<span class=\"point2\">%s</span></a>"
					 +"<h3 class=\"bookname2\"><a>%s</a></h3>"
					 +"<span class=\"tip2\" >%s</span></li>",
					 rs3.getString("book_id"),rs3.getString("book_image"),rs3.getString("point"), rs3.getString("book_info.book_name"),rs3.getString("book_author")
					 )
				);countnum3++;
			}
		  rs3.close();
		  stmt.close();
		  con.close();
		}catch (Exception e){
			  msg = e.getMessage();
		}
		if(request.getMethod().equalsIgnoreCase("post")){
			if(request.getParameter("logout")!=null){
				identity=0;
				for(int i=0;i<cookies.length;i++){
					String cookien = cookies[i].getName();
					if(cookien.equals("scuname")||cookien.equals("scuid")){
				    	cookies[i].setMaxAge(0);
				    	cookies[i].setPath("/");
				    	response.addCookie(cookies[i]); 
				    	System.out.print("logoutla");
					}
				}  
			}
		}
%>      

<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; utf-8">
<title>书虫网</title>
</head>
<script type="text/javascript">
function show1(){
	document.getElementById("nav1").style.background="white";
	document.getElementById("nav2").style.background="rgba(195,195,195,1)";
	document.getElementById("nav3").style.background="rgba(195,195,195,1)";
	document.getElementById("hp").style.display="none";
	document.getElementById("zx").style.display="none";
	document.getElementById("tj0").style.display="none";
	document.getElementById("tj").style.display="block";
}
function show2(){
	document.getElementById("nav2").style.background="white";
	document.getElementById("nav1").style.background="rgba(195,195,195,1)";
	document.getElementById("nav3").style.background="rgba(195,195,195,1)";
	document.getElementById("tj").style.display="none";
	document.getElementById("zx").style.display="none";
	document.getElementById("tj0").style.display="none";
	document.getElementById("hp").style.display="block";
	}
function show3(){
	document.getElementById("nav3").style.background="white";
	document.getElementById("nav1").style.background="rgba(195,195,195,1)";
	document.getElementById("nav2").style.background="rgba(195,195,195,1)";
	document.getElementById("hp").style.display="none";
	document.getElementById("tj").style.display="none";
	document.getElementById("tj0").style.display="none";
	document.getElementById("zx").style.display="block";
	}
</script>
<style>

		body{
		    font-family: Arial,sans-serif;
            color: #000000;
            font-size: 12px;
            margin: 0px;
            padding: 0px;
            background:url("./RES/background.jpg");
            background-size: cover;
		}
		a:visited,a:link{
			color:black;
			font-weight: bold;
		}
		
		.header2{
			margin:0 auto;
			height:80px;
			background:rgba(174,143,038,0.5);
			border:1px solid black;
			min-width:980px;
		}
		.input_top{
			float:right;
			margin-top:20px;
			margin-right:15px;
		}
		.navbar_img{
			float:left;
			margin-top:10px;
			margin-left:15px;
		}
		#header{
			border : 1px solid black;
			text-align:right;
			height:20px;
			min-width:980px;
			margin: 0 auto;
            position:relative;
            background:rgba(174,143,038,1);
        }
        .nouser{
        	margin: 5px 5px 5px auto;
        }
		.container{
			width:980px;height:80px;margin:0 auto;
		}
		#main{
			margin:0 auto;
			width:980px;
			border : 1px solid black;
			overflow:hidden;
		}
		#left{
			border : 1px solid black;
			float:left;
			width:200px;
			height:1200px;
			background: rgba(195,195,195,1);
		}
		.mainbody{
			border : 1px solid black;
			margin-left:200px;
			height:1200px;
			background:white;
			position:relative;
		}
		.point{
			position:relative;
			top:-187px;
			left:-143px;
			color:white;
			padding-right:3px;
			background:blue;
		}
		.image{
			position:relative;
		}
		#type{
			width:780px;
			border-bottom : 1px solid black;
			font-weight: bold;
			padding-left:10px;
		}
		.fenlei{
			font-size:22px;
			margin-top:5px;
			margin-left:5px;
		}
		.leftlist{
			margin-left:30px;
			font-size:18px;
		}
		.leftlist li{
			margin:10px auto;
		}
		.booklist li{
			display:inline-block;
			margin:5px 40px 10px 40px;
		}
		#pages{
			position:absolute;
			right:10px;
			top:1160px;
		}
		.page{
			margin:10px 10px;
			font-size:18px;
			font-weight: bold;
		}
		#footer{
			height:50px;
			border : 1px solid black;
			background:rgba(247,238,214,0.8);
			margin:0px auto 0 auto;
			text-align:center;
		}
		.footer{
			width:980px;
			height:40px;
			margin-left:auto;
			margin-right:auto;
			margin-top:10px;
		}
		.tip{
			position:relative;
			top:-20px;
			right:0px;
		}
		.bookname{
			position:relative;
			top:-10px;
			right:0px;
		}
		#view{
			height:360px;
			width:978px;
			border-left:2px solid black;
			border-right:2px solid black;
			margin:0 auto;
			background:white;
		}
		.nav{
			display:inline-block;
			margin:0 65px;
			font-size:18px;
			
		}
		#nav{position:relative;}
		.nav_out{
			border-top:1px solid black;
			border-bottom:1px solid black;
			background:rgba(195,195,195,1);
		}
		#nav .subnav{
			width:940px;
			height:312px;
			position:absolute;
			top:45px;
			left:0px;
		}
		#tj,#zx,#hp{
			display:none;
		}
		
		#nav>li li{
			display:inline-block;
			margin-left:50px;
			margin-top:20px;
		}
		.image2{
			position:relative;
		}
		.point2{
			position:relative;
			top:-187px;
			left:-143px;
			color:white;
			padding-right:3px;
			background:blue;
		}
		.bookname2{
			position:relative;
			top:-10px;
			right:0px;
		}
		.tip2{
			position:relative;
			top:-20px;
			right:0px;
		}
		input.logout {
			width:24px;
			padding:0;
			font-family: Arial,sans-serif;
            font-size: 12px;
            font-weight: bold;
  			border:none;background:none;cursor:pointer;color:black;
  			text-decoration:underline;
  			position:absolute;
        	right:10px;
        	top:5px;
  		}
  		div.user{
  			width:100%;
  			positon:relative;
        }
        .user>a {
        	position:absolute;
        	right:50px;
        	top:5px;
        }
</style>
<body>
	<header id="header" >
			<div class="nouser" style="<%=identity==0?"":"display:none;"%>">
					<a href="LR.jsp">登录</a>
					<a href="LR.jsp">注册</a>
			</div>
			<div class="user" style="<%=identity!=0?"":"display:none;"%>">
					<form action="Main.jsp" method="post">
					<input type="submit" name="logout" class="logout" value="退出" />
					</form>
					<a href="<%=identity==1?"UserPage.jsp":"AdminPage.jsp" %>">主页</a>
			</div>
			
		</header>
		<div class="clear"></div>
	<div class="header2" >
		<div class=container>
			<div class="navbar_img">
				<img src="./RES/logo.png" alt="1">
			</div>
			
			<div class="input_top" >
				<form action="Main.jsp" method="post" id="searchForm">
					<div class="nav_left">
						<input type="text" class="input" name="keywords" placeholder="搜索你想查找的图书" id="searchKeywordsId" value="" autocomplete="off">
						<input class="btn hits" type="submit" value="搜索" name="search">
					</div>
				</form>						
			</div>
		</div>	
	</div>
	<div id="view">
		<div class="nav_out">
			<ul class="wrapper" id="nav">
				<li class="nav"  id="nav1" onmouseover="show1()" >网站推荐
					<ul class="subnav" id="tj0">
						<%=list4 %>
						</ul>
					<ul class="subnav" id="tj">
						<%=list4 %>
					</ul></li>
				<li class="nav" id="sg1"> <span>|</span></li>
				<li class="nav" id="nav2" onmouseover="show2()" > 好评作品
					<ul class="subnav" id="hp">
						<%=list2 %>
					</ul></li>
				<li class="nav" id="sg2"> <span >|</span></li>
				<li class="nav" id="nav3" onmouseover="show3()">最新上传
					<ul class="subnav" id="zx">
						<%=list3 %>
					</ul></li>
			</ul>
		</div>
	</div>
	<div id="main">
		<div id="left">
			<span class="fenlei">分类：</span>
			<ul class="leftlist">
				<li><a href=Main.jsp?op=qb&cout=0>全部</a></li>
				<li><a href=Main.jsp?op=yq&cout=0>言情</a></li>
				<li><a href=Main.jsp?op=js&cout=0>惊悚</a></li>
				<li><a href=Main.jsp?op=xy&cout=0>校园</a></li>
				<li><a href=Main.jsp?op=jd&cout=0>经典</a></li>
				<li><a href=Main.jsp?op=et&cout=0>儿童</a></li>
				<li><a href=Main.jsp?op=kx&cout=0>科学</a></li>
				<li><a href=Main.jsp?op=ls&cout=0>历史</a></li>
				<li><a href=Main.jsp?op=xh&cout=0>玄幻</a></li>
			</ul>
		</div>
		<div class="mainbody">
		<div id="type"><a><%=op2 %></a></div>
			
			<ul class="booklist">
			<%=list %>
			</ul>
			<div id="pages">
				<a href="Main.jsp?pgno=<%=pgprev%>&pgcnt=<%=pgcnt%>&cout=<%=cout %>&keywordsave=<%=query %>" id="pre " class="page">上一页</a>
				<a href="Main.jsp?pgno=<%=pgnext%>&pgcnt=<%=pgcnt%>&cout=<%=cout %>&keywordsave=<%=query %>" id="aft" class="page">下一页</a>
			</div>
			
		</div>
	</div>
	<footer id="footer">
		<div class="footer"><span>在线阅读的图书网站</span></div>
	</footer>
</body>
</html>