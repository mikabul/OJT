<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>INNOBL - 메인</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<style>
	.pie-chart {
  position: relative;
  display:inline-block;
  width: 200px;
  height: 200px;
  border-radius: 50%;
  transition: 0.3s;
}
span.center{
  background: #fff;
  display : block;
  position: absolute;
  top:50%; left:50%;
  width:100px; height:100px;
  border-radius: 50%;
  text-align:center; 
  line-height: 100px;
  font-size:30px;
   transform: translate(-50%, -50%);
}
</style>
</head>
<body style="margin: 60px 0;">
	<c:import url="/WEB-INF/views/include/TopMenu.jsp" />
	
	<div class="pie-chart pie-chart1"><span class="center">80%</span></div>


<div class="pie-chart pie-chart2"><span class="center">50%</span></div>


<div class="pie-chart pie-chart3"><span class="center">30%</span></div>
</body>
<script>

	$(window).ready(function() {
		draw(80, '.pie-chart1', '#ccc');
		draw(50, '.pie-chart2', '#8b22ff');
		draw(30, '.pie-chart3', '#ff0');
	});

	function draw(max, classname, colorname) {
		var i = 1;
		var func1 = setInterval(function() {
			if (i < max) {
				color1(i, classname, colorname);
				i++;
			} else {
				clearInterval(func1);
			}
		}, 10);
	}
	function color1(i, classname, colorname) {
		$(classname).css(
				{
					"background" : "conic-gradient(" + colorname + " 0% " + i
							+ "%, #ffffff " + i + "% 100%)"
				});
	}
</script>
</html>