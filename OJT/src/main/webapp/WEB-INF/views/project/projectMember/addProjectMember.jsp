<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
	.modal table td {
		text-align: center;
	}
	
	table thead tr:nth-child(2) td {
		padding: 5px 5px;
	}
	
	#projectMemberDateAllChangeButton{
		padding-right: 7px;
		padding-left: 7px;
	}
</style>
</head>
<body>
	<div class="modal-background">
		<div class="modal">
			<header>
				<div class="w-30">
					<!-- 공백 -->	
				</div>
				<div class="w-40 text-center">
					인원 등록
				</div>
				<div class="w-30 text-right">
					<button type="button" class="closeBtn" id="addProjectMemberClose">
						<img src="${root}resources/images/x.png" alt="닫기" />
					</button>
				</div>
			</header>
			<section>
				<form id="addProjectMemberSearch">
					<div class="flex">
						<div>사원명</div>
						<div>
							<input type="text" name="memberName"/>
						</div>
						<div>
							<button type="button" id="asdasd">조회</button>
						</div>
					</div>
				</form>
			</section>
			<section>
				<div id="scrollDiv" data-scroll="9">
					<input type="hidden" name="projectNumber" value="${ projectNumber }"/>
					<input type="hidden" name="projectStartDate" value="${ projectStartDate }" />
					<input type="hidden" name="projectEndDate" value="${ projectEndDate }" />
					<input type="hidden" name="maintEndDate" value="${ maintEndDate }"/>
					<table>
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
								<td scope="col"><input type="checkbox" class="allCheck"/></td>
								<td scope="col">사원 번호</td>
								<td>사원명</td>
								<td>부서</td>
								<td>직급</td>
								<td>투입일</td>
								<td>철수일</td>
								<td>역할</td>
							</tr>
<!-- 							<tr> -->
<!-- 								<td></td> -->
<!-- 								<td></td> -->
<!-- 								<td></td> -->
<!-- 								<td></td> -->
<!-- 								<td></td> -->
<!-- 								<td> -->
<%-- 									<input type="date" id="allStartDate" min="${ projectStartDate }" max="${ projectEndDate }" value="${ projectStartDate }"/> --%>
<!-- 								</td> -->
<!-- 								<td> -->
<%-- 									<input type="date" id="allEndDate" min="${ projectStartDate }" max="${ projectEndDate }" value="${ projectEndDate }"/> --%>
<!-- 								</td> -->
<!-- 								<td> -->
<!-- 									<button type="button" id="projectMemberDateAllChangeButton" class="btn">모두 적용</button> -->
<!-- 								</td> -->
<!-- 							</tr> -->
						</thead>
						<tbody>
							
						</tbody>
					</table>
				</div>
			</section>
			<section class="text-center">
				<button type="button" class="btn btn-green" id="addProjectMemberButton">저장</button>
				<button type="button" class="btn btn-orange" id="addProjectMemberCancleButton">취소</button>
			</section>
		</div>
	</div>
</body>
<script>
	modalStack.push('#modalAddProjectMember');
	currModal = getCurrModalDom();
	currModal.querySelector('#addProjectMemberClose').addEventListener('click', closeEvent); // 닫기 버튼 이벤트
	currModal.querySelector('#addProjectMemberCancleButton').addEventListener('click', closeEvent); // 취소 버튼 이벤트
	currModal.querySelector('#addProjectMemberSearch').addEventListener('submit', addProjectMemberSearchEvent); // 조회 이벤트
	currModal.querySelector('#addProjectMemberButton').addEventListener('click', addProjectMemberButtonEvent); //저장 버튼 이벤트
