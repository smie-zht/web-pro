<%@ page language="java" import="java.io.*,java.util.*,java.sql.*,
	org.apache.commons.io.*,org.apache.commons.fileupload.*,
	org.apache.commons.fileupload.disk.*,
	org.apache.commons.fileupload.servlet.*"
 contentType="text/html; charset=utf-8"%>

<% request.setCharacterEncoding("utf-8"); 
String msg = ""; 
String connectString = "jdbc:mysql://172.18.187.234:53306/boke15352405"
		+ "?autoReconnect=true&useUnicode=true"
		+ "&characterEncoding=UTF-8&useSSL=false";  
 String user="user"; 
 String pwd="123"; 
 String SQLitem[] = new String[6]; 
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
			 		//dfi.write(new File(filename));
			 		//out.print(new File(fileName).getAbsolutePath());
			 		//dfi.write(new File(fileName));
			 	 }
			 }
		 }
		 
		 bname = request.getParameter("bname");
		 aname = request.getParameter("aname");
		 introduce = request.getParameter("introduce");
		 String filePic = "pic-address";
		 String fileBook = "book-address";
		 bpic = filePic;
		 book = fileBook;
	 }
	 try{ 
		 String fmt="insert into book_info(book_name,book_author,book_image,book_url,book_info)"
	     +" values('%s', '%s', '%s', '%s', '%s')"; 
		                               //bname     aname        bpic       book     introduce
		 String sql = String.format(fmt,SQLitem[0],SQLitem[1],SQLitem[3],SQLitem[4],SQLitem[2]); 
		 int cnt = stmt.executeUpdate(sql); 
		 if(cnt>0)msg = "上传成功成功!"; 
		 stmt.close(); 
		 con.close(); 
		}catch (Exception e){ msg = e.getMessage(); } 
	} %>


<!DOCTYPE HTML>
<html>
<head>
	<title>上传图书</title>
	 <style> a:link,a:visited {color:blue;} 
	.container{  margin:0 auto;width:500px;text-align:center;} 
	 </style> 
</head>
	<body>
	 <div class="container"> 
	 	<h1>用户上传图书</h1> 
	 	<form action="bookUpdate.jsp" method="post" enctype="multipart/form-data">
	 	书名:<input id="bname" type="text" name="bname">
	 	<br></br>
	 	作者:<input id="aname" type="text" name="aname">
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
	</body>
</html>
