<%@ page language="java" import="java.io.*,java.util.*,java.sql.*,
	org.apache.commons.io.*,org.apache.commons.fileupload.*,
	org.apache.commons.fileupload.disk.*,
	org.apache.commons.fileupload.servlet.*
	,java.net.URLEncoder,java.net.URLDecoder"
 contentType="text/html; charset=utf-8"%>

<% request.setCharacterEncoding("utf-8"); 
	int isAdmin = 0;
	int user_id = 0;
	String userName = "未登录";
	//获取cookid流
	Cookie[] cookies = request.getCookies();
	if(cookies!=null){
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
	}
	
String msg = ""; 
String connectString = "jdbc:mysql://172.18.187.234:53306/boke15352405"
		+ "?autoReconnect=true&useUnicode=true"
		+ "&characterEncoding=UTF-8&useSSL=false";  
 String user="user"; 
 String pwd="123"; 
 String SQLitem[] = new String[7]; 
 String bname = "";
 String aname="";
 String bpic="";
 String book="";
 String introduce="";
 
 if(request.getMethod().equalsIgnoreCase("post")){ 
	 Class.forName("com.mysql.jdbc.Driver");
	 Connection con = DriverManager.getConnection(connectString,user, pwd); 
	 Statement stmt = con.createStatement(); 
	 boolean isMulti = ServletFileUpload.isMultipartContent(request);
	 if(isMulti){
		 FileItemFactory factory = new DiskFileItemFactory();
		 ServletFileUpload upload = new ServletFileUpload(factory);
		 
		 List items = upload.parseRequest(request);
		 for(int i=0;i<items.size();i++){
			 FileItem fi = (FileItem) items.get(i);
			 if(fi.isFormField()){//表单字段
				 //SQLitem[i] = fi.getString();
			 	//out.print("No."+i+fi.getFieldName()+":"+fi.getString("utf-8"));
			 	SQLitem[i] = new String(fi.getString("utf-8"));
			 }
			 else{//文件
				 DiskFileItem dfi = (DiskFileItem) fi;
			 	 if(!dfi.getName().trim().equals("")){//文件名非空
			 		 String fileName = application.getRealPath("/file")
			 		 				   + System.getProperty("file.separator")
			 		 				   + FilenameUtils.getName(dfi.getName());
			 	 
			 		//out.print("No."+i+new File(fileName).getAbsolutePath());
			 	 	//SQLitem[i]=fileName;
			 		SQLitem[i]= new String(new File(fileName).getAbsolutePath());
			 		dfi.write(new File(fileName));
			 		//out.print(new File(fileName).getAbsolutePath());
			 		//dfi.write(new File(fileName));
			 	 }
			 }
		 }
		 
	 }
	 try{ 
		 //处理转义字符
		 String pic_url = SQLitem[4].replaceAll("\\\\","/");
		 String bk_url = SQLitem[5].replaceAll("\\\\", "/");
		 //out.print("ok  "+pic_url);
		 String sql="insert into book_info(book_name,book_author,book_image,book_url,book_info,book_type)"
	     +" values('"+SQLitem[0]+"', '"+SQLitem[1]+"', '"+pic_url+"', '"+bk_url+"', '"+SQLitem[3]
	    		 +"','"+SQLitem[2]+"')"; 
		                               //bname     aname        bpic       book     introduce    type
//		 String sql = String.format(fmt,SQLitem[0],SQLitem[1],SQLitem[4],SQLitem[5],SQLitem[2],SQLitem[3]); 
		 int cnt = stmt.executeUpdate(sql); 
		 if(cnt>0){
			 Random rnd = new Random(user_id); 
			 int rndP = rnd.nextInt(10);
			 String RndP = String.valueOf(rndP);
			 String sql1 = "insert into book_point (book_name,book_point,user_id) values('"+SQLitem[0]+"','"+RndP+"','"+String.valueOf(user_id)+"')";
			 int cnt1 = stmt.executeUpdate(sql1); 
			 if(cnt1>0){
				 msg = "上传成功！ 图书系统自动评分为："; 
				 msg = msg +RndP;
			 }
		 }
		 stmt.close(); 
		 con.close(); 
		}catch (Exception e){ msg = e.getMessage(); } 
   } %>


<!DOCTYPE HTML>
<html>
<head>
	<title>上传图书</title>
	
	 <style> a:link,a:visited {color:blue;} 
	 body{background:url("./RES/background.jpg");}
	.container{
			margin:100px auto;width:500px;text-align:center;
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
	 	<h1>用户上传图书</h1> 
	 	<form action="bookUpdate.jsp" method="post" enctype="multipart/form-data">
	 	书名:<input id="bname" type="text" name="bname">
	 	<br></br>
	 	作者:<input id="aname" type="text" name="aname">
	 	<br></br>
	 	类型:
	 	<input id="type" type="radio" name="type" value="言情"/>言情
	 	<input id="type" type="radio" name="type" value="惊悚"/>惊悚
	 	<input id="type" type="radio" name="type" value="校园"/>校园
	 	<br/>
	 	<input id="type" type="radio" name="type" value="经典"/>经典
	 	<input id="type" type="radio" name="type" value="儿童"/>儿童
	 	<input id="type" type="radio" name="type" value="科学"/>科学
	 	<input id="type" type="radio" name="type" value="历史"/>历史
	 	<br></br>
	 	简介:<input id="introduce" type="text" name="introduce">
	 	<br></br>
	 	图片<input id="bpic" type="file" name="bpic">
	 	<br></br>
	 	图书文件<input id="book" name="book" type="file">
	 	<br></br>
	 	<input type="submit" name="submit" value="上传">
	 	<input type="reset"  name="reset"  value="重置"> 
		</form> 
		<br></br>
		<%=msg %>
		<br><a href='Main.jsp'>返回</a> 
	 </div>

</html>
