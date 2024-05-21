<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="root" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" href="${root}/resources/style/TopMenu.css" />
<nav class="top-nav">
	<div>
		<button id="side_btn" class="top-btn top-btn-white">메뉴</button>
	</div>
	<div>
		<a class="top-logo" href="${root}/main">INNOBL 관리 시스템</a>
	</div>
	<div>
		<span style="color: white">${ loginMemberName }님</span>
		<button class="top-btn" id="logout"
			onclick="location.href='${root}/logout'">로그아웃</button>
	</div>
</nav>
<div class="top-side-menu-bar">
	<ul class="top-side-menu">
		<c:forEach var="item" items="${ menuList }">
			<li>
				<a href="${ root }${ item.menuUrl}">${ item.menuName }</a>
			</li>
		</c:forEach>
	</ul>
</div>
<c:forEach var="item" items="${ menuList }">
	<c:if test="${ item.menuUrl == '/project/add' }">
		<div id="modalAddProject"></div>
		<div id="modalAddProjectMember"></div>
		<script>
			document.querySelector('a[href="${root}/project/add"]').addEventListener('click', showAddProjectModal);

			function showAddProjectModal(event) {
				event.preventDefault();

				$.ajax({
					url : '${root}/project/add/modal',
					method : 'GET',
					contentType : 'html',
					success : function(html) {
						$('#modalAddProject').html(html);
					},
					error : function(response, status, error) {
						if(request.status == 403) {
							Swal.fire('실패', '접근 권한이 부족합니다.', 'warning');
						} else {
							Swal.fire('실패', '로딩에 실패하였습니다.', 'error');
						}

						console.error(error);
					}
				});
			}
		</script>
	</c:if>
</c:forEach>
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