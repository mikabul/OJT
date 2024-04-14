<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<script src="${root}resources/lib/javascript/jquery-3.7.1.min.js"></script>
<!-- SweetAlert2 -->
<link href="${root}resources/lib/style/sweetalert2.min.css" rel="stylesheet"/>
<script src="${root}resources/lib/javascript/sweetalert2.min.js"></script>
</head>
<body>
<script>
	Swal.fire({
		icon: 'success',
		title: '성공',
		text: '등록에 성공하였습니다.'
	}).then(() => {
		const memberNumber = `${memberNumber}`;
		location.href="/OJT/member/Main?memberNumber=" + memberNumber;
	});
</script>
</body>
</html>