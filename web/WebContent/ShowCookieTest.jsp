<%@ page language="java" import="java.util.*,java.sql.*,java.net.URLEncoder,java.net.URLDecoder" 
 pageEncoding="gb2312"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
  <head>
    <base href="<%=basePath%>">
    <title>读取客户端的Cookie信息</title>
  </head>
  
  <body>
    读取客户端的Cookie信息. <br>
   <%
     // 获得当前路径以及"直接父路径"的所有Cookie对象,如果没有任何Cookie的话,则返回null   
     Cookie[] cookies = request.getCookies();
     
     // 遍历数组,获得具体的Cookie
     if(cookies == null) {
        out.print("没有Cookie信息");
     } else {
         for(int i=0; i<cookies.length; i++) {
            // 获得具体的Cookie
            Cookie cookie = cookies[i];
            // 获得Cookie的名称
            String name = cookie.getName();
            String value = URLDecoder.decode(cookie.getValue(), "UTF-8");
            out.print("Cookie名:"+name+" &nbsp; Cookie值:"+value+"<br>");
         }
     } 
    %>
  </body>
</html>