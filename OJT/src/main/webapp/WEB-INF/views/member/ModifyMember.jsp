<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>INNOBL - 사원 수정</title>
<script src="${root}resources/lib/javascript/jquery-3.7.1.min.js"></script>
<!-- select2 -->
<link href="${root}resources/lib/style/select2.min.css" rel="stylesheet" />
<script src="${root}resources/lib/javascript/select2.min.js"></script>
<!-- SweetAlert2 -->
<link href="${root}resources/lib/style/sweetalert2.min.css" rel="stylesheet"/>
<script src="${root}resources/lib/javascript/sweetalert2.min.js"></script>
<!-- 외부 css -->
<link rel="stylesheet" href="${root}resources/style/Main.css" />
</head>
<style>
	* { 
/* 		border: 1px solid black; */
 	}
	
	section {
		margin-left: 200px;
		margin-right: 200px;
	}
	
	.content {
		display: flex;
		align-content: center;
	}
	
	.content > div {
		display: flex;
		align-content: center;
		width: 50%;
		padding: 3px;
	}
	
	.content > div > *:nth-child(1) {
		display: flex;
		width: 20%;
	}
	
	.content > div > *:nth-child(2){
		display: flex;
		width: 80%;
	}
	
	#preview[data-show="false"] {
		display: none;
	}
	
	#preview[data-show="true"] {
		display: block;
		max-width: 198px;
		max-height: 198px;
	}
	
	#resignationDateDiv[data-show="true"] {
		display: flex;
	}
	
	#resignationDateDiv[data-show="false"] {
		display: none;
	}
	
	input[readonly] {
		background-color: #f2f2f2;
	}
	
	.valid-error {
		background-color: #ffcccc;
	}
