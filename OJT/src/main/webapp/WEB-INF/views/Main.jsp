<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>INNOBL - 메인</title>

</head>
<body style="margin: 60px 0;">
	<c:import url="/WEB-INF/views/include/TopMenu.jsp" />
	
	<label for="radio">라디오!</label>
	<input type="radio" name="test" value="test" onclick="return false;"/>
	<input type="radio" name="test" value="test2"/>
</body>

</html>