<%@ page language="java" import="java.util.*,java.sql.*,java.net.URLEncoder,java.net.URLDecoder" 
 pageEncoding="gb2312"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
  <head>
    <base href="<%=basePath%>">
    <title>��ȡ�ͻ��˵�Cookie��Ϣ</title>
  </head>
  
  <body>
    ��ȡ�ͻ��˵�Cookie��Ϣ. <br>
   <%
     // ��õ�ǰ·���Լ�"ֱ�Ӹ�·��"������Cookie����,���û���κ�Cookie�Ļ�,�򷵻�null   
     Cookie[] cookies = request.getCookies();
     
     // ��������,��þ����Cookie
     if(cookies == null) {
        out.print("û��Cookie��Ϣ");
     } else {
         for(int i=0; i<cookies.length; i++) {
            // ��þ����Cookie
            Cookie cookie = cookies[i];
            // ���Cookie������
            String name = cookie.getName();
            String value = URLDecoder.decode(cookie.getValue(), "UTF-8");
            out.print("Cookie��:"+name+" &nbsp; Cookieֵ:"+value+"<br>");
         }
     } 
    %>
  </body>
</html>