</style>
<body>
	<c:import url="/WEB-INF/views/include/TopMenu.jsp"></c:import>
	<header class="text-center">
		<h1>사원 수정</h1>
	</header>
	<section>
		<form action="${ root }member/modifyMember/modify" id="modifyMemberBean" method="post" enctype="multipart/form-data">
			<div style="display: flex">
				<div class="w-30">
					<div class="container-center" style="width: 200px; height: 242px; border: 1px solid black;">
						<div style="width: 200px; height: 200px; display: flex; align-items: center">
							<img id="preview" src="${ root }resources/images/member/${modifyMemberBean.pictureDir}" alt="Uploaded Image" data-show="true"/>
						</div>
						<div style="width: 200px; height: 42px; border-top: 1px solid black;">
							<input type="file" name="memberImage" accept="image/*" value="${ modifyMemberBean.memberImage }"/>
						</div>
						<div id="memberImage.errors" style="width: 200px; margin-top: 13px;">
							<c:if test="${ fn:length(errorMessage.memberImage) > 0 }">
								<c:forEach var="item" items="${ errorMessage.memberImage }">
									<div>${ item }</div>
								</c:forEach>
							</c:if>
						</div>
					</div>
				</div>
				<div class="w-70">
					<div class="content">
						<div>
							<div>사원번호</div>
							<input type="text" name="memberNumber" value="${ modifyMemberBean.memberNumber }" readonly="readonly"/>
						</div>
					</div>
					<div class="content">
						<div>
							<div>이름<span class="required">*</span></div>
							<input type="text" name="memberName" value="${ modifyMemberBean.memberName }" required="required"/>
						</div>
						<div>
							<div>아이디<span class="required">*</span></div>
							<div class="justify-content-center">
								<input class="w-60" type="text" name="memberId" data-value="${ modifyMemberBean.memberId }" value="${ modifyMemberBean.memberId }" required="required"/>
								<p class="w-10"></p>
								<button class="w-30 btn" type="button" id="checkIdButton">중복확인</button>
							</div>
						</div>
					</div>
					<div class="content">
						<div>
							<div></div>
							<div id="memberName.errors">
								<c:if test="${ fn:length(errorMessage.memberName) > 0 }">
									<c:forEach var="item" items="${ errorMessage.memberName }">
										<div>${ item }</div>
									</c:forEach>
								</c:if>
							</div>
						</div>
						<div>
							<div></div>
							<div id="memberId.errors">
								<c:if test="${ fn:length(errorMessage.memberId) > 0 }">
									<c:forEach var="item" items="${ errorMessage.memberId }">
										<div>${ item }</div>
									</c:forEach>
								</c:if>
							</div>
						</div>
					</div>
					<div class="content">
						<div>
							<div>주민번호<span class="required">*</span></div>
							<div>
								<input class="w-40" type="text" name="memberRrnPrefix" value="${ modifyMemberBean.memberRrnPrefix }" maxlength="6" required="required"/>
								<input type="text" class="read-input w-20 text-center" style="background-color: unset;" readonly value="-"/>
								<input class="w-40" type="password" name="memberRrnSuffix" value="${ modifyMemberBean.memberRrnSuffix }" maxlength="7"/>
							</div>
						</div>
						<div>
							<div>패스워드</div>
							<input type="password" name="memberPW" value="${ modifyMemberBean.memberPW }"/>
						</div>
					</div>
					<div class="content">
						<div>
							<div></div>
							<div id="memberRrn.errors">
								<c:if test="${ fn:length(errorMessage.memberRrn) > 0 }">
									<c:forEach var="item" items="${ errorMessage.memberRrn }">
										<div>${ item }</div>
									</c:forEach>
								</c:if>
							</div>
						</div>
						<div>
							<div></div>
							<div id="memberPW.errors">
								<c:if test="${ fn:length(errorMessage.memberPW) > 0 }">
									<c:forEach var="item" items="${ errorMessage.memberPW }">
										<div>${ item }</div>
									</c:forEach>
								</c:if>
							</div>
						</div>
					</div>
					<div class="content">
						<div>
							<div>연락처<span class="required">*</span></div>
							<input type="text" name="tel" value="${ modifyMemberBean.tel }" required="required" required="required"/>
						</div>
						<div>
							<div>패스워드 확인</div>
							<input type="password" name="memberPW2" value="${ modifyMemberBean.memberPW2 }"/>
						</div>
					</div>
					<div class="content">
						<div>
							<div></div>
							<div id="tel.errors">
								<c:if test="${ fn:length(errorMessage.tel) > 0 }">
									<c:forEach var="item" items="${ errorMessage.tel }">
										<div>${ item }</div>
									</c:forEach>
								</c:if>
							</div>
						</div>
						<div>
							<div></div>
							<div id="memberPW2.errors">
								<c:if test="${ fn:length(errorMessage.memberPW2) > 0 }">
									<c:forEach var="item" items="${ errorMessage.memberPW2 }">
										<div>${ item }</div>
									</c:forEach>
								</c:if>
							</div>
						</div>
					</div>
					<div class="content">
						<div>
							<div>비상연락처</div>
							<input type="text" name="emTel" value="${ modifyMemberBean.emTel }"/>
						</div>
						<div>
							<div>부서</div>
							<select name="departmentCode">
								<c:forEach var="item" items="${ departmentList }">
									<option value="${ item.detailCode }" ${ item.detailCode == modifyMemberBean.departmentCode ? 'selected' : '' }>${ item.codeName }</option>
								</c:forEach>						
							</select>
						</div>
					</div>
					<div class="content">
						<div>
							<div></div>
							<div id="emTel.errors">
								<c:if test="${ fn:length(errorMessage.emTel) > 0 }">
									<c:forEach var="item" items="${ errorMessage.emTel }">
										<div>${ item }</div>
									</c:forEach>
								</c:if>
							</div>
						</div>
						<div>
							<div></div>
							<div id="departmentCode.errors">
								<c:if test="${ fn:length(errorMessage.departmentCode) > 0 }">
									<c:forEach var="item" items="${ errorMessage.departmentCode }">
										<div>${ item }</div>
									</c:forEach>
								</c:if>
							</div>
						</div>
					</div>
					<div class="content">
						<div>
							<div>이메일</div>
							<div class="flex" style="margin-top: 0;">
								<input type="text" name="emailPrefix" value="${ addMemberBean.emailPrefix }"/>@
								<input type="text" name="emailSuffix" value="${ addMemberBean.emailSuffix }"/>
								<select id="emailCode" style="margin-left: 5px;">
									<c:forEach var="item" items="${ emailList }">
										<option value="${ item.codeName }" ${ item.codeName == addMemberBean.emailSuffix ? 'selected' : '' }>${ item.codeName }</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div>
							<div>직책<span class="required">*</span></div>
							<select name="positionCode" required="required">
								<option value="">-선택-</option>
								<c:forEach var="item" items="${ positionList }">
									<option value="${ item.detailCode }" ${ item.detailCode == modifyMemberBean.positionCode ? 'selected' : '' }>${ item.codeName }</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="content">
						<div>
							<div></div>
							<div id="email.errors">
								<c:if test="${ fn:length(errorMessage.email) > 0 }">
									<c:forEach var="item" items="${ errorMessage.email }">
										<div>${ item }</div>
									</c:forEach>
								</c:if>
							</div>
						</div>
						<div>
							<div></div>
							<div id="positionCode.errors">
								<c:if test="${ fn:length(errorMessage.positionCode) > 0 }">
									<c:forEach var="item" items="${ errorMessage.positionCode }">
										<div>${ item }</div>
									</c:forEach>
								</c:if>
							</div>
						</div>
					</div>
					<div class="content">
						<div>
							<div>성별<span class="required">*</span></div>
							<select name="genderCode" required="required">
								<option value="">-선택-</option>
								<c:forEach var="item" items="${ genderList }">
									<option value="${ item.detailCode }" ${ item.detailCode == modifyMemberBean.genderCode ? 'selected' : '' }>${ item.codeName }</option>
								</c:forEach>
							</select>
						</div>
						<div>
							<div>보유기술</div>
							<div>
								<div class="w-100 dropdown">
									<div class="dropdown-header">
										<div class="dropdown-label ellipsis" title=""></div>
										<div class="dropdown-icon">▼</div>
									</div>
									<div class="dropdown-menu" data-show="false">
										<c:forEach var="item" items="${ skillList }" varStatus="status">
											<c:set var="checked" value="" />
											<div>
												<c:forEach var="code" items="${ modifyMemberBean.skillCodes }">
													<c:if test="${ item.detailCode == code }">
														<c:set var="checked" value="checked" />
													</c:if>
												</c:forEach>
												<input type="checkbox" name="skillCodes" id="skillCodes${ status.index }" value="${ item.detailCode }" ${ checked }/>
												<label for="skillCodes${ status.index }">${ item.codeName }</label>
											</div>
										</c:forEach>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="content">
						<div>
							<div></div>
							<div id="genderCode.errors">
								<c:if test="${ fn:length(errorMessage.genderCode) > 0 }">
									<c:forEach var="item" items="${ errorMessage.genderCode }">
										<div>${ item }</div>
									</c:forEach>
								</c:if>
							</div>
						</div>
						<div>
							<div></div>
							<div id="skillCodes.errors">
								<c:if test="${ fn:length(errorMessage.skillCodes) > 0 }">
									<c:forEach var="item" items="${ errorMessage.skillCodes }">
										<div>${ item }</div>
									</c:forEach>
								</c:if>
							</div>
						</div>
					</div>
					<div class="content">
						<div>
							<div>재직상태<span class="required">*</span></div>
							<select name="statusCode">
								<c:forEach var="item" items="${ statusList }">
									<option value="${ item.detailCode }" ${ item.detailCode == modifyMemberBean.statusCode ? 'selected' : '' }>${ item.codeName }</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="content">
						<div>
							<div></div>
							<div id="statusCode.errors">
								<c:if test="${ fn:length(errorMessage.statusCode) > 0 }">
									<c:forEach var="item" items="${ errorMessage.statusCode }">
										<div>${ item }</div>
									</c:forEach>
								</c:if>
							</div>
						</div>
					</div>
					<div class="content">
						<div>
							<div>입사일<span class="required">*</span></div>
							<input type="date" name="hireDate" required="required" value="${ modifyMemberBean.hireDate }"/>
						</div>
						<div id="resignationDateDiv" data-show="false">
							<div>퇴사일<span class="required">*</span></div>
							<input type="date" name="resignationDate" value="${ addMemberBean.resignationDate }"/>
						</div>
					</div>
					<div class="content">
						<div>
							<div></div>
							<div id="hireDate.errors">
								<c:if test="${ fn:length(errorMessage.hireDate) > 0 }">
									<c:forEach var="item" items="${ errorMessage.hireDate }">
										<div>${ item }</div>
									</c:forEach>
								</c:if>
							</div>
						</div>
						<div>
							<div></div>
							<div id="resignationDate.errors">
								<c:if test="${ fn:length(errorMessage.resignationDate) > 0 }">
									<c:forEach var="item" items="${ errorMessage.resignationDate }">
										<div>${ item }</div>
									</c:forEach>
								</c:if>
							</div>
						</div>
					</div>
					<div class="flex">
						<div class="w-10">주소<span class="required">*</span></div>
						<div class="w-70">
							<div class="flex">
								<input type="text" class="w-30" id="sample6_postcode" name="zoneCode" placeholder="우편번호" value="${ modifyMemberBean.zoneCode }" required="required">
								<button type="button" class="btn" onclick="postCodeEvent()">우편번호 찾기</button>
							</div>
							<div>
								<input type="text" id="sample6_address" name="address" placeholder="주소" required="required" value="${ modifyMemberBean.address }" ><br>
							</div>
							<div class="flex" style="margin: 0;">
								<input type="text" id="sample6_detailAddress" name="detailAddress" value="${ modifyMemberBean.detailAddress }" placeholder="상세주소">
								<input type="text" id="sample6_extraAddress" name="extraAddress" value="${ modifyMemberBean.extraAddress }" placeholder="참고항목">
							</div>
						</div>
					</div>
					<div class="flex" style="margin-top: 2px;">
						<div class="w-10"></div>
						<div class="w-70">
							<div></div>
							<div id="address.errors">
								<c:if test="${ fn:length(errorMessage.address) > 0 }">
									<c:forEach var="item" items="${ errorMessage.address }">
										<div>${ item }</div>
									</c:forEach>
								</c:if>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="text-center" style="margin-top: 5px;">
				<button type="submit" class="btn btn-green">저장</button>
				<button type="reset" class="btn btn-orange">초기화</button>
			</div>
		</form>
	</section>
