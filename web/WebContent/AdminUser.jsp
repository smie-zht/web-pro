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
	
	String msg ="";
	String word ="";
	Integer pgno = 0; //当前页号
	Integer pgcnt = 15;  //每页行数
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
		  if(request.getMethod().equalsIgnoreCase("get")){
			  String sql=String.format("select * from user_info where user_name!='Admin' limit %d,%d",
					  pgno*pgcnt,pgcnt);
			  ResultSet rs1=stmt.executeQuery(sql);
			  table.append("<table><tr><th>用户名</th><th>密码</th><th>小黑屋</th>"+
					  "<th>编辑</th></tr>");
			  while(rs1.next()) {
		             table.append(String.format(
		            		 "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s %s</td></tr>",
		            		 rs1.getString("user_name"),rs1.getString("user_password"),rs1.getInt("user_able")==1?"正常":"禁止登陆",
		            		 "<a href='AdminUserUpdate.jsp?uid="+rs1.getString("user_id")+"'>修改</a>",
		            		 "<a href='AdminUserDelete.jsp?uid="+rs1.getString("user_id")+"'>删除</a>"
		            		 ));
			  }
			  table.append("</table>");
			  rs1.close();
			  stmt.close();
			  con.close();
		  }
		  else if (request.getMethod().equalsIgnoreCase("post")) {
			  word = request.getParameter("query");
		      String sql = "select * from user_info where user_name like '%"+word+"%'";
			  table.append("<table><tr><th>用户名</th><th>密码</th><th>小黑屋</th>"+
					  "<th>编辑</th></tr>");
			  ResultSet rs2=stmt.executeQuery(sql);
			  while(rs2.next()) {
		             table.append(String.format(
		            		 "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s %s</td></tr>",
		            		 rs2.getString("user_name"),rs2.getString("user_password"),rs2.getInt("user_able")==1?"正常":"禁止登陆",
		            		 "<a href='AdminUserUpdate.jsp?pid="+rs2.getString("user_id")+"'>修改</a>",
		            		 "<a href='AdminUserDelete.jsp?pid="+rs2.getString("user_id")+"'>删除</a>"
		            		 ));
			  }
			  table.append("</table>");
			  rs2.close();
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
<title><%=ifAdmin==1?"管理用户":"出错啦" %></title>
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
      <h2>用户清单</h2>
  	  <br/><br/>
	  <form action="AdminUser.jsp" method="post" name="f">
		搜索用户:&nbsp;&nbsp;<input id="query" name="query" type="text" value="<%=word %>">&nbsp;&nbsp;		                     
		<input type="submit" name="sub" value="Search">
		                     <br/><br/>
	  </form> 
	  <%=table%><br/><br/>
	  <div style="float:left;padding-left:80px;">
	  <a href="AdminUser.jsp?pgno=<%=pgprev%>&pgcnt=<%=pgcnt%>">上一页</a>
	  </div>
	  <div style="float:right;padding-right:80px;">
      
      <a href="AdminUser.jsp?pgno=<%=pgnext%>&pgcnt=<%=pgcnt%>">下一页</a>
      </div>
	  <br/><br/>
	  <br/><br/><%=msg %>
	  <br/><br/>     
  </div>
  
</body>
</html>