// 	currModal.querySelector('#allStartDate').addEventListener('focus', projectMemberDateFocusEvent);
// 	currModal.querySelector('#allStartDate').addEventListener('focusout', projectMemberStartDateFocusoutEvent);
// 	currModal.querySelector('#allEndDate').addEventListener('focus', projectMemberDateFocusEvent);
// 	currModal.querySelector('#allEndDate').addEventListener('focusout', projectMemberEndDateFocusoutEvent);
	
	
	/* 함수 실행 */
	currModal.querySelector('#addProjectMemberSearch').dispatchEvent(new Event('submit')); // 로딩 후 실행
	
	// 닫기 이벤트
	function closeEvent(){
		$(modalStack.pop()).html('');
		currModal = getCurrModalDom();
	}
	
	// 조회 이벤트
	function addProjectMemberSearchEvent(event){
		event.preventDefault(); // 기본이벤트 비활성화
		
		const memberName = currModal.querySelector('input[type="text"][name="memberName"]').value;
		const projectNumber = currModal.querySelector('input[type="hidden"][name="projectNumber"]').value;
		const projectStartDate = currModal.querySelector('input[type="hidden"][name="projectStartDate"]').value;
		const projectEndDate = currModal.querySelector('input[type="hidden"][name="projectEndDate"]').value;
		const maintEndDate = currModal.querySelector('input[type="hidden"][name="maintEndDate"]').value;
		
		let endDate;
	
		if(maintEndDate != ''){
			endDate = maintEndDate;
		} else {
			endDate = projectEndDate;
		}
		
		$.ajax({
			url: '/OJT/projectMember/addProjectMemberSearch',
			method: 'POST',
			traditional: true,
			data: {
				'memberName' : memberName,
				'projectNumber' : projectNumber,
				'startDate' : projectStartDate,
				'endDate' : endDate
			},
			success: function(result){
				currModal.querySelector('tbody').innerHTML = result;
				isScroll();
				checkEvent();
				projectMemberAddEventFunction();
			}
		})
	}
	
	// 투입일, 철수일, 역할 변경 이벤트 추가
	function projectMemberAddEventFunction(){
		const startDates = currModal.querySelectorAll('.startDate');
		const endDates = currModal.querySelectorAll('.endDate');
		const roles = currModal.querySelectorAll('.role');
		
		startDates.forEach(startDate => {
			startDate.addEventListener('change', projectMemberChangeEvent);
			startDate.addEventListener('focus', projectMemberDateFocusEvent);
			startDate.addEventListener('focusout', projectMemberStartDateFocusoutEvent);
		});
		
		endDates.forEach(endDate => {
			endDate.addEventListener('change', projectMemberChangeEvent);
			endDate.addEventListener('focus', projectMemberDateFocusEvent);
			endDate.addEventListener('focusout', projectMemberEndDateFocusoutEvent);
		});
		
		roles.forEach(role => {
			role.addEventListener('change', projectMemberChangeEvent);
		});
	}
	
	// 변경시 체크 이벤트
	function projectMemberChangeEvent(){
		const row = this.closest('tr');
		const checkbox = row.querySelector('input[type="checkbox"].check');
		if(!checkbox.checked){
			checkbox.checked = true;
		}
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
				
			projectMemberDateAlert({html : '<p>투입일은 프로젝트 시작일보다 작을수 없습니다.</p><p>프로젝트 시작일 : ' + formattedStartDate +'</p>'});
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
		if(maintEnd != null && maintEnd != ''){// 유지보수 종료일이 비어있지 않다면
			projectEndDate = new Date(maintEnd); 
		} else {
			projectEndDate = new Date(projectEnd);
		}
		const formattedEndDate = 	projectEndDate.getFullYear() + '-'
								+	String(projectEndDate.getMonth() + 1).padStart(2, '0') + '-'
								+	String(projectEndDate.getDate()).padStart(2, '0');
		
		if(projectStartDate > endDate){
			
			projectMemberDateAlert({html : '<p>철수일은 프로젝트 시작일보다 작을수 없습니다.</p><p>프로젝트 시작일 : ' + formattedStartDate + '</p>'});
			this.value = preDate == '' ? formattedStartDate : preDate;
			
		} else if(projectEndDate < endDate){
			
			projectMemberDateAlert({html : '<p>철수일은 프로젝트 종료일보다 클수 없습니다.</p><p>프로젝트 종료일 : ' + formattedEndDate +'</p>'});
			this.value = preDate == '' ? formattedEndDate : preDate;
			
		} else if(startDate > endDate){
			
			projectMemberDateAlert({text : '철수일은 투입일보다 작을수 없습니다.'});
			this.value = preDate;
		}
	}
	
	// 저장 버튼
	function addProjectMemberButtonEvent(){
		
		const projectNumber = currModal.querySelector('input[type="hidden"][name="projectNumber"]').value;
		const projectStartDate = currModal.querySelector('input[type="hidden"][name="projectStartDate"]').value;
		const projectEndDate = currModal.querySelector('input[type="hidden"][name="projectEndDate"]').value;
		const maintEndDate = currModal.querySelector('input[type="hidden"][name="maintEndDate"]').value;
		
		const rows = currModal.querySelector('tbody').rows;
		const datePattern = /^[0-9]{4}\-(0[1-9]|1[0-2])\-(0[1-9]|[12][0-9]|3[01])$/;
		let errors = [];
		let pmList = [];
		
		for(let i = 0; i < rows.length; i++){
			const row = rows[i];
			if(row.querySelector('input[type="checkbox"].check').checked && errors.length == 0){
				
				/* 데이터 추출 */
				const memberNumber = row.cells[1].innerText;
				const startDate = row.querySelector('.startDate').value;
				const endDate = row.querySelector('.endDate').value;
				const roleCode = row.querySelector('.role').value;
				
				/* 유효성 검사 */
				if(memberNumber === undefined || memberNumber == ''){
					errors.push('사원번호는 비어있을수 없습니다');
				}
				if(startDate !== undefined && startDate != ''){
					if(!datePattern.test(startDate)){
						errors.push('투입일이 날짜 형식이 아닙니다.');
					}
				} 
				
				if(endDate !== undefined && endDate != ''){
					if(!datePattern.test(endDate)){
						errors.push('철수일이 날짜 형식이 아닙니다.');
					}
				} 
				
				if(roleCode === undefined || roleCode == ''){
					errors.push('역할은 비어있을수 없습니다.')
				}
				
				if(errors.length != 0){
					errorMessage = '';
					for(let error = 0; error < errors.length; error++){
						errorMessage += errors[error] + '\n';
					}
					alert(errorMessage);
					return;
				}
				
				/* 데이터 저장 */
				pmList.push({
					projectNumber : projectNumber,
					memberNumber : memberNumber,
					startDate : startDate,
					endDate : endDate,
					roleCode : roleCode
				});
			}
		}
		
		// 선택된 멤버가 없다면 alert후 메서드 종료
		if(pmList.length == 0){
			alert('추가할 인원이 없습니다.');
			return;
		}
		
		$.ajax({
			url: '/OJT/projectRest/addProjectMember',
			method: 'POST',
			contentType: 'application/json',
			data: JSON.stringify({
				projectNumber: projectNumber,
				projectStartDate : projectStartDate,
				projectEndDate : projectEndDate,
				maintEndDate : maintEndDate,
				pmList : pmList
			}),
			success: function(result){
				if(result.result == true){
					alert('등록에 성공하였습니다.');
					reloadProjectMember(projectNumber);
					$(modalStack.pop()).html('');
					currModal = getCurrModalDom();
				} else {
					let errorMessage = '';
					for(let i = 0; i < result.errorMessage.length; i++){
						errorMessage += result.errorMessage[i] + "\n";
					}
					
					alert(errorMessage);
				}
			},
			error: function(xhr, status, error){
				if(status == 515){
					alert(error);
				} else {
					console.error(error);
				}
			}
		});
	}
</script>
</html>