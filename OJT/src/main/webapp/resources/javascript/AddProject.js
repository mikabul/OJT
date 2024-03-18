
function loadAddProject(){
	// 멤버 투입일 이벤트 추가
	let st_dt = document.querySelectorAll(".st_dt");
	st_dt.forEach(date => {
		date.removeEventListener('change', startDateChangeEvent);
		date.addEventListener('change', startDateChangeEvent);
	})
	
	// 멤버 철수일 이벤트 추가
	let ed_dt = document.querySelectorAll(".ed_dt");
	ed_dt.forEach(date => {
		date.removeEventListener('change', endDateChangeEvent);
		date.addEventListener('change', endDateChangeEvent);
	})
	
	// 프로젝트 시작일 종료일 이벤트 추가
	document.getElementById('prj_st_dt').addEventListener('change', prjStartDateChange);
	document.getElementById('prj_ed_dt').addEventListener('change', prjEndDateChange);
	
	// 유지보수 시작일 철수일 이벤트 추가
	document.getElementById('maint_st_dt').addEventListener('change', maintStartDateEvent);
	document.getElementById('maint_ed_dt').addEventListener('change', maintEndDateEvent);
	
	// 닫기(취소) 버튼
	document.getElementById('addProjectClose').addEventListener('click', function(){
		$('#modalAddProject').html('');
	})
	document.getElementById('cancelBtn').addEventListener('click', function(){
		$('#modalAddProject').html('');
	})
	
	// 드롭다운 이벤트
	document.getElementById('dropdown').addEventListener('click', dropdownEvent);
	
	// 기술 check 이벤트
	document.querySelectorAll('input[type="checkbox"][name="prj_sk_list"]').forEach(check => {
		check.addEventListener('click', checkedSKEvent);
	})
	
	// 삭제 버튼 이벤트
	document.getElementById('delete_addProjectBtn').addEventListener('click', delete_addProjectEvent);
	
	// 모두 체크 이벤트
	document.getElementById('allCheckAddProject').addEventListener('click', allCheckAddProjectEvent);
	
	// 모두 체크 되었을 때의 이벤트
	document.querySelectorAll('.checkAddProject').forEach(check => {
		check.addEventListener('click', isAllCheckAddProject);
	})
	
	// 추가 버튼 이벤트
	document.getElementById('addPMModalBtn').addEventListener('click', addPMModalBtnEvent);
}

// 프로젝트 시작일 변경 이벤트
function prjStartDateChange() {
	const prj_st_dt = document.getElementById("prj_st_dt");
	const prj_ed_dt = document.getElementById('prj_ed_dt');
	const value = prj_st_dt.value;

	const st_dt = document.querySelectorAll(".st_dt");
	const ed_dt = document.querySelectorAll(".ed_dt");

	st_dt.forEach(date => {
		date.min = value;
	})

	ed_dt.forEach(date => {
		date.min = value;
	})
	
	prj_ed_dt.min = value;
}

// 프로젝트 종료일 변경 이벤트
function prjEndDateChange() {
	const prj_ed_dt = document.getElementById("prj_ed_dt");
	const prj_st_dt = document.getElementById("prj_st_dt");
	const value = prj_ed_dt.value;

	const st_dt = document.querySelectorAll(".st_dt");
	const ed_dt = document.querySelectorAll(".ed_dt");
	const maint_st_dt = document.getElementById('maint_st_dt');
	const maint_ed_dt = document.getElementById('maint_ed_dt');

	if(maint_ed_dt.value == ''){
		st_dt.forEach(date => {
			date.max = value;
		});
		ed_dt.forEach(date => {
			date.max = value;
		});
	}
	
	prj_st_dt.max = value;
	maint_st_dt.min = value;
	maint_ed_dt.min = value;
}

// 멤버 투입일 변경 이벤트
function startDateChangeEvent() {
	let index = this.getAttribute("index");
	let date = this.value;
	console.log(date);
	let ed_dt = document.getElementById("pmList" + index + '.ed_dt');
	ed_dt.min = date;
}

// 멤버 철수일 변경 이벤트
function endDateChangeEvent() {
	let index = this.getAttribute("index");
	let date = this.value;
	console.log(date);
	let st_dt = document.getElementById("pmList" + index + '.st_dt');
	st_dt.max = date;
}

