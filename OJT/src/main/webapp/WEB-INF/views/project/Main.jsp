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
</style>
</head>
<c:import url="/WEB-INF/views/include/TopMenu.jsp"></c:import>
<body style="margin: 70px 20px;">
	<div style="margin: 0 10%;">
		<div id="testBtn"></div>
		<!-- ===== 검색 ===== -->
		<div style="margin-top: 100px;">
			<form:form action="#" method="GET" ModelAttribute="projectSearchBean">
				<table class="table-center form-table">
					<thead>
						<tr>
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
								<form:input type="search" path="prj_nm" class="w-100 h-20" style="box-sizing: content-box;"/>
							</td>
							<td colspan="2" class="text-center">고객사</td>
							<td colspan="2">
								<select name="cust_seq" id="cust_seq" class="w-60 h-20" style="box-sizing: content-box;">
									<option value="0" id="cusr_seq_default">전체</option>
									<option value="1">현대 자동차</option>
									<option value="2">농협</option>
									<option value="3">삼성 전자</option>
									<option value="4">SK매직</option>
									<option value="5">아모레퍼시픽</option>
								</select>
							</td>
						</tr>
						<!-- 위아래 공백 -->
						<tr>
							<td colspan="8" style="height: 20px;"></td>
						</tr>
						<!-- 기간 -->
						<tr>
							
							<td colspan="2">
								<select name="dateType" id="dateType">
									<option value="prj_st_dt" id="dateType_default">시작일</option>
									<option value="prj_ed_dt">종료일</option>
								</select>
							</td>
							<td colspan="3" class="">
								<input type="date" name="firstDate" id="firstDate" class="w-40 h-20"/>
								<span>~</span>
								<input type="date" name="secondDate" id="secondDate" class="w-40 h-20"/>
							</td>
							
						</tr>
						
						<!-- 공백 -->
						<tr>
							<td colspan="8" style="height: 8px"></td>
						</tr>
						
						<tr>
							<td colspan="2">상태</td>
							<td>
								<input type="checkbox" name="st_cd" id="st_cd_1" class="stCheckbox" value="1"/>
								<label for="st_cd_1">진행 예정</label>
							</td>
							<td>
								<input type="checkbox" name="st_cd" id="st_cd_2" class="stCheckbox" value="2"/>
								<label for="st_cd_2">진행 중</label>
							</td>
							<td>
								<input type="checkbox" name="st_cd" id="st_cd_3" class="stCheckbox" value="3"/>
								<label for="st_cd_3">완료</label>
							</td>
							<td>
								<input type="checkbox" name="st_cd" id="st_cd_4" class="stCheckbox" value="4"/>
								<label for="st_cd_4">유지보수</label>
							</td>
							<td>
								<input type="checkbox" name="st_cd" id="st_cd_5" class="stCheckbox" value="5"/>
								<label for="st_cd_5">중단</label>
							</td>
						</tr>
						
						<tr>
							<td colspan="8" style="height: 20px;"></td>
						</tr>
						<!-- button -->
						<tr>
							<td colspan="8" class="text-center">
								<button type="submit" class="btn btn-green w-10">조회</button>
								<button type="reset" class="btn w-10">초기화</button>
							</td>
						</tr>
					</tbody>
				</table>
			</form:form>
		</div>
		<!-- 검색 갯수와 등록 버튼 -->
		<div class="text-right" style="margin-top: 30px;">
			<select name="view" id="view" oninput>
				<option value="1">10개</option>
				<option value="2" selected>20개</option>
				<option value="3">30개</option>
				<option value="4">40개</option>
				<option value="5">50개</option>
			</select>
			<button class="btn btn-green btn-w-90" onclick="location.href='#'">등록</button>
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
							<td class="text-center">${item.dtl_cd_nm }</td>
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
						<span class="w-20">
							<button class="btn">이전</button>
						</span>
						<span id="pageBtns" class="w-60">
							<c:forEach var="item" items="${pageBtns}">
								<button type="button" class="btn" class="pageBtn" index="${(item - 1) * view + 1 }">${item }</button>
							</c:forEach>
						</span>
						<span class="w-20">
							<button class="btn">다음</button>
						</span>
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

	
</script>
</html>