<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>프로젝트 수정</title>
<style>
	
	
	
</style>
</head>
<body>
	<div class="modal-background">
		<div class="modal">
			<header>
				<div class="w-30">
					<span>*</span>&nbsp;필수
				</div>
				<div class="w-40">
					<h3>프로젝트 수정</h3>
				</div>
				<div class="w-30">
					<button type="button" class="closeBtn" id="modifyProjectCloseButton">
						<img src="${root}resources/images/x.png" alt="닫기" />
					</button>
				</div>
			</header>
			<form:form modelAttribute="modifyProjectBean" action="#" submit="return false;" method="POST">
				<section>
					
				</section>
			</form:form>
		</div>
	</div>
</body>
</html>