<script src="${root}resources/javascript/Main.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</body>
<script>
modalStack = [];

let checkId = true;
let checkPassword = true;
let errorMessage = '';

document.querySelector('input[name="memberImage"]').addEventListener('change', memberImageChangeEvent); // 이미지 변경 이벤트
document.querySelectorAll('input[type="checkbox"][name="skillCodes"]').forEach(check => {// 드롭다운 메뉴 내부 체크박스 클릭 시 이벤트
	check.addEventListener('change', dropdownCheckboxClickEvent);
});
document.querySelector('input[name="memberPW"]').addEventListener('keyup', passwordChangeEvent); // 비밀번호 변경 이벤트
document.querySelector('input[name="memberPW2"]').addEventListener('keyup', passwordChangeEvent); // 비밀번호 확인 변경 이벤트
document.querySelector('select[name="statusCode"]').addEventListener('change', resignationDateShowEvent); // 재직 상태 변경 이벤트
document.getElementById('modifyMemberBean').addEventListener('submit', addMemberSubmitEvent); // submit 이벤트
document.getElementById('checkIdButton').addEventListener('click', checkIdButtonEvent); // 중복 체크 버튼 이벤트
document.getElementById('emailCode').addEventListener('change', suffixChange); // 이메일 도메인 변경 이벤트
document.querySelector('input[name="tel"]').addEventListener('keyup', telKeyupEvent);
document.querySelector('input[name="emTel"]').addEventListener('keyup', telKeyupEvent);

