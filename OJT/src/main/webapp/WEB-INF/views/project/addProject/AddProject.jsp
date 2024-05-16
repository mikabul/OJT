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
		<input type="hidden" name="success" value="${success}"/>
		<input type="hidden" name="projectNumber" value="${projectNumber}"/>
		<div class="modal">
			<header>
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
			</header>
			<section>
				<form:form action="${root}project/add" method="POST" modelAttribute="addProjectBean" enctype="application/x-www-form-urlcencoded">
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
							<form:input type="date" path="projectStartDate" required="true"/>
						</div>
						<div class="w-20 text-center">~</div>
						<div class="w-30">
							<form:input type="date" path="projectEndDate" required="true"/>
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
							<form:input type="date" path="maintStartDate" min="${ addProjectBean.projectEndDate }"/>
						</div>
						<div class="w-20 text-center">~</div>
						<div class="w-30">
							<form:input type="date" path="maintEndDate" min="${ addProjectBean.projectEndDate }"/>
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
									<th scope="col"><input type="checkbox" class="allCheck"/></th>
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
														min="${ startDate }" max="${ endDate }"/>
												</td>
												<td>
													<form:input type="date" path="pmList[${status.index}].endDate" class="endDate" index="${status.index }"
														min="${ startDate }" max="${ endDate }"/>
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
						<button type="button" class="btn btn-red" id="deletePMButton">삭제</button>
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
currModal = getCurrModalDom();

currModal.querySelector('#addProjectClose').addEventListener('click', addProjectCloseEvent);				// 닫기 버튼 이벤트
currModal.querySelector('#cancelBtn').addEventListener('click', addProjectCloseEvent);						// 취소버튼 이벤트
currModal.querySelectorAll('input[type="date"]').forEach( date => {											// 날짜 포커스 이벤트
	date.addEventListener('focus', addProjectDateFocusEvent);
});
currModal.querySelector('#projectStartDate').addEventListener('focusout', projectStartDateFocusoutEvent);	// 프로젝트 시작일 이벤트
currModal.querySelector('#projectEndDate').addEventListener('focusout', projectEndDateFocusoutEvent);		// 프로젝트 종료일 이벤트
currModal.querySelector('#maintStartDate').addEventListener('focusout', maintStartDateFocusoutEvent);		// 유지보수 시작일 이벤트
currModal.querySelector('#maintEndDate').addEventListener('focusout', maintEndDateFocusoutEvent);			// 유지보수 종료일 이벤트
currModal.querySelectorAll('input[type="checkbox"][name="skillCodeList"]').forEach(check => {				// 기술 check 이벤트
	check.addEventListener('click', dropdownLabelDraw);
});
currModal.querySelector('#deletePMButton').addEventListener('click', deletePMButtonEvent);				// 삭제 버튼 이벤트

currModal.querySelector('#addPMModalBtn').addEventListener('click', addPMModalBtnEvent);					// 추가 버튼 이벤트
currModal.querySelector('#addProjectBean').addEventListener('submit', function(event){						// submit 이벤트
	event.preventDefault();
	addProjectBeanSubmitEvent();
});
currModal.querySelector('#projectDetail').addEventListener('input', projectDetailLength);					// input들의 현재 길이 이벤트

addDropdownEvent();			// 드롭다운 이벤트 추가
lengthLimitEvent();			// 길이제한 이벤트 추가
dropdownLabelDraw();		// 필요기술을 표시하기위해 checkedSKEvent() 호출
errorMessagesAlert();		// 멤버 벨리데이션 얼럿
isScroll();					// 스크롤
projectDetailLength();		// 프로젝트 디테일 길이 표시 이벤트
checkEvent();				// 체크 이벤트 추가
pmDateEvent();			// 프로젝트멤버 날짜 이벤트 추가

// 프로젝트 추가 모달 닫기 이벤트
function addProjectCloseEvent(){
	$(modalStack.pop()).html('');
	currModal = getCurrModalDom();
}

