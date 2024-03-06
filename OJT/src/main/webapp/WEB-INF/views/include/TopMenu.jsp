<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<link rel="stylesheet" href="${root}resources/style/TopMenu.css" />
<nav class="top-nav">
	<div>
		<button id="side_btn" class="top-btn top-btn-white">메뉴</button>
	</div>
	<div>
		<a class="top-logo" href="${root}Main">INNOBL 관리 시스템</a>
	</div>
	<div>
		<button class="top-btn" id="logout"
			onclick="location.href='${root}Logout'">로그아웃</button>
	</div>
</nav>
<div class="top-side-menu-bar">
	<ul class="top-side-menu">
		<li><a href="${root}project/Main">프로젝트</a></li>
		<li><a href="${root}member/Main">사원</a></li>
	</ul>
</div>
<script>
	var side_state = false;

	$("#side_btn").click(function() {
		if (side_state) {
			$(".top-side-menu-bar").removeClass("top-show");
			side_state = false;
		} else {
			$(".top-side-menu-bar").addClass("top-show");
			side_state = true;
		}
	})
</script>