<%@ page language="java" import="java.util.*,java.sql.*,java.net.URLEncoder,java.net.URLDecoder" 
         contentType="text/html; charset=utf-8"%>
<%
	request.setCharacterEncoding("utf-8");
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
				if(uname.equals("Admin")) ifAdmin=1;	
				break;
			}
		}
	}
	


	String msg ="";
	String word ="";
	Integer pgno = 0; //当前页号
	Integer pgcnt = 12;  //每页行数
	String param = request.getParameter("pgno");
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
    StringBuilder table=new StringBuilder("");
    
	try{
		  Class.forName("com.mysql.jdbc.Driver");
		  Connection con=DriverManager.getConnection(connectString, 
		                 "user", "123");
		  Statement stmt=con.createStatement();
		  if(request.getMethod().equalsIgnoreCase("post")&&request.getParameter("search") != null){
			  word = request.getParameter("query");
		      
			  String sql = "select * from book_point where book_name like '%"+word
					  +"%' limit "+pgno*pgcnt+","+pgcnt+";";
			  ResultSet rs2=stmt.executeQuery(sql);
			  table.append("<table><tr><th>书名</th><th>评分</th><th>用户ID</th>"+
					  "<th>删除</th></tr>");
			  while(rs2.next()) {
		             table.append(String.format(
		            		 "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>",
		            		 rs2.getString("book_name"),rs2.getString("book_point"),
		            		   rs2.getInt("user_id")==0?"未注册用户":rs2.getInt("user_id"),
		            			"<input type='checkbox' name='delete' value='"+rs2.getInt("mark_id")+"'>"
		            		   ));
			  }
			  table.append("</table>");
			  rs2.close();
			  stmt.close();
			  con.close(); 
		  }
		  else {
			  //首先获取选中的复选框
			  String[] selected = request.getParameterValues("delete");
			  if (selected != null && selected.length != 0) {
				  for(int i=0;i<selected.length;i++){
				      String fmt="delete from book_point where mark_id=%s";
				      String sql = String.format(fmt,selected[0]);
				      int cnt = stmt.executeUpdate(sql);
				      if(cnt>0)	msg = "成功清理评分!";
				      
				  }
			  }
			  String sql=String.format("select * from book_point limit %d,%d",
					  pgno*pgcnt,pgcnt);
			  ResultSet rs1=stmt.executeQuery(sql);
			  table.append("<table><tr><th>书名</th><th>评分</th><th>用户ID</th>"+
					  "<th>删除</th></tr>");
			  while(rs1.next()) {
		             table.append(String.format(
		            		 "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>",
		            		 rs1.getString("book_name"),rs1.getString("book_point"),
		            		   rs1.getInt("user_id")==0?"未注册用户":rs1.getInt("user_id"),
		            			"<input type='checkbox' name='delete' value='"+rs1.getInt("mark_id")+"'>"
		            		   ));
		             			
			  }
			  table.append("</table>");
			  rs1.close();
			  stmt.close();
			  con.close();
		  }
		}
		catch (Exception e){
		  msg = e.getMessage();
		}
%>
<!DOCTYPE HTML>
<html>
<head>
<title><%=ifAdmin==1?"管理评分":"出错啦" %></title>
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
    width:500px;  
    text-align:center;  
  }  
  p {text-align:left;  }
</style>
</head>
<body>
  <div class="container" style="<%=ifAdmin==1?"display:none;":"" %>>">
  <br/><br/><h2>这位同学你走错片场啦</h2><br/><br/>
  </div>
  <div class="container" style="<%=ifAdmin!=1?"display:none;":"" %>>">
      <h2>评分清单</h2>
  	  <br/><br/>
	  <div>
	  <form action="AdminMark.jsp" method="post" name="f">
		查询图书:&nbsp;<input id="query" name="query" type="text" value="<%=word %>">&nbsp;
				                     
		<input type="submit" name="search" value="Search"><br/>
		
		<br/>
	  <%=table%>
	  <input type="submit" name="clear" value="清理" style="float:right;margin:8px 15px 0px 0px;"/><br/><br/><br/>
	  </form>
	  </div>
	  
	  
	  <div style="float:left;padding-left:120px;">
	  <a href="AdminMark.jsp?pgno=<%=pgprev%>&pgcnt=<%=pgcnt%>">上一页</a>
	  </div>
	  <div style="float:right;padding-right:120px;">
      
      <a href="AdminMark.jsp?pgno=<%=pgnext%>&pgcnt=<%=pgcnt%>">下一页</a>
      </div>
	  <br/><br/><%=msg %>
	      
  </div>
  
</body>
</html>