<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<html>
<head>
<meta charset="UTF-8">
<style type="text/css">
	.modal header {
		display: flex;
		justify-content: center;
	}
	
	.modal header > div{
		width: 33.3%;
	}
	
	.modal section{
		margin: auto;
		margin-top: 30px;
	}
	
	.modal section.justify-content-center > div.flex input{
		border: 1px solid black;
		background-color: #f0f0f0;
	}
	
	.modal section.justify-content-center > div.flex > div {
		padding-left: 5px;
		padding-right: 5px;
	}
	
	.modal table td input{
		text-align: center;
	}
</style>
</head>
<body>
	<div class="modal-background">
		<div class="modal">
			<header>
				<div></div>
				<div class="text-center"><h3>인원 관리</h3></div>
				<div class="text-right">
					<button type="button" class="closeBtn" id="projectMemberClose">
						<img src="${root}resources/images/x.png" alt="닫기" />
					</button>
				</div>
			</header>
			
			<section>
				<form:form modelAttribute="modifyProjectBean" method="POST" enctype="multipart/form-data">
					<section class="justify-content-center">
						<form:hidden path="projectNumber"/>
						<form:hidden path="projectStartDate"/>
						<form:hidden path="projectEndDate"/>
						<form:hidden path="maintEndDate"/>
						<div class="w-50 flex">
							<div class="w-30">프로젝트 명</div>
							<div class="w-70">
								<form:input path="projectName" class="read-input" readonly="true"/>
							</div>
						</div>
						<div class="w-50 flex">
							<div class="w-30">고객사</div>
							<div class="w-70">
								<form:input path="customerName" class="read-input" readonly="true"/>
							</div>
						</div>
					</section>
					<section>
						<div id="scrollDiv" data-scroll="6">
							<table class="container-center">
								<colgroup>
									<!-- 체크 박스 -->
									<col style="width: 30px;"/>
									<!-- 사원 번호 -->
									<col style="width: 80px;"/>
									<!-- 사원명 -->
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
										<th scope="col">사원명</th>
										<th scope="col">부서</th>
										<th scope="col">직급</th>
										<th scope="col">투입일</th>
										<th scope="col">철수일</th>
										<th scope="col">역할</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="item" items="${ modifyProjectBean.pmList }" varStatus="status">
										<tr>
											<td><input type="checkbox" class="check"/></td>
											<td>
												<form:input path="pmList[${ status.index }].memberNumber" class="read-input text-center" readonly="true"/>
											</td>
											<td>
												<form:input path="pmList[${ status.index }].memberName" class="read-input text-center" readonly="true"/>
											</td>
											<td>
												<form:input path="pmList[${ status.index }].department" class="read-input" readonly="true"/>
											</td>
											<td>
												<form:input path="pmList[${ status.index }].position" class="read-input text-center" readonly="true"/>
											</td>
											<td>
												<form:input type="date" path="pmList[${status.index}].startDate" class="startDate"
													data-value="${ projectBean.pmList[status.index].startDate }"
													min="${ projectBean.projectStartDate }" max="${ projectBean.maintEndDate != null ? projectBean.maintEndDate : projectBean.projectEndDate }"/>
											</td>
											<td>
												<form:input type="date" path="pmList[${status.index}].endDate" class="endDate"
													data-value="${ projectBean.pmList[status.index].endDate }"
													min="${ projectBean.projectStartDate }" max="${ projectBean.maintEndDate != null ? projectBean.maintEndDate : projectBean.projectEndDate }"/>
											</td>
											<td>
												<form:select path="pmList[${status.index}].roleCode" data-value="${ projectBean.pmList[status.index].roleCode }">
													<c:forEach var="role" items="${ roleList }">
														<form:option value="${ role.detailCode }">${ role.codeName }</form:option>
													</c:forEach>
													<form:option value="9999">error-test</form:option>
												</form:select>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</section>
					<section>
						<div class="text-right">
							<button type="button" class="btn btn-red" id="projectMemberDeleteButton">삭제</button>
							<button type="button" class="btn btn-green" id="projectMemberAddButton">추가</button>
						</div>
						<div class="text-center">
							<button type="submit" class="btn">저장</button>
							<button type="button" class="btn" id="projectMemberCloseButton">닫기</button>
						</div>
					</section>
					<div class="none">
						<form:errors path="memberNumberError"></form:errors>
						<form:errors path="startDateError"></form:errors>
						<form:errors path="endDateError"></form:errors>
						<form:errors path="roleCodeError"></form:errors>
					</div>
				</form:form>
			</section>
		</div>
	</div>
