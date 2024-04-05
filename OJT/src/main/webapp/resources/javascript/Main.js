let currModal;
let preDate;

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

// 체크박스 이벤트 주입
function checkEvent(){
	const currModal = getCurrModal();
	const allCheckbox = document.querySelector(currModal + ' .allCheck');
	const checkboxs = document.querySelectorAll(currModal + ' .check');
	
	allCheckbox.addEventListener('click', allCheckboxEvent);
	Array.from(checkboxs).forEach(checkbox => {
		checkbox.addEventListener('click', checkboxEvent);
	})
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
	console.log(mergedOption);
	Swal.fire(mergedOption);
}
