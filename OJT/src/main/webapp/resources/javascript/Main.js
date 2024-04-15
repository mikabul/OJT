let modalStack = []; // 모달창을 하나씩 닫기위해 저장하는 변수
let currModal;
let preDate;

let projectStart;
let projectEnd;
let maintStart;
let maintEnd;

//esc누를시 모달 닫힘
$(document).keydown(function(event) {
	if (event.keyCode == 27 || event.which == 27) {
		$(modalStack.pop()).html('');
		currModal = getCurrModalDom();
		window.history.pushState({}, '', window.location.pathname);
	}
});

// input 글자수 제한 이벤트 주입 함수
// 호출시 input[type="text"] 와 textarea의 길이제한 이벤트 주입
function lengthLimitEvent(){
	document.querySelectorAll('input[type="text"], textarea').forEach(input => {
		input.removeEventListener('keydown', lengthLimit);
		input.addEventListener('keydown', lengthLimit);
	})
}

// input 글자수 제한 이벤트
function lengthLimit(event){

	let limit = this.getAttribute('maxlength');
	let name = this.getAttribute('name');
	console.log(name);
	if(limit != '' && this.value.length >= limit && (event.keyCode !== 8 || event.which !== 8)){
		document.getElementById(name + "Length.errors").innerHTML = limit + '글자까지 가능합니다.';
	}
	else {
		document.getElementById(name + "Length.errors").innerHTML = '';
	}
}

/*											*/
/* ================= 드롭다운 ===============	*/
/*											*/
// 드롭다운 이벤트 주입
function addDropdownEvent(){
	document.querySelectorAll('.dropdown-header').forEach(drop => {
		drop.removeEventListener('click', dropdownEvent);
		drop.addEventListener('click', dropdownEvent);
	})
	// 드롭다운 외 클릭
	document.removeEventListener('click', notDropdownClickEvent);
	document.addEventListener('click', notDropdownClickEvent);
	// 드롭다운 메뉴 크기 및 위치 조정
	window.removeEventListener('resize', adjustDropdownMenuPosition);
	window.addEventListener('resize', adjustDropdownMenuPosition);
	// 드롭다운 메뉴 크기 위치 초기 설정
	adjustDropdownMenuPosition();
}

// 드롭다운 외 부분 클릭 이벤트
function notDropdownClickEvent(event){
	const dropdowns = document.querySelectorAll('.dropdown');
	dropdowns.forEach(dropdown => {
		const dropdownMenu = dropdown.querySelector('.dropdown-menu'); 
		const dropdownIcon = dropdown.querySelector('.dropdown-icon');
				
		if(!dropdown.contains(event.target) && dropdownMenu.dataset.show == 'true'){
			dropdownMenu.dataset.show = 'false';
			dropdownIcon.innerText = '▼';
		}
	})
}

// 드롭다운
function dropdownEvent(){
	const dropdown = this.closest('div.dropdown');
	const dropdownMenu = dropdown.querySelector('.dropdown-menu');
	const dropdownIcon = dropdown.querySelector('.dropdown-icon');
	
	if(dropdownMenu.dataset.show === 'true'){
		dropdownMenu.dataset.show = 'false';
		dropdownIcon.innerText = '▼';
	} else {
		dropdownMenu.dataset.show = 'true';
		dropdownIcon.innerText = '▲';
	}
	adjustDropdownMenuPosition();
}

// 드롭다운 위치 크기 조절
function adjustDropdownMenuPosition(){
    document.querySelectorAll('.dropdown').forEach(dropdown => {
        let dropdownMenu = dropdown.querySelector('.dropdown-menu');
        let dropdownRect = dropdown.getBoundingClientRect(); // 위치와 크기 정보를 담은 변수
        dropdownMenu.style.top = (dropdownRect.top + dropdownRect.height ) + 'px';
        dropdownMenu.style.width = dropdownRect.width + 'px';
    });
}

// 드롭다운 라벨 표시
function dropdownLabelDraw(){
	let checkboxs = currModal.querySelectorAll('input[type="checkbox"][name="skillCodeList"]');
	let tempList = [];
	let message = '';
	
	checkboxs.forEach(check => {
		if(check.checked){ // 체크되어있는지?
			tempList.push(document.querySelector('label[for="' + check.id + '"]').textContent.trim());
			// trim을 사용하여 공백을 제거해줘야함
		}
	})
	
	if(tempList.length >= 1){ //리스트에 값이 있는지?
		message += tempList[0];
		for(let i = 1; i < tempList.length; i++){
			message += ', ' + tempList[i];
		}
	}
	let label = currModal.querySelector('.dropdown-label');
	label.innerHTML = message;
	label.setAttribute('title', message);
}


