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
<style>
table {
	margin: 0 auto;
	margin-top: 300px;
	border: 1px solid gray;
}
</style>
</head>
<body>
	<!-- 상단 메뉴 -->
	<nav class="navbar bg-body-tertiary">
		<div class="container-fluid justify-content-center">
			<div class="navbar-brand">INNOBL 관리 시스템</div>
		</div>
	</nav>
	<!-- 로그인 -->
	<form:form action="${root}Login" modelAttribute="memberBean"
		method="POST">
		<table>
			<colgroup>
				<col style="width: 100px" />
				<col style="width: 300px" />
			</colgroup>
			<thead>
				<tr>
					<td colspan="2">
						<p class="navbar-brand text-center">관리 시스템 로그인</p>
					</td>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td scope="col">
						<form:label path="mem_id" class="col-form-label">아이디</form:label>
					</td>
					<td scope="col">
						<form:input type="text" path="mem_id" class="form-control" />
						<form:errors path="mem_id"></form:errors>
					</td>
				</tr>
				<tr>
					<td scope="col">
						<form:label path="mem_pw" class="col-form-label">비밀번호</form:label>
					</td>
					<td scope="col">
						<form:input type="password" path="mem_pw" class="form-control" />
						<form:errors path="mem_pw"></form:errors>
					</td>
				</tr>
				<tr>
					<td colspan="2" class="text-center">
						<form:button type="submit"> submit </form:button>
					</td>
				</tr>
			</tbody>
		</table>
	</form:form>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>
</body>
</html>