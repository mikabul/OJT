// 프로젝트 시작일 변경 이벤트
function prjStartDateChange() {
	const projectStratDate = document.getElementById("projectStartDate");
	const projectEndDate = document.getElementById('projectEndDate');
	const value = projectStratDate.value;

	const startDate = document.querySelectorAll(".startDate");
	const endDate = document.querySelectorAll(".endDate");

	startDate.forEach(date => {
		date.min = value;
	})

	endDate.forEach(date => {
		date.min = value;
	})
	
	projectEndDate.min = value;
}

// 프로젝트 종료일 변경 이벤트
function prjEndDateChange() {
	const projectEndDate = document.getElementById("projectEndDate");
	const projectStartDate = document.getElementById("projectStartDate");
	const value = projectEndDate.value;

	const startDate = document.querySelectorAll(".startDate");
	const endDate = document.querySelectorAll(".endDate");
	const maintStartDate = document.getElementById('maintStartDate');
	const maintEndDate = document.getElementById('maintEndDate');

	if(maintEndDate.value == ''){
		startDate.forEach(date => {
			date.max = value;
		});
		endDate.forEach(date => {
			date.max = value;
		});
	}
	
	projectStartDate.max = value;
	maintStartDate.min = value;
	maintEndDate.min = value;
}

function changeProjectDateEvent(){
	
	// 멤버 투입일 이벤트 추가
	let startDate = document.querySelectorAll(".startDate");
	startDate.forEach(date => {
		date.removeEventListener('change', startDateChangeEvent);
		date.addEventListener('change', startDateChangeEvent);
	})
	
	// 멤버 철수일 이벤트 추가
	let endDate = document.querySelectorAll(".endDate");
	endDate.forEach(date => {
		date.removeEventListener('change', endDateChangeEvent);
		date.addEventListener('change', endDateChangeEvent);
	})
}

// 멤버 투입일 변경 이벤트
function startDateChangeEvent() {
	let index = this.getAttribute("index");
	let date = this.value;
	let endDate = document.getElementById("pmList" + index + '.endDate');
	endDate.min = date;
}

// 멤버 철수일 변경 이벤트
function endDateChangeEvent() {
	let index = this.getAttribute("index");
	let date = this.value;
	let startDate = document.getElementById("pmList" + index + '.startDate');
	startDate.max = date;
}

// 멤버 관련 벨리데이션
function errorMessagesAlert(){
	let errorsMessage = '';
	document.querySelectorAll('#errorMessages [id$=".errors"]').forEach(item => {
		errorsMessage += item.innerHTML + '\n';
	});
	if (errorsMessage.length > 0) {
		Swal.fire('인원 추가', errorsMessage, 'error');
	}
}

// 유지보수 시작일 이벤트
function maintStartDateEvent(){
	let value = this.value;
	
	const maintEndDate = document.getElementById('maintEndDate');
	maintEndDate.min = value;
}

// 유지보수 종료일 이벤트
function maintEndDateEvent(){
	let value = this.value;
	
	const startDate = document.querySelectorAll(".startDate");
	const endDate = document.querySelectorAll(".endDate");
	const maintStartDate = document.getElementById('maintStartDate');
	
	startDate.forEach(date => {
		date.max = value;
	})
	
	endDate.forEach(date => {
		date.max = value;
	})
	
	maintStartDate.max = value;
}

// 프로젝트 멤버 삭제 버튼 이벤트
function delete_addProjectEvent(){
	
	const rows = document.getElementById('pmListBody').rows;
	let checkAddProject = document.querySelectorAll('.checkAddProject');
	const allCheckAddProject = document.getElementById('allCheckAddProject');
	
	checkAddProject.forEach((check)=> {
		if(check.checked){
			let row = check.closest('tr');
			row.remove();
		}
	})
	
	if(rows.length == 0){
		$('#pmListBody').html('<tr><td class="text-center" colspan="8">추가된 인원이 없습니다.</td></tr>');
	}
	
	allCheckAddProject.checked = false;
	
	isScroll();
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
		url: '/OJT/addProject/showAddPMModal',
		success: function(result){
			$('#modalAddProjectMember').html(result);
		},
		error: function(error){
			console.log('ajax 실패');
			console.error(error);
		}
	})
}

// submit버튼 이벤트
function addProjectBeanSubmitEvent(){
    const form = document.getElementById('addProjectBean');
    const formData = new FormData(form);
    
   	let urlSearchParams = new URLSearchParams();
   	
   	formData.forEach((value, key) => {
		urlSearchParams.append(key, value);
	})
   	
    $.ajax({
        url: '/OJT/addProject/addProject',
        method: 'POST',
        contentType: false,
        processData: false,
        data: urlSearchParams,
        success: function(response){
			$('#modalAddProject').html(response);
			const inputSuccess = document.querySelector('input[name="success"]');
			let success;
			if(inputSuccess){ // input[name="success"] 이 undefined가 아닌지
				success = inputSuccess.value;
			}
			
			if(success == 'true'){ 
	            addSuccess();
			}
        },
        error: function(error){
            console.error(error);
        }
    });
}

// 추가에 성공 했을 경우의 함수
function addSuccess(){
	Swal.fire({
		icon: 'success',
		title: '성공!'
	}).then(() => {
		const success = document.querySelector('input[name="success"]').value;
		const projectNumber = document.querySelector('input[name="projectNumber"]').value;
		const form = document.querySelector('form');
		form.action = '/OJT/project/Main?&success=' + success + '&projectNumber=' + projectNumber;
		form.submit();
	})
}

// 프로젝트 세부사항 길이표시 이벤트
function projectDetailLength(){
	const projectDetail = document.getElementById('projectDetail');
	const projectDetailLength = document.getElementById('projectDetailLength');
	let maxlength = projectDetail.getAttribute('maxlength');
	let length = projectDetail.value.length;
	
	projectDetailLength.innerHTML = length + '/' + maxlength;
}