<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<link rel="stylesheet" href="${root}resources/style/TopMenu.css" />
<nav class="nav">
	<div>
		<button id="side_btn" class="btn">메뉴</button>
	</div>
	<div>
		<a class="logo" href="${root}Main">INNOBL 관리 시스템</a>
	</div>
	<div>
		<button class="btn" id="logout"
			onclick="location.href='${root}Logout'">로그아웃</button>
	</div>
</nav>
<div class="side-menu-bar">
	<ul class="side-menu">
		<li><a href="${root}project/Main">프로젝트</a></li>
		<li><a href="${root}member/Main">사원</a></li>
	</ul>
</div>
<script>
	var side_state = false;

	$("#side_btn").click(function() {
		if (side_state) {
			$(".side-menu-bar").removeClass("show");
			side_state = false;
		} else {
			$(".side-menu-bar").addClass("show");
			side_state = true;
		}
	})
</script>