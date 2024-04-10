<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<script>
	let modalStack = []; // 모달창을 하나씩 닫기위해 저장하는 변수
</script>
<meta charset="UTF-8">
<title>INNOBL - 프로젝트</title>
<script src="${root}resources/lib/javascript/jquery-3.7.1.min.js"></script>
<!-- select2 -->
<link href="${root}resources/lib/style/select2.min.css" rel="stylesheet" />
<script src="${root}resources/lib/javascript/select2.min.js"></script>
<!-- SweetAlert2 -->
<link href="${root}resources/lib/style/sweetalert2.min.css" rel="stylesheet"/>
<script src="${root}resources/lib/javascript/sweetalert2.min.js"></script>
<!-- 외부 css -->
<link rel="stylesheet" href="${root}resources/style/Main.css" />
<style>
#searchForm {
	border-radius: 4px;
	border: 1px solid black;
	padding: 10px;
	width: 960px;
	margin-top: 130px;
}

#searchForm>div {
	margin: 14px 0;
}

table tr {
	height: 40px;
}
</style>
</head>
<c:import url="/WEB-INF/views/include/TopMenu.jsp"></c:import>
<body>
	<!-- 검색 -->
	<header>
		<form:form action="${root}project/Main" method="POST"
			modelAttribute="projectSearchBean">
			<div id="searchForm" class="container-center">
				<!-- 프로젝트 명과 고객사 -->
				<div class="justify-content-center">
					<form:label path="name" class="w-20">프로젝트 명</form:label>
					<form:input class="w-30" type="search" path="name"
						placeholder="입력..." />

					<form:label path="customer" class="w-20 text-center">고객사</form:label>
					<form:select class="w-30" path="customer">
						<form:option value="0">전체</form:option>
						<c:forEach var="item" items="${customerList}">
							<form:option value="${item.customerNumber}">${item.customerName}</form:option>
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
					<form:input type="date" path="firstDate" class="w-30"></form:input>
					<div class="text-center w-20">~</div>
					<form:input type="date" path="secondDate" class="w-30" />
				</div>
				<!-- 프로젝트 상태 -->
				<div style="display: flex;">
					<div class="w-20">상태</div>
					<div class="w-30 dropdown">
						<div class="dropdown-header">
							<div class="dropdown-label ellipsis" title=""></div>
							<div class="dropdown-icon">▼</div>
						</div>
						<div class="dropdown-menu" data-show="false">
							<c:forEach var="item" items="${ psList }" varStatus="status">
								<div>
									<form:checkbox path="state" class="state"
										value="${ item.detailCode }" />
									<form:label path="state" for="state${status.index + 1}">${ item.codeName }</form:label>
								</div>
							</c:forEach>
						</div>
					</div>
				</div>
				<!-- 버튼 부분 -->
				<div class="text-center">
					<button type="submit" class="btn btn-green w-40">조회</button>
					<button type="button" id="resetBtn" class="btn btn-blue w-40">초기화</button>
				</div>
			</div>
			<form:hidden path="view" />
		</form:form>
	</header>

	<!--검색 결과 영역  -->
	<div class="justify-content-center" style="margin-top: 30px;">
		<div style="width: auto">
			<div class="text-right">
				<select id="viewSelect" class="w-10"
					value="${projectSearchBean.view}">
					<option value="1"
						${projectSearchBean.view == '1' ? 'selected' : '' }>1개</option>
					<option value="2"
						${projectSearchBean.view == '2' ? 'selected' : '' }>2개</option>
					<option value="3"
						${projectSearchBean.view == '3' ? 'selected' : '' }>3개</option>
					<option value="4"
						${projectSearchBean.view == '4' ? 'selected' : '' }>4개</option>
					<option value="5"
						${projectSearchBean.view == '5' ? 'selected' : '' }>5개</option>
				</select>
			</div>
			<table class="container-center">
				<colgroup>
					<!-- checkbox -->
					<col style="width: 55px" />
					<!-- 번호 -->
					<col style="width: 70px" />
					<!-- 프로젝트 명 -->
					<col style="width: 200px" />
					<!-- 고객사 -->
					<col style="width: 200px" />
					<!-- 시작일 -->
					<col style="width: 130px" />
					<!-- 종료일 -->
					<col style="width: 130px" />
					<!-- 상태 -->
					<col style="width: 130px" />
					<!-- 인원 관리 -->
					<col style="width: 110px" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" class="allCheck"/></th>
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
									<td>
										<label>
											<input type="checkbox" class="check" value="${ status.index }" />
										</label>
									</td>
									<td>${ item.projectNumber }</td>
									<td class="text-left">
										<a class="projectInfo" href="${root}project/projectInfo?projectNumber=${item.projectNumber}" title="${item.projectName} - 자세히">
											${ item.projectName }
										</a>
									</td>
									<td class="text-left">${ item.customerName }</td>
									<td>${ item.projectStartDate }</td>
									<td>${ item.projectEndDate }</td>
									<td data-cd="${ item.projectStateCode }">${ item.projectStateName }</td>
									<td>
										<button type="button" class="btn projectMemberBtn" value="${ item.projectNumber }">인원 관리</button>
									</td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
			<div class="text-right">
				<div id="BeforeSwitchBtn">
					<button type="button" class="btn btn-blue" id="modifyProjectState">상태
						수정</button>
					<button type="button" class="btn btn-red" id="removeBtn">삭제</button>
					<button type="button" class="btn btn-green" id="addProjectBtn">등록</button>
				</div>
				<div id="AfterSwitchBtn" class="none">
					<button type="button" class="btn btn-green" id="changeStateSubmit">저장</button>
					<button type="button" class="btn btn-orange" id="changeStateCancle">취소</button>
				</div>
			</div>
			<form:form modelAttribute="projectSearchBean" id="paginationForm"
				action="${root}project/Main" method="POST">
				<form:hidden path="name" />
				<form:hidden path="customer" />
				<form:hidden path="dateType" />
				<form:hidden path="firstDate" />
				<form:hidden path="secondDate" />
				<form:hidden path="view" />
				<form:hidden path="state" />
				<input type="hidden" name="page" id="page" />
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
	<div id="modalProject"></div>
	<div id="modalModifyProject"></div>
	<div id="modalProjectMember"></div>
	<div id="modalAddProjectMember"></div>
</body>
<script src="${root}resources/javascript/Main.js"></script>
<script src="${root}resources/javascript/ProjectMain.js"></script>
<script src="${root}resources/javascript/AddProject.js"></script>
<script src="${root}resources/javascript/AddProjectMember.js"></script>
<script>
	addDropdownEvent(); // 처음 진입시 드롭다운 이벤트 설정
	const psList = JSON.parse(`${psListJSON}`);
</script>
</html>