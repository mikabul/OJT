
	$(document).ready(function() {
		
		roleOptions();
		
		// 멤버 투입일 이벤트 주입
		let st_dt = document.querySelectorAll(".st_dt");
		st_dt.forEach(date => {
			date.addEventListener('change', startDateChangeEvent);
		})
		
		// 멤버 철수일 이벤트 주입
		let ed_dt = document.querySelectorAll(".ed_dt");
		ed_dt.forEach(date => {
			date.addEventListener('change', endDateChangeEvent);
		})
	});
	
	// 역할 선택 옵션들
	function roleOptions(){
		const role_select = document.querySelectorAll(".role_select");
		
		fetch("/OJT/projectFetch/getRole")
		.then(response => {
			if(!response.ok){
				throw new Error("통신 에러");
			}
			return response.json();
		})
		.then(json => {
			
			role_select.forEach(role => {
				let role_selectHtml = '';
				
				json.forEach(role_list => {
					role_selectHtml += '<option value="' + role_list.dtl_cd + '">'
									+	role_list.dtl_cd_nm + '</option>';
				})
				$(role).html(role_selectHtml);
			})
			
		})
		.catch(error => {
			console.error("패치 에러", error);
		})
	}
	
	// 프로젝트 시작일 변경 이벤트
	function prjStartDateChange(){
		const prj_st_dt = document.getElementById("prj_st_dt");
		const value = prj_st_dt.value;
		
		const st_dt = document.querySelectorAll(".st_dt");
		const ed_dt = document.querySelectorAll(".ed_dt");
		
		st_dt.forEach(date => {
			date.min = value;
		})
		
		ed_dt.forEach(date => {
			date.min = value;
		})
	}
	
	// 프로젝트 종료일 변경 이벤트
	function prjEndDateChange(){
		const prj_ed_dt = document.getElementById("prj_ed_dt");
		const value = prj_ed_dt.value;
		
		const st_dt = document.querySelectorAll(".st_dt");
		const ed_dt = document.querySelectorAll(".ed_dt");
		
		st_dt.forEach(date => {
			date.max = value;
		})
		
		ed_dt.forEach(date => {
			date.max = value;
		})
	}
	
	// 멤버 투입일 변경 이벤트
	function startDateChangeEvent(){
		let index = this.getAttribute("index");
		let date = this.value;
		let ed_dt = document.getElementById("projectMemberList" + index + '.ed_dt');
		ed_dt.min = date;
	}
	
	// 멤버 철수일 변경 이벤트
	function endDateChangeEvent(){
		let index = this.getAttribute("index");
		let date = this.value;
		let st_dt = document.getElementById("projectMemberList" + index + '.st_dt');
		st_dt.max = date;
	}
	
	// 등록 팝업 닫기
	function closeAddProjetcPop(){
		let addProjectPop = document.getElementById("addProjectPop");
		addProjectPop.classList.add("none");
	}
	
	// 프로젝트 인원 등록 버튼
	function clickAddPM(){
		let addPMPop = document.getElementById('addPMPop');
		addPMPop.classList.remove('none');
		
		getPMList();
	}
	