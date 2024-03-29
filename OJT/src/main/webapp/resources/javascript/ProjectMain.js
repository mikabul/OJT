let modalStack = []; // 모달창을 하나씩 닫기위해 저장하는 변수
let allCheck = false; // 모든 프로젝트 체크를 위한 변수

document.addEventListener('DOMContentLoaded', function() {

	//============= 이벤트 추가 =============
	document.querySelectorAll('.pageBtn').forEach(btn => { // 페이징 버튼
		btn.addEventListener('click', paginationButtonEvent);
	})
	document.getElementById('resetBtn').addEventListener('click', resetBtn);// 리셋 버튼
	document.getElementById('viewSelect').addEventListener('click', changeView);// view 변경 이벤트
	document.getElementById('removeBtn').addEventListener('click', deleteProject);// 프로젝트 삭제 버튼
	document.getElementById('addProjectBtn').addEventListener('click', addProjectBtnEvent); // 등록 버튼 이벤트
	document.querySelectorAll("a").forEach(a => { //프로젝트 명 클릭 이벤트
		a.addEventListener('click', projectNameClickEvent);
	})
	document.querySelectorAll('input[type="checkbox"][name="state"]').forEach(check => {// 드롭다운 메뉴 내부 체크박스 클릭 시 이벤트
		check.addEventListener('change', dropdownCheckboxClickEvent);
	})
	document.getElementById('modifyProjectState').addEventListener('click', modifyProjectStateButtonEvent);// 상태 수정 버튼 이벤트 추가
	document.getElementById('allCheckbox').addEventListener('click', allCheckboxEvent);// 모두 선택 체크박스 이벤트
	document.querySelectorAll('#resultBody input[type="checkbox"]').forEach(check => { // 선택 박스 선택 이벤트
		check.addEventListener('change', checkboxEvent);
	})
	document.querySelectorAll('#resultBody tr').forEach(tr => { // 프로젝트의 체크박스 셀을 클릭 했을 때의 이벤트
		tr.querySelector('td:nth-child(1)').addEventListener('click', projectCheckboxCellClickEvent);
	})
	const tableBody = document.querySelector('#resultBody');
	const table = tableBody.closest('table');
	const theadCheckboxCell = table.querySelector('thead tr th:nth-child(1)');
	theadCheckboxCell.addEventListener('click', projectCheckboxCellClickEvent); // 프로젝트 전체 선택 체크박스의 셀을 클릭했을 때의 이벤트
	document.getElementById('changeStateSubmit').addEventListener('click', changeSubmitEvent); // 프로젝트 상태 수정 저장 버튼 이벤트
	//============= 로딩 후 실행할 함수들 =============
	$('#customer').select2(); // 고객사 select2
	projectAddSuccess(); // 프로젝트를 추가한 직후 라면 실행 할 함수
	dropdownCheckboxClickEvent(); // 초기 진입시 체크박스 데이터 라벨에 입력
});



/*													*/
/*						이벤트 함수					*/
/*													*/

// 화면에 표시할 개수를 담는 view가 변경 될 경우 작동하는 이벤트
// 검색 직후의 form을 이용하기 위해 #paginaionFormData를 이용
function changeView() {
	let form = document.getElementById("paginationForm");
	let selectedView = $("#viewSelect").val();
	let view = document.querySelector("#paginationForm input#view");
	view.value = selectedView;

	form.submit();
}

// 프로젝트 명 클릭 이벤트
function projectNameClickEvent(event) {
	event.preventDefault();
	let link = this.href;

	$.ajax({
		url: link,
		method: 'GET',
		success: function(response) {
			$('#modalProject').html(response);
		},
		error: function(error) {
			console.error(error);
		}
	})
}

// 초기화 버튼 이벤트
function resetBtn() {
	$("#name").val("");
	$("#customer").val("0");
	$("#dateType").val("0");
	$("#firstDate").val("");
	$("#secondDate").val("");

	let state = document.querySelectorAll(".state");
	state.forEach(check => { check.checked = false; })

	dropdownCheckboxClickEvent();// 라벨 초기화
}

// 페이징 버튼 이벤트
function paginationButtonEvent() {
	let btnPage = this.getAttribute("page");
	let page = document.getElementById("page");
	page.value = btnPage;

	const form = document.getElementById("paginationForm");
	form.submit();
}

