// 검색 조건을 가져와 getNotAddProjectMember 호출
function searchMember(){
	let search = document.getElementById('search').value;
	let memberNumbers = [];
	
	let rows = document.getElementById('pmListBody').rows;
	console.log(rows);
	Array.from(rows).forEach(row => {
		if(row.cells.length > 1){
			let cell = row.cells[1];
			console.log(cell);
			let number = cell.querySelector('input').value;
			console.log(number);
			memberNumbers.push(number);
		}
	});
	
	getNotAddProjectMember(search, memberNumbers); //미참여 멤버 리스트
	
}

// 검색 ajax
function getNotAddProjectMember(search, memberNumbers){
	
	let startDate = document.getElementById('projectStartDate').value;
	let projectEndDate = document.getElementById('projectEndDate').value;
	let maintEndDate = document.getElementById('maintEndDate').value;
	let endDate;
	
	if(maintEndDate != ''){
		endDate = maintEndDate;
	} else {
		endDate = projectEndDate;
	}
	
	$.ajax({
		url: '/OJT/addProject/getNotAddProjectMember',
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
			// checkbox 클릭 이벤트
			let checkPM = document.querySelectorAll('.checkPM');
			checkPM.forEach(check => {
				check.addEventListener('click', isAllCheckAddPM);
			});
			isScroll(); // 스크롤 추가
			
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
				memberNumber: cell[1].innerHTML,
				memberName: cell[2].innerHTML,
				department: cell[3].innerHTML,
				position: cell[4].innerHTML,
				startDate: cell[5].querySelector('input').value,
				endDate: cell[6].querySelector('input').value,
				roleCode: cell[7].querySelector('select').value
			})
		}
	})
	
	return addPMList;
}

// 체크된 멤버의 리스트를 이용하여 'addProject'에 추가
function wirteAddProjectMember(addPMList){
	const pmListBodyRows = document.getElementById('pmListBody').rows; //'#pmListBody'의 전체 행
	const startDate = document.getElementById('projectStartDate').value;
	const projectEndDate = document.getElementById('projectEndDate').value;
	const maintEndDate = document.getElementById('maintEndDate').value;
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
		url: '/OJT/addProject/addProjectTable',
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
			modalStack.pop();
			
			//스코롤
			isScroll();
			changeProjectDateEvent();
		},
		error: function(error){
			console.error(error);
		}
	})
	
}