/*
 * 유효성 검사
 */
document.querySelector('input[name="memberName"]').addEventListener('focusout', memberNameFocusoutEvent); 			// 멤버 이름
document.querySelector('input[name="memberId"]').addEventListener('focusout', memberIdFocusoutEvent); 				// 아이디
document.querySelector('input[name="memberRrnPrefix"]').addEventListener('focusout', memberRrnPrefixFocusoutEvent); // 주민등록번호 앞
document.querySelector('input[name="memberRrnSuffix"]').addEventListener('focusout', memberRrnSuffixFocusoutEvent); // 주민등록번호 뒤
document.querySelector('input[name="memberPW"]').addEventListener('focusout', memberPWFocusoutEvent); 				// 패스워드
document.querySelector('input[name="tel"]').addEventListener('focusout', telFocusoutEvent); 						// 연락처
document.querySelector('input[name="emTel"]').addEventListener('focusout', emTelFocusoutEvent); 					// 비상 연락처
document.querySelector('input[name="emailPrefix"]').addEventListener('focusout', emailFocusoutEvent); 				// 이메일 앞
document.querySelector('input[name="emailSuffix"]').addEventListener('focusout', emailFocusoutEvent); 				// 이메일 뒤

document.querySelectorAll('input').forEach(input => { // 인풋 포커스 이벤트
	input.addEventListener('focus', inputFocusEvent);
});

