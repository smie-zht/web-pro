<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"%>
<%	
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
		if(op1==null||op1.isEmpty())
		{
			op1="全部";
			System.out.print(op1);
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
			+ "&characterEncoding=UTF-8"; 
		StringBuilder list=new StringBuilder("");
		try{
				 Class.forName("com.mysql.jdbc.Driver");
				 Connection con=DriverManager.getConnection(connectString, 
				                 "user", "123");
				 Statement stmt=con.createStatement();
			if(request.getMethod().equalsIgnoreCase("post")||cout==1)
			{
				
				 cout=1;
				 
				 query1=query;
				 String sql=String.format("select book_id,book_image,round(avg(book_point),1) as point,book_info.book_name,book_author from book_info,book_point where book_point.book_name=book_info.book_name "
		 					+" and  book_info.book_name like '%%"+query+"%%' group by book_info.book_name limit %d,%d",pgno*pgcnt,pgcnt);
				 System.out.print(sql);
				 ResultSet rs=stmt.executeQuery(sql);
				
			while(rs.next()){
				list.append(String.format("<li ><a href=\"Read.jsp?bookid=%s class=\"image\"\" title=\"nihao\">"
						 +"<img  src=\"%s\"height=\"200\" width=\"143\">"
						 +"<span class=\"point\">%s</span></a>"
						 +"<h3 class=\"bookname\"><a>%s</a></h3>"
						 +"<span class=\"tip\" >%s</span></li>",
						 rs.getString("book_id"),rs.getString("book_image"),rs.getString("point"), rs.getString("book_info.book_name"),rs.getString("book_author")
						 )
					);System.out.print(rs.getString("book_image"));
				}
			  rs.close();
			  stmt.close();
			  con.close();
			}
			else if(request.getMethod().equalsIgnoreCase("get")){
				if(op1.equals("全部"))
				{		System.out.print(cout+"aaaaaaaaaa");
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
							);System.out.print(rs.getString("point")+" ");
						}
					  rs.close();
					  stmt.close();
					  con.close();
				}
				else 
				{
					String sql=String.format("select book_id,book_image,round(avg(book_point),1) as point,book_info.book_name,book_author from book_info,book_point where book_point.book_name=book_info.book_name"
		 					+"and book_type=%s group by book_info.book_name limit %d,%d",op1,pgno*pgcnt,pgcnt);
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
			  stmt.close();
			  con.close();
				}
			}
				
			 
		}catch (Exception e){
			  msg = e.getMessage();
		}
%>      

<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; utf-8">
<title>web-pro</title>
</head>
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
			hight:20px;
			margin: 0 auto;
            position:relative;
            background:rgba(174,143,038,1);
        }
        .user{
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
</style>
<body>
	<header id="header" >
			<div class="user">
					<a href="LR.jsp">登录</a>
					<a href="LR.jsp">注册</a>
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
						<input class="btn hits" type="submit" value="搜索" >
					</div>
				</form>						
			</div>
		</div>	
	</div>
	
	<div id="main">
		<div id="left">
			<span class="fenlei">分类：</span>
			<ul class="leftlist">
				<li><a href=Main.jsp?op=全部&cout=0>全部</a></li>
				<li><a href=Main.jsp?op=言情&cout=0>言情</a></li>
				<li><a href=Main.jsp?op=惊悚&cout=0>惊悚</a></li>
				<li><a href=Main.jsp?op=校园&cout=0>校园</a></li>
				<li><a href=Main.jsp?op=经典&cout=0>经典</a></li>
				<li><a href=Main.jsp?op=儿童&cout=0>儿童</a></li>
				<li><a href=Main.jsp?op=科学&cout=0>科学</a></li>
				<li><a href=Main.jsp?op=历史&cout=0>历史</a></li>
				<li><a href=Main.jsp?op=玄幻&cout=0>玄幻</a></li>
			</ul>
		</div>
		<div class="mainbody">
		<div id="type"><a><%=op1 %></a></div>
			
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