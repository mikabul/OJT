<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>프로젝트 등록 - 멤버 추가</title>
<style>
.modal section {
	margin-top: 20px;
}

.modal section div {
	display: flex;
	align-items: center;
}

.modal section div * {
	margin: 0 4px;
}

.modal article div {
	margin-top: 20px;
}

.modal #search {
	width: 300px;
}
</style>
</head>
<body>
	<div class="modal-background">
		<div class="modal">
			<header>
				<div class="w-20">
					<!-- 공백 -->
				</div>
				<div class="text-center w-60">
					<h3>프로젝트 등록 - 멤버 추가</h3>
				</div>
				<div class="text-right w-20">
					<button type="button" class="closeBtn" id="addProjectMemberClose">
						<img src="${root}resources/images/x.png" alt="" />
					</button>
				</div>
			</header>
			<section>
				<div>
					<div class="container-center">
						<label for="search">사원명</label>
						<input type="search" name="search" id="search"/>
						<button type="button" id="searchBtn" class="btn btn-green">조회</button>
					</div>
				</div>
			</section>
			<article>
				<div id="scrollDiv" data-scroll="11">
					<table class="container-center">
						<colgroup>
							<!-- checkbox -->
							<col style="width: 30px;"/>
							<!-- 사원 번호 -->
							<col style="width: 40px;"/>
							<!-- 사원명 -->
							<col style="width: 120px;"/>
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
								<th scope="col">번호</th>
								<th scope="col">이름</th>
								<th scope="col">부서</th>
								<th scope="col">직급</th>
								<th scope="col">투입일</th>
								<th scope="col">철수일</th>
								<th scope="col">역할</th>
							</tr>
						</thead>
						<tbody id="memberList">
							
						</tbody>
					</table>
				</div>
				<div class="text-center">
					<button type="button" class="btn btn-green" id="addPMBtn">추가</button>
					<button type="button" class="btn btn-orange" id="cancelAddPMBtn">취소</button>
				</div>
			</article>
		</div><!-- 모달 끝 -->
	</div>
</body>
<script>
modalStack.push('#modalAddProjectMember');
currModal = getCurrModalDom();

document.getElementById('addProjectMemberClose').addEventListener('click', addProjectMemberCloseEvent);	// 닫기 버튼 이벤트
document.getElementById('cancelAddPMBtn').addEventListener('click', addProjectMemberCloseEvent);		// 취소 버튼 이벤트
document.getElementById('searchBtn').addEventListener('click', searchMember);							// 검색 버튼 이벤트
document.getElementById('addPMBtn').addEventListener('click', addPMBtnEvent);							// 저장 버튼 이벤트

searchMember();	// 처음 진입시 검색 실행

// 프로젝트 멤버 추가 모달 닫기 이벤트
function addProjectMemberCloseEvent(){
	$(modalStack.pop()).html('');
	currModal = getCurrModalDom();
}

//검색 조건을 가져와 getNotAddProjectMember 호출
function searchMember(){
	
	const search = currModal.querySelector('#search').value;
	const inputs = document.querySelectorAll('#pmListBody input[name$=".memberNumber"]');
	const memberNumbers = [];
	const startDate = `${startDate}`;
	const endDate = `${endDate}`;
	
	inputs.forEach( input => {
		memberNumbers.push(input.value);
	});
	
	$.ajax({
		url: '/OJT/project/add/not-project-member',
		method: 'GET',
		traditional: true,
		data: {
			'search': search,
			'memberNumbers': memberNumbers,
			'startDate': startDate,
			'endDate': endDate
		},
		success: function(result){
			$('#memberList').html(result);
			isScroll(); // 스크롤 추가
			checkEvent(); // 체크박스 이벤트 추가
			addPMDateEvent(); // 날짜 이벤트 추가
			addPMInputChangeEvent(); //변경시 체크 이벤트 추가
		},
		error: function(request, status, error){
			if(request.status == 403) {
				Swal.fire('실패', '접근 권한이 부족합니다.', 'warning');
			} else {
				Swal.fire('실패', '조회에 실패하였습니다.', 'error');
			}
		}
	});
}

