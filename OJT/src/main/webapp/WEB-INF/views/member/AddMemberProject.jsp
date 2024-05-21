<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
	.modal {
		width: 1200px;
	}
	
	.modal section {
		margin-top: 20px;
	}
	
	[id$=".errors"][data-show="false"] {
		display: none;
	}
	
	[id$=".errors"][data-show="true"] {
		display: table-row;
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
					<h2>사원 프로젝트 추가</h2>
				</div>
				<div class="w-30 text-right">
					<button type="button" class="closeBtn" onclick="addMemberProjectClose()">
						<img src="${root}resources/images/x.png" alt="닫기" />
					</button>
				</div>
			</header>
			<section>
				<div id="scrollDiv" data-scroll="8">
					<table class="container-center">
						<colgroup>
							<col style="width: 40px"/>
							<col style="width: 200px"/>
							<col style="width: 150px"/>
							<col style="width: 100px"/>
							<col style="width: 100px"/>
							<col style="width: 100px"/>
							<col style="width: 100px"/>
							<col style="width: 131px"/>
							<col style="width: 131px"/>
							<col style="width: 100px"/>
						</colgroup>
						<thead>
							<tr>
								<th scope="col"><input type="checkbox" class="allCheck" /></th>
								<th scope="col">프로젝트</th>
								<th scope="col">고객사</th>
								<th scope="col">시작일</th>
								<th scope="col">종료일</th>
								<th scope="col">유지보수<br />시작일</th>
								<th scope="col">유지보수<br />종료일</th>
								<th scope="col">투입일</th>
								<th scope="col">철수일</th>
								<th scope="col">역할</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="item" items="${ projectList }" varStatus="status">
								<c:set var="startDate" value="${ item.projectStartDate }" />
								<c:set var="endDate" value="${ item.projectMaintStartDate != '' ? item.projectMaintEndDate : item.projectEndDate }"/>
								<tr>
									<td><input type="checkbox" class="check" data-projectnumber="${ item.projectNumber }"/></td>
									<td class="text-left">${ item.projectName }</td>
									<td class="text-left">${ item.customerName }</td>
									<td>${ item.projectStartDate }</td>
									<td>${ item.projectEndDate }</td>
									<td>${ item.projectMaintStartDate }</td>
									<td>${ item.projectMaintEndDate }</td>
									<td>
										<input type="date" name="startDate" value="${ item.startDate }" min="${ startDate }" max="${ endDate }"/>
									</td>
									<td>
										<input type="date" name="endDate" value="${ item.endDate }" min="${ startDate }" max="${ endDate }"/>
									</td>
									<td>
										<select name="roleCode">
											<c:forEach var="role" items="${ roleList }">
												<option value="${ role.detailCode }" ${ role.detailCode == item.roleCode ? 'selected' : '' }>${ role.codeName }</option>
											</c:forEach>
										</select>
									</td>
								</tr>
								<tr id="${ status.index }.errors" data-show="false">
									<td colspan="7"></td>
									<td class="errors" colspan="3"></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<div class="container-center text-center" style="width: 1180px; margin-top: 20px;">
					<button type="button" class="btn btn-green" onclick="addMemberProject()">저장</button>
					<button type="button" class="btn btn-orange" onclick="addMemberProjectClose()">취소</button>
				</div>
			</section>
		</div>
	</div>
</body>
<script>
modalStack.push('#addMemberProjectModal');
currModal = getCurrModalDom();
let oldDate;

// currModal.querySelectorAll('input[type="date"]').forEach(date => { // 날짜 포커스, 포커스아웃 이벤트
// 	date.addEventListener('focus', dateFocusEvent);
// 	date.addEventListener('focusout', dateFocusoutEvent);
// });
// currModal.querySelectorAll('input[name="startDate"]').forEach(startDate => { // 투입일 포커스아웃 이벤트
// 	startDate.addEventListener('focusout', startDateFocusoutEvent);
// });
// currModal.querySelectorAll('input[name="endDate"]').forEach(endDate => { // 철수일 포커스아웃 이벤트
// 	endDate.addEventListener('focusout', endDateFocusoutEvent);
// });
currModal.querySelectorAll('input[name="startDate"], input[name="endDate"], select[name="roleCode"]').forEach(input => { // 투입일, 철수일, 역할 변경 이벤트
	input.addEventListener('change', inputChangeEvent);
});

isScroll(); // 스크롤 추가 펑션
checkEvent(); // 체크 이벤트

// 닫기
function addMemberProjectClose() {
	$(modalStack.pop()).html('');
	currModal = getCurrModalDom();
}

// 날짜 포커스 이벤트
function dateFocusEvent() {
	oldDate = this.value;
}

//날짜 포커스 아웃 이벤트
function dateFocusoutEvent() {
	const startDate = new Date(this.min);
	const endDate = new Date(this.max);
	const date = new Date(this.value);
	
	if(startDate > date) {
		projectMemberDateAlert({
			text: '프로젝트 시작일 보다 작게 설정 할 수 없습니다.'
		});
		this.value = oldDate;
	}
	
	if(endDate < date) {
		projectMemberDateAlert({
			text: '프로젝트(유지보수) 종료일 보다 크게 설정 할 수 없습니다.'
		});
		this.value = oldDate;
	}
}

// 투입일 포커스 아웃 이벤트
function startDateFocusoutEvent() {
	const startDate = new Date(this.value);
	const endDate = new Date(this.closest('tr').querySelector('input[name="endDate"]').value);
	
	if(startDate > endDate) {
		projectMemberDateAlert({
			text: '투입일은 철수일보다 크게 설정할수 없습니다.'
		});
		this.value = oldDate;
	}
}

// 철수일 포커스 아웃 이벤트
function endDateFocusoutEvent() {
	const startDate = new Date(this.closest('tr').querySelector('input[name="startDate"]').value);
	const endDate = new Date(this.value);
	
	if(startDate > endDate) {
		projectMemberDateAlert({
			text: '철수일은 투입일보다 작게 설정할수 없습니다.'
		});
		this.value = oldDate;
	}
}

// 투입일, 철수일, 역할 변경 이벤트
function inputChangeEvent() {
	const row = this.closest('tr');
	const startDate = row.querySelector('input[name="startDate"]').value;
	const endDate = row.querySelector('input[name="endDate"]').value;
	const roleCode = row.querySelector('select[name="roleCode"]').value;
	const checkbox = row.querySelector('input[type="checkbox"]');
	
	if( startDate != '' || endDate != '' || roleCode != 1) {
		if(checkbox.checked === false) {
			checkbox.click();
		}
	} else {
		if(checkbox.checked === true) {
			checkbox.click();
		}
	}
}

// 저장 버튼 이벤트
function addMemberProject() {
	const tbody = currModal.querySelector('tbody');
	const rows = tbody.rows;
	
	let memberProjects = [];
	
	Array.from(rows).forEach((row, index) => {
		
		if(index % 2 == 1) {
			row.dataset.show = "false";
		}
		
		const checkbox = row.querySelector('input[type="checkbox"]');
		if(checkbox && checkbox.checked === true) {
			const projectNumber = checkbox.dataset.projectnumber;
			const startDate = row.querySelector('input[name="startDate"]').value;
			const endDate = row.querySelector('input[name="endDate"]').value;
			const roleCode = row.querySelector('select[name="roleCode"]').value;
			memberProjects.push({
				memberNumber: `${memberNumber}`,
				projectNumber: projectNumber,
				startDate: startDate,
				endDate: endDate,
				roleCode: roleCode,
				index: index
			});
		}
	});
	
	if(memberProjects.length == 0){
		Swal.fire('', '추가될 프로젝트가 없습니다.', 'info');
		return;
	}
	
	$.ajax({
		url: '/OJT/member/project/add',
		method: 'POST',
		contentType: 'application/json',
		data: JSON.stringify(memberProjects),
		success: function(result) {
			const success = result.success;
			const errorMessages = result.errorMessages;
			
			if(success === true) {
				Swal.fire({
					icon: 'success',
					title: '성공',
					text: '저장에 성공하였습니다.'
				}).then(() => {
					addMemberProjectClose();
					window.location.reload();
				})
			} else if(errorMessages) {
				for(let i = 0; i < rows.length; i++) {
					const errorMessage = errorMessages[i];
					if(typeof errorMessage != 'undefined') {
						
						let errorMessageHTML = '';
						
						errorMessage.forEach(error => {
							errorMessageHTML += '<p>' + error + '</p>';
						});
						
						const errorCell = rows[i + 1].querySelector('.errors');
						errorCell.innerHTML = errorMessageHTML;
						rows[i + 1].dataset.show = "true";
						
					}
				}
				
				Swal.fire({
					icon: 'error',
					text: '입력데이터를 확인해주세요.'
				});
			} else {
				Swal.fire({
					icon: "error",
					title: '실패',
					text: '저장에 실패하였습니다.'
				});
			}
		},
		error: function(request, status, error) {
			if(request.status == 403) {
				Swal.fire('실패', '접근 권한이 부족합니다.', 'warning');
			} else {
				Swal.fire('실패', '서버와의 통신에 실패하였습니다.', 'error');
			}
		}
	})
}
</script>
</html>