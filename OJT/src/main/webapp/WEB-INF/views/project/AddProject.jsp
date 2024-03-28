<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>프로젝트 등록</title>
<style>
	form > div {
		margin: 3px 0;
		padding: 0 3px;
	}
	
	th, td{
		text-align: center;
	}
	
	.text-top {
		vertical-align: top;
	}
	
	tbody select, tbody input {
		padding: 3px 5px;
		text-align: center;
	}
	
	#scrollDiv {
		min-height: 200px;
		max-height: 200px;
	}
	
	.dropdown-menu {
		max-height: 135px;
	}
	
</style>
</head>
<body>
	<div class="modal-background">
		<input type="hidden" name="success" value="${success}"/>
		<input type="hidden" name="prj_seq" value="${prj_seq}"/>
		<div class="modal">
			<header>
				<div class="justify-content-center">
					<div class="w-20">
						<span class="required">*</span>필수입력
					</div>
					<div class="text-center w-60">
						<h3>프로젝트 등록</h3>
					</div>
					<div class="text-right w-20">
						<button type="button" class="closeBtn" id="addProjectClose">
							<img src="${root}resources/images/x.png" alt="" />
						</button>
					</div>
				</div>
			</header>
			<section>
				<form:form action="${root}project/addProject" method="POST" modelAttribute="addProjectBean" enctype="application/x-www-form-urlcencoded">
					<div class="justify-content-center">
						<div class="w-20">프로젝트 명<span class="required">*</span></div>
						<div class="w-30">
							<form:input path="prj_nm" maxlength="20" placeholder="1 ~ 20 글자" required="true"/>
						</div>
						<div class="w-20 text-center" class="required">고객사<span class="required">*</span></div>
						<div class="w-30">
							<form:select path="cust_seq">
								<form:option value="0">-선택-</form:option>
								<c:forEach var="item" items="${customerList}">
									<form:option value="${item.cust_seq}">${item.cust_nm}</form:option>
								</c:forEach>
							</form:select>
						</div>
					</div>
					<!-- error -->
					<div class="justify-content-center">
						<div class="w-20"></div>
						<div class="w-30">
							<span id="prj_nm_length.errors"></span>
							<form:errors path="prj_nm"></form:errors>
						</div>
						<div class="w-20"></div>
						<div class="w-30">
							<form:errors path="cust_seq"></form:errors>
						</div>
					</div>
					<div class="justify-content-center">
						<div class="w-20">프로젝트 기간<span class="required">*</span></div>
						<div class="w-30">
							<form:input type="date" path="prj_st_dt" required="true"/>
						</div>
						<div class="w-20 text-center">~</div>
						<div class="w-30">
							<form:input type="date" path="prj_ed_dt" required="true"/>
						</div>
					</div>
					<!-- error -->
					<div class="justify-content-center">
						<div class="w-20"></div>
						<div class="w-30">
							<form:errors path="prj_st_dt"></form:errors>
						</div>
						<div class="w-20"></div>
						<div class="w-30">
							<form:errors path="prj_ed_dt"></form:errors>
						</div>
					</div>
					<div class="justify-content-center" id="projectStatus">
						<div class="w-20">
							유지보수 기간					
						</div>
						<div class="w-30">
							<form:input type="date" path="maint_st_dt"/>
						</div>
						<div class="w-20 text-center">~</div>
						<div class="w-30">
							<form:input type="date" path="maint_ed_dt" />
						</div>
					</div>
					<!-- error -->
					<div class="justify-content-center">
						<div class="w-20"></div>
						<div class="w-30">
							<form:errors path="maint_st_dt"></form:errors>
						</div>
						<div class="w-20"></div>
						<div class="w-30">
							<form:errors path="maint_ed_dt"></form:errors>
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
										<form:checkbox path="sk_cd_list" value="${item.dtl_cd}"/>
										<form:label style="flex: 1;" path="sk_cd_list" for="sk_cd_list${status.index + 1}">
											${item.dtl_cd_nm}
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
							<form:errors path="prj_sk_list"></form:errors>
						</div>
					</div>
					
					<div class="justify-content-center" style="align-items: start;">
						<div class="w-20 text-top">세부사항</div>
						<div class="w-80">
							<div>
								<form:textarea path="prj_dtl" maxlength="500" wrap="on"/>
							</div>
							<div class="text-right">
								<span id="prj_dtl_length"></span>
							</div>
							<div>
								<span id="prj_dtl_length.errors"></span>
							</div>
						</div>
					</div>
					<div>
						<div class="w-100">
							<form:errors path="prj_dtl"></form:errors>
						</div>
					</div>
					<div class="justify-content-center">
						인원 추가<hr class="text-line"/>
					</div>
					<div id="scrollDiv" class="">
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
									<th scope="col"><input type="checkbox" id="allCheckAddProject" value="false"/></th>
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
									<c:when test="${fn:length(addProjectBean.pmList) == 0 }">
										<tr>
											<td class="text-center" colspan="8">
												추가된 인원이 없습니다.
											</td>
										</tr>
									</c:when>
									<c:otherwise>
										<c:forEach var="item" items="${addProjectBean.pmList}" varStatus="status">
											<tr>
												<td><input type="checkbox" class="checkAddProject"/></td>
												<td>
													<form:input path="pmList[${status.index}].mem_seq" class="read-input" readonly="true"/>
												</td>
												<td>
													<form:input path="pmList[${status.index}].mem_nm" class="read-input" readonly="true"/>
												</td>
												<td>
													<form:input path="pmList[${status.index}].dept" class="read-input" readonly="true"/>
												</td>
												<td>
													<form:input path="pmList[${status.index }].position" class="read-input" readonly="true"/>
												</td>
												<td>
													<form:input type="date" path="pmList[${status.index}].st_dt" class="st_dt" index="${status.index }"/>
												</td>
												<td>
													<form:input type="date" path="pmList[${status.index}].ed_dt" class="ed_dt" index="${status.index }"/>
												</td>
												<td>
													<form:select path="pmList[${status.index}].ro_cd" class="role text-left">
														<c:forEach var="role" items="${roleList}">
															<form:option value="${role.dtl_cd}">${role.dtl_cd_nm}</form:option>
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
						<form:errors path="mem_seq_error"></form:errors>
						<form:errors path="st_dt_error"></form:errors>
						<form:errors path="ed_dt_error"></form:errors>
						<form:errors path="ro_cd_error"></form:errors>
					</div>
					<div class="text-right">
						<button type="button" class="btn btn-red" id="delete_addProjectBtn">삭제</button>
						<button type="button" class="btn btn-green" id="addPMModalBtn">추가</button>
					</div>
					<div class="text-center">
						<button type="submit" class="btn btn-green">저장</button>
						<button type="button" class="btn btn-orange" id="cancelBtn">취소</button>
					</div>
				</form:form>
			</section>
		</div>
	</div>