addDropdownEvent();
dropdownCheckboxClickEvent();
modifyMemberStartup();
suffixChange();
resignationDateShowEvent();

function modifyMemberStartup(){
	const success = `${success}`;
	if(success == "false"){
		const message = `${message}`;
		Swal.fire('실패', message, 'error');
	}
}

//이미지 변경 이벤트
function memberImageChangeEvent(){
	const file = document.querySelector('input[name="memberImage"]').files[0];
	const preview = document.getElementById('preview');
	const reader = new FileReader();
	console.log(file);
	if(file){
		
		if(file.size > 5242880){
			Swal.fire('5MB이하까지 업로드 가능합니다.', '', 'error');
			this.value = '';
			preview.src = '${root}resources/images/member/default.jpg';
			return;
		} else if(!file.type.startsWith('image/')){
			Swal.fire('이미지 파일만 업로드 가능힙니다.', '', 'error');
			this.value = '';
			preview.src = '${root}resources/images/member/default.jpg';
			return;
		}
		
		reader.onload = function(){
			preview.src = this.result;
			preview.dataset.show = 'true';
		}
		console.log(preview.src);
		reader.readAsDataURL(file);
		
	} else {
		preview.src = '${root}resources/images/member/default.jpg';
	} 
}

//드롭다운 내부 체크박스 클릭 이벤트
function dropdownCheckboxClickEvent() {
	const dropdown = document.querySelector('#modifyMemberBean .dropdown');
	let dropdownLabel = dropdown.querySelector('.dropdown-label');
	let checkboxs = document.querySelectorAll('input[type="checkbox"][name="skillCodes"]');
	let message = '';

	checkboxs.forEach(checkbox => {
		if (checkbox.checked) {
			message += document.querySelector('label[for="' + checkbox.id + '"]').textContent.trim() + ', ';
		}
	})

	if (message.length != 0) {
		message = message.substring(0, (message.length - 2));
	} else {
		message = '-선택-'
	}

	dropdownLabel.innerText = message;
	dropdownLabel.setAttribute('title', message);
}

// 패스워드 비교 펑션
function passwordChangeEvent(){
	const pw = document.querySelector('input[name="memberPW"]').value;
	const pw2 = document.querySelector('input[name="memberPW2"]').value;
	const memberPW2Errors = document.querySelector('[id="memberPW2.errors"]'); 
	
	if(pw.length == 0 && pw2.length == 0){
		checkPassword = true;
		memberPW2Errors.innerHTML = '';
	} else if(pw == pw2){
		checkPassword = true;
		memberPW2Errors.innerHTML = '<span style="color: green; font-size: 10px;">비밀번호가 일치합니다.</span>';
	} else {
		checkPassword = false;
		memberPW2Errors.innerHTML = '<span style="color: red; font-size: 10px;">비밀번호가 일치하지않습니다.</span>';
	}
}

