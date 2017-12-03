<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"%>
      

<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; utf-8">
<title>web-pro</title>
</head>
<body>
<header class="header" style="position: fixed; top: 0px;">
	
	<div class="header" >
		
		<div class="navbar_img" style="float:left">
			<a href="http://www.shuchongwang.com/index.html" class="logo"><img src="./RES/logo.png" alt="1"></a>
		</div>
		
		<div class="input_top" style="float:left;margin-top:20px;margin-left:15px">
			<form action="http://www.shuchongwang.com/search.html" method="get" id="searchForm">
				<div class="nav_left">
					<input type="text" class="input" name="keywords" placeholder="搜索你想查找的图书" id="searchKeywordsId" value="" autocomplete="off">
					<input class="btn hits" type="submit" value="搜索" >
				</div>
			</form>						
		</div>
		
		<div class="user" style="float:left">
			<ul class="ul01">
					<li><a href="http://www.shuchongwang.com/login.html">登录</a></li>
					<li class="log_top"><a href="http://www.shuchongwang.com/publicRaiseChannel/register.html">注册</a></li>
			</ul>
		</div>
		
	</div>
	
</header>
</body>
</html>