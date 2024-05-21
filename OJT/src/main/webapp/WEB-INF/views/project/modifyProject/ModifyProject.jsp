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
					<span class="required">*</span>&nbsp;필수
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
				<form:form modelAttribute="modifyProjectBean">
					<form:hidden path="projectNumber"/>
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
					<div class="flex">
						<div class="w-20">
							상태
						</div>
						<div class="w-30">
							<form:select path="projectStateCode">
								<c:forEach var="item" items="${ psList }">
									<form:option value="${ item.detailCode }">${ item.codeName }</form:option>
								</c:forEach>
							</form:select>
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
													<form:input type="date" path="pmList[${status.index}].startDate" class="startDate" min="${startDate}" max="${endDate}"/>
												</td>
												<td>
													<form:input type="date" path="pmList[${status.index}].endDate" class="endDate" min="${startDate}" max="${endDate}"/>
												</td>
												<td>
													<form:select path="pmList[${status.index}].roleCode" class="role text-left">
														<c:forEach var="role" items="${roleList}">
															<form:option class="text-left" value="${role.detailCode}">${role.codeName}</form:option>
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
					<div class="none" id="deleteMember">
						<c:forEach var="item" items="${ deleteMemberList }">
							<div data-membernumber="${ item }"></div>
						</c:forEach>
					</div>
					<div class="text-right">
						<button type="button" class="btn btn-red" id="modifyProjectDeleteButton">삭제</button>
						<button type="button" class="btn btn-green" id="modifyProjectAddPMButton">추가</button>
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
	currModal.querySelectorAll('input[type="date"]').forEach(date => { // 날짜 포커스 이벤트
		date.addEventListener('focus', modifyProjectDateFocusEvent);
	});
	currModal.querySelector('input[name="projectStartDate"]').addEventListener('focusout', modifyProjectStartDateFocusoutEvent); // 프로젝트 시작일 포커스 아웃 이벤트
	currModal.querySelector('input[name="projectEndDate"]').addEventListener('focusout', modifyProjectEndDateFocusoutEvent); // 프로젝트 종료일 포커스 아웃 이벤트
	currModal.querySelector('input[name="maintStartDate"]').addEventListener('focusout', modifyMaintStartDateFocusoutEvent); // 유지보수 시작일 포커스 아웃 이벤트
	currModal.querySelector('input[name="maintEndDate"]').addEventListener('focusout', modifyMaintEndDateFocusoutEvent); // 유지보수 종료일 포커스 아웃 이벤트
	
	currModal.querySelector('form#modifyProjectBean').addEventListener('submit', modifyProjetcSubmitEvent);// submit 이벤트
	currModal.querySelector('#modifyProjectAddPMButton').addEventListener('click', modifyProjectAddPMButtonEvent); // 멤버 추가 버튼 이벤트
	currModal.querySelector('#modifyProjectDeleteButton').addEventListener('click', modifyProjectDeleteButtonEvent); // 멤버 삭제 버튼 이벤트
	
	modifyProjectStartup();
	addDropdownEvent();
	isScroll();
	checkEvent();
	dropdownLabelDraw();
	lengthLimitEvent();
	addModifyPMFocusEvent();
	
	/*            */
	/* 이벤트 펑션 들 */
	/*            */
	// 닫기 이벤트
	function modifyProjectCloseEvent(){
		$(modalStack.pop()).html('');
		currModal = getCurrModalDom();
	}
	
	function modifyProjectStartup(){
		const success = `${success}`;
		const code = `${code}`;
		const projectNumber = `${modifyProjectBean.projectNumber}`;
		if(success == 'true'){
			Swal.fire({
				icon: 'success',
				title: '성공',
				text: '프로젝트 수정에 성공하였습니다.'
			}).then(() => {
				const form = document.querySelector('form');
				form.action = '/OJT/project/main?&success=' + success + '&projectNumber=' + projectNumber;
				form.submit();
			})
		} else if(success == 'false') {
			if(code == '400'){
				const errorMessages = currModal.querySelectorAll('#errorMessages span[id$=".errors"]');
				let message = '';
				errorMessages.forEach( error => {
					message += '<p>' + error.innerText + '</P>';
				});
				
				Swal.fire({
					icon: 'error',
					title: '프로젝트 인원',
					html: message
				});
			} else if(code == '500'){
				Swal.fire('실패', '프로젝트 수정에 실패하였습니다.', 'error');
			} else if(code == '501'){
				Swal.fire('실패', '프로젝트 인원 수정에 실패하였습니다.', 'error');
			} else if(code == '502'){
				Swal.fire('실패', '프로젝트 인원 삭제에 실패하였습니다.', 'error');
			}
		}
	}
	
	// 프로젝트(유지보수) 시작일, 종료일 포커스 이벤트
	function modifyProjectDateFocusEvent(){
		preDate = this.value;
		projectStart = currModal.querySelector('input[name="projectStartDate"]');
		projectEnd = currModal.querySelector('input[name="projectEndDate"]');
		maintStart = currModal.querySelector('input[name="maintStartDate"]');
		maintEnd = currModal.querySelector('input[name="maintEndDate"]');
	}
	
	// 프로젝트 시작일 포커스 아웃 이벤트
	function modifyProjectStartDateFocusoutEvent(){
		
		const projectStartDate = new Date(this.value);
		const projectEndDate = new Date(projectEnd.value);
		const maintStartDate = new Date(maintStart.value);
		const maintEndDate = new Date(maintEnd.value);
		
		if(projectStartDate > projectEndDate){
			projectEnd.value = this.value;
		}
		if(maintStartDate < projectStartDate){
			maintStart.value = this.value;
			maintStart.min = this.value;
			maintEnd.min = this.value;
			if(maintEndDate < projectStartDate){
				maintEnd.value = this.value;
			}
		}
		modifyProjectDateChangeToMemberDate();
	}

	// 프로젝트 종료일 포커스 아웃 이벤트
	function modifyProjectEndDateFocusoutEvent(){
		
		const projectStartDate = new Date(projectStart.value);
		const projectEndDate = new Date(this.value);
		const maintStartDate = new Date(maintStart.value);
		const maintEndDate = new Date(maintEnd.value);
		
		if(projectStartDate > projectEndDate){
			projectStart.value = this.value;
		}
		if(maintStartDate < projectEndDate){
			maintStart.value = this.value;
			if(maintEndDate < projectEndDate){
				maintEnd.value = this.value;
			}
		}
		maintStart.min = this.value;
		maintEnd.min = this.value;
		modifyProjectDateChangeToMemberDate();
	}
	
	// 유지보수 시작일 포커스 아웃 이벤트
	function modifyMaintStartDateFocusoutEvent(){
		const projectEndDate = new Date(projectEnd.value);
		const maintStartDate = new Date(maintStart.value);
		const maintEndDate = new Date(maintEnd.value);
		
		if(maintStartDate < projectEndDate){
			projectMemberDateAlert({text : '유지보수 시작일은 프로젝트 종료일보다 이전일수 없습니다.'});
			this.value = preDate;
			return;
		}
		if(maintEndDate < maintStartDate){
			maintEnd.value = this.value;
		}
		modifyProjectDateChangeToMemberDate();
	}
	
	// 유지보수 종료일 포커스 아웃 이벤트
	function modifyMaintEndDateFocusoutEvent(){
		const projectEndDate = new Date(projectEnd.value);
		const maintStartDate = new Date(maintStart.value);
		const maintEndDate = new Date(maintEnd.value);
		
		if(projectEndDate > maintEndDate){
			projectMemberDateAlert({text : '유지보수 종료일은 프로젝트 종료일보다 이전일수 없습니다.'});
			this.value = preDate;
			return;
		}
		if(maintStartDate > maintEndDate){
			maintStart.value = this.value;
		}
		modifyProjectDateChangeToMemberDate();
	}
	
	// 프로젝트(유지보수) 날짜 변경시 멤버 투입일, 철수일 변경 함수
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
			if(projectStartDate > memberStartDate){// 프로젝트 시작일 보다 이전이라면
				memberStart.value = projectStart.value;
			}
			memberStart.min = projectStart.value;
			if(maintStartDate != 'Invalid Date' && maintEndDate == 'Invalid Date'){
				memberStart.max = '';
			} else if(maintEndDate != 'Invalid Date'){ // 유지보수 종료일이 존재한다면
				if(maintEndDate < memberStartDate){ // 유지보수 종료일보다 이후라면
					memberStart.value = maintEnd.value;
				}
				memberStart.max = maintEnd.value;
			} else {
				if(projectEndDate < memberStartDate){ // 프로젝트 종료일보다 이후라면
					memberStart.value = projectEnd.value;
				}
				memberStart.max = projectEnd.value;
			}
		});
		// 멤버 철수일
		memberEnds.forEach(memberEnd => {
			const memberEndDate = new Date(memberEnd.value);
			memberEnd.min = projectStart.value;
			if(projectStartDate > memberEndDate){// 프로젝트 시작일보다 이전이라면
				memberEnd.value = projectStart.value;
			}
			if(maintStartDate != 'Invalid Date' && maintEndDate == 'Invalid Date'){
				memberEnd.max = '';
			} else if(maintEndDate != 'Invalid Date'){ // 유지보수 종료일이 존재한다면
				if(maintEndDate < memberEndDate){ // 유지보수 종료일보다 이후라면
					memberEnd.value = maintEnd.value;
				}
				memberEnd.max = maintEnd.value;
			} else {
				if(memberEndDate > projectEnd){ // 프로젝트 종료일 보다 이후라면
					memberEnd.value = this.value;
				}
				memberEnd.max = this.value;
			}
		});
	}
	
	function addModifyPMFocusEvent(){
		currModal.querySelectorAll('input[name$=".startDate"]').forEach(startDate => { // 멤버 투입일 포커스 아웃 이벤트
			startDate.addEventListener('focus', modifyProjectDateFocusEvent);
			startDate.addEventListener('focusout', modifyPMStartDateFocusoutEvent);
		});
		currModal.querySelectorAll('input[name$=".endDate"]').forEach(endDate => { // 멤버 철수일 포커스 아웃 이벤트
			endDate.addEventListener('focus', modifyProjectDateFocusEvent);
			endDate.addEventListener('focusout', modifyPMEndDateFocusoutEvent);
		});
	}
	
	// 멤버 투입일 포커스 아웃 이벤트
	function modifyPMStartDateFocusoutEvent(){
		const projectStartDate = new Date(projectStart.value);
		const projectEndDate = new Date(projectEnd.value);
		const maintStartDate = new Date(maintStart.value);
		const maintEndDate = new Date(maintEnd.value);
		const memberStartDate = new Date(this.value);
		
		if(memberStartDate < projectStartDate){
			projectMemberDateAlert({text : '투입일은 프로젝트 시작일보다 이전일수 없습니다.'});
			
			if(preDate == ''){
				this.value = projectStart.value;
			} else {
				this.value = preDate;
			}
		}
		if(maintStartDate != 'Invalid Date' && maintEndDate == 'Invalid Date'){
			return;
		} else if(maintEndDate != 'Invalid Date'){
			if(maintEndDate < memberStartDate){
				projectMemberDateAlert({text : '투입일은 유지보수 종료일보다 이후일수 없습니다.'});
				if(preDate == ''){
					this.value = maintEnd.value;
				} else {
					this.value = preDate;
				}
			}
		} else if(projectEndDate < memberStartDate){
			projectMemberDateAlert({text : '투입일은 프로젝트 종료일보다 이후일수 없습니다.'});
			if(preDate == ''){
				this.value = projectEnd.value;
			} else {
				this.value = preDate;
			}
		}
	}
	
	// 멤버 철수일 포커스 아웃 이벤트
	function modifyPMEndDateFocusoutEvent(){
		const projectStartDate = new Date(projectStart.value);
		const projectEndDate = new Date(projectEnd.value);
		const maintStartDate = new Date(maintStart.value);
		const maintEndDate = new Date(maintEnd.value);
		const memberEndDate = new Date(this.value);
		
		if(memberEndDate < projectStartDate){
			projectMemberDateAlert({text : '철수일은 프로젝트 시작일보다 이전일수 없습니다.'});
			if(preDate == ''){
				this.value = projectStart.value;
			} else {
				this.value = preDate;
			}
		}
		if(maintStartDate != 'Invalid Date' && maintEndDate == 'Invalid Date'){
			return;
		} else if(maintEndDate != 'Invalid Date'){
			if(maintEndDate < memberEndDate){
				projectMemberDateAlert({text : '철수일은 유지보수 종료일보다 이후일수 없습니다.'});
				if(preDate == ''){
					this.value = maintEnd.value;
				} else {
					this.value = preDate;
				}
			}
		} else if(projectEndDate < memberEndDate){
			projectMemberDateAlert({text : '철수일은 프로젝트 종료일보다 이후일수 없습니다.'});
			if(preDate == ''){
				this.value = projectEnd.value;
			} else {
				this.value = preDate;
			}
		}
	}
	
	// submit 이벤트
	function modifyProjetcSubmitEvent(event){
		event.preventDefault();
		
		const formData = new FormData(this);
		let deleteMemberNumbers = [];
		currModal.querySelectorAll('#deleteMember div').forEach( number => {
			deleteMemberNumbers.push(number.dataset.membernumber);
		});
		
		formData.append('deleteMemberNumbers', deleteMemberNumbers);
		
		$.ajax({
			url: '/OJT/project/modify/modify-project',
			method: 'POST',
			contentType: false,
			processData: false,
			data: formData,
			success: function(result){
				$(modalStack.pop()).html(result);
			},
			error: function(request, status, error){
				if(request.status == 403) {
					Swal.fire('실패', '접근 권한이 부족합니다.', 'warning');
				} else {
					Swal.fire('실패', '저장에 실패하였습니다.', 'error');
				}
			}
		});
	}
	
	// 멤버 추가 버튼 이벤트
	function modifyProjectAddPMButtonEvent(){
		
		const startDate = currModal.querySelector('input[type="date"][name="projectStartDate"]').value;
		const projectEnd = currModal.querySelector('input[type="date"][name="projectEndDate"]').value;
		const maintStart = currModal.querySelector('input[type="date"][name="maintStartDate"]').value;
		const maintEnd = currModal.querySelector('input[type="date"][name="maintEndDate"]').value;
		let endDate;
		
		if(maintEnd != '' || maintStart != ''){
			endDate = maintEnd;
		} else {
			endDate = projectEnd;
		}
		
		$.ajax({
			url: '/OJT/project/modify/member-modal',
			method: 'POST',
			data: {
				'startDate' : startDate,
				'endDate' : endDate
			},
			success: function(result){
				$('#modalAddProjectMember').html(result);
			},
			error: function(request, status, error){
				if(request.status == 403) {
					Swal.fire('실패', '접근 권한이 부족합니다.', 'warning');
				} else {
					Swal.fire('실패', '로딩에 실패하였습니다.', 'error');
				}
			}
		});
	}
	
	// 삭제 버튼 이벤트
	function modifyProjectDeleteButtonEvent(){
		
		const deleteMember = currModal.querySelector('#deleteMember');
		const tbody = currModal.querySelector('tbody');
		const rows = tbody.rows;
		const formData = new FormData(currModal.querySelector('form'));
		
		let deleteMemberNumbers = [];
		let deleteIndex = [];
		
		for(let i = 0; i < rows.length; i++){
			const checkbox = rows[i].cells[0].querySelector('input');
			if(checkbox.checked){
				const row = rows[i];
				deleteMember.innerHTML += '<div data-membernumber="' + row.cells[1].querySelector('input').value + '" />';
				deleteIndex.push(i);
			}
		}
		
		formData.append('deleteIndex', deleteIndex);

		$.ajax({
			url: '/OJT/project/modify/delete-member',
			method: 'POST',
			contentType: false,
			processData: false,
			data: formData,
			success: function(result){
				tbody.innerHTML = result;
			},
			error: function(request, status, error){
				if(request.status == 403) {
					Swal.fire('실패', '접근 권한이 부족합니다.', 'warning');
				} else {
					Swal.fire('실패', '삭제에 실패하였습니다.', 'error');
				}
			}
			
		});
	}
	
</script>
</html>