// 재직상태가 퇴직일 경우 퇴직일input을 보여주는 함수
function resignationDateShowEvent(){
	const statusCode = document.querySelector('select[name="statusCode"]').value;
	const resignationDateDiv = document.getElementById('resignationDateDiv');
	
	if(statusCode == '3'){
		resignationDateDiv.dataset.show = true;
	} else {
		resignationDateDiv.dataset.show = false;
	}
}

// 아이디 중복 체크 이벤트
function checkIdButtonEvent(){
	const inputId = document.querySelector('input[name="memberId"]').value;
	const memberNumber = document.querySelector('input[name="memberNumber"]').value;
	$.ajax({
		url: '${root}member//modifyMember/matchId',
		data: {
			'inputId' : inputId,
			'memberNumber' : memberNumber
		},
		success: function(result){
			console.log(result);
			if(result){
				Swal.fire('사용가능한 아이디 입니다.', '' ,'success');
				checkId = true;
			} else {
				Swal.fire('사용할수 없는 아이디 입니다.', '' ,'error');
				checkId = false;
			}
		},
		error: function(error){
			console.error(error);
		}
	});
}

// submit 이벤트
function addMemberSubmitEvent(event){
	
	let message = '';
	if(checkId == false){
		message += '<p>아이디 중복체크가 필요합니다.</p>';
	}
	if(checkPassword == false){
		message += '<p>비밀번호가 일치하지 않습니다.</p>';
	}
	
	if(message.length > 0){
		Swal.fire('', message, 'error');
		event.preventDefault();
		return;
	}
	
	/*
	* 모든 유효성 검사를 호출
	*/
	if(memberNameFocusoutEvent() &&
		memberIdFocusoutEvent() &&
		memberRrnPrefixFocusoutEvent() &&
		memberRrnSuffixFocusoutEvent() &&
		memberPWFocusoutEvent() &&
		telFocusoutEvent() &&
		emTelFocusoutEvent() &&
		emailFocusoutEvent() ) {
		
		this.submit;
		
	} else {
		Swal.fire({
			icon: 'error',
			text: '유효성 검사에 실패하였습니다.'
		});
		event.preventDefault();
	}
}

// 이메일 도메인 선택시
function suffixChange(){
	const emailCode = document.getElementById('emailCode');
	const suffix = document.querySelector('input[name="emailSuffix"]');
	
	if(emailCode.value == '직접입력'){
		suffix.removeAttribute('readonly');
		suffix.value = '';
	} else {
		suffix.setAttribute('readonly', true);
		suffix.value = emailCode.value;
	}
}

// input or select 포커스 이벤트
function inputFocusEvent(){
	this.classList.remove('valid-error');
}

// 사원이름 포커스 아웃 이벤트
function memberNameFocusoutEvent(){
	const memberName = document.querySelector('input[name="memberName"]');
	const memberNameErrors = document.querySelector('[id="memberName.errors"]');
	const memberNameValue = memberName.value;
	const koreanPattern = /^[가-힣]+$/;
	const englishPattern = /^[a-zA-Z ]+$/;
	
	if(memberNameValue.length >= 2){
		if(koreanPattern.test(memberNameValue)){
			if(memberNameValue.length > 6){
				memberNameErrors.innerHTML = '<span class="errors">한글은 6글자까지 입력 가능합니다.</span>';
				memberName.classList.add('valid-error');
				return false;
			} else if(memberName.vlaue < 2){
				memberNameErrors.innerHTML = '<span class="errors">한글은 최소 2글자이상 입력해야합니다.</span>';
				memberName.classList.add('valid-error');
				return false;
			}
			memberNameErrors.innerHTML = '';
			return true;
		} else if(englishPattern.test(memberNameValue)){
			if(memberNameValue.length > 20){
				memberNameErrors.innerHTML = '<span class="errors">영어는 20글자까지 입력 가능합니다.</span>';
				memberName.classList.add('valid-error');
				return false;
			} else if(memberNameValue.length < 5){
				memberNameErrors.innerHTML = '<span class="errors">영어는 최소 5글자 이상 입력해야합니다.</span>';
				memberName.classList.add('valid-error');
				return false;
			}
			memberNameErrors.innerHTML = '';
			return true;
		} else {
			memberNameErrors.innerHTML = '<span class="errors">한글 또는 영어만 입력가능합니다.</p><p>한글은 공백이 없어야 합니다.</p>';
			memberName.classList.add('valid-error');
			return false;
		}
	} else {
		memberNameErrors.innerHTML = '<span class="errors">한글은 최소 3글자, 영어는 최소 5글자 이상이어야합니다.</p>';
		memberName.classList.add('valid-error');
		return false;
	}
}