</body>
<script type="text/javascript">
	
	/* 	페이지 로딩 끝날시 실행	*/
	modalStack.push('#modalProjectMember');
	currModal = getCurrModalDom();
	
	currModal.querySelector('#projectMemberClose').addEventListener('click', projectMemberCloseButtonEvent); // 닫기 버튼 이벤트
	currModal.querySelector('#projectMemberCloseButton').addEventListener('click', projectMemberCloseButtonEvent); // 취소 버튼 이벤트
	currModal.querySelector('#projectMemberAddButton'). addEventListener('click', projectMemberAddButtonEvent); // 추가 버튼 이벤트
	currModal.querySelector('#projectMemberDeleteButton').addEventListener('click', projectMemberDeleteButtonEvent); // 삭제 버튼 이벤트
	currModal.querySelectorAll('.check').forEach(checkbox => { // checkbox 변경 이벤트
		checkbox.addEventListener('change', projectMemberCheckboxChangeEvent);
	});
	currModal.querySelector('.allCheck').addEventListener('change', projectMemberAllCheckboxChangeEvent); // 모두 선택 checkbox 이벤트
	currModal.querySelector('form#modifyProjectBean').addEventListener('submit', projectMemberModifySubmitEvent); // submit 이벤트
	
	projectMemberDateChangeAddEvent(); // 멤버 날짜 변경 이벤트 추가 펑션
	isScroll(); // 프로젝트 멤버 리스트 스크롤
	checkEvent(); // checkbox 이벤트
	projectMemberInputChangeEvent(); // 멤버 정보 변경시 이벤트
	startUpProjectMember(); // 로딩 시 실행 함수
	
	/*             	*/
	/*  이벤트 펑션 들 	*/
	/*             	*/
	// 닫기 이벤트(닫기 버튼, 취소 버튼)
	function projectMemberCloseButtonEvent(){
		modalStack.pop();
		currModal = getCurrModalDom();
		$('#modalProjectMember').html('');
	}
	
	// 인원 관리 삭제 버튼 이벤트
	function projectMemberDeleteButtonEvent(){
		let memberNumbers = [];
		const table = currModal.querySelector('table');
		const rows = table.querySelector('tbody').rows;
		const projectNumber = document.getElementById('projectNumber').value;
		
		Array.from(rows).forEach(row => {
			if(row.cells[0].querySelector('input[type="checkbox"]').checked){//첫번째 cell의 체크박스에 체크가 되어있다면
				memberNumbers.push(
					row.cells[1].querySelector('input').value// 사원 번호
				)
			}
		});
		
		if(memberNumbers.length == 0){ //length == 0이라면 체크된 인원이 없다고 판단
			Swal.fire({
				toast: true,
				position: 'top',
				showConfirmButton: false,
				timer: 2500,
				timerProgressBar: true,
				icon: 'info',
				text: '선택된 인원이 없습니다.'
			});
			return;
		}
		
		let confirmMessage = '';// 확인을 위한 메시지 작성
		
		Array.from(rows).forEach(row => {
			if(row.cells[0].querySelector('input[type="checkbox"]').checked){//첫번째 cell의 체크박스에 체크가 되어있다면
				
				const memberName = row.cells[2].querySelector('input').value;
				const department = row.cells[3].querySelector('input').value;
				const position = row.cells[4].querySelector('input').value;
				confirmMessage += memberName + '\t' + department + '\t' + position + '\n';
			}
		});
		
		Swal.fire({
			icon: 'warning',
			title: '멤버 삭제',
			text: confirmMessage + '삭제 하시겠습니까?',
			confirmButtonText: '삭제',
			showCancelButton: true,
			cancelButtonText: '취소'
		}).then((result) => {
			if(result.isConfirmed){
				$.ajax({
					url: '/OJT/project/member/delete',
					method: 'POST',
					traditional: true,
					data: {
						'memberNumbers' : memberNumbers,
						'projectNumber' : projectNumber
					},
					success: function(result){
						Swal.fire({
							icon: 'success',
							title: '성공',
							text: '삭제에 성공하였습니다.',
							timer: 3000,
							timerProgressBar: true
						}).then(() => {
							reloadProjectMember(projectNumber); //삭제후 모달 재생성
						});
					},
					error: function(error){
						console.error(error);
					}
				});
			} else {
				Swal.fire('', '취소 되었습니다.', '');
			}
		});
	}// 삭제 버튼 끝
	
	// 모달 새로 불러오기
	function reloadProjectMember(projectNumber){
		$.ajax({
			url: '/OJT/project/member/modal',
			method: 'GET',
			data: {
				'projectNumber' : projectNumber
			},
			success: function(result){
				modalStack.pop();
				$('#modalProjectMember').html(result);
			},
			error: function(xhr, status, error){
				if(xhr.status === 400 && error === false){
					Swal.fire('', '인원을 다시한번 확인해주시기 바랍니다.', 'error');
				} else if(xhr.status === 500 && error === false){
					Swal.fire('', '삭제에 실패하였습니다.\n문제가 계속되면 관리자에게 문의해주시기 바랍니다.', 'error');
				} else {
					console.error(error);
				}
			}
		})
	}
	
	// 인원 추가 모달 불러오기, 추가 버튼 이벤트
	function projectMemberAddButtonEvent(){
		const projectNumber = currModal.querySelector('input[type="hidden"][name="projectNumber"]').value;
		const projectStartDate = currModal.querySelector('input[type="hidden"][name="projectStartDate"]').value;
		const projectEndDate = currModal.querySelector('input[type="hidden"][name="projectEndDate"]').value;
		const maintEndDate = currModal.querySelector('input[type="hidden"][name="maintEndDate"]').value;
		$.ajax({
			url: '/OJT/project/member/addModal',
			method: 'GET',
			data: {
				projectNumber : projectNumber,
				projectStartDate : projectStartDate,
				projectEndDate : projectEndDate,
				maintEndDate : maintEndDate
			},
			success: function(result){
				$('#modalAddProjectMember').html(result);
			},
			error: function(error){
				console.error(error);
			}
		})
	}
	
	// 날짜 변경 이벤트 추가 함수
	function projectMemberDateChangeAddEvent(){
		const startDates = currModal.querySelectorAll('.startDate');
		const endDates = currModal.querySelectorAll('.endDate');
		
		startDates.forEach(startDate => {
			startDate.addEventListener('focus', projectMemberDateFocusEvent);
			startDate.addEventListener('focusout', projectMemberStartDateFocusoutEvent);
		});
		
		endDates.forEach(endDate => {
			endDate.addEventListener('focus', projectMemberDateFocusEvent);
			endDate.addEventListener('focusout', projectMemberEndDateFocusoutEvent);
		})
	}
	
	// focus 시 기존 날짜 저장
	function projectMemberDateFocusEvent(){
		preDate = this.value;
	}
	
	// 투입일 focusout 시 프로젝트 시작일과 비교
	function projectMemberStartDateFocusoutEvent(){
		
		const row = this.closest('tr');
		const startDate = new Date(this.value);
		const endDate = new Date(row.querySelector('.endDate').value);
		const projectStartDate = new Date(currModal.querySelector('input[type="hidden"][name="projectStartDate"]').value);
		const formattedStartDate = 	projectStartDate.getFullYear() + '-'
								+	String(projectStartDate.getMonth() + 1).padStart(2, '0') + '-'
								+	String(projectStartDate.getDate()).padStart(2, '0');
		
		const projectEnd = currModal.querySelector('input[type="hidden"][name="projectEndDate"]').value;
		const maintEnd = currModal.querySelector('input[type="hidden"][name="maintEndDate"]').value;
		let projectEndDate;
		if(maintEnd != null && maintEnd != ''){// 유지보수 종료일이 비어있지 않다면
			projectEndDate = new Date(maintEnd); 
		} else {
			projectEndDate = new Date(projectEnd);
		}
		const formattedEndDate = 	projectEndDate.getFullYear() + '-'
								+	String(projectEndDate.getMonth() + 1).padStart(2, '0') + '-'
								+	String(projectEndDate.getDate()).padStart(2, '0');
		
		
		if(projectStartDate > startDate){ // 프로젝트 시작일보다 작은지?
				
			projectMemberDateAlert({html: '<html><p>투입일은 프로젝트 시작일보다 작을수 없습니다.</p><p>프로젝트 시작일 : ' + formattedStartDate +'</p></html>'});
			this.value = preDate == '' ? formattedStartDate : preDate;
			
		} else if(projectEndDate < startDate){ // 프로젝트 종료일 보다 큰지?
			
			projectMemberDateAlert({html : '<p>투입일은 프로젝트 종료일보다 클수 없습니다.</p><p>프로젝트 종료일 : ' + formattedEndDate + '</p>'});
			this.value = preDate == '' ? formattedEndDate : preDate;
			
		} else if(startDate > endDate){ // 투입일 보다 큰지?
			
			projectMemberDateAlert({text : '투입일은 철수일보다 클수 없습니다.'});
			this.value = preDate;
			
		}
	}

	
	// 철수일 focusout 시 프로젝트 종료일과 비교
	function projectMemberEndDateFocusoutEvent(){
		
		const row = this.closest('tr');
		const startDate = new Date(row.querySelector('.startDate').value);
		const endDate = new Date(this.value);
		const projectStartDate = new Date(currModal.querySelector('input[type="hidden"][name="projectStartDate"]').value);
		const formattedStartDate = 	projectStartDate.getFullYear() + '-'
								+	String(projectStartDate.getMonth() + 1).padStart(2, '0') + '-'
								+	String(projectStartDate.getDate()).padStart(2, '0');
		
		const projectEnd = currModal.querySelector('input[type="hidden"][name="projectEndDate"]').value;
		const maintEnd = currModal.querySelector('input[type="hidden"][name="maintEndDate"]').value;
		let projectEndDate;
		if(maintEnd != null && maintEnd != ''){ // 유지보수 종료일이 비어있지 않다면
			projectEndDate = new Date(maintEnd); 
		} else {
			projectEndDate = new Date(projectEnd);
		}
		const formattedEndDate = 	projectEndDate.getFullYear() + '-'
								+	String(projectEndDate.getMonth() + 1).padStart(2, '0') + '-'
								+	String(projectEndDate.getDate()).padStart(2, '0');
		
		if(projectStartDate > endDate){
			
			projectMemberDateAlert({html: '<p>철수일은 프로젝트 시작일보다 작을수 없습니다.</p><p>프로젝트 시작일 : ' + formattedStartDate + '</p>'});
			this.value = preDate == '' ? formattedStartDate : preDate;
			
		} else if(projectEndDate < endDate){
			
			projectMemberDateAlert({html : '<p>철수일은 프로젝트 종료일보다 클수 없습니다.</p><p>프로젝트 종료일 : ' + formattedEndDate +'</p>'});
			this.value = preDate == '' ? formattedEndDate : preDate;
			
		} else if(startDate > endDate){
			
			projectMemberDateAlert({text: '철수일은 투입일보다 작을수 없습니다.'});
			this.value = preDate;
		}
	}
	
	// input select change 이벤트 주입
	function projectMemberInputChangeEvent(){
		// input[type="date"]와 select중 name이 .roleCode로 끝나는 것을 모두 선택
		const input = currModal.querySelectorAll('input[type="date"], select[name$=".roleCode"]');
		
		input.forEach(i => {
			i.addEventListener('change', function(){
				
				const row = i.closest('tr'); // 해당하는 input select의 가장 가까운 부모를 가져옴
				const startDate = row.querySelector('input[name$=".startDate"]');
				const endDate = row.querySelector('input[name$=".endDate"]');
				const roleCode = row.querySelector('select[name$=".roleCode"]');
				const checkbox = row.querySelector('input[type="checkbox"]');
				
				// 각 input select에 있는 data-value의 값을 가져옴
				const startDateValue = startDate.dataset.value ?? '';
				const endDateValue = endDate.dataset.value ?? '';
				const roleCodeValue = roleCode.dataset.value ?? '';
				
				if(	startDateValue !== startDate.value || endDateValue !== endDate.value || roleCodeValue !== roleCode.value){
					
					if(!checkbox.checked){
						checkbox.click();
					}
					
				} else {
					
					if(checkbox.checked){
						checkbox.click();
					}
					
				}
			});
		});
	}
	
	// 체크 박스 변경 이벤트, 체크박스 해제시 초기 값으로
	function projectMemberCheckboxChangeEvent(){
		if(!this.checked){
			const row = this.closest('tr');
			const startDate = row.querySelector('input[name$=".startDate"]');
			const endDate = row.querySelector('input[name$=".endDate"]');
			const select = row.querySelector('select[name$=".roleCode"]');
			
			startDate.value = startDate.dataset.value ?? '';
			endDate.value = endDate.dataset.value ?? '';
			select.value = select.dataset.value ?? '';
		}
	}
	
	// 체크 박스 전체 변경 이벤트, 모든 값 초기화
	function projectMemberAllCheckboxChangeEvent(){
		if(!this.checked){
			const tbody = currModal.querySelector('tbody');
			const rows = tbody.rows;
			
			Array.from(rows).forEach(row => {
				const startDate = row.querySelector('input[name$=".startDate"]');
				const endDate = row.querySelector('input[name$=".endDate"]');
				const select = row.querySelector('select[name$=".roleCode"]');
				
				startDate.value = startDate.dataset.value ?? '';
				endDate.value = endDate.dataset.value ?? '';
				select.value = select.dataset.value ?? '';
			})
		}
	}
	
	// submit 이벤트
	function projectMemberModifySubmitEvent(event){
		event.preventDefault(); // 기본 이벤트 차단
		
		const form = this;
		
		const checkboxs = form.querySelectorAll('input[type="checkbox"].check');
		let count = 0;
		// 반복문을 통해 체크된 인원이 있을 때 count 증가
		checkboxs.forEach(checkbox => {
			if(checkbox.checked){
				count++;
			}
		});
		
		if(count == 0 ){ // count == 0 은 변경할 인원이 없는 것
			Swal.fire({
				icon: 'info',
				title: '변경될 인원이 없습니다.',
				toast: true,
				showConfirmButton: false,
				timer: 2500,
				timerProgressBar: true
			});
			return;
		}
		
		const formData = new FormData(form);
		
		$.ajax({
			url: '/OJT/project/member/modify',
			method: 'POST',
			contentType: false,
			processData: false,
			data: formData,
			success: function(result){
				$(modalStack.pop()).html(result);
			},
			error: function(error){
				Swal.fire({
					icon: 'error',
					title: '실패',
					text: '등록에 실패하였습니다. 문제가 계속 될시 관리자에게 문의 바랍니다.'
				});
				console.error(error);
			}
		});
	}
	
	function startUpProjectMember(){
		const success = `${success}`;
		if(success == 'true'){
			Swal.fire('성공', '업데이트에 성공하였습니다.', 'success');
		} else if(success == 'false'){
			const code = `${code}`;
			if(code == 400){
				const errorMessages = currModal.querySelectorAll('span[id$=".errors"]');
				let errorMessageHtml = '';
				
				errorMessages.forEach(message => {
					errorMessageHtml += '<p>' + message.innerText + '</p>'
				});
				
				Swal.fire({
					icon: 'error',
					title: '실패',
					html: errorMessageHtml
				});
			} else if (code == 500){
				Swal.fire('실패', '업데이트에 실패하였습니다. 문제가 계속될 경우 관리자에게 문의해주세요. CODE : 500', 'error');
			}
			
		}
		
		// 각 input select중 하나라도 dataset.value와 값이 다르면 체크
		const inputs = currModal.querySelectorAll('form#modifyProjectBean input[type="date"], form#modifyProjectBean select');
		Array.from(inputs).forEach(input => {
			const value = input.dataset.value ?? '';
			
			if(value != input.value){
				const row = input.closest('tr');
				const checkbox = row.cells[0].querySelector('input[type="checkbox"]');
				checkbox.checked = true;
			}
		});
	}
</script>
</html>