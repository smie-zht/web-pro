<%@ page language="java" import="java.io.*,java.util.*,java.sql.*,
	org.apache.commons.io.*,org.apache.commons.fileupload.*,
	org.apache.commons.fileupload.disk.*,
	java.net.URLEncoder,java.net.URLDecoder"
 contentType="text/html; charset=utf-8"%>

<% 
	request.setCharacterEncoding("utf-8"); 
	//get User_id from cookie
		Cookie[] cookies = request.getCookies();//get cookies
	int isAdmin = 0;
	String userName = "未登录";
	int userId = 0; //保存USER_id
	//遍历cookies，获取名为scuid的cookie，获取其中的值
	for(int i=0;i<cookies.length;i++){
		Cookie cookie = cookies[i];
		String cookieName = cookie.getName();
		if(cookieName.equals("scuid")){
			userId = Integer.parseInt(cookie.getValue());
			if(userId==1) isAdmin=1;
		}
		if(cookieName.equals("scuname")){
    		userName = URLDecoder.decode(cookie.getValue(), "UTF-8");
    	}
	}
	
	String msg = ""; 
	String connectString = "jdbc:mysql://172.18.187.234:53306/boke15352405"
		+ "?autoReconnect=true&useUnicode=true"
		+ "&characterEncoding=UTF-8&useSSL=false";  
 	String user="user"; 
 	String pwd="123";
 
	 String bk_dir="";//book direction in SQL 
	 String bk_name=""; //book name in SQL
	 String a_name="";//author name in SQL
	 StringBuffer buffer = new StringBuffer();
	 String getPoint = request.getParameter("point");
	 float point;
	 Class.forName("com.mysql.jdbc.Driver");
	 Connection con = DriverManager.getConnection(connectString,user, pwd); 
	 Statement stmt = con.createStatement(); 
	 //获取bookid
	 String bid=request.getParameter("bookid");  
	 if(bid == null){
		 String bnam = request.getParameter("bookName");
		 try{
			String sql2 = "select * from book_info where book_name = '"+bnam+"'";
			ResultSet rs=stmt.executeQuery(sql2);
			if(rs.next()){
				 //out.print("查询成功！");
				bid = rs.getString("book_id");
			 }
		 }catch(Exception e){ msg = e.getMessage(); } 
			 
	 }
	 
	 try{ 
		 //处理转义字符
		 String sql = "select * from book_info where book_id = '"+bid+"'" ; 
		 ResultSet rs=stmt.executeQuery(sql);
		 //out.print("查询！");
		 if(rs.next()){
			 //out.print("查询成功！");
			 a_name = rs.getString("book_author");
			 bk_name = rs.getString("book_name");
			 bk_dir = rs.getString("book_url");
			 Scanner scan = new Scanner(new FileInputStream(bk_dir));
		      scan.useDelimiter("\n");
		      while(scan.hasNext()){
		          buffer.append(scan.next()).append("\n");
		      }
		      scan.close();
		 }
		//提及评分
			if(getPoint!=null&&!getPoint.isEmpty())
			{
				point=Float.parseFloat(getPoint);
				if(point>=0&&point<=10){
					try{ 
						 String sql1 = "insert into book_point (book_name,book_point,user_id) values('"+bk_name+"','"+getPoint+"','"+String.valueOf(userId)+"')"; 
						 int cnt = stmt.executeUpdate(sql1); 
						 if(cnt>0){
							 out.print("评分上传成功!"); 
						 }
						}catch (Exception e){ msg = e.getMessage(); } 
				}
				else{
					out.print("评分无效!"); 
				}
 
			}
		 stmt.close(); 
		 con.close(); 
		}catch (Exception e){ msg = e.getMessage(); } 
			
 %>

<!DOCTYPE HTML>
<html>
<head>
	<title>阅读图书</title>
	 <style> 
	 	a:link,a:visited {color:blue;} 
	 	.container{  
	 		margin:0 auto;
	 		width:980px;
	 		text-align:center;
	 	} 
	 	#user{
	 		width:100px;
	 		height:40px;
	 		float:right;
	 		font-family:楷体;
	 		font-size:20px;
	 	}
		#content{
			border:1px  solid red;
			width:960px;
			height:680px;
			margin:0px auto;
			padding: 20px;
		}
		.goBack{
			height:20px;
			width:50px;
			border:1px solid rgb(150,150,150);
			background-color:rgba(66,66,66,0.3);
			margin:20px;
			border-radius:3px;
		}
		#book{
			overflow:scroll;
			margin:10px;
			border:1px  solid green;
			width:900px;
			height:480px;
			margin:0px auto;
			padding: 20px;
		}
	}
	
	
	
	 </style> 
</head>
	<body><%request.setCharacterEncoding("utf-8");%>
	 <div class="container"> 
	 	<div id="user">当前用户：<%=userName %></div>
	 	<div id="content">
	 	<h1>《<%=bk_name %>》</h1><h4>作者：<%=a_name %></h4>
	 	<div id="book">
	 	 <%=buffer %>
	 	</div>
	 	 <div>
	 	 	<form action="Read.jsp?bookid=<%=bid %>" method="post" id="point">
	 	 		<br/>喜欢这部作品，就为它打分吧！（0~10）
	 	 		<input type=text name ="point" id = "point">
	 	 		<input type="submit" value="评分">
	 	 	</form>
	 	 </div>
	 	 
	 	</div>
		<div class="goBack"><a href='Main.jsp'>返回</a></div>
	 </div>	 
</html>