// 모든 프로젝트 선택 이벤트
function allCheckboxEvent() {
	document.querySelectorAll(".checkProject").forEach(check => {
		check.checked = this.checked;
	})
}

// 프로젝트 선택 이벤트
function checkboxEvent() {
	let checkProject = document.querySelectorAll(".checkProject");
	let allCheckbox = document.getElementById("allCheckbox");

	if (Array.from(checkProject).every(check => check.checked)) {
		allCheckbox.checked = true;
	} else {
		allCheckbox.checked = false;
	}
}

// 체크박스 셀 클릭시 체크
function projectCheckboxCellClickEvent(event){
	const checkbox = this.querySelector('input[type="checkbox"]');
	if(event.target !== checkbox){// 클릭된 것이 checkbox가 아닐때만 작동
		checkbox.click();	
	}
}

// 삭제 버튼 이벤트
function deleteProject() {
	let checkbox_value = getCheckbox();
	if (checkbox_value.length == 0) {
		alert("선택된 프로젝트가 없습니다.");
		return;
	}
	let projectValue = getTableProjetcInfo(checkbox_value);
	if (deleteAlert(projectValue)) {
		deleteProjectAjax(projectValue);
	}
}

// checkbox의 index를 가져오는 함수
function getCheckbox() {
	let checkboxs = document.querySelectorAll('.checkProject');
	let checkbox_value = [];

	if (checkboxs.length)

		checkboxs.forEach(check => {
			if (check.checked == true) {
				checkbox_value.push(check.value);
			}
		})

	return checkbox_value;
}

// checkbox의 index를 이용하여 해당 프로젝트의 정보를 가져오는 함수
function getTableProjetcInfo(checkbox_value) {
	let resultBody = document.getElementById('resultBody');
	let rows = resultBody.rows;

	let projectValue = [];

	checkbox_value.forEach(index => {
		// index를 이용하여 tr을 가져옴
		let row = rows[index];
		// tr내부 td에 담겨있는 데이터를 가져와 projectValue에 담기
		projectValue.push({
			seq: row.cells[1].innerText,
			name: row.cells[2].getElementsByTagName('a')[0].innerText,
			customer: row.cells[3].innerText
		});
	})

	return projectValue;
}

// 삭제를 진행할지 여부를 묻는 alert
function deleteAlert(projectValue) {
	// 얼럿 메세지 작성
	let confirmMessage = '';
	for (let i = 0; i < projectValue.length; i++) {
		confirmMessage += '프로젝트명 : ' + projectValue[i].name + '\t고객사 : ' + projectValue[i].customer + '\n';
	}
	confirmMessage += '삭제 하시겠습니까?'
	// 얼럿 메세지 표시
	var result = confirm(confirmMessage);
	if (result) {
		return true;
	} else {
		// '취소' 버튼이 클릭된 경우 또는 창이 닫힌 경우
		alert("취소되었습니다.");
		return false;
	}
}

// 삭제를 진행하기 위한 ajax
function deleteProjectAjax(projectValue) {

	let projectSeq = [];

	projectValue.forEach(project => {
		projectSeq.push(project.seq);
	})

	$.ajax({
		url: '/OJT/projectRest/deleteProjects',
		method: 'POST',
		traditional: true,
		data: {
			"projectSeq": projectSeq
		},
		success: function(result) {
			if (result) {
				alert('삭제에 성공하였습니다.');
				location.reload();
			} else {
				alert('삭제에 실패하였습니다.');
			}
		},
		error: function(error) {
			console.error("ajax 실패");
			console.error(error);
		}
	})
}

// 프로젝트 등록 모달 호출
function addProjectBtnEvent() {
	$.ajax({
		url: '/OJT/project/addProjectModal',
		dataType: 'HTML',
		success: function(result) {
			$('#modalAddProject').html(result);
		},
		error: function(error) {
			console.error("error\n", error);
		}
	})

}

// 프로젝트 등록 직후에 작동 하는 함수
function projectAddSuccess() {

	const url = new URLSearchParams(location.href);//현재 페이지의 url을 갖옴
	const success = url.get('success');// parameter 분리
	const prj_seq = url.get('prj_seq');// parameter 분리

	if (success && success == 'true') { //success가 undefiend가 아니고 'true'일때
		$.ajax({
			url: '/OJT/project/projectInfo',
			method: 'GET',
			traditional: true,
			data: {
				'prj_seq': prj_seq
			},
			success: function(response) {
				$('#modalProject').html(response);
			},
			error: function(error) {
				console.error(error);
			}
		})
	}
}