//프로젝트 날짜 포커스 이벤트
function addProjectDateFocusEvent(){
	preDate = this.value;
	projectStart = currModal.querySelector('input[name="projectStartDate"]');
	projectEnd = currModal.querySelector('input[name="projectEndDate"]');
	maintStart = currModal.querySelector('input[name="maintStartDate"]');
	maintEnd = currModal.querySelector('input[name="maintEndDate"]');
}

// 프로젝트 시작일 포커스 아웃 이벤트
function projectStartDateFocusoutEvent(){
	const projectStartDate = new Date(this.value);
	const projectEndDate = new Date(projectEnd.value);
	const maintStartDate = new Date(maintStart.value);
	const maintEndDate = new Date(maintEnd.value);
	
	if(projectStartDate > projectEndDate){
		projectEnd.value = this.value;
	}
	if(projectStartDate > maintStartDate){
		maintStart.min = this.value;
		maintStart.value = this.value;
	}
	if(projectStartDate > maintEndDate){
		maintEndDate.min = this.value;
		maintEndDate.value = this.value;
	}
	
	modifyProjectDateChangeToMemberDate();
}

// 프로젝트 종료일 포커스 아웃 이벤트
function projectEndDateFocusoutEvent(){
	const projectStartDate = new Date(projectStart.value);
	const projectEndDate = new Date(this.value);
	const maintStartDate = new Date(maintStart.value);
	const maintEndDate = new Date(maintEnd.value);
	
	if(projectEndDate < projectStartDate){
		projectStart.value = this.value;
	}
	if(projectEndDate > maintStartDate){
		maintStart.value = this.value;
	}
	if(projectEndDate > maintEndDate){
		maintEnd.value = this.value;
	}
	maintStart.min = this.value;
	maintEnd.min = this.value;
	modifyProjectDateChangeToMemberDate();
}

// 유지보수 시작일 포커스 아웃 이벤트
function maintStartDateFocusoutEvent(){
	const projectEndDate = new Date(projectEnd.value);
	const maintStartDate = new Date(this.value);
	const maintEndDate = new Date(maintEnd.value);
	
	if(maintStartDate < projectEndDate){
		projectMemberDateAlert({text : '프로젝트 종료일보다 이전일수 없습니다.'});
		if(preDate != ''){
			this.value = preDate;
		} else {
			this.value = projectEnd.value;
		}
	}
	if(maintStartDate > maintEndDate){
		maintEnd.value = this.value;
	}
	modifyProjectDateChangeToMemberDate();
}

// 유지보수 종료일 포커스 아웃 이벤트
function maintEndDateFocusoutEvent(){
	const projectEndDate = new Date(projectEnd.value);
	const maintStartDate = new Date(maintStart.value);
	const maintEndDate = new Date(this.value);
	
	if(maintEndDate < projectEndDate){
		projectMemberDateAlert({text : '프로젝트 종료일보다 이전일수 없습니다.'});
		if(preDate != ''){
			this.value = preDate;
		} else {
			this.value = projectEnd.value;
		}
	}
	
	if(maintEndDate < maintStartDate){
		maintStart.value = this.value;
	}
	modifyProjectDateChangeToMemberDate();
}

//프로젝트(유지보수) 날짜 변경시 멤버 투입일, 철수일 변경 함수
function modifyProjectDateChangeToMemberDate(){
	const projectStartDate = new Date(projectStart.value);
	const projectEndDate = new Date(projectEnd.value);
	const maintStartDate = new Date(maintStart.value);
	const maintEndDate = new Date(maintEnd.value);
	const memberStarts = currModal.querySelectorAll('input[type="date"][name$=".startDate"]');
	const memberEnds = currModal.querySelectorAll('input[type="date"][name$=".endDate"]');
	
	//멤버 투입일
	memberStarts.forEach(memberStart => {
		
		const memberStartDate = new Date(memberStart.value);
		memberStart.min = projectStart.value;
		
		if(projectStartDate > memberStartDate){// 프로젝트 시작일 보다 이전이라면
			memberStart.value = projectStart.value;
		}
		
		if(maintStart.value != ''){
			memberStart.max = maintEnd.value;
			if(maintEnd.value != '' && maintEndDate < memberStartDate){
				memberStart.value = maintEnd.value;
			}
		} else {
			memberStart.max = projectEnd.value;
			if(projectEndDate < memberStartDate){
				memberStart.value = projectEnd.value;
			}
		}
	});
	
	// 멤버 철수일
	memberEnds.forEach(memberEnd => {
		const memberEndDate = new Date(memberEnd.value);
		memberEnd.min = projectStart.value;
		if(projectStartDate > memberEndDate){// 프로젝트 시작일보다 이전이라면
			memberEnd.value = projectStart.value;
		}
		
		if(maintStart.value != ''){
			memberEnd.max = maintEnd.value;
			if(maintEnd.value != '' && maintEndDate < memberEndDate){
				memberEnd.value = maintEnd.value;
			}
		} else {
			memberEnd.max = projectEnd.value;
			if(projectEndDate < memberEndDate){
				memberEnd.value = projectEnd.value;
			}
		}
	});
}

