<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="${root}resources/lib/javascript/jquery-3.7.1.min.js"></script>
<!-- select2 -->
<link href="${root}resources/lib/style/select2.min.css" rel="stylesheet" />
<script src="${root}resources/lib/javascript/select2.min.js"></script>
<!-- SweetAlert2 -->
<link href="${root}resources/lib/style/sweetalert2.min.css" rel="stylesheet"/>
<script src="${root}resources/lib/javascript/sweetalert2.min.js"></script>
<!-- 외부 css -->
<link rel="stylesheet" href="${root}resources/style/Main.css" />
<style>
	[id$=".errors"][data-show="false"] {
		display: none;
	}
	
	[id$=".errors"][data-show="true"] {
		display: table-row;
	}
	
	header table {
		font-size: 20px;
		margin-bottom: 30px;
	}
	
	header table td {
		border: none;
		text-align: left;
		padding: 5px 10px;
	}
	
	header table tr {
		text-align: left;
	}
</style>
</head>
<body>
	<c:import url="/WEB-INF/views/include/TopMenu.jsp"></c:import>
	
	<header>
		<div class="flex">
			<table class="container-center">
				<tr>
					<th>사원번호</th>
					<td>${ memberNumber }</td>
				</tr>
				<tr>
					<th>사원명</th>
					<td>${ memberName }</td>
				</tr>
			</table>
		</div>
	</header>
	<section>
		<table class="container-center">
			<colgroup>
				<!-- 체크박스 -->
				<col style="width: 100px;"/>
				<!-- 프로젝트 이름 -->
				<col style="width: 100px;"/>
				<!-- 고객사 이름 -->
				<col style="width: 100px;"/>
				<!-- 프로젝트 시작일 -->
				<col style="width: 100px;"/>
				<!-- 프로젝트 종료일 -->
				<col style="width: 100px;"/>
				<!-- 유지보수 시작일 -->
				<col style="width: 100px;"/>
				<!-- 유지보수 종료일 -->
				<col style="width: 100px;"/>
				<!-- 투입일 -->
				<col style="width: 100px;"/>
				<!-- 철수일 -->
				<col style="width: 100px;"/>
				<!-- 역할 -->
				<col style="width: 100px;"/>
			</colgroup>
			<thead>
				<tr>
					<th scope="col"><input type="checkbox" class="allCheck"/></th>
					<th scope="col">프로젝트</th>
					<th scope="col">고객사</th>
					<th scope="col">시작일</th>
					<th scope="col">종료일</th>
					<th scope="col">유지보수 시작일</th>
					<th scope="col">유지보수 종료일</th>
					<th scope="col">투입일</th>
					<th scope="col">철수일</th>
					<th scope="col">역할</th>
				</tr>
			</thead>
			<tbody id="memberProjectList">
				<c:forEach var="item" items="${ memberProjectList }" varStatus="status">
					<c:set var="startDate" value="${ item.projectStartDate }" />
					<c:set var="endDate" value="${ item.projectMaintStartDate != '' ? item.projectMaintEndDate : item.projectEndDate }"/>
					<tr>
						<td>
							<input type="checkbox" data-projectnumber="${ item.projectNumber }" class="check"/>
						</td>
						<td>${ item.projectName }</td>
						<td>${ item.customerName }</td>
						<td>${ item.projectStartDate }</td>
						<td>${ item.projectEndDate }</td>
						<td>${ item.projectMaintStartDate }</td>
						<td>${ item.projectMaintEndDate }</td>
						<c:choose>
							<c:when test="${ ROLE_CREATE_MEMBER == true || ROLE_SUPER == true }">
								<td>
									<input type="date" name="startDate" value="${ item.startDate }" data-value="${ item.startDate }" min="${ startDate }" max="${ endDate }"/>
								</td>
								<td>
									<input type="date" name="endDate" value="${ item.endDate }" data-value="${ item.endDate }" min="${ startDate }" max="${ endDate }"/>
								</td>
								<td>
									<select name="roleCode" data-value="${ item.roleCode }">
										<c:forEach var="role" items="${ roleList }">
											<option value="${ role.detailCode }" ${ role.detailCode == item.roleCode ? 'selected' : '' }>${ role.codeName }</option>
										</c:forEach>
									</select>
								</td>
							</c:when>
							<c:otherwise>
								<td>${ item.startDate }</td>
								<td>${ item.endDate }</td>
								<td>${ item.roleName }</td>
							</c:otherwise>
						</c:choose>
					</tr>
					<tr id="${ status.index }.errors" data-show="false">
						<td colspan="7"></td>
						<td class="errors" colspan="3"></td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<div class="text-right">
			<c:if test="${ ROLE_CREATE_MEMBER == true || ROLE_SUPER == true }">
				<button type="button" class="btn btn-blue" onclick="showAddMemberPeojectModal(event)">추가</button>
				<button type="button" class="btn btn-green" onclick="updateMemberProject(event)">저장</button>
				<button type="button" class="btn btn-red" onclick="deleteMemberProject(event)">삭제</button>
			</c:if>
		</div>
	</section>
	<script src="${root}resources/javascript/Main.js"></script>
	<div id="addMemberProjectModal"></div>
</body>
<script>
modalStack = [];
currModal = getCurrModalDom();

document.querySelectorAll('input[type="date"], select').forEach(input => {			// 투입일, 철수일, 역할 변경 이벤트
	input.addEventListener('change', dataChangedEvent);
});

document.querySelectorAll('input[type="checkbox"].check').forEach( checkbox => {	// 체크박스 클릭 이벤트
	checkbox.addEventListener('click', clickCheckboxEvent);
});