// 아이디 포커스 아웃 이벤트
function memberIdFocusoutEvent(){
	const memberId = document.querySelector('input[name="memberId"]');
	const memberIdErrors = document.querySelector('[id="memberId.errors"]');
	const value = memberId.value;
	const pattern = /^[a-zA-Z0-9]+$/;
	
	if(value.length >= 5){
		if(pattern.test(value)){
			memberIdErrors.innerHTML = '';
			return true;
		} else {
			memberIdErrors.innerHTML = '<span class="errors">영어와 숫자만 입력 가능합니다.</span>';
			memberId.classList.add('valid-error');
			return false;
		}
	} else {
		memberIdErrors.innerHTML = '<span class="errors">최소 5글자, 최대 20글자까지 입력해야합니다.</span>';
		memberId.classList.add('valid-error');
		return false;
	}
}

// 주민등록번호 앞자리 포커스 아웃 이벤트
function memberRrnPrefixFocusoutEvent(){
	const memberRrnPrefix = document.querySelector('input[name="memberRrnPrefix"]');
	const memberRrnErrors = document.querySelector('[id="memberRrn.errors"]');
	const value = memberRrnPrefix.value;
	const pattern = /^(\d{2})(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[0-1])$/;
	
	if(value.length == 6){
		if(pattern.test(value)){
			memberRrnErrors.innerHTML = '';
			return true;
		} else {
			memberRrnErrors.innerHTML = '<span class="errors">주민등록번호 형식에 맞지 않습니다.</span>';
			memberRrnPrefix.classList.add('valid-error');
			return false;
		}
	} else {
		memberRrnErrors.innerHTML = '<span class="errors">주민등록번호 형식에 맞지 않습니다.</span>';
		memberRrnPrefix.classList.add('valid-error');
		return false;
	}
}

// 주민등록번호 뒷자리 포커스 아웃 이벤트
function memberRrnSuffixFocusoutEvent(){
	const memberRrnSuffix = document.querySelector('input[name="memberRrnSuffix"]');
	const memberRrnErrors = document.querySelector('[id="memberRrn.errors"]');
	const value = memberRrnSuffix.value;
	const pattern = /^[1-4]\d{6}$/;
	if(value.length > 0){
		if(pattern.test(value)){
			memberRrnErrors.innerHTML = '';
			return true;
		} else {
			memberRrnErrors.innerHTML = '<span class="errors">주민등록번호 형식에 맞지 않습니다.</span>';
			memberRrnSuffix.classList.add('valid-error');
			return false;
		}
	} else {
		return true;
	}
}

// 패스워드 포커스 아웃 이벤트
function memberPWFocusoutEvent(){
	const memberPW = document.querySelector('input[name="memberPW"]');
	const memberPWErrors = document.querySelector('[id="memberPW.errors"]');
	const value = memberPW.value;
	const pattern = /^[a-zA-Z0-9\!\@\^]+$/;
	if(value.length > 0){
		if(pattern.test(value)){
			if(value.length > 20){
				memberPWErrors.innerHTML = '<span class="errors">20글자까지 입력가능합니다.</span>';
				memberPW.classList.add('valid-error');
				return false;
			} else if(value.length < 8){
				memberPWErrors.innerHTML = '<span class="errors">최소 8글자 이상 입력해야합니다.</span>';
				memberPW.classList.add('valid-error');
				return false;
			}
			memberPWErrors.innerHTML = '';
			return true;
		} else {
			memberPWErrors.innerHTML = '<span class="errors">영어와 숫자, 특수문자(! @ ^)만 입력가능합니다.</span>';
			memberPW.classList.add('valid-error');
			return false;
		}
	} else {
		return true;
	}
}