//멤버 관련 벨리데이션
function errorMessagesAlert(){
	let errorsMessage = '';
	document.querySelectorAll('#errorMessages [id$=".errors"]').forEach(item => {
		errorsMessage += item.innerHTML + '\n';
	});
	if (errorsMessage.length > 0) {
		Swal.fire('인원 추가', errorsMessage, 'error');
	}
}

//프로젝트 멤버 삭제 버튼 이벤트
function deletePMButtonEvent(){
	
	const formData = new FormData(currModal.querySelector('#addProjectBean'));
	const tbody = currModal.querySelector('tbody');
	const rows = tbody.rows;
	let deleteIndex = [];
	
	for(let i = 0; i < rows.length; i++){
		const row = rows[i];
		const checkbox = row.cells[0].querySelector('input');
		if(checkbox.checked){
			deleteIndex.push(i);
		}
	}
	
	if(deleteIndex.length == 0){
		Swal.fire({
			toast: true,
			timer: 2500,
			timerProgressBar: true,
			position: 'top',
			showConfirmButton: false,
			icon: 'info',
			title: '선택된 인원이 없습니다.'
		});
		return;
	}
	
	formData.append("deleteIndex", deleteIndex);
	
	$.ajax({
		url: '/OJT/project/add/delete-member',
		method: 'POST',
		contentType: false,
		processData: false,
		data: formData,
		success: function(result){
			tbody.innerHTML = result;
			checkEvent();
			pmDateEvent();
		},
		error: function(error){
			console.error(error);
		}
	});
	
}

// 추가 버튼 이벤트
function addPMModalBtnEvent(){
	
	const projectStart = currModal.querySelector('input[name="projectStartDate"]').value;
	const projectEnd = currModal.querySelector('input[name="projectEndDate"]').value;
	const maintStart = currModal.querySelector('input[name="maintStartDate"]').value;
	const maintEnd = currModal.querySelector('input[name="maintEndDate"]').value;
	let endDate;
	
	if(maintStart != ''){
		endDate = maintEnd;
	} else {
		endDate = projectEnd;
	}
	
	$.ajax({
		url: '/OJT/project/add/modal-member',
		method: 'GET',
		data: {
			'startDate' : projectStart,
			'endDate' : endDate
		},
		success: function(result){
			$('#modalAddProjectMember').html(result);
		},
		error: function(error){
			console.log('ajax 실패');
			console.error(error);
		}
	});
}

// submit버튼 이벤트
function addProjectBeanSubmitEvent(){
    const form = document.getElementById('addProjectBean');
    const formData = new FormData(form);
    
   	let urlSearchParams = new URLSearchParams();
   	
   	formData.forEach((value, key) => {
		urlSearchParams.append(key, value);
	})
   	
    $.ajax({
        url: '/OJT/project/add/add-project',
        method: 'POST',
        contentType: false,
        processData: false,
        data: urlSearchParams,
        success: function(response){
			$('#modalAddProject').html(response);
			const inputSuccess = document.querySelector('input[name="success"]');
			let success;
			if(inputSuccess){ // input[name="success"] 이 undefined가 아닌지
				success = inputSuccess.value;
			}
			
			if(success == 'true'){ 
	            addSuccess();
			}
        },
        error: function(error){
            console.error(error);
        }
    });
}

