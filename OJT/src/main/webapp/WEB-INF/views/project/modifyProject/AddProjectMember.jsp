<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>프로젝트 멤버 추가</title>
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

.valid-error {
	background-color: #ffcccc;
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
					프로젝트 인원 등록
				</div>
				<div class="w-30 text-right">
					<button type="button" class="closeBtn" id="addProjectMemberClose">
						<img src="${root}resources/images/x.png" alt="닫기" />
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
				<div id="scrollDiv" data-scroll="10">
					<table class="container-center">
						<colgroup>
							<!-- checkbox -->
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
								<th scope="col">사원번호</th>
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
					<button type="button" class="btn btn-green" id="addProjectMemberButton">추가</button>
					<button type="button" class="btn btn-orange" id="cancelAddPMBtn">취소</button>
				</div>
			</article>
			<section>
				<div class="text-center">
				
				</div>
			</section>
		</div>
	</div>
</body>
<script>
	modalStack.push('#modalAddProjectMember');
	currModal = getCurrModalDom();
	
	currModal.querySelector('#addProjectMemberClose').addEventListener('click', addProjectMemberCloseEvent); // 닫기 버튼 이벤트
	currModal.querySelector('#cancelAddPMBtn').addEventListener('click', addProjectMemberCloseEvent); // 취소 버튼 이벤트
	currModal.querySelector('#searchBtn').addEventListener('click', searchMember); // 조회 버튼 이벤트
	currModal.querySelector('#addProjectMemberButton').addEventListener('click', addProjectMemberButtonEvent); // 추가 버튼 이벤트
	
	searchMember(); // 진입 직후 검색
	
	// 닫기 이벤트
	function addProjectMemberCloseEvent(){
		$(modalStack.pop()).html('');
		currModal = getCurrModalDom();
	}
	
	// 미참여 멤버 조회
	function searchMember(){
		const search = currModal.querySelector('input[name="search"]').value;
		let memberNumbers = [];
		const startDate = `${startDate}`;
		const endDate = `${endDate}`;
		
		document.querySelectorAll('#pmListBody input[name$="memberNumber"]').forEach( number => {
			memberNumbers.push(number.value);
		});
		
		$.ajax({
			url: '/OJT/projectModify/getNotAddProjectMember',
			method: 'POST',
			data: {
				'search' : search,
				'memberNumbers' : memberNumbers,
				'startDate' : startDate,
				'endDate' : endDate
			},
			success: function(result){
				$(getCurrModal() + ' #memberList').html(result);
				
				isScroll(); //스크롤 추가
				checkEvent(); // 체크박스 이벤트 추가
				addModifyPMEvent(); // 날짜 포커스, 포커스 아웃 이벤트 추가
				
				currModal.querySelectorAll('input[type=date], select').forEach(input => { // 날짜 혹은 select change이벤트 추가
					input.addEventListener('change', addProjectMemberChangeEvent);
				});
			},
			error: function(error){
				console.error(error);
			}
		});
	}
	
	// 투입일, 철수일, 역할 변경시 체크 이벤트
	function addProjectMemberChangeEvent(){
		const row = this.closest('tr');
		const checkbox = row.cells[0].querySelector('input[type="checkbox"].check');
		if(!checkbox.checked){
			checkbox.click();
		}
	}
	
	// 날짜 이벤트 주입 함수
	function addModifyPMEvent(){
		const startDates = currModal.querySelectorAll('input[type="date"][name="startDate"]');
		const endDates = currModal.querySelectorAll('input[type="date"][name="endDate"]');
		
		startDates.forEach(startDate => {
			startDate.addEventListener('focus', pmDateFocusEvent);
			startDate.addEventListener('focusout', pmStartDateFocusoutEvent);
		});
		
		endDates.forEach(endDate => {
			endDate.addEventListener('focus', pmDateFocusEvent);
			endDate.addEventListener('focusout', pmEndDateFocusoutEvent);
		});
	}
	
	// 날짜 포커스 이벤트
	function pmDateFocusEvent(){
		preDate = this.value;
		this.classList.remove('valid-error');
	}
	
	// 투입일 포커스 아웃 이벤트
	function pmStartDateFocusoutEvent(){
		const projectStart = `${startDate}`;
		const projectEnd = `${endDate}`;
		
		const memberStartDate = new Date(this.value);
		const projectStartDate = new Date(projectStart);
		const projectEndDate = new Date(projectEnd);
		
		if(memberStartDate < projectStartDate){
			projectMemberDateAlert({html : '<p>프로젝트 시작일보다 이전일수 없습니다.</p><p>프로젝트 시작일 : ${startDate}</p>'});
			if(preDate != ''){
				this.value = preDate;
			} else {
				this.value = projectStart;
			}
		} else if(memberStartDate > projectEndDate){
			projectMemberDateAlert({html : '<p>프로젝트(유지보수) 종료일보다 이후일수 없습니다.</p><p>프로젝트 종료일 : ${endDate}</p>'});
			if(preDate != ''){
				this.value = preDate;
			} else {
				this.value = projectEnd;
			}
		}
	}
	
	// 철수일 포커스 아웃 이벤트
	function pmEndDateFocusoutEvent(){
		const projectStart = `${startDate}`;
		const projectEnd = `${endDate}`;
		
		const memberEndDate = new Date(this.value);
		const projectStartDate = new Date(projectStart);
		const projectEndDate = new Date(projectEnd);
		
		if(memberEndDate < projectStartDate){
			projectMemberDateAlert({html : '<p>프로젝트 시작일보다 이전일수 없습니다.</p><p>프로젝트 시작일 : ${startDate}</p>'});
			if(preDate != ''){
				this.value = preDate;
			} else {
				this.value = projectStart;
			}
		} else if(memberEndDate > projectEndDate){
			projectMemberDateAlert({html : '<p>프로젝트(유지보수) 종료일보다 이후일수 없습니다.</p><p>프로젝트 종료일 : ${endDate}</p>'});
			if(preDate != ''){
				this.value = preDate;
			} else {
				this.value = projectEnd;
			}
		}
	}
	
	// 추가 버튼 이벤트
	function addProjectMemberButtonEvent(){
		const tbody = currModal.querySelector('table > tbody');
		const rows = tbody.rows;
		let memberList = [];
		let hasError = false;
		
		Array.from(rows).forEach(row => {
			const checkbox = row.cells[0].querySelector('input[type="checkbox"]');
			if(checkbox.checked){
				const memberNumber = row.cells[1].innerText;
				const memberName = row.cells[2].innerText;
				const department = row.cells[3].innerText;
				const position = row.cells[4].innerText;
				const startDate = row.querySelector('input[name="startDate"]');
				const endDate = row.querySelector('input[name="endDate"]');
				const roleCode = row.cells[7].querySelector('select').value;
				
				const startDateLocal = new Date(startDate.value);
				const endDateLocal = new Date(endDate.value);
				
				if(startDateLocal > endDateLocal){
					startDate.classList.add('valid-error');
					hasError = true;
				}
				
				memberList.push({
					'memberNumber' : memberNumber,
					'memberName' : memberName,
					'department' : department,
					'position' : position,
					'startDate' : startDate.value,
					'endDate' : endDate.value,
					'roleCode' : roleCode
				});
			}
		});
		
		// 에러가 있는지
		if(hasError){
			Swal.fire({
				icon: 'warning',
				text : '투입일이 철수일보다 이후일수 없습니다.'
			});
			return;
		}
		
		// 선택된 인원이 없는지
		if(memberList.length == 0){
			Swal.fire({
				icon: 'info',
				text : '선택된 인원이 없습니다.'
			});
			return;
		}
		
		// 테이블 추가에 필요한 것들
		const startDate = `${startDate}`;
		const endDate = `${endDate}`;
		const pmListBody = document.querySelector('#pmListBody');
		const pmListBodyRows = pmListBody.rows;
		let rowsLength;
		
		if(pmListBodyRows[0].cells.length == 1){
			rowsLength = 0;
		} else {
			rowsLength = pmListBodyRows.length;
		}
		
		// 멤버를 테이블에 추가
		$.ajax({
			url: '/OJT/projectModify/modifyProjectMember',
			method: 'POST',
			contentType: 'application/json',
			dataType: 'HTML',
			data: JSON.stringify({
				'pmList' : memberList,
				'startDate' :startDate,
				'endDate' : endDate,
				'rowsLength' : rowsLength
			}),
			success: function(result){
				Swal.fire({
					icon: 'success',
					title: '성공',
					text: '추가에 성공하였습니다.'
				}).then(() => {
					
					$(modalStack.pop()).html(''); //인원 추가 모달 닫기
					currModal = getCurrModalDom();
					
					if(pmListBodyRows[0].cells.length == 1){ // 행이 한개라면
						pmListBody.innerHTML = result; // 기존내용을 지우고 HTML추가
					} else {
						let pmListBodyHtml = pmListBody.innerHTML + result; // 기존내용을 포함해서 HTML작성
						pmListBody.innerHTML = pmListBodyHtml; // HTML추가
					}
					isScroll();
					checkEvent();
					addModifyPMFocusEvent();
					
					memberList.forEach(member => {
						const deleteMember = currModal.querySelector('div[data-memberNumber="' + member.memberNumber + '"]');
						if(deleteMember !== null){
							deleteMember.remove();
						}
					});
				});
			},
			error: function(error){
				console.error(error);
			}
		});
	}
</script>
</html>