</body>
<script>
modalStack.push('#modalAddProject');

//멤버 투입일, 철수일 변경 이벤트 추가
changeProjectDateEvent();

// 프로젝트 시작일 종료일 이벤트 추가
document.getElementById('prj_st_dt').addEventListener('change', prjStartDateChange);
document.getElementById('prj_ed_dt').addEventListener('change', prjEndDateChange);

// 유지보수 시작일 철수일 이벤트 추가
document.getElementById('maint_st_dt').addEventListener('change', maintStartDateEvent);
document.getElementById('maint_ed_dt').addEventListener('change', maintEndDateEvent);

// 닫기(취소) 버튼
document.getElementById('addProjectClose').addEventListener('click', function(){
	$('#modalAddProject').html('');
	modalStack.pop();
})
document.getElementById('cancelBtn').addEventListener('click', function(){
	$('#modalAddProject').html('');
	modalStack.pop();
})

// 드롭다운 이벤트 추가
addDropdownEvent();

// 기술 check 이벤트
document.querySelectorAll('input[type="checkbox"][name="sk_cd_list"]').forEach(check => {
	check.addEventListener('click', checkedSKEvent);
})

// 삭제 버튼 이벤트
document.getElementById('delete_addProjectBtn').addEventListener('click', delete_addProjectEvent);

// 모두 체크 이벤트
document.getElementById('allCheckAddProject').addEventListener('click', allCheckAddProjectEvent);

// 모두 체크 되었을 때의 이벤트
document.querySelectorAll('.checkAddProject').forEach(check => {
	check.addEventListener('click', isAllCheckAddProject);
})

// 추가 버튼 이벤트
document.getElementById('addPMModalBtn').addEventListener('click', addPMModalBtnEvent);

// submit 이벤트
document.getElementById('addProjectBean').addEventListener('submit', function(event){
	event.preventDefault();
	addProjectBeanSubmitEvent();
})

// 길이제한 이벤트 추가
lengthLimitEvent();

// 필요기술을 표시하기위해 checkedSKEvent() 호출
checkedSKEvent();

// 멤버 벨리데이션 얼럿
errorMessagesAlert();

// 스크롤
isScrollAddProject();

// 프로젝트 세부사항 현재 길이
projectDetailLength();
document.getElementById('prj_dtl').addEventListener('input', projectDetailLength);
</script>
</html>