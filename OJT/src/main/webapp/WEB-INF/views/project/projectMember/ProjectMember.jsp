<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${root}resources/style/Main.css" />
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
				<form:form modelAttribute="projectBean" method="POST" action="#">
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
									<c:forEach var="item" items="${ projectBean.pmList }" varStatus="status">
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
													min="${ projectBean.projectStartDate }" max="${ projectBean.maintEndDate != '' ? projectBean.maintEndDate : projectBean.projectStartDate }"/>
											</td>
											<td>
												<form:input type="date" path="pmList[${status.index}].endDate" class="endDate"
													data-value="${ projectBean.pmList[status.index].endDate }"
													min="${ projectBean.projectStartDate }" max="${ projectBean.maintEndDate != '' ? projectBean.maintEndDate : projectBean.projectStartDate }"/>
											</td>
											<td>
												<form:select path="pmList[${status.index}].roleCode" data-value="${ projectBean.pmList[status.index].roleCode }">
													<c:forEach var="role" items="${ roleList }">
														<form:option value="${ role.detailCode }">${ role.codeName }</form:option>
													</c:forEach>
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
	currModal.querySelector('.allCheck').addEventListener('change', projectMemberAllCheckboxChangeEvent);
	
	projectMemberDateChangeAddEvent(); // 멤버 날짜 변경 이벤트 추가 펑션
	isScroll(); // 프로젝트 멤버 리스트 스크롤
	checkEvent(); // checkbox 이벤트
	projectMemberInputChangeEvent(); // 멤버 정보 변경시 이벤트
	
	/*             */
	/* 이벤트 펑션 들 */
	/*             */
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
			alert('선택된 인원이 없습니다.');
			return;
		}
		
		let confirmMessage = '';// 확인을 위한 메시지 작성
		
		for(let i = 0; i < memberNumbers.length; i++){
			const memberName = rows[memberNumbers[i]].cells[2].querySelector('input').value;
			const department = rows[memberNumbers[i]].cells[3].querySelector('input').value;
			const position = rows[memberNumbers[i]].cells[4].querySelector('input').value;
			
			confirmMessage += memberName + '\t' + department + '\t' + position + '\n';
		}
		
		let confirmResult = confirm(confirmMessage + '삭제 하시겠습니까?');// 결과 저장
		if(confirmResult){
			$.ajax({
				url: '/OJT/projectRest/deleteProjectMember',
				method: 'POST',
				traditional: true,
				data: {
					'memberNumbers' : memberNumbers,
					'projectNumber' : projectNumber
				},
				success: function(result){
					alert('삭제에 성공하였습니다.');
					reloadProjectMember(projectNumber); //삭제후 모달 재생성
				},
				error: function(error){
					console.error(error);
				}
			})
		} else {
			alert('취소 되었습니다.');
		}
	}// 삭제 버튼 끝
	
	// 모달 새로 불러오기
	function reloadProjectMember(projectNumber){
		$.ajax({
			url: '/OJT/project/projectMember',
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
					alert('인원을 다시한번 확인해주시기 바랍니다.');
				} else if(xhr.status === 500 && error === false){
					alert('삭제에 실패하였습니다.\n문제가 계속되면 관리자에게 문의해주시기 바랍니다.');
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
			url: '/OJT/projectMember/modalAddProjectMember',
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
			startDate.addEventListener('change', projectMemberStartDateChangeEvent);
		});
		
		endDates.forEach(endDate => {
			endDate.addEventListener('change', projectMemberEndDateChangeEvent);
		})
	}
	
	// 투입일 변경 이벤트
	function projectMemberStartDateChangeEvent(){
		const row = this.closest('tr');
		const endDate = row.querySelector('input[name$=".endDate"]');
		
		endDate.min = this.value;
	}
	
	// 철수일 변경 이벤트
	function projectMemberEndDateChangeEvent(){
		const row = this.closest('tr');
		const startDate = row.querySelector('input[name$=".startDate"]');
		
		startDate.max = this.value;
	}
	
	// input select change 이벤트 주입
	function projectMemberInputChangeEvent(){
		// input[type="date"]와 select중 name이 .roleCode로 끝나는 것을 모두 선택
		const input = currModal.querySelectorAll('input[type="date"], select[name$=".roleCode"]');
		
		input.forEach(i => {
			i.addEventListener('change', function(){
				const row = i.closest('tr');
				const checkbox = row.querySelector('input[type="checkbox"]');
				if(!checkbox.checked){
					checkbox.click();
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
			
			startDate.value = startDate.dataset.value;
			endDate.value = endDate.dataset.value;
			select.value = select.dataset.value;
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
				
				startDate.value = startDate.dataset.value;
				endDate.value = endDate.dataset.value;
				select.value = select.dataset.value;
			})
		}
	}
</script>
</html>