// #dropdown 이벤트
function dropdownEvent(){
	let show = this.show;
	let dropdownMenu = document.getElementById('dropdownMenu');
	
	if(show){
		dropdownMenu.classList.add('none');
		this.show = false;
		$('#dropIcon').html('▼');
	} else {
		dropdownMenu.classList.remove('none');
		this.show = true;
		adjustDropdownMenuPosition();
		$('#dropIcon').html('▲');
	}
}

// dropdownMenu 위치 크기 조절
function adjustDropdownMenuPosition() {
    var dropdown = document.getElementById("dropdown");
    var dropdownMenu = document.getElementById("dropdownMenu");

    var dropdownRect = dropdown.getBoundingClientRect(); // #dropdown의 위치 및 크기를 가져옴
	
    // #dropdownMenu의 위치를 조정
    dropdownMenu.style.top = (dropdownRect.top + dropdown.offsetHeight - 4) + "px"; // #dropdown 아래로 설정
    dropdownMenu.style.left = dropdownRect.left + "px"; // #dropdown의 왼쪽 위치에 설정
    dropdownMenu.style.width = (dropdownRect.width - 8) + 'px';
}

// 창사이즈가 바뀔 때마다 adjustDropdownMenuPosition 호출
window.addEventListener("resize", function() {
    adjustDropdownMenuPosition();
});

// 프로젝트의 필요기술 리스트를 클릭 할때마다 호출되는 이벤트
function checkedSKEvent(){
	let prj_sk_list = document.querySelectorAll('input[type="checkbox"][name="prj_sk_list"]');
	let tempList = [];
	let message = '';
	
	prj_sk_list.forEach(check => {
		if(check.checked){ // 체크되어있는지?
			tempList.push(document.querySelector('label[for="' + check.id + '"]').innerHTML);
		}
	})
	
	if(tempList.length >= 1){ //리스트에 값이 있는지?
		message += tempList[0];
		for(let i = 1; i < tempList.length; i++){
			message += ', ' + tempList[i];
		}
	}
	
	$('#checkMessage').html(message);
}

// 유지보수 시작일 이벤트
function maintStartDateEvent(){
	let value = this.value;
	
	const maint_ed_dt = document.getElementById('maint_ed_dt');
	maint_ed_dt.min = value;
}

// 유지보수 종료일 이벤트
function maintEndDateEvent(){
	let value = this.value;
	
	const st_dt = document.querySelectorAll(".st_dt");
	const ed_dt = document.querySelectorAll(".ed_dt");
	const maint_st_dt = document.getElementById('maint_st_dt');
	
	st_dt.forEach(date => {
		date.max = value;
	})
	
	ed_dt.forEach(date => {
		date.max = value;
	})
	
	maint_st_dt.max = value;
}

// 프로젝트 멤버 삭제 버튼 이벤트
function delete_addProjectEvent(){
	
	const rows = document.getElementById('pmListBody').rows;
	let checkAddProject = document.querySelectorAll('.checkAddProject');
	
	checkAddProject.forEach((check)=> {
		if(check.checked){
			let row = check.closest('tr');
			row.remove();
		}
	})
	
	if(rows.length == 0){
		$('#pmListBody').html('<tr><td class="text-center" colspan="8">추가된 인원이 없습니다.</td></tr>');
	}
}

// 멤버 모두 선택 #allCheckAddProject
function allCheckAddProjectEvent(){
	
	const checkAddProject = document.querySelectorAll('.checkAddProject');
	
	checkAddProject.forEach(check => {
		check.checked = this.checked;
	})
}

// 모두 체크되었는지 .checkAddProject
function isAllCheckAddProject(){
	const checkAddProject = document.querySelectorAll('.checkAddProject');
	
	let allCheckAddProject = document.getElementById('allCheckAddProject');
	let allCheck = true;
	
	checkAddProject.forEach(check => {
		if(!check.checked){
			allCheck = false;
		}
	})
	
	allCheckAddProject.checked = allCheck;

}

// 추가 버튼 이벤트
function addPMModalBtnEvent(){
	$.ajax({
		url: '/OJT/project/showAddPMModal',
		success: function(result){
			$('#modalAddProjectMember').html(result);
			loadAddProjectMember();
		},
		error: function(error){
			console.log('ajax 실패');
			console.error(error);
		}
	})
}