//esc누를시 모달 닫힘
$(document).keydown(function(event) {
	if (event.keyCode == 27 || event.which == 27) {
		$(modalStack.pop()).html('');
		window.history.pushState({}, '', '/OJT/project/Main');
	}
});

// 드롭다운 내부 체크박스 클릭 이벤트
function dropdownCheckboxClickEvent() {
	const dropdown = document.querySelector('#projectSearchBean .dropdown');
	let dropdownLabel = dropdown.querySelector('.dropdown-label');
	let checkboxs = document.querySelectorAll('input[type="checkbox"][name="state"]');
	let message = '';

	checkboxs.forEach(checkbox => {
		if (checkbox.checked) {
			message += document.querySelector('label[for="' + checkbox.id + '"]').textContent.trim() + ', ';
		}
	})

	if (message.length != 0) {
		message = message.substring(0, (message.length - 2));
	}

	dropdownLabel.innerText = message;
	dropdownLabel.setAttribute('title', message);
}

// 프로젝트 상태 수정 버튼 이벤트
function modifyProjectStateButtonEvent() {
	const resultBody = document.getElementById('resultBody');
	const resultBodyRows = resultBody.rows;

	let selectHTML = '<select class="changeState">';
	psList.forEach(ps => {
		selectHTML += '<option value="' + ps.dtl_cd + '">' + ps.dtl_cd_nm + '</option>';
	})
	selectHTML += '</select>';

	document.querySelectorAll('table input[type="checkbox"]').forEach(check => {
		check.checked = false;
	})

	Array.from(resultBodyRows).forEach(row => {
		let cell = row.cells[6];
		cell.innerHTML = selectHTML;
		let cd = cell.dataset.cd;
		cell.querySelector('select').value = cd;
	});

	// 프로젝트 상태 변경 이벤트
	document.querySelectorAll('.changeState').forEach(select => {
		select.addEventListener('change', function(){
			const row = select.closest('tr');
			const cell = row.cells[0];
			const cd = row.cells[6].dataset.cd;
			const checkbox = cell.querySelector('input[type="checkbox"]'); // 또는 .get(0) 메서드를 사용할 수도 있습니다.
			if(select.value == cd){
				checkbox.checked = false;
			} else {
				checkbox.checked = true;
			}
			checkboxEvent();
		})
	})
	
	document.querySelectorAll('.checkProject').forEach(check => {
		check.addEventListener('change', function(){
			if(!check.checked){
				const row = check.closest('tr');
				const cell = row.cells[6];
				const select = cell.querySelector('select');
				select.value = cell.dataset.cd;
			}
		})
	})

	document.getElementById('BeforeSwitchBtn').classList.add('none');
	document.getElementById('AfterSwitchBtn').classList.remove('none');
}

function changeSubmitEvent(){
	const resultBody = document.getElementById('resultBody'); // tbody
	const rows = resultBody.rows; // tr list
	let projectNumber = []; // 프로젝트 번호 배열
	let projectState = []; // 프로젝트 상태코드 배열
	
	Array.from(rows).forEach(row => {
		let cell = row.cells[0];
		let checkbox = cell.querySelector('input[type="checkbox"]');
		if(checkbox.checked) {
			projectNumber.push(row.cells[1].innerText);
			projectState.push(row.cells[6].querySelector('select').value);
		}
	})
	
	if(projectNumber.length != projectState.length){ // 프로젝트 번호 배열과 상태의 배열의 길이가 다르면
		alert('문제가 발생하였습니다.');
		return;
	}
	
	if(projectNumber.length == 0){ // 선택된 프로젝트가 없다면
		alert('변경될 프로젝트가 없습니다.');
		return;
	}
	
	$.ajax({
		url: "/OJT/projectRest/updateProjectState",
		method: 'POST',
		traditional: true,
		data: {
			'projectNumber' : projectNumber,
			'projectState' : projectState
		},
		success: function(){
			alert('업데이트에 성공하였습니다!');
		},
		error: function(error){
			alert('업데이트에 실패하였습니다.');
			console.error(error);
		}
	})
}
