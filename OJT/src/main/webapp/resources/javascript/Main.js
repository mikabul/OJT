// input 글자수 제한 이벤트 주입 함수
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
	
	if(limit != '' && this.value.length >= limit && (event.keyCode !== 8 || event.which !== 8)){
		document.getElementById(name + "_length.errors").innerHTML = limit + '글자까지 가능합니다.';
	}
	else {
		document.getElementById(name + "_length.errors").innerHTML = '';
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