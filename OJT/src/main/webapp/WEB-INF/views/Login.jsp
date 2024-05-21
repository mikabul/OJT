<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="root" value="${pageContext.request.contextPath }/"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>INNOBL 관리 시스템</title>
<script src="${root}resources/lib/javascript/jquery-3.7.1.min.js"></script>
<link rel="stylesheet" href="${root}resources/style/Main.css" />
<style>
.top-nav {
	width: 100%;
	height: 60px;
	top: 0%;
	background-color: black;
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	align-items: center;
	position: fixed;
	left: 0%;
	z-index: 5;
}

.top-logo {
	color: lightcyan;
    font-size: 20px;
    font-weight: 600;
    text-decoration: none;
}

.container {
	width: 100%;
	height: 700px;
	display: flex;
	justify-content:center;
	align-items: center;
}

.login-wrap {
	border: 1px solid #F1F3F4;
	border-radius: 1em;
	width: 455px;
	height: 255px;
	display: grid;
	align-content: center;
}

.loginBtn {
	margin-top: 10px;
	width: 400px;
	height: 36px;
}

.input-box {
	width: 400px;
	height: 25px;
	margin: 5px 0;
}

.input-box:focus {
	outline-color: #01DF74;
}
</style>
</head>
<body style="margin-top: 60px;">
	<!-- 상단 바 -->
	<nav class="top-nav">
		<div class="w-100 text-center">
			<span class="top-logo">INNOBL 관리 시스템</span>
		</div>
	</nav>
	<!-- 로그인 -->
	<form action="login" method="POST">
		<div class="container">
			<div class="login-wrap">
				<div class="w-100 text-center">
					<div>
						<input name="memberId" class="input-box" placeholder="아이디" value="${ memberId }"/>
					</div>
					<div>
						<input type="password" name="memberPW" class="input-box" placeholder="비밀번호" />
					</div>
				</div>
				<c:if test="${ error == true }">
					<div class="text-center">
						<span class="errors">아이디 혹은 비밀번호를 확인해주세요.</span>
					</div>
				</c:if>
				<div class="w-100 text-center">
					<button type="submit" class="loginBtn">로그인</button>
				</div>
			</div>
		</div>
	</form>
</body>
</html>