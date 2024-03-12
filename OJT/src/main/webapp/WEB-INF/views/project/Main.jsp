<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>INNOBL - 프로젝트</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<!-- select2 -->
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<!-- 외부 css -->
<link rel="stylesheet" href="${root}resources/style/Main.css" />
<style>
form div{
	margin: 7px 0;
}

input[type="checkbox"] {
	width: auto;
}

#searchForm {
	border-radius: 4px;
	border: 1px solid black;
	padding: 10px;
}

</style>
</head>
<c:import url="/WEB-INF/views/include/TopMenu.jsp"></c:import>
<body>
	<!-- 검색 -->
	<div style="margin-top: 130px;">
		<!-- 검색창을 가운데로 -->
		<div class="w-50" style="margin: auto;">
			<form:form action="${root}project/Main" method="POST" id="searchForm" modelAttribute="projectSearchBean">
				<!-- 프로젝트 명과 고객사 -->
				<div class="justify-content-center">
					<form:label path="name" class="w-20">프로젝트 명</form:label>
					<form:input class="w-30" type="search" path="name" placeholder="입력..."/>
					
					<form:label path="customer" class="w-20 text-center">고객사</form:label>
					<form:select class="w-30" path="customer">
						<form:option value="0" >전체</form:option>
						<c:forEach var="item" items="${customerList}">
							<form:option value="${item.cust_seq}">${item.cust_nm}</form:option>
						</c:forEach>
					</form:select>
				</div>
				<!-- 기간 -->
				<div class="justify-content-center">
					<form:select path="dateType" class="w-10 text-left">
						<form:option value="0">시작일</form:option>
						<form:option value="1">종료일</form:option>
					</form:select>
					<div class="w-10"></div>
					<form:input type="date" path="firstDate" class="w-30"/>
					<div class="text-center w-20"> ~ </div>
					<form:input type="date" path="secondDate" class="w-30"/>
				</div>
				<!-- 프로젝트 상태 -->
				<div class="justify-content-center">
					<div class="w-20">상태</div>
					<div class="w-80 justify-content-center">
						<div>
							<form:checkbox path="state" class="state" value="1"/>
							<form:label path="state" for="state1">진행 예정</form:label>
						</div>
						<div>
							<form:checkbox path="state" class="state" value="2"/>
							<form:label path="state" for="state2">진행 중</form:label>
						</div>
						<div>
							<form:checkbox path="state" class="state" value="3"/>
							<form:label path="state" for="state3">유지보수</form:label>
						</div>
						<div>
							<form:checkbox path="state" class="state" value="4"/>
							<form:label path="state" for="state4">종료</form:label>
						</div>
						<div>
							<form:checkbox path="state" class="state" value="5"/>
							<form:label path="state" for="state5">중단</form:label>
						</div>
					</div>
				</div>
				<!-- 버튼 부분 -->
				<div class="text-center">
					<button type="submit" class="btn btn-green w-40">조회</button>
					<button type="button" id="resetBtn" class="btn w-40">초기화</button>
				</div>
			</form:form>
		</div>
	</div>
</body>
<script>
	
	let allCheck = false;

	$(document).ready(function() {
		
		// 페이지 버튼 이벤트 추가
		let pageBtn = document.querySelectorAll(".pageBtn");
		pageBtn.forEach(btn => {
			btn.addEventListener('click', paginationButtonEvent);
		})
		
		$("#resetBtn").on('click', function(){
			$("#name").val("");
			$("#customer").val("0");
			$("#dateType").val("1");
			$("#firstDate").val("");
			$("#secondDate").val("");
			
			let state = document.querySelectorAll(".state");
			state.forEach(check => { check.checked = false; })
		});
		
	});

	// 화면에 표시할 개수를 담는 view가 변경 될 경우 작동하는 함수
	// 검색 직후의 form을 이용하기 위해 #paginaionFormData를 이용
	function changeView(){
		let form = document.getElementById("paginationFormData");
		let selectedView = $("#view").val();
		let view = document.querySelector("#paginationFormData input#view");
		view.value = selectedView;
		
		form.submit();
	}
	
	// 초기화 버튼
	function resetBtn(){
		$("#prj_nm").val("");
		$("#cust_seq").val("0");
		$("#dateType").val("prj_st_dt");
		$("#firstDate").val("");
		$("#secondDate").val("");
		
		let st_cd = document.querySelectorAll(".psCheckbox");
		st_cd.forEach(check => { check.checked = false; })
	}
	
	// 페이징 버튼 이벤트
	function paginationButtonEvent(){
		let btnPage = this.getAttribute("page");
		let page = document.getElementById("page");
		page.value = btnPage;
		
		const form = document.getElementById("paginationFormData");
		form.submit();
	}
	
	// 모든 프로젝트 선택 펑션
	function allCheckbox(){
		let checkProject = document.querySelectorAll(".checkProject");
		
		if(allCheck){
			
			allCheck = false;
			checkProject.forEach(check => {
				check.checked = false;
			})
		} else {
			
			allCheck = true;
			checkProject.forEach(check => {
				check.checked = true;
			})
		}
	}
	
	// 프로젝트 선택 펑션
	function checkboxFunction(){
		let checkProject = document.querySelectorAll(".checkProject");
		let allCheckbox = document.getElementById("allCheckbox");
		
		if( isChecked(checkProject) ){
			allCheck = true;
			allCheckbox.checked = true;
		} else {
			allCheck = false;
			allCheckbox.checked = false;
		}
	}
	
	// 모든 프로젝트가 선택되었는지
	function isChecked(checkProject){
		return Array.from(checkProject).every(check => check.checked);
	}
	
	// 등록 버튼 팝업 생성
	function addProjectPop(){
		let addProjectPop = document.getElementById("addProjectPop");
		addProjectPop.classList.remove("none");
	}
	
	
</script>
</html>