// 스크롤 추가 펑션
function isScroll(){
	const currModal = modalStack[modalStack.length - 1];
	const scrollDiv = document.querySelector(currModal + ' #scrollDiv');
	const scroll = scrollDiv.dataset.scroll;
	const rows = scrollDiv.querySelector('tbody').rows;
	
	if(rows.length > scroll){
		scrollDiv.classList.add('scroll');
	} else {
		scrollDiv.classList.remove('scroll');
	}
	
}

/*											*/
/* ================= 체크박스 ===============	*/
/*											*/
// 체크박스 이벤트 주입
function checkEvent(){
	const currModal = getCurrModal();
	const allCheckbox = document.querySelector(currModal + ' .allCheck');
	const checkboxs = document.querySelectorAll(currModal + ' .check');
	
	if(allCheckbox){
		allCheckbox.addEventListener('click', allCheckboxEvent);
	}
	if(checkboxs){
		Array.from(checkboxs).forEach(checkbox => {
			checkbox.addEventListener('click', checkboxEvent);
		})
	}
}

// 모두 체크
function allCheckboxEvent(){
	const currModal = getCurrModal();
	const checkboxs = document.querySelectorAll(currModal + ' .check');
	checkboxs.forEach(checkbox => {
		checkbox.checked = this.checked;
	})
}

// 체크박스 클릭 이벤트
function checkboxEvent(){
	const currModal = getCurrModal();
	const checkboxs = document.querySelectorAll(currModal + ' input[type="checkbox"].check');
	
	if(Array.from(checkboxs).every(checkbox => checkbox.checked)){
		document.querySelector(currModal + ' .allCheck').checked = true;
	} else {
		document.querySelector(currModal + ' .allCheck').checked = false;
	}
}

// 현재 모달의 아이디 반환
function getCurrModal(){
	return modalStack.length > 0 ? modalStack[modalStack.length - 1] : '';
}

// 현재 모달의 dom반환
function getCurrModalDom(){
	const currModalSlice = getCurrModal().slice(1);
	return document.getElementById(currModalSlice);
}


/*											*/
/* ================== 날짜 ================	*/
/*											*/
// 날짜 경고 alert
function projectMemberDateAlert(option) {
	
	const defaultOption = {
		toast: true,
		position: 'top',
		showConfirmButton: false,
		timer: 2500,
		timerProgressBar: true,
		icon: 'warning'
	};
	
	const mergedOption = Object.assign({}, defaultOption, option);
	Swal.fire(mergedOption);
}

// 밸리데이션 alert
function inputValdationAlert(option){
	
	const defaultOption = {
		toast: true,
		position: 'top',
		showConfirmButton: false,
		timer: 4000,
		timerProgressBar: true,
		icon: 'info'
	};
	
	const mergedOption = Object.assign({}, defaultOption, option);
	Swal.fire(mergedOption);
}

// 주소 API
function postCodeEvent() {
	new daum.Postcode({
		oncomplete: function(data) {
			// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

			// 각 주소의 노출 규칙에 따라 주소를 조합한다.
			// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
			var addr = ''; // 주소 변수
			var extraAddr = ''; // 참고항목 변수

			//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
			if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
				addr = data.roadAddress;
			} else { // 사용자가 지번 주소를 선택했을 경우(J)
				addr = data.jibunAddress;
			}

			// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
			if (data.userSelectedType === 'R') {
				// 법정동명이 있을 경우 추가한다. (법정리는 제외)
				// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
				if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
					extraAddr += data.bname;
				}
				// 건물명이 있고, 공동주택일 경우 추가한다.
				if (data.buildingName !== '' && data.apartment === 'Y') {
					extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
				}
				// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
				if (extraAddr !== '') {
					extraAddr = ' (' + extraAddr + ')';
				}
				// 조합된 참고항목을 해당 필드에 넣는다.
				document.getElementById("extraAddress").value = extraAddr;

			} else {
				document.getElementById("extraAddress").value = '';
			}

			// 우편번호와 주소 정보를 해당 필드에 넣는다.
			document.getElementById('postcode').value = data.zonecode;
			document.getElementById("address").value = addr;
			// 커서를 상세주소 필드로 이동한다.
			document.getElementById("detailAddress").focus();
		}
	}).open();
}
