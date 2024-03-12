<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!-- 프로젝트 등록 팝업 -->
<div class="pop-background justify-content-center">
	<div class="pop">
		<!-- 상단 부분 -->
		<div class="justify-content-center">
			<div class="col-3">
				<span style="color: red">*</span> <span>필수입력</span>
			</div>
			<div class="col-3 text-center">
				<h3>프로젝트 등록</h3>
			</div>
			<div class="col-3 text-right">
				<button type="button" class="closeBtn"
					onclick="closeAddProjetcPop()">
					<img src="${root}resources/images/x.png" alt="" class="closeImg" />
				</button>
			</div>
		</div>
		<!-- form -->
		<form:form modelAttribute="addProjectBean"
			action="${root}project/test" method="POST">
			<table id="addPMTable" class="table-center w-90"
				style="maring-top: 13px;">
				<tr>
					<td class="w-20">프로젝트 명</td>
					<td class="w-30"><form:input class="w-100" path="prj_nm" /> <form:errors
							path="prj_nm"></form:errors></td>
					<td class="w-20" style="padding-left: 10px;">고객사</td>
					<td class="w-30"><form:select class="w-100" path="cust_seq">
							<form:option value="1">현대 자동차</form:option>
							<form:option value="2">농협</form:option>
							<form:option value="3">삼성 전자</form:option>
							<form:option value="4">SK매직</form:option>
							<form:option value="5">아모레퍼시픽</form:option>
						</form:select> <form:errors path="cust_seq"></form:errors></td>
				</tr>
				<tr>
					<td class="w-20">진행 기간</td>
					<td class="w-30"><form:input type="date" path="prj_st_dt"
							class="w-100" onchange="prjStartDateChange()" /></td>
					<td class="w-20 text-center">~</td>
					<td class="w-30"><form:input type="date" path="prj_ed_dt"
							class="w-100" onchange="prjEndDateChange()" /></td>
				</tr>
				<tr>
					<td class="w-20">필요기술</td>
					<td class="w-80" colspan="3">
						<div>
							<form:checkbox path="prj_sk_list" value="1" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="w-20" style="vertical-align: top;">세부사항</td>
					<td class="w-80" colspan="3"><form:textarea path="prj_dtl"
							class="fixed-size-textarea" /> <form:errors path="prj_dtl"></form:errors>
					</td>
				</tr>
			</table>
			<div class="flex">
				<p>인원 추가</p>
				<hr class="text-line" />
			</div>
			<div class="text-right">
				<button type="button" class="btn btn-sm" onclick="clickAddPM()">추가</button>
			</div>
			<div class="scroll" style="height: 190px;">
				<table class="table-center w-90" id="addPM_table">
					<colgroup>
						<col style="width: 55px" />
						<col style="width: 77px" />
						<col style="width: 55px" />
						<col style="width: 55px" />
						<col style="width: 55px" />
						<col style="width: 123px" />
						<col style="width: 123px" />
						<col style="width: 55px" />
					</colgroup>
					<thead>
						<tr>
							<!-- 모두 선택 -->
							<td scope="col" class="text-center"><input type="checkbox"
								onclick="" /></td>
							<!-- 사원번호 -->
							<td scope="col" class="text-center">사원번호</td>
							<!-- 이름 -->
							<td scope="col" class="text-center">이름</td>
							<!-- 부서 -->
							<td scope="col" class="text-center">부서</td>
							<!-- 직급 -->
							<td scope="col" class="text-center">직급</td>
							<!-- 투입일 -->
							<td scope="col" class="text-center">투입일</td>
							<!-- 철수일 -->
							<td scope="col" class="text-center">철수일</td>
							<!-- 역할 -->
							<td scope="col" class="text-center">역할</td>
						</tr>
					</thead>
					<tbody id="addPMBody">
						<c:choose>
							<c:when
								test="${fn:length(addProjectBean.projectMemberList) >= 1}">
								<c:set var="index" value="0" />
								<c:forEach var="item"
									items="${addProjectBean.projectMemberList}" varStatus="status">
									<tr>
										<td class="text-center"><input class="" type="checkbox"
											value="${index}" /> <c:set var="index" value="${index + 1}" />
										</td>
										<td><form:input class="w-100 read-input text-center mem_seq"
												path="projectMemberList[${status.index}].mem_seq"
												readonly="true" /></td>
										<td><form:input class="w-100 read-input text-center"
												path="projectMemberList[${status.index}].mem_nm"
												readonly="true" /></td>
										<td><form:input class="w-100 read-input text-center"
												path="projectMemberList[${status.index}].dept"
												readonly="true" /></td>
										<td><form:input class="w-100 read-input text-center"
												path="projectMemberList[${status.index}].position"
												readonly="true" /></td>
										<td><form:input type="date" class="w-100 st_dt"
												path="projectMemberList[${status.index}].st_dt"
												index="${status.index}" required="required" /></td>
										<td><form:input type="date" class="w-100 ed_dt"
												path="projectMemberList[${status.index}].ed_dt"
												index="${status.index}" required="required" /></td>
										<td><form:select class="w-100 role_select"
												path="projectMemberList[${status.index}].role">
											</form:select></td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="8" class="text-center">등록 인원이 없습니다.</td>
								</tr>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>
			<div class="text-right">
				<form:button class="btn btn-red" type="button">삭제</form:button>
			</div>
			<div class="text-center">
				<form:button class="btn btn-green" type="submit">저장</form:button>
			</div>
		</form:form>
	</div>
</div>
<script src="${root}resources/javascript/AddProject.js"></script>