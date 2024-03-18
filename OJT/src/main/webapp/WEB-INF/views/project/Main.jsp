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

table tbody td{
	text-align: center;
	padding: 5px 5px;
	max-width: 200px;
	overflow: hidden;
	white-space: nowrap;
	text-overflow: ellipsis;
	border-top: 1px solid #E6E6E6;
}

table {
	border-collapse: collapse;
}

table tr {
	height: 40px;
}
</style>
</head>
<c:import url="/WEB-INF/views/include/TopMenu.jsp"></c:import>
<body>
	<!-- 검색 -->
	<div style="margin-top: 130px;">
		<form:form action="${root}project/Main" method="POST" modelAttribute="projectSearchBean">
			<!-- 검색창을 가운데로 -->
			<div class="w-50" style="margin: auto;">
				<div id="searchForm">
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
						<button type="button" id="resetBtn" class="btn btn-blue w-40">초기화</button>
					</div>
				</div>
			</div>
			<form:hidden path="view" />
		</form:form>
	</div>
	
	<!--검색 결과 영역  -->
	<div class="justify-content-center" style="margin-top: 30px;">
		<div style="width: auto">
			<div class="text-right">
				<select id="viewSelect" class="w-10" >
					<option value="1">5개</option>
					<option value="2">10개</option>
					<option value="3">15개</option>
					<option value="20">20개</option>
				</select>
			</div>
			<table class="container-center">
				<colgroup>
					<!-- checkbox -->
					<col style="width: 55px"/>
					<!-- 번호 -->
					<col style="width: 70px"/>
					<!-- 프로젝트 명 -->
					<col style="width: 200px"/>
					<!-- 고객사 -->
					<col style="width: 200px"/>
					<!-- 시작일 -->
					<col style="width: 130px"/>
					<!-- 종료일 -->
					<col style="width: 130px"/>
					<!-- 상태 -->
					<col style="width: 130px"/>
					<!-- 인원 관리 -->
					<col style="width: 110px"/>
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" id="allCheckbox" onclick="allCheckbox()"/></th>
						<th scope="col">번호</th>
						<th scope="col">프로젝트 명</th>
						<th scope="col">고객사</th>
						<th scope="col">시작일</th>
						<th scope="col">종료일</th>
						<th scope="col">상태</th>
						<th scope="col">인원 관리</th>
					</tr>
				</thead>
				<tbody id="resultBody">
					<c:choose>
						<c:when test="${projectList == null}">
							<tr>
								<td colspan="8">검색 결과가 없습니다.</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="item" items="${projectList}" varStatus="status">
								<tr>
									<td><input type="checkbox" class="checkProject" value="${ status.index }" onclick="checkboxFunction()"/></td>
									<td>${ item.prj_seq }</td>
									<td class="text-left"><a href="#" title="${item.prj_nm} - 자세히">${ item.prj_nm }</a></td>
									<td class="text-left">${ item.cust_nm }</td>
									<td>${ item.prj_st_dt }</td>
									<td>${ item.prj_ed_dt }</td>
									<td>${ item.ps_nm }</td>
									<td><button type="button" class="btn" value="${ item.prj_seq }">인원 관리</button></td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
			<div class="text-right">
				<button type="button" class="btn btn-blue">상태 수정</button>
				<button type="button" class="btn btn-red" id="removeBtn">삭제</button>
				<button type="button" class="btn btn-green" id="addProjectBtn">등록</button>
			</div>
			<form:form modelAttribute="projectSearchBean" id="paginationForm" action="${root}project/Main" method="POST">
				<form:hidden path="name" />
				<form:hidden path="customer" />
				<form:hidden path="dateType" />
				<form:hidden path="firstDate" />
				<form:hidden path="secondDate" />
				<form:hidden path="view" />
				<form:hidden path="state" />
				<input type="hidden" name="page" id="page"/>
			</form:form>
			
			<div class="text-center">
				<c:if test="${preBtn != null}">
					<button type="button" class="btn pageBtn" page="${preBtn}">이전</button>
				</c:if>
				<c:forEach var="item" items="${pageBtns}">
					<c:choose>
						<c:when test="${item == page}">
							<button type="button" class="btn btn-blue" disabled="disabled">${item + 1}</button>
						</c:when>
						<c:otherwise>
							<button type="button" class="btn pageBtn" page="${item}">${item + 1}</button>
						</c:otherwise>
					</c:choose>
				</c:forEach>
				<c:if test="${nextBtn != null}">
					<button type="button" class="btn pageBtn" page="${nextBtn}">다음</button>
				</c:if>
			</div>
			
		</div>
	</div>
	<div style="height: 100px"></div>
	<div id="modalAddProject"></div>
	<div id="modalAddProjectMember"></div>
	<div id="modalProject"></div>
	<div id="modalProjectMember"></div>
</body>
<script src="${root}resources/javascript/ProjectMain.js"></script>
<script src="${root}resources/javascript/AddProject.js"></script>
<script src="${root}resources/javascript/AddProjectMember.js"></script>
</html>