//저장 버튼 이벤트
function addPMBtnEvent(){
	
	const addPMRows = currModal.querySelector('#memberList').rows; // 테이블의 row들을 저장
	const startDate = `${startDate}`;
	const endDate = `${endDate}`;
	
	let addPMList = []; // 추가할 맴버의 정보를 담는 변수
	
	Array.from(addPMRows).forEach(row => {
		const checkbox = row.cells[0].querySelector('input[type="checkbox"]');
		if(checkbox != null && checkbox.checked){
			const cell = row.cells;
			addPMList.push({
				memberNumber: cell[1].innerHTML,
				memberName: cell[2].innerHTML,
				department: cell[3].innerHTML,
				position: cell[4].innerHTML,
				startDate: cell[5].querySelector('input').value,
				endDate: cell[6].querySelector('input').value,
				roleCode: cell[7].querySelector('select').value
			});
		}
	})
	
	if(addPMList.length == 0){// 선택된 멤버가 있는지?
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
	
	const pmListBody = document.getElementById('pmListBody');
	let rowsLength; // pmListBodyRows의 크기를 담을 변수
	
	if(pmListBody.rows[0].cells.length == 1){
		rowsLength = 0;
	} else {
		rowsLength = pmListBody.rows.length;
	}
	
	$.ajax({
		url: '/OJT/project/add/member-table',
		method: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			'addPMList': addPMList,
			'rowsLength': rowsLength,
			'startDate': startDate,
			'endDate': endDate
		}),
		success: function(result){
			
			const pmListBody = document.getElementById('pmListBody');
			if(pmListBody.rows[0].cells.length == 1){
				pmListBody.innerHTML = result;
			} else {
				pmListBody.innerHTML += result;
			}
			
			$(modalStack.pop()).html(''); // 창 닫기
			currModal = getCurrModalDom();
			//스크롤
			isScroll();
			pmDateEvent(); // 프로젝트 멤버 날짜 이벤트 추가
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

// 프로젝트 멤버 추가 날짜 이벤트 추가
function addPMDateEvent(){
	currModal.querySelectorAll('.startDate').forEach(startDate => {
		startDate.removeEventListener('focus', addPMDateFocusEvent);
		startDate.removeEventListener('focusout', addPMStartDateFocusoutEvent);
		startDate.addEventListener('focus', addPMDateFocusEvent);
		startDate.addEventListener('focusout', addPMStartDateFocusoutEvent);
	});
	
	currModal.querySelectorAll('.endDate').forEach(endDate => {
		endDate.removeEventListener('focus', addPMDateFocusEvent);
		endDate.removeEventListener('focusout', addPMEndDateFouceoutEvent);
		endDate.addEventListener('focus', addPMDateFocusEvent);
		endDate.addEventListener('focusout', addPMEndDateFouceoutEvent);
	});	
}

// 프로젝트 멤버 추가 날짜 포커스 이벤트
function addPMDateFocusEvent(){
	preDate = this.value;
}
 
// 프로젝트 멤버 추가 시작일 포커스 아웃 이벤트
function addPMStartDateFocusoutEvent(){
	const startDate = `${startDate}`;
	const endDate = `${endDate}`;
	
	const startDateLocal = new Date(startDate);
	const endDateLocal = new Date(endDate);
	const memberStartDate = new Date(this.value);
	
	if(memberStartDate < startDateLocal){
		projectMemberDateAlert({html : '<p>투입일은 프로젝트 시작일보다 이전일수 없습니다.</p><p>프로젝트 시작일 : ${startDate}'});
		if(preDate != ''){
			this.value = preDate;
		} else {
			this.value = startDate;
		}
	} else if(memberStartDate > endDateLocal){
		projectMemberDateAlert({html : '<p>투입일은 프로젝트(유지보수) 종료일보다 이후일수 없습니다.</p><p>프로젝트(유지보수) 종료일 : ${endDate}'});
		if(preDate != ''){
			this.value = preDate;
		} else {
			this.value = startDate;
		}
	}
}

//프로젝트 멤버 추가 종료일 포커스 아웃 이벤트
function addPMEndDateFouceoutEvent(){
	const startDate = `${startDate}`;
	const endDate = `${endDate}`;
	
	const startDateLocal = new Date(startDate);
	const endDateLocal = new Date(endDate);
	const memberEndDate = new Date(this.value);
	
	if(memberEndDate < startDateLocal){
		projectMemberDateAlert({html : '<p>철수일은 프로젝트 시작일보다 이전일수 없습니다.</p><p>프로젝트 시작일 : ${startDate}'});
		if(preDate != ''){
			this.value = preDate;
		} else {
			this.value = endDate;
		}
	} else if(memberEndDate > endDateLocal){
		projectMemberDateAlert({html : '<p>철수일은 프로젝트(유지보수) 종료일보다 이후일수 없습니다.</p><p>프로젝트(유지보수) 종료일 : ${endDate}'});
		if(preDate != ''){
			this.value = preDate;
		} else {
			this.value = endDate;
		}
	}
}

// 프로젝트 멤버 추가 input, select 변경이벤트
function addPMInputChangeEvent(){
	currModal.querySelectorAll('input[type="date"], select[name="role"]').forEach(input => {
		input.addEventListener('change', function(){
			const row = this.closest('tr');
			const checkbox = row.cells[0].querySelector('input[type="checkbox"]');
			if(!checkbox.checked){
				checkbox.click();
			}
		});
	});
}
</script>
</html>