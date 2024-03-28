// 검색 조건을 가져와 getNotAddProjectMember 호출
function searchMember(){
	let search = document.getElementById('search').value;
	let seqList = [];
	
	let rows = document.getElementById('pmListBody').rows;
	Array.from(rows).forEach(row => {
		if(row.cells.length > 1){
			let cell = row.cells[1];
			let seq = cell.querySelector('input').value;
			seqList.push(seq);
		}
	});
	
	getNotAddProjectMember(search, seqList); //미참여 멤버 리스트
	
}

// 검색 ajax
function getNotAddProjectMember(search, seqList){
	
	let startDate = document.getElementById('prj_st_dt').value;
	let projectEndDate = document.getElementById('prj_ed_dt').value;
	let maintEndDate = document.getElementById('maint_ed_dt').value;
	let endDate;
	
	if(maintEndDate != ''){
		endDate = maintEndDate;
	} else {
		endDate = projectEndDate;
	}
	console.log(startDate);
	console.log(endDate);
	$.ajax({
		url: '/OJT/project/getNotAddProjectMember',
		method: 'GET',
		traditional: true,
		data: {
			'search': search,
			'seqList': seqList,
			'startDate': startDate,
			'endDate': endDate
		},
		success: function(result){
			$('#memberList').html(result);
			// checkbox 클릭 이벤트
			let checkPM = document.querySelectorAll('.checkPM');
			checkPM.forEach(check => {
				check.addEventListener('click', isAllCheckAddPM);
			});
			isScrollPM(); // 스크롤 추가
			
			const memberList = document.getElementById('memberList').rows;
			for(let i = 0; i < memberList.length; i++){
				const startDate = memberList[i].cells[5].querySelector('input');
				const secondDate = memberList[i].cells[6].querySelector('input');
				const role = memberList[i].cells[7].querySelector('select');
				
				// 변경시 체크박스에 체크
				startDate.addEventListener('change', function(){
					checkPM[i].checked = true;
					isAllCheckAddPM();
					secondDate.min = this.value;
				})
				secondDate.addEventListener('change', function(){
					checkPM[i].checked = true;
					isAllCheckAddPM();
					startDate.max = this.value;
				})
				role.addEventListener('change', function(){
					checkPM[i].checked = true;
					isAllCheckAddPM();
				})
			}
		},
		error: function(error){
			console.error(error);
		}
	})
}

// 모두 체크 이벤트
function allCheckAddPMEvent(){
	
	let checkPM = document.querySelectorAll('.checkPM');
	
	checkPM.forEach(check => {
		check.checked = this.checked;
	})
}

// 체크 시 이벤트, 모두 체크되었 다면 '#allCheckAddPM'을 체크 아니라면 해제
function isAllCheckAddPM(){
	let allCheckAddPM = document.getElementById('allCheckAddPM');
	let checkPM = document.querySelectorAll('.checkPM');
	
	if(Array.from(checkPM).every(check => check.checked)){ // 모두 체크 되어있다면
		allCheckAddPM.checked = true;
	} else {
		allCheckAddPM.checked = false;
	}
}

// 행이 9개 이상일 경우 스크롤 추가
function isScrollPM(){
	let resultAddPMTable = document.getElementById('resultAddPMTable');
	let memberListRows = document.getElementById('memberList').rows;
	
	if(memberListRows.length >= 11){
		resultAddPMTable.classList.add('scroll');
	} else {
		resultAddPMTable.classList.remove('scroll');
	}
}

// 저장 버튼 이벤트
function addPMBtnEvent(){
	
	let addPMList = getCheckedPMList();
	
	if(addPMList.length == 0){// 선택된 멤버가 있는지?
		alert('선택된 멤버가 없습니다.');
		return;
	}
	
	wirteAddProjectMember(addPMList);
}

// 체크된 멤버의 리스트를 얻어옴
function getCheckedPMList(){
	let addPMList = []; // 추가할 맴버의 정보를 담는 변수
	const addPMRows = document.getElementById('memberList').rows; // 테이블의 row들을 저장
	
	Array.from(addPMRows).forEach(row => {
		let cell = row.cells;
		if(cell.length == 1){
			alert('선택된 멤버가 없습니다.');
			return;
		}
		if(cell[0].querySelector('input').checked){
			addPMList.push({
				mem_seq: cell[1].innerHTML,
				mem_nm: cell[2].innerHTML,
				dept: cell[3].innerHTML,
				position: cell[4].innerHTML,
				st_dt: cell[5].querySelector('input').value,
				ed_dt: cell[6].querySelector('input').value,
				ro_cd: cell[7].querySelector('select').value
			})
		}
	})
	
	return addPMList;
}

// 체크된 멤버의 리스트를 이용하여 'addProject'에 추가
function wirteAddProjectMember(addPMList){
	const pmListBodyRows = document.getElementById('pmListBody').rows; //'#pmListBody'의 전체 행
	const startDate = document.getElementById('prj_st_dt').value;
	const projectEndDate = document.getElementById('prj_ed_dt').value;
	const maintEndDate = document.getElementById('maint_st_dt').value;
	let endDate;
	
	if(maintEndDate != ''){
		endDate = maintEndDate;
	} else {
		endDate = projectEndDate;
	}
	
	let rowsLength; // pmListBodyRows의 크기를 담을 변수
	let pmListBodyHtml; //'#pmListBody'의 html을 담을 변수
	if(pmListBodyRows[0].cells.length == 1){// cell이 1개일 경우 (= '추가된 인원이 없습니다')
		rowsLength = 0;
		pmListBodyHtml = '';
	} else {
		rowsLength = pmListBodyRows.length;
		pmListBodyHtml = $('#pmListBody').html();
	}
	
	$.ajax({
		url: '/OJT/project/addProjectTable',
		method: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			'addPMList': addPMList,
			'rowsLength': rowsLength,
			'startDate': startDate,
			'endDate': endDate
		}),
		success: function(result){
			// 선택 멤버를 프로젝트에 추가
			pmListBodyHtml += result;
			$('#pmListBody').html(pmListBodyHtml);
			$('#modalAddProjectMember').html(''); // 창 닫기
			
			//스코롤
			isScrollAddProject();
			changeProjectDateEvent();
		},
		error: function(error){
			console.error(error);
		}
	})
	
}