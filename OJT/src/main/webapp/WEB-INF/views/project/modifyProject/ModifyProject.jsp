<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>프로젝트 수정</title>
<style>
	.modal form > div {
		margin: 3px 0;
		padding: 0 3px;
	}
	
	.modal th, .modal td{
		text-align: center;
	}
	
	.modal .text-top {
		vertical-align: top;
	}
	
	.modal tbody select, .modal tbody input {
		padding: 3px 5px;
		text-align: center;
	}
	
	.modal .dropdown-menu {
		max-height: 135px;
	}
	
	
</style>
</head>
<body>
	<div class="modal-background">
		<div class="modal">
			<header>
				<div class="w-30">
					<span>*</span>&nbsp;필수
				</div>
				<div class="w-40 text-center">
					<h3>프로젝트 수정</h3>
				</div>
				<div class="w-30 text-right">
					<button type="button" class="closeBtn" id="modifyProjectCloseButton">
						<img src="${root}resources/images/x.png" alt="닫기" />
					</button>
				</div>
			</header>
			<section>
				<form:form action="#" method="POST" modelAttribute="modifyProjectBean" onsubmit="return false;">
					<div class="justify-content-center">
						<div class="w-20">프로젝트 명<span class="required">*</span></div>
						<div class="w-30">
							<form:input path="projectName" maxlength="20" placeholder="1 ~ 20 글자" required="true"/>
						</div>
						<div class="w-20 text-center" class="required">고객사<span class="required">*</span></div>
						<div class="w-30">
							<form:select path="customerNumber">
								<form:option value="0">-선택-</form:option>
								<c:forEach var="item" items="${customerList}">
									<form:option value="${item.customerNumber}">${item.customerName}</form:option>
								</c:forEach>
							</form:select>
						</div>
					</div>
					<!-- error -->
					<div class="justify-content-center">
						<div class="w-20"></div>
						<div class="w-30">
							<span id="projectNameLength.errors"></span>
							<form:errors path="projectName"></form:errors>
						</div>
						<div class="w-20"></div>
						<div class="w-30">
							<form:errors path="customerNumber"></form:errors>
						</div>
					</div>
					<div class="justify-content-center">
						<div class="w-20">프로젝트 기간<span class="required">*</span></div>
						<div class="w-30">
							<form:input type="date" path="projectStartDate" required="true" max="${ modifyProjectBean.projectEndDate }"/>
						</div>
						<div class="w-20 text-center">~</div>
						<div class="w-30">
							<form:input type="date" path="projectEndDate" required="true" min="${ modifyProjectBean.projectStartDate }"/>
						</div>
					</div>
					<!-- error -->
					<div class="justify-content-center">
						<div class="w-20"></div>
						<div class="w-30">
							<form:errors path="projectStartDate"></form:errors>
						</div>
						<div class="w-20"></div>
						<div class="w-30">
							<form:errors path="projectEndDate"></form:errors>
						</div>
					</div>
					<div class="justify-content-center" id="projectStatus">
						<div class="w-20">
							유지보수 기간					
						</div>
						<div class="w-30">
							<form:input type="date" path="maintStartDate" min="${ modifyProjectBean.projectEndDate }"/>
						</div>
						<div class="w-20 text-center">~</div>
						<div class="w-30">
							<form:input type="date" path="maintEndDate" min="${ modifyProjectBean.projectEndDate }"/>
						</div>
					</div>
					<!-- error -->
					<div class="justify-content-center">
						<div class="w-20"></div>
						<div class="w-30">
							<form:errors path="maintStartDate"></form:errors>
						</div>
						<div class="w-20"></div>
						<div class="w-30">
							<form:errors path="maintEndDate"></form:errors>
						</div>
					</div>
					<div class="justify-content-center">
						<div class="w-20">필요기술</div>
						<div class="w-80 margin-0 dropdown">
							<div class="dropdown-header w-100">
								<div class="dropdown-label ellipsis">
								
								</div>
								<div class="dropdown-icon">
								▼
								</div>
							</div>
							<div class="dropdown-menu scroll" data-show="false" title="">
								<c:forEach var="item" items="${skList}" varStatus="status">
									<div style="display: flex;">
										<form:checkbox path="skillCodeList" value="${item.detailCode}"/>
										<form:label style="flex: 1;" path="skillCodeList" for="skillCodeList${status.index + 1}">
											${item.codeName}
										</form:label>
									</div>
									<hr />
								</c:forEach>
							</div>
						</div>
					</div>
					<!-- error -->
					<div class="justify-content-center">
						<div class="w-20"></div>
						<div class="w-80">
							<form:errors path="projectSkillList"></form:errors>
						</div>
					</div>
					
					<div class="justify-content-center" style="align-items: start;">
						<div class="w-20 text-top">세부사항</div>
						<div class="w-80">
							<div>
								<form:textarea path="projectDetail" maxlength="500" wrap="on"/>
							</div>
							<div class="text-right">
								<span id="projectDetailLength"></span>
							</div>
							<div>
								<span id="projectDetailLength.errors"></span>
							</div>
						</div>
					</div>
					<div>
						<div class="w-100">
							<form:errors path="projectDetail"></form:errors>
						</div>
					</div>
					<div class="justify-content-center">
						인원 추가<hr class="text-line"/>
					</div>
					<div id="scrollDiv" data-scroll="4">
						<table class="container-center">
							<colgroup>
								<!-- 체크박스 -->
								<col style="width: 30px;"/>
								<!-- 사원 번호 -->
								<col style="width: 80px;"/>
								<!-- 이름 -->
								<col style="width: 80px;"/>
								<!-- 부서 -->
								<col style="width: 80px;"/>
								<!-- 직급 -->
								<col style="width: 80px;"/>
								<!-- 투입일 -->
								<col style="width: 120px;"/>
								<!-- 철수일 -->
								<col style="width: 120px;"/>
								<!-- 역할 -->
								<col style="width: 100px;"/>
							</colgroup>
							<thead>
								<tr>
									<th scope="col"><input type="checkbox" class="allCheck" value="false"/></th>
									<th scope="col">사원 번호</th>
									<th scope="col">이름</th>
									<th scope="col">부서</th>
									<th scope="col">직급</th>
									<th scope="col">투입일</th>
									<th scope="col">철수일</th>
									<th scope="col">역할</th>
								</tr>
							</thead>
							<tbody id="pmListBody">
								<c:choose>
									<c:when test="${fn:length(modifyProjectBean.pmList) == 0 }">
										<tr>
											<td class="text-center" colspan="8">
												추가된 인원이 없습니다.
											</td>
										</tr>
									</c:when>
									<c:otherwise>
										<c:forEach var="item" items="${modifyProjectBean.pmList}" varStatus="status">
											<tr>
												<td><input type="checkbox" class="check"/></td>
												<td>
													<form:input path="pmList[${status.index}].memberNumber" class="read-input" readonly="true"/>
												</td>
												<td>
													<form:input path="pmList[${status.index}].memberName" class="read-input" readonly="true"/>
												</td>
												<td>
													<form:input path="pmList[${status.index}].department" class="read-input" readonly="true"/>
												</td>
												<td>
													<form:input path="pmList[${status.index }].position" class="read-input" readonly="true"/>
												</td>
												<td>
													<form:input type="date" path="pmList[${status.index}].startDate" class="startDate" index="${status.index }"
														min="${modifyProjectBean.projectStartDate}" max="${modifyProjectBean.maintEndDate != '' ? modifyProjectBean.maintEndDate : modifyProjectBean.projectEndDate}"/>
												</td>
												<td>
													<form:input type="date" path="pmList[${status.index}].endDate" class="endDate" index="${status.index }"
														min="${modifyProjectBean.projectStartDate}" max="${modifyProjectBean.maintEndDate != '' ? modifyProjectBean.maintEndDate : modifyProjectBean.projectEndDate}"/>
												</td>
												<td>
													<form:select path="pmList[${status.index}].roleCode" class="role text-left">
														<c:forEach var="role" items="${roleList}">
															<form:option value="${role.detailCode}">${role.codeName}</form:option>
														</c:forEach>
													</form:select>
												</td>
											</tr>
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</tbody>
						</table>
					</div>
					<div class="none" id="errorMessages">
						<form:errors path="memberNumberError"></form:errors>
						<form:errors path="startDateError"></form:errors>
						<form:errors path="endDateError"></form:errors>
						<form:errors path="roleCodeError"></form:errors>
					</div>
					<div class="text-right">
						<button type="button" class="btn btn-red" id="delete_addProjectBtn">삭제</button>
						<button type="button" class="btn btn-green" id="addPMModalBtn">추가</button>
					</div>
					<div class="text-center">
						<button type="submit" class="btn btn-green">저장</button>
						<button type="button" class="btn btn-orange" id="modifyProjectCancelButton">취소</button>
					</div>
				</form:form>
			</section>
		</div>
	</div>
</body>
<script>
	modalStack.push('#modalModifyProject');
	currModal = getCurrModalDom();
	
	currModal.querySelector('#modifyProjectCloseButton').addEventListener('click', modifyProjectCloseEvent); // 닫기 버튼 이벤트
	currModal.querySelector('#modifyProjectCancelButton').addEventListener('click', modifyProjectCloseEvent); // 취소 버튼 이벤트
	currModal.querySelectorAll('input[type="checkbox"][name="skillCodeList"]').forEach(skill => { // 프로젝트 필요기술 체크 이벤트
		skill.addEventListener('click', dropdownLabelDraw);
	});
	
	
	addDropdownEvent();
	isScroll();
	checkEvent();
	dropdownLabelDraw();
	lengthLimitEvent();
	
	function modifyProjectCloseEvent(){
		$(modalStack.pop()).html('');
		currModal = getCurrModalDom();
	}
	
	function modifyProjectStartDateChangeEvent(){
		const projectEndDate
	}
	
</script>
</html>