
let allCheck = false; // 모든 프로젝트 체크를 위한 변수


$('#customer').select2();

// 페이지 버튼 이벤트 추가
let pageBtn = document.querySelectorAll(".pageBtn");
pageBtn.forEach(btn => {
	btn.addEventListener('click', paginationButtonEvent);
})

// 리셋 버튼 이벤트 추가
$("#resetBtn").on('click', resetBtn);

// #viewSelect 값 설정
let viewSelect = document.getElementById("viewSelect");
let view = $('#view').val();
viewSelect.value = view;

//이벤트 추가
viewSelect.addEventListener('change', changeView);

// 삭제 버튼 이벤트
let removeBtn = document.getElementById('removeBtn');
removeBtn.addEventListener('click', deleteProject);

// 등록 버튼 이벤트
document.getElementById('addProjectBtn').addEventListener('click', addProjectBtnEvent);


// 화면에 표시할 개수를 담는 view가 변경 될 경우 작동하는 함수
// 검색 직후의 form을 이용하기 위해 #paginaionFormData를 이용
function changeView() {
	let form = document.getElementById("paginationForm");
	let selectedView = $("#viewSelect").val();
	let view = document.querySelector("#paginationForm input#view");
	view.value = selectedView;

	form.submit();
}

// 초기화 버튼
function resetBtn() {
	$("#name").val("");
	$("#customer").val("0");
	$("#dateType").val("0");
	$("#firstDate").val("");
	$("#secondDate").val("");

	let state = document.querySelectorAll(".state");
	state.forEach(check => { check.checked = false; })
}

// 페이징 버튼 이벤트
function paginationButtonEvent() {
	let btnPage = this.getAttribute("page");
	let page = document.getElementById("page");
	page.value = btnPage;

	const form = document.getElementById("paginationForm");
	form.submit();
}

// 모든 프로젝트 선택 펑션
function allCheckbox() {
	let checkProject = document.querySelectorAll(".checkProject");

	if (allCheck) {

		allCheck = false;
		checkProject.forEach(check => {
			check.checked = false;
		})
	} else {

		allCheck = true;
		checkProject.forEach(check => {
			check.checked = true;
		})
	}
}

// 프로젝트 선택 펑션
function checkboxFunction() {
	let checkProject = document.querySelectorAll(".checkProject");
	let allCheckbox = document.getElementById("allCheckbox");

	if (isChecked(checkProject)) {
		allCheck = true;
		allCheckbox.checked = true;
	} else {
		allCheck = false;
		allCheckbox.checked = false;
	}
}

// 모든 프로젝트가 선택되었는지
function isChecked(checkProject) {
	return Array.from(checkProject).every(check => check.checked);
}

// 등록 버튼 모달 생성
function addProjectModal() {

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
			seq: row.cells[1].innerHTML,
			name: row.cells[2].getElementsByTagName('a')[0].innerHTML,
			customer: row.cells[3].innerHTML
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

function addProjectBtnEvent() {
	$.ajax({
		url: '/OJT/project/addProjectModal',
		dataType: 'HTML',
		success: function(result) {
			$('#modalAddProject').html(result);
			loadAddProject();
		},
		error: function(error) {
			console.error("error\n", error);
		}
	})

}