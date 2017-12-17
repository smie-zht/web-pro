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
 
 boolean ifok=true;
 if(request.getMethod().equalsIgnoreCase("post")){ 
	 Class.forName("com.mysql.jdbc.Driver");
	 Connection con = DriverManager.getConnection(connectString,user, pwd); 
	 Statement stmt = con.createStatement(); 
	 boolean isMulti = ServletFileUpload.isMultipartContent(request);
	 if(isMulti){
		 FileItemFactory factory = new DiskFileItemFactory();
		 ServletFileUpload upload = new ServletFileUpload(factory);
		 
		 List items = upload.parseRequest(request);
		 
		 if(items.size()==7) {
			 String bn = "";
			 for(int i=0;i<items.size();i++){
				 FileItem fi = (FileItem) items.get(i);
				 if(fi.isFormField()){//表单字段
					 if(fi.getString().trim().equals(""))
						 ifok=false;
					 else
						 SQLitem[i] = new String(fi.getString("utf-8"));
					 if(fi.getFieldName().equals("bname"))
						 bn=SQLitem[i];
				
				 }
				 else{//文件
					 DiskFileItem dfi = (DiskFileItem) fi;
				 	 if(!dfi.getName().trim().equals("")){//文件名非空
				 		 String newname = bn+"_"+fi.getFieldName()+"_"+FilenameUtils.getName(dfi.getName());
				 		 String fileName = application.getRealPath("/file")
				 		 				   + System.getProperty("file.separator")
				 		 				   + newname;
				 		//out.print("No."+i+new File(fileName).getAbsolutePath());
				 	 	//SQLitem[i]=fileName;
				 		SQLitem[i]= new String(new File(fileName).getAbsolutePath());
				 		SQLitem[i]= "file/"+newname;
				 		dfi.write(new File(fileName));
				 		//System.out.print(new File(fileName).getAbsolutePath());
				 		//dfi.write(new File(fileName));
				 	 }
				 	 else
				 		ifok=false;
				 }
			 }
		 }
		 else
			 ifok=false;
		 
		 
	 }
	 if(ifok){
		 try{ 
			 String sql="insert into book_info(book_name,book_author,book_image,book_url,book_info,book_type)"
		     +" values('"+SQLitem[0]+"', '"+SQLitem[1]+"', '"+SQLitem[4]+"', '"+SQLitem[5]+"', '"+SQLitem[3]
		    		 +"','"+SQLitem[2]+"')"; 
			                               //bname     aname        bpic       book     introduce    type
//			 String sql = String.format(fmt,SQLitem[0],SQLitem[1],SQLitem[4],SQLitem[5],SQLitem[2],SQLitem[3]); 
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
			}catch (Exception e){
				msg = e.getMessage(); 
				String message = "上传图书出错拉，可能已经存在此书籍喔。";
				out.println("<SCRIPT LANGUAGE='JavaScript'>");
				out.println("<!--");
				out.println("alert('"+message+"')");
				out.println("//-->");
				out.println("</SCRIPT>");
			} 
	 }
	 else {
		 String message = "请完确认填写所有信息！输入不能为空喔~";
		 out.println("<SCRIPT LANGUAGE='JavaScript'>");
		 out.println("<!--");
		 out.println("alert('"+message+"')");
		 out.println("//-->");
		 out.println("</SCRIPT>");
	 }
	
} %>


<!DOCTYPE HTML>
<html>
<head>
	<title>上传图书</title>
	
	 <style> a:link,a:visited {color:blue;} 
	 body{background:url("./RES/background.jpg");}
	.container{
			margin:40px auto;width:500px;text-align:center;
			background-color:rgba(255,255,255,0.7);
			border:2px solid white;
			border-radius:2px;} 
	#user{
			margin:20px auto 0 auto;
			text-shadow:0 0 20px red;
	 		width:400px;height:40px;
	 		color:white;
	 		font-family:黑体;font-size:18px;
	 		text-align:center;
	 	}
	 
	 </style> 
</head>
	<body><%request.setCharacterEncoding("utf-8");%>

	<div id="user">当前用户：<%=userName %></div>
	
	 <div class="container"> 
	 	<h1>用户上传图书</h1> 
	 	<form action="bookUpdate.jsp" method="post" enctype="multipart/form-data">
	 	书名:<input id="bname" type="text" name="bname">
	 	<br/><br/>
	 	作者:<input id="aname" type="text" name="aname">
	 	<br/><br/>
	 	类型:
	 	<input id="type" type="radio" name="type" value="言情"/>言情
	 	<input id="type" type="radio" name="type" value="惊悚"/>惊悚
	 	<input id="type" type="radio" name="type" value="校园"/>校园
	 	<input id="type" type="radio" name="type" value="经典"/>经典
	 	<br/><br/>
	 	<input id="type" type="radio" name="type" value="儿童"/>儿童
	 	<input id="type" type="radio" name="type" value="科学"/>科学
	 	<input id="type" type="radio" name="type" value="历史"/>历史
	 	<input id="type" type="radio" name="type" value="玄幻"/>玄幻
	 	<br/><br/>
	 	简介:<input id="introduce" type="text" name="introduce">
	 	<br/><br/>
	 	封面:<input id="bpic" type="file" name="bpic">
	 	<br/><br/>
	 	文档:<input id="book" name="book" type="file">
	 	<br/><br/><br/>
	 	<input type="submit" name="submit" value="上传">
	 	<input type="reset"  name="reset"  value="重置"> 
		</form> 
		<br/>
		<%=msg %>
		<br/><a href='UserPage.jsp'>返回</a> <br/><br/>
	 </div>

</html>
