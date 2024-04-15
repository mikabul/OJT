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
					</div>
				</div>
				<div class="w-70">
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
							<div>주민번호<span class="required">*</span></div>
							<div>
								<input class="w-40" type="text" name="memberRrnPrefix" value="${ modifyMemberBean.memberRrnPrefix }" maxlength="6" required="required"/>
								<input type="text" class="read-input w-20 text-center" readonly value="-"/>
								<input class="w-40" type="password" name="memberRrnSuffix" value="${ modifyMemberBean.memberRrnSuffix }" maxlength="7" required="required"/>
							</div>
						</div>
						<div>
							<div>패스워드<span class="required">*</span></div>
							<input type="password" name="memberPW" value="${ modifyMemberBean.memberPW }" required="required"/>
						</div>
					</div>
					<div class="content">
						<div>
							<div>연락처<span class="required">*</span></div>
							<input type="text" name="tel" value="${ modifyMemberBean.tel }" required="required" required="required"/>
						</div>
						<div>
							<div>패스워드 확인<span class="required">*</span></div>
							<input type="password" name="memberPW2" value="${ modifyMemberBean.memberPW2 }"/>
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
							<div>입사일<span class="required">*</span></div>
							<input type="date" name="hireDate" required="required" value="${ modifyMemberBean.hireDate }"/>
						</div>
						<div id="resignationDateDiv" data-show="false">
							<div>퇴사일</div>
							<input type="date" name="resignationDate" value="${ modifyMemberBean.resignationDate }"/>
						</div>
					</div>
					<div class="flex">
						<div class="w-10">주소<span class="required">*</span></div>
						<div class="w-70">
							<div class="flex">
								<input type="text" class="w-30" id="sample6_postcode" name="zoneCode" placeholder="우편번호" value="${ modifyMemberBean.zoneCode }" required="required" onfocus="this.focusout();">
								<button type="button" class="btn" onclick="postCodeEvent()">우편번호 찾기</button>
							</div>
							<div>
								<input type="text" id="sample6_address" name="address" placeholder="주소" required="required" value="${ modifyMemberBean.address }" onfocus="this.focusout();"><br>
							</div>
							<div class="flex" style="margin: 0;">
								<input type="text" id="sample6_detailAddress" name="detailAddress" value="${ modifyMemberBean.detailAddress }" placeholder="상세주소">
								<input type="text" id="sample6_extraAddress" name="extraAddress" value="${ modifyMemberBean.extraAddress }" placeholder="참고항목">
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

document.querySelector('input[name="memberImage"]').addEventListener('change', memberImageChangeEvent); // 이미지 변경 이벤트

let checkId = true;
let checkPassword = true;

addDropdownEvent();
dropdownCheckboxClickEvent();
modifuMemberStartup();

function modifuMemberStartup(){
	const preview = document.getElementById('preview');
	if(preview.naturalWidth !== 0){
		preview.src = '${root}resources/images/member/default.jpg';
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

//패스워드 비교 펑션
function passwordChangeEvent(){
	const pw = document.querySelector('input[name="memberPW"]').value;
	const pw2 = document.querySelector('input[name="memberPW2"]').value;
	
	if(pw == '' && pw2 == ''){
		checkPassword = true;
	} else if(pw == pw2){
		checkPassword = true;
	} else {
		checkPassword = false;
	}
}

//재직상태가 퇴직일 경우 퇴직일input을 보여주는 함수
function resignationDateShowEvent(){
	const statusCode = document.querySelector('select[name="statusCode"]').value;
	const resignationDateDiv = document.getElementById('resignationDateDiv');
	
	if(statusCode == '3'){
		resignationDateDiv.dataset.show = true;
	} else {
		resignationDateDiv.dataset.show = false;
	}
}
</script>
</html>