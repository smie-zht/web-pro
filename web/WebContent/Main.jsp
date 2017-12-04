<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"%>
      

<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; utf-8">
<title>web-pro</title>
<style type="text/css">
		.slides {
			margin:0; padding:0; position:absolute; white-space: nowrap;
			animation: myfirst 12s infinite;
			height=1024px;
			overflow:hideen;
        }
        @keyframes myfirst { 
            0%{left: 0}
            50% { left: -1024px; }
            100% { left: -2048px; }
        }
</style>

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
	<div style="clear:both"></div>
	<div id="slide" style="height:200px;width:1024px;overflow:hidden;">
         <div class="slides">
                <span><img class="slide" src="./RES/slide1.jpg" height="180" width="1024" /></span>
                <span><img class="slide" src="./RES/slide2.jpg" height="180" width="1024"/></span>
                <span><img class="slide" src="./RES/slide3.jpg" height="180" width="1024"/></span>
         </div>
    </div>
    
</header>
</body>
</html>