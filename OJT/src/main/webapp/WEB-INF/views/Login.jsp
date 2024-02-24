<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="root" value="${pageContext.request.contextPath }/"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>INNOBL 관리 시스템</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9" crossorigin="anonymous">
</head>
<body>
	<!-- 상단 메뉴 -->
	<nav class="navbar bg-body-tertiary">
		<div class="container-fluid justify-content-center">
			<div class="navbar-brand">INNOBL 관리 시스템</div>
		</div>
	</nav>
	<!-- 로그인 -->
	<div>
		<form:form action="${root}Login" modelAttribute="memberBean" method="POST">
			<!-- 아이디 -->
			<div class="row g-3 align-items-center">
				<div class="col-auto">
					<label for="inputPassword6" class="col-form-label">Password</label>
				</div>
				<div class="col-auto">
					<input type="password" id="inputPassword6" class="form-control"
						aria-describedby="passwordHelpInline">
				</div>
				<div class="col-auto">
					<span id="passwordHelpInline" class="form-text"> Must be 8-20
						characters long. </span>
				</div>
			</div>
			<!-- 비밀번호 -->
			<div class="row g-3 align-items-center">
				<div class="col-auto">
					<label for="inputPassword6" class="col-form-label">Password</label>
				</div>
				<div class="col-auto">
					<input type="password" id="inputPassword6" class="form-control"
						aria-describedby="passwordHelpInline">
				</div>
				<div class="col-auto">
					<span id="passwordHelpInline" class="form-text"> Must be 8-20
						characters long. </span>
				</div>
			</div>
			<form:button type="submit"> submit </form:button>
		</form:form>
	</div>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>
</body>
</html>