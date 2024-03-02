<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="root" value="${pageContext.request.contextPath}"></c:set>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>잘못된 접근</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
</head>
<body>
	<p>잘못된 접근 입니다.</p>
	<p id="second"></p>
</body>
<script>
	$(document).ready(function(){
		goHome();
	})
	
	function goHome() {
    let count = 5;

    function updateCountdown() {
        $("#second").html(count + "초 뒤 로그인 페이지로 이동합니다.");
        count--;

        if (count >= 0) {
            setTimeout(updateCountdown, 1000);
        } else {
            location.href='${root}';
        }
    }

    updateCountdown();
}
	
</script>
</html>