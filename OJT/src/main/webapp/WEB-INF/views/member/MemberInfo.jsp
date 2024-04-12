<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원 상세 정보</title>
</head>
<body>
	<div class="modal-background">
		<div class="modal">
			<header>
				<div class="w-30">
					<!-- 공백 -->
				</div>
				<div class="w-40 text-center">
					사원 상세 정보
				</div>
				<div class="w-30 text-right">
					<button type="button" class="closeBtn" id="memberInfoCloseButton">
						<img src="${root}resources/images/x.png" alt="닫기" />
					</button>
				</div>
			</header>
			<section>
				
			</section>
		</div>
	</div>
</body>
<script>
modalStack.push('#modalMemberInfo');
currModal = getCurrModalDom();
</script>
</html>