// 추가에 성공 했을 경우의 함수
function addSuccess(){
	Swal.fire({
		icon: 'success',
		title: '성공!'
	}).then(() => {
		const success = document.querySelector('input[name="success"]').value;
		const projectNumber = document.querySelector('input[name="projectNumber"]').value;
		const form = document.querySelector('form');
		form.action = '/OJT/project/main?&success=' + success + '&projectNumber=' + projectNumber;
		form.submit();
	})
}

// 프로젝트 세부사항 길이표시 이벤트
function projectDetailLength(){
	const projectDetail = document.getElementById('projectDetail');
	const projectDetailLength = document.getElementById('projectDetailLength');
	let maxlength = projectDetail.getAttribute('maxlength');
	let length = projectDetail.value.length;
	
	projectDetailLength.innerHTML = length + '/' + maxlength;
}

//프로젝트 멤버 추가 날짜 이벤트 추가
function pmDateEvent(){
	currModal.querySelectorAll('.startDate').forEach(startDate => {
		startDate.removeEventListener('focus', addProjectDateFocusEvent);
		startDate.removeEventListener('focusout', pmStartDateFocusoutEvent);
		startDate.addEventListener('focus', addProjectDateFocusEvent);
		startDate.addEventListener('focusout', pmStartDateFocusoutEvent);
	});
	
	currModal.querySelectorAll('.endDate').forEach(endDate => {
		endDate.removeEventListener('focus', addProjectDateFocusEvent);
		endDate.removeEventListener('focusout', pmEndDateFouceoutEvent);
		endDate.addEventListener('focus', addProjectDateFocusEvent);
		endDate.addEventListener('focusout', pmEndDateFouceoutEvent);
	});	
}
 
// 프로젝트 멤버 시작일 포커스 아웃 이벤트
function pmStartDateFocusoutEvent(){
	
	const memberStartDate = new Date(this.value);
	const projectStartDate = new Date(projectStart.value);
	const projectEndDate = new Date(projectEnd.value);
	const maintEndDate = new Date(maintEnd.value);
	
	if(memberStartDate < projectStartDate){
		projectMemberDateAlert({html : '<p>투입일은 프로젝트 시작일보다 이전일수 없습니다.</p>'});
		if(preDate != ''){
			this.value = preDate;
		} else {
			this.value = projectStart.value;
		}
	} else if(maintStart.value != ''){
		if(memberStartDate > maintEndDate){
			projectMemberDateAlert({html : '<p>투입일은 유지보수 종료일보다 이후일수 없습니다.</p>'});
			if(preDate != ''){
				this.value = preDate;
			} else {
				this.value = projectStart.value;
			}
		}
	} else if(memberStartDate > projectEndDate){
		projectMemberDateAlert({html : '<p>투입일은 프로젝트 종료일보다 이후일수 없습니다.</p>'});
		if(preDate != ''){
			this.value = preDate;
		} else {
			this.value = projectStart.value;
		}
	}
}

//프로젝트 멤버 종료일 포커스 아웃 이벤트
function pmEndDateFouceoutEvent(){
	
	const memberEndDate = new Date(this.value);
	const projectStartDate = new Date(projectStart.value);
	const projectEndDate = new Date(projectEnd.value);
	const maintEndDate = new Date(maintEnd.value);
	
	if(memberEndDate < projectStartDate){
		projectMemberDateAlert({html : '<p>투입일은 프로젝트 시작일보다 이전일수 없습니다.</p>'});
		if(preDate != ''){
			this.value = preDate;
		} else {
			this.value = projectEnd.value;
		}
	} else if(maintStart.value != ''){
		if(memberEndDate > maintEndDate){
			projectMemberDateAlert({html : '<p>투입일은 유지보수 종료일보다 이후일수 없습니다.</p>'});
			if(preDate != ''){
				this.value = preDate;
			} else {
				this.value = maintEnd.value;
			}
		}
	} else if(memberEndDate > projectEndDate){
		projectMemberDateAlert({html : '<p>투입일은 프로젝트 종료일보다 이후일수 없습니다.</p>'});
		if(preDate != ''){
			this.value = preDate;
		} else {
			this.value = projectEnd.value;
		}
	}
}
</script>
</html>