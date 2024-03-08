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
</style>
</head>
<c:import url="/WEB-INF/views/include/TopMenu.jsp"></c:import>
<body style="margin: 70px 20px;">
	<div style="margin: 0 10%;">
		<div id="testBtn"></div>
		<!-- ===== 검색 ===== -->
		<div style="margin-top: 100px;">
			<form:form action="${root}project/searchProject" method="POST" modelAttribute="projectSearchBean" id="form">
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
								<form:checkbox path="ps_cd" class="stCheckbox" value="1"/>
								<label>진행 예정</label>
							</td>
							<td>
								<form:checkbox path="ps_cd" class="stCheckbox" value="2"/>
								<label>진행 중</label>
							</td>
							<td>
								<form:checkbox path="ps_cd" class="stCheckbox" value="3"/>
								<label>완료</label>
							</td>
							<td>
								<form:checkbox path="ps_cd" class="stCheckbox" value="4"/>
								<label>유지보수</label>
							</td>
							<td>
								<form:checkbox path="ps_cd" class="stCheckbox" value="5"/>
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
						<form:option value="1">10개</form:option>
						<form:option value="20">20개</form:option>
						<form:option value="3">30개</form:option>
						<form:option value="4">40개</form:option>
						<form:option value="5">50개</form:option>
					</form:select>
					<button class="btn btn-green btn-w-90" onclick="location.href='#'">등록</button>
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
						<th scope="col" class="text-center"><input type="checkbox" name="allCheckProject"/></th>
						<th scope="col" class="text-center">번호</th>
						<th scope="col" class="">프로젝트 명</th>
						<th scope="col" class="">고객사</th>
						<th scope="col" class="text-center">시작일</th>
						<th scope="col" class="text-center">종료일</th>
						<th scope="col" class="text-center">상태</th>
						<th scope="col" class="text-center">인원 관리</th>
				</thead>
				<tbody id="projectListTable">
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
								<input type="checkbox" name="checkProjectSeq" value="${item.prj_seq}"/>
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
				</tbody>
			</table>
			
			<!-- 페이지 버튼과 삭제 버튼 -->
			<div class="w-100 justify-content-center">
					<div class="w-20"></div>
					<div class="w-60 text-center">
						<form:form method="POST" modelAttribute="projectSearchBean" id="formData">
							<form:hidden path="prj_nm"/>
							<form:hidden path="cust_seq"/>
							<form:hidden path="dateType"/>
							<form:hidden path="firstDate"/>
							<form:hidden path="secondDate"/>
							<form:hidden path="ps_cd"/>
							<form:hidden path="view" />
							<input type="hidden" name="index" id="index" value=""/>
							<span class="w-20">
								<c:choose>
									<c:when test="${page >= 11 }">
										<button type="button" class="btn" id="preBtn" btnIndex="${preBtn}" onclick="preBtn()">이전</button>
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
											<button type="button" class="btn disable">${item }</button>
										</c:when>
										<c:otherwise>
											<button type="button" class="btn pageBtn" btnIndex="${(item - 1) * projectSearchBean.view + 1 }">${item }</button>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</span>
							<span class="w-20">
								<c:choose>
									<c:when test="${maxCount > nextBtn }">
										<button type="button" class="btn" id="nextBtn" btnIndex="${nextBtn}" onclick="preBtn()">다음</button>
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
</body>
<script>

	$(document).ready(function() {
	    addEventPageBtn();
	    
	    const preBtn = document.querySelector("#preBtn");
	    const nextBtn = document.querySelector("#nextBtn");
	    
	    preBtn.addEventListener('click', pre_nextBtnEvent);
	    nextBtn.addEventListener('click', pre_nextBtnEvent);
	})
	
	// 페이지 버튼 클릭 이벤트 주입
	function addEventPageBtn() {
	    const pageBtns = document.querySelectorAll(".pageBtn");
	
	    pageBtns.forEach(btn => {
	        btn.addEventListener('click', pageBtnEvent);
	    })
	}
	
	// 페이지 버튼 클릭 이벤트
	function pageBtnEvent() {
	    const btnIndex = this.getAttribute("btnIndex");
	    let index = document.getElementById("index");
	
	    index.value = btnIndex;
	    
	    const form = document.getElementById("formData");
	    form.action = '${root }project/pagingProject';
	    form.submit();
	}
	
	// 보여지는 개수 변경시
	function changeView(){
		const form = document.getElementById("form");
		form.submit();
	}
	
	// input 값 초기화
	function resetBtn(){
		$("#prj_nm").val("");
		$("#firstDate").val("");
		$("#secondDate").val("");

		let ps_cd = document.querySelectorAll(".stCheckbox");
		
		ps_cd.forEach(check => {
		    check.checked = false;
		})
		
		let cust_seq = document.querySelector("#cust_seq");
		cust_seq.selectedIndex = 0;
		
		let dateType = document.querySelector("#dateType");
		dateType.selectedIndex = 0;
	}
	
	// 이전 다음 버튼
	function pre_nextBtnEvent(){
		 const btnIndex = this.getAttribute("btnIndex");
		    let index = document.getElementById("index");
		
		    index.value = btnIndex;
		    
		    const form = document.getElementById("formData");
		    form.action = '${root }project/nextPage';
		    form.submit();
	}
	
</script>
</html>