// 연락처 포커스 아웃 이벤트
function telFocusoutEvent(){
	const tel = document.querySelector('input[name="tel"]');
	const telErrors = document.querySelector('[id="tel.errors"]');
	const value = tel.value;
	const pattern = /^(01[016789])-(\d{3,4})-(\d{4})|(\d{2,3})-(\d{3,4})-(\d{4})$/;
	
	if(value.length > 0){
		if(pattern.test(value)){
			telErrors.innerHTML = '';
			return true;
		} else {
			telErrors.innerHTML = '<span class="errors">올바른 형식이 아닙니다.</span>';
			tel.classList.add('valid-error');
			return false;
		}
	} else {
		telErrors.innerHTML = '<span class="errors">비워둘수 없습니다.</span>';
		tel.classList.add('valid-error');
		return false;
	}
}

// 비상연락처 포커스 아웃 이벤트
function emTelFocusoutEvent(){
	const emTel = document.querySelector('input[name="emTel"]');
	const emTelErrors = document.querySelector('[id="emTel.errors"]');
	const value = emTel.value;
	const pattern = /^(01[016789])-(\d{3,4})-(\d{4})|(\d{2,3})-(\d{3,4})-(\d{4})$|^$/;
	if(pattern.test(value)){
		emTelErrors.innerHTML = '';
		return true;
	} else {
		emTelErrors.innerHTML = '<span class="errors">올바른 형식이 아닙니다.</span>';
		emTel.classList.add('valid-error');
		return false;
	}
}

// 연락처, 비상연락처 keyup 이벤트
function telKeyupEvent(){
	const value = this.value.replace(/[^\d]/g, '');
	let replaceValue;
	console.log('value : ' + value);
	if(value.length >= 2){
		if(/^(01[016789])\d*$/.test(value)){
			replaceValue = value.replace(/^(\d{0,3})(\d{0,4})(\d{0,4})$/, '$1-$2-$3').replace(/(\-{1,2})$/, '');
			this.maxLength = 13;
		} else if(/^(02)\d*$/g.test(value)){
			replaceValue = value.replace(/^(\d{0,2})(\d{0,3})(\d{0,4})$/, '$1-$2-$3').replace(/(\-{1,2})$/, '');
			this.maxLength = 11;
		} else if(/^(\d{3})\d*$/g.test(value)){
			replaceValue = value.replace(/^(\d{0,3})(\d{0,3})(\d{0,4})$/, '$1-$2-$3').replace(/(\-{1,2})$/, '');
			this.maxLength = 12;
		} else {
			replaceValue = value;
		}
	} else {
		replaceValue = value;
	}
	
	this.value = replaceValue;
}

// 이메일 포커스 아웃 이벤트
function emailFocusoutEvent(){
	const emailPrefix = document.querySelector('input[name="emailPrefix"]');
	const emailSuffix = document.querySelector('input[name="emailSuffix"]');
	const emailErrors = document.querySelector('[id="email.errors"]');
	const email = emailPrefix.value + '@' + emailSuffix.value;
	const patter = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
	if(emailPrefix.value != '' && emailSuffix.value != ''){
		if(pattern.test(email)){
			if(email.lngth > 31){
				meailErrors.innerHTML = '<span class="errors">30글자까지 입력 가능합니다.</span>';
				emailPrefix.classList.add('valid-error');
				return false;
			}
			meailErrors.innerHTML = '';
			return true
		}else {
			meailErrors.innerHTML = '<span class="errors">올바른 이메일형식이 아닙니다.</span>';
			emailPrefix.classList.add('valid-error');
			return false;
		}
	} else {
		emailErrors.innerHTML = '';
		return true;
	}
}
</script>
</html>