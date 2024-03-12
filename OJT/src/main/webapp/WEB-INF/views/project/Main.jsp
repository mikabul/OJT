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
th {
	height: 46px;
}

#addPMTable td {
	padding: 3px 0;
}

input {
	box-sizing: border-box;
}

select {
	height: 25px;
}

.ellipsis {
	max-width: 300px;
}

#searchTable td {
	padding: 0 5px;
}
.disable {
	background-color: black;
	border: none;
	color: white;
}

.disable:hover{
	background-color: black;
	border: black;
	color: white;
}

.fixed-size-textarea {
	width: 100%;
	height: 100px;
	resize: none;
}

</style>
</head>
<c:import url="/WEB-INF/views/include/TopMenu.jsp"></c:import>
<body style="margin: 70px 20px;">
	<div style="margin: 0 10%;">
		<div id="testBtn"></div>
		<!-- ===== 검색 ===== -->
		<div style="margin-top: 100px;">
			<form:form action="${root}project/Main" method="POST" modelAttribute="projectSearchBean" id="formData">
				<table class="table-center form-table">
					<thead>
						<tr style="margin">
							<td style="width: 50px;"><span style="color: red">*</span> 필수</td>
							<td style="width: 50px;" />
							<td style="width: 100px;" />
							<td style="width: 100px;" />
							<td style="width: 100px;" />
							<td style="width: 100px;" />
							<td style="width: 100px;" />
							<td style="width: 100px;" />
						</tr>
					</thead>
					<tbody>
						<!-- 프로젝트, 고객사 -->
						<tr>
							<td colspan="2">프로젝트 명<span style="color: red">*</span></td>
							<td colspan="2">
								<form:input type="search" path="prj_nm"  class="w-100 h-20" style="box-sizing: content-box;"/>
							</td>
							<td colspan="2" class="text-center">고객사</td>
							<td colspan="2">
								<form:select path="cust_seq" class="w-60 h-20" style="box-sizing: content-box;">
									<form:option value="0">전체</form:option>
									<form:option value="1">현대 자동차</form:option>
									<form:option value="2">농협</form:option>
									<form:option value="3">삼성 전자</form:option>
									<form:option value="4">SK매직</form:option>
									<form:option value="5">아모레퍼시픽</form:option>
								</form:select>
							</td>
						</tr>
						<!-- 위아래 공백 -->
						<tr>
							<td colspan="8" style="height: 20px;"></td>
						</tr>
						<!-- 기간 -->
						<tr>
							
							<td colspan="2">
								<form:select path="dateType">
									<form:option value="prj_st_dt">시작일</form:option>
									<form:option value="prj_ed_dt">종료일</form:option>
								</form:select>
							</td>
							<td colspan="3" class="">
								<form:input type="date" path="firstDate" class="w-40 h-20"/>
								<span>~</span>
								<form:input type="date" path="secondDate" class="w-40 h-20"/>
							</td>
							
						</tr>
						
						<!-- 공백 -->
						<tr>
							<td colspan="8" style="height: 8px"></td>
						</tr>
						
						<tr>
							<td colspan="2">상태</td>
							<td>
								<form:checkbox path="ps_cd" class="psCheckbox" value="1"/>
								<label>진행 예정</label>
							</td>
							<td>
								<form:checkbox path="ps_cd" class="psCheckbox" value="2"/>
								<label>진행 중</label>
							</td>
							<td>
								<form:checkbox path="ps_cd" class="psCheckbox" value="3"/>
								<label>유지보수</label>
							</td>
							<td>
								<form:checkbox path="ps_cd" class="psCheckbox" value="4"/>
								<label>종료</label>
							</td>
							<td>
								<form:checkbox path="ps_cd" class="psCheckbox" value="5"/>
								<label>중단</label>
							</td>
						</tr>
						
						<tr>
							<td colspan="8" style="height: 20px;"></td>
						</tr>
						<!-- button -->
						<tr>
							<td colspan="8" class="text-center">
								<form:button type="submit" class="btn btn-green w-10">조회</form:button>
								<form:button type="button" class="btn w-10" onclick="resetBtn()">초기화</form:button>
							</td>
						</tr>
					</tbody>
				</table>
				<!-- 검색 갯수와 등록 버튼 -->
				<div class="text-right" style="margin-top: 30px;">
					<form:select path="view" onchange="changeView()">
						<form:option value="5">5개</form:option>
						<form:option value="10">10개</form:option>
						<form:option value="15">15개</form:option>
						<form:option value="20">20개</form:option>
					</form:select>
					<button type="button" class="btn btn-green btn-w-90" onclick="addProjectPop()">등록</button>
				</div>
			</form:form>
		</div>
		
		<!-- ===== 검색 결과 ====== -->
		<div>
			<table class="table-center w-100" id="searchTable">
				<colgroup>
					<!-- checkbox  -->
					<col style="width: 50px;"/>
					<!-- 프로젝트 번호 -->
					<col style="width: 50px;">
					<!-- 프로젝트 명 -->
					<col style="width: 300px;">
					<!-- 고객사 -->
					<col style="width: 300px;">
					<!-- 시작일 -->
					<col style="width: 150px;">
					<!-- 종료일 -->
					<col style="width: 150px;">
					<!-- 필요 기술 -->
					<col style="width: 220px;">
					<!-- 인원 관리 -->
					<col style="width: 150px;">
				</colgroup>
				<thead id="projectListTableHead">
					<tr class="table-bg-0">
						<th scope="col" class="text-center">
							<input type="checkbox" id="allCheckbox" onclick="allCheckbox()"/>
						</th>
						<th scope="col" class="text-center">번호</th>
						<th scope="col" class="">프로젝트 명</th>
						<th scope="col" class="">고객사</th>
						<th scope="col" class="text-center">시작일</th>
						<th scope="col" class="text-center">종료일</th>
						<th scope="col" class="text-center">상태</th>
						<th scope="col" class="text-center">인원 관리</th>
				</thead>
				<tbody id="projectListTable">
					<c:choose>
						<c:when test="${fn:length(projectList) != 0}">
							<c:set var="i" value="0" />
							<c:forEach var="item" items="${projectList}">
								
								<c:if test="${i % 2 == 0}">
									<tr class="table-bg-1">
								</c:if>
								<c:if test="${i % 2 == 1}">
									<tr class="table-bg-2">
								</c:if>
									<c:set var="i" value="${i+1}"/>
									
									<td class="text-center">
										<input type="checkbox" class="checkProject" onclick="checkboxFunction()" value="${item.prj_seq}"/>
									</td>
									<td class="text-center">${item.prj_seq }</td>
									<td class="text-left ellipsis"><a href="#">${item.prj_nm}</a></td>
									<td class="text-left ellipsis">${item.cust_nm }</td>
									<td class="text-center">${item.prj_st_dt }</td>
									<td class="text-center">${item.prj_ed_dt }</td>
									<td class="text-center">${item.ps_nm }</td>
									<td class="text-center">
										<button type="button" class="btn projectMemberBtn">인원관리</button>
									</td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="8" class="text-center">
									검색 결과가 없습니다.
								</td>
							</tr>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
			
			<!-- 페이지 버튼과 삭제 버튼 -->
			<div class="w-100 justify-content-center">
					<div class="w-20"></div>
					<div class="w-60 text-center">
						<form:form action="${root}project/Main" method="POST" modelAttribute="projectSearchBean" id="paginationFormData">
							<form:hidden path="prj_nm"/>
							<form:hidden path="cust_seq"/>
							<form:hidden path="dateType"/>
							<form:hidden path="firstDate"/>
							<form:hidden path="secondDate"/>
							<form:hidden path="ps_cd"/>
							<form:hidden path="view" />
							<input type="hidden" name="page" id="page" value=""/>
							<span class="w-20">
								<c:choose>
									<c:when test="${preBtn}">
										<button type="button" class="btn pageBtn" page="${pageBtns[0] - buttonCount}">이전</button>
									</c:when>
									<c:otherwise>
										<button type="button" class="btn disable">이전</button>
									</c:otherwise>
								</c:choose>
							</span>
							<span id="pageBtns" class="w-60">
								<c:forEach var="item" items="${pageBtns}">
									<c:choose>
										<c:when test="${item == page }">
											<button type="button" class="btn disable">${item + 1}</button>
										</c:when>
										<c:otherwise>
											<button type="button" class="btn pageBtn" page="${item}">${item + 1}</button>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</span>
							<span class="w-20">
								<c:choose>
									<c:when test="${nextBtn}">
										<button type="button" class="btn pageBtn" page="${pageBtns[0] + buttonCount}">다음</button>
									</c:when>
									<c:otherwise>
										<button type="button" class="btn disable">다음</button>
									</c:otherwise>
								</c:choose>
							</span>
						</form:form>
					</div>
					<div class="w-20 text-right">
						<button class="btn btn-w-90 btn-green">상태 수정</button>
						<button class="btn btn-w-90 btn-red">삭제</button>
					</div>
			</div>
		</div>
	</div>
	
	<!-- 프로젝트 등록 팝업 -->
	<c:choose>
		<c:when test="${showAddProjectPop == true}">
			<div id="addProjectPop" class="">
		</c:when>
		<c:otherwise>
			<div id="addProjectPop" class="none">
		</c:otherwise>
	</c:choose>
		<c:import url="/WEB-INF/views/project/AddProject.jsp"></c:import>
	</div>
	<!-- 프로젝트 -->
	<c:choose>
		<c:when test="${showAddProjectPop == true}">
			<div id="addPMPop" class="">
		</c:when>
		<c:otherwise>
			<div id="addPMPop" class="none">
		</c:otherwise>
	</c:choose>
		<c:import url="/WEB-INF/views/project/AddProjectMember.jsp"></c:import>
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