checkEvent(); // 체크박스 이벤트 주입

// 투입일, 종료일, 역할 변경시 이벤트
function dataChangedEvent() {
	const value = this.value;
	const basicValue = this.dataset.value;
	const checkbox = this.closest('tr').cells[0].querySelector('input[type="checkbox"]');
	
	if(value == basicValue && checkbox.checked) {
		checkbox.click();
	} else if(!checkbox.checked){
		checkbox.click();
	}
}

// 체크박스 클릭 이벤트
function clickCheckboxEvent() {
	const row = this.closest('tr');
	const startDate = row.cells[7].querySelector('input');
	const endDate = row.cells[8].querySelector('input');
	const select = row.cells[9].querySelector('select');
	
	if(!this.checked){
		startDate.value = startDate.dataset.value;
		endDate.value = endDate.dataset.value;
		select.value = select.dataset.value;
	}
}

//삭제 버튼 클릭 이벤트
function deleteMemberProject() {
	const tbody = document.getElementById('memberProjectList');
	const rows = tbody.rows;
	
	const memberNumber = `${memberNumber}`;
	let deleteAlertMessage = `
		<table>
			<thead>
				<tr>
					<th style="width: 200px;">프로젝트</th>
					<th style="width: 200px;">고객사</th>
				</tr>
			</thead>
			<tbody>
	`;
	let projectNumbers = [];
	
	Array.from(rows).forEach(row => {
		const checkbox = row.querySelector('input[type="checkbox"]');
		if(checkbox && checkbox.checked){
			projectNumbers.push(checkbox.dataset.projectnumber);
			const projectName = row.cells[1].innerText;
			const customerName = row.cells[2].innerText;
			
			deleteAlertMessage += '<tr><td>' + projectName + '</td><td>' + customerName + '</td></tr>';
		}
	});
	
	deleteAlertMessage += '</tbody></table>';
	
	if(projectNumbers.length == 0) {
		Swal.fire({
			icon: 'info',
			text: '선택된 프로젝트가 없습니다.'
		});
		return;
	}
	
	Swal.fire({
		icon: 'warning',
		title: '삭제하시겠습니까?',
		html: deleteAlertMessage,
		showCancelButton: true,
		confirmButtonText: '삭제',
		cancelButtonText: '취소',
	})
	.then((confirm) => {
		if(confirm.isConfirmed){
			$.ajax({
				url: '/OJT/member/project/delete/' + projectNumbers + '/' + memberNumber,
				method: 'DELETE',
				success: function(result){
					if(result){
						Swal.fire({
							icon: 'success',
							title: '성공',
							text: '삭제에 성공하였습니다.'
						}).then(() => {
							window.location.reload();
						});
					} else {
						Swal.fire('실패', '삭제에 실패하였습니다.', 'error');
					}
				},
				error: function(request, status, error){
					if(request.status == 403) {
						Swal.fire('실패', '접근 권한이 부족합니다.', 'warning');
					} else {
						Swal.fire('실패', '삭제에 실패하였습니다.', 'error');
					}
				}
			});
		} else {
			return;
		}
	});
}

// 추가 버튼 클릭 이벤트
function showAddMemberPeojectModal() {
	$.ajax({
		url: '${root}member/project/addModal/${memberNumber}',
		method: 'GET',
		success: function(result) {
			$('#addMemberProjectModal').html(result);
		},
		error: function(request, status, error) {
			if(request.status == 403) {
				Swal.fire('실패', '접근 권한이 부족합니다.', 'warning');
			} else {
				Swal.fire('실패', '추가에 실패하였습니다.', 'error');
			}
		}
	})
}

// 저장 버튼 클릭 이벤트
function updateMemberProject() {
	const memberNumber = `${memberNumber}`;
	const tbody = document.getElementById('memberProjectList');
	const rows = tbody.rows;
	
	let memberProjects = [];
	
	Array.from(rows).forEach((row, index) => {
		if(index % 2 == 1) {
			row.dataset.show = "false";
		}
		const checkbox = row.querySelector('input[type="checkbox"]');
		if(checkbox && checkbox.checked) {
			
			// 엘리먼트 들
			const startDate = row.querySelector('input[name="startDate"]');
			const endDate = row.querySelector('input[name="endDate"]');
			const roleCode = row.querySelector('select[name="roleCode"]');
			
			// 원래의 값들
			const originStartDate = startDate.dataset.value;
			const originEndDate = endDate.dataset.value;
			const originRoleCode = roleCode.dataset.value;
			
			// 하나라도 다를 경우에만 포함
			if(originStartDate != startDate.value || originEndDate != endDate.value || originRoleCode != roleCode.value){
				memberProjects.push({
					memberNumber: memberNumber,
					projectNumber: checkbox.dataset.projectnumber,
					startDate: startDate.value,
					endDate: endDate.value,
					roleCode: roleCode.value,
					index: index
				});
			}
		}
	})
	
	if(memberProjects.length == 0){
		Swal.fire({
			icon: 'info',
			text: '변경될 프로젝트가 없습니다.'
		});
		return;
	}
	
	$.ajax({
		url: '${root}member/project/update',
		method: 'PUT',
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
					icon: 'error',
					title: '실패',
					text: '저장에 실패하였습니다.'
				});
			}
		},
		error: function(request, status, error){
			if(request.status == 403) {
				Swal.fire('실패', '접근 권한이 부족합니다.', 'warning');
			} else {
				Swal.fire('실패', '저장에 실패하였습니다.', 'error');
			}
		}
	})
}

</script>
</html>