<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>INNOBL - 사원</title>
<script src="${root}resources/lib/javascript/jquery-3.7.1.min.js"></script>
<!-- select2 -->
<link href="${root}resources/lib/style/select2.min.css" rel="stylesheet" />
<script src="${root}resources/lib/javascript/select2.min.js"></script>
<!-- SweetAlert2 -->
<link href="${root}resources/lib/style/sweetalert2.min.css" rel="stylesheet"/>
<script src="${root}resources/lib/javascript/sweetalert2.min.js"></script>
<!-- 외부 css -->
<link rel="stylesheet" href="${root}resources/style/Main.css" />
<style>
#searchForm {
	border-radius: 4px;
	border: 1px solid black;
	padding: 10px;
	width: 960px;
	margin-top: 130px;
}

#searchForm > div {
	margin: 14px 0;
}

table tr {
	height: 40px;
}

#searchForm > div{
	display: flex;
}

#searchForm > div > *{
	width: 16%;
}

#searchForm > div > div{
	text-align: center;
}

#searchForm .text-center{
	display: block;
}
</style>
</head>
<body>
	<c:import url="/WEB-INF/views/include/TopMenu.jsp"></c:import>
	<!-- 검색 -->
	<header>
		<form action="#" onsubmit="return false;" id="searchMember">
			<div id="searchForm" class="container-center">
				<div class="flex">
					<div class="w-10">사원명</div>
					<input type="text" name="memberName" placeholder="입력..."/>
					<div>부서</div>
					<select name="departmentCode">
						<option value="">-전체-</option>
						<c:forEach var="item" items="${ departmentList }">
							<option value="${ item.detailCode }">${ item.codeName }</option>
						</c:forEach>
					</select>
					<div>직급</div>
					<select name="positionCode" >
						<option value="">-전체-</option>
						<c:forEach var="item" items="${ positionList }">
							<option value="${ item.detailCode }">${ item.codeName }</option>
						</c:forEach>
					</select>
				</div>
				<div class="flex">
					<div>입사일</div>
					<input type="date" name="firstDate"/>
					<div>~</div>
					<input type="date" name="secondDate"/>
					<div>재직상태</div>
					<select name="statusCode">
						<option value="">-전체-</option>
						<c:forEach var="item" items="${ statusList }">
							<option value="${ item.detailCode }">${ item.codeName }</option>
						</c:forEach>
					</select>
				</div>
				<div class="text-center w-100">
					<button type="submit" class="btn btn-green">조회</button>
					<button type="reset" class="btn btn-orange">초기화</button>
				</div>
			</div>
			<div class="container-center text-right" style="width: 960px; margin-top: 10px;">
				<select name="view" class="w-10">
					<c:forEach var="item" items="${ viewList }">
						<option value="${ item }" ${ item == searchMemberBean.view ? 'selected' : '' }>${ item }개</option>
					</c:forEach>
				</select>
			</div>
		</form>
	</header>
	
	<section>
		<!-- 검색 결과 테이블 -->
		<section>
			<table class="container-center">
				<colgroup>
					<!-- checkbox -->
					<col style="width: 55px" />
					<!-- 사원번호 -->
					<col style="width: 70px" />
					<!-- 사원명 -->
					<col style="width: 200px" />
					<!-- 입사일 -->
					<col style="width: 200px" />
					<!-- 부서 -->
					<col style="width: 130px" />
					<!-- 직급 -->
					<col style="width: 130px" />
					<!-- 재직상태 -->
					<col style="width: 130px" />
					<!-- 프로젝트 관리 -->
					<col style="width: 110px" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" class="allCheck" /></th>
						<th scope="col">사원번호</th>
						<th scope="col">사원명</th>
						<th scope="col">입사일</th>
						<th scope="col">부서</th>
						<th scope="col">직급</th>
						<th scope="col">재직상태</th>
						<th scope="col">프로젝트 관리</th>
					</tr>
				</thead>
				<tbody id="searchMemberResult">
					<c:choose>
						<c:when test="${ fn:length(memberList) == 0 }">
							<tr>
								<td class="text-center" colspan="8">
									검색 결과가 없습니다.
								</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="item" items="${ memberList }">
								<tr>
									<td><input type="checkbox" class="check"/></td>
									<td>${ item.memberNumber }</td>
									<td><a href="javascript:showMemberInfoModal(${ item.memberNumber });">${ item.memberName }</a></td>
									<td>${ item.hireDate }</td>
									<td>${ item.department }</td>
									<td>${ item.position }</td>
									<td>${ item.status }</td>
									<td><button class="btn">관리</button></td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</section>
		<section class="container-center" style="width: 1025px;">
			<div class="flex">
				<div class="w-30"></div>
				<div class="w-40 text-center" id="pageButton">
					<c:if test="${ preBtn != null && preBtn != '' }">
						<button type="button" class="btn" data-page="${ preBtn }">이전</button>
					</c:if>
					<c:forEach var="item" items="${ pageBtns }">
						<c:choose>
							<c:when test="${ item == page }">
								<button type="button" class="btn" disabled="disabled">${ item + 1 }</button>
							</c:when>
							<c:otherwise>
								<button type="button" class="btn" data-page="${ item }">${ item + 1 }</button>
							</c:otherwise>
						</c:choose>
					</c:forEach>
					<c:if test="${ nextBtn != null && nextBtn != '' }">
						<button type="button" class="btn" data-page="${ nextBtn }">다음</button>
					</c:if>
				</div>
				<div class="w-30 text-right">
					<button class="btn btn-green" onclick="location.href='${root}member/addMember/'">등록</button>
					<button class="btn btn-red">삭제</button>
				</div>
			</div>
		</section>
	</section>
	<script src="${root}resources/javascript/Main.js"></script>
	<div id="modalMemberInfo"></div>
	<div id="modalMemberProject"></div>
	<div id="modalMemberAddProject"></div>
</body>
<script>
modalStack = [];
let searchData = {
	'memberName' : `${searchMemberBean.memberName}`,
	'departmentCode' : `${searchMemberBean.departmentCode}`,
	'positionCode' : `${searchMemberBean.positionCode}`,
	'firstDate' : `${searchMemberBean.firstDate}`,
	'secondDate' : `${searchMemberBean.secondDate}`,
	'statusCode' : `${searchMemberBean.statusCode}`,
	'view' : `${searchMemberBean.view}`
};

document.getElementById('searchMember').addEventListener('submit', searchMemberSubmitEvent);	// 조회버튼 클릭 이벤트
document.querySelector('select[name="view"]').addEventListener('change', viewChangeEvent);		// view 변경 이벤트

memberMainStartup();
checkEvent();
addPageButtonEvnet();

function memberMainStartup(){
	const memberNumber = `${memberNumber}`;
	if(memberNumber != ''){
		showMemberInfoModal(memberNumber);
	}
}

// 조회 버튼 클릭 이벤트
function searchMemberSubmitEvent(){
	searchData = {
		'memberName' : 		this.querySelector('input[name="memberName"]').value,
		'departmentCode' : 	this.querySelector('select[name="departmentCode"]').value,
		'positionCode' : 	this.querySelector('select[name="positionCode"]').value,
		'firstDate' : 		this.querySelector('input[name="firstDate"]').value,
		'secondDate' : 		this.querySelector('input[name="secondDate"]').value,
		'statusCode' : 		this.querySelector('select[name="statusCode"]').value,
		'view' : 			this.querySelector('select[name="view"]').value
	};
	
	searchAjax();
}

// 페이지 버튼 이벤트 추가 함수
function addPageButtonEvnet(){
	const pageButtons = document.querySelectorAll('#pageButton button');
	pageButtons.forEach(button => {
		button.removeEventListener('click', pageButtonEvent);
		button.addEventListener('click', pageButtonEvent);
	});
}

// 페이지 버튼 클릭 이벤트
function pageButtonEvent(){
	const page = this.dataset.page;
	searchData.page = page;
	
	searchAjax();
}

// view 변경 이벤트
function viewChangeEvent(){
	const view = this.value;
	searchData.view = view;
	
	searchAjax();
}

// 검색 ajax
function searchAjax(){
	$.ajax({
		url: '/OJT/member/searchMember',
		method: 'POST',
		dataType: 'json',
		data: searchData,
		success: function(result){
			
			const searchMemberResult = document.getElementById('searchMemberResult');
			const pageButton = document.getElementById('pageButton');
			
			const memberList = result.memberList;
			const preBtn = result.preBtn;
			const pageBtns = result.pageBtns;
			const nextBtn = result.nextBtn;
			const page = result.page;
			
			let searchMemberResultHTML = '';
			if(memberList.length == 0){
				searchMemberResultHTML = '<tr><td colspan="8">검색결과가 없습니다.</td></tr>';
			} else {
				for(const member of memberList){
					searchMemberResultHTML += 	'<tr>' + 
												'<td><input type="checkbox" class="check"/></td>' +
												'<td>' + member.memberNumber + '</td>' + 
												'<td><a href="javascript:showMemberInfoModal(' + member.memberNumber + ');">' + member.memberName + '</a></td>' + 
												'<td>' + member.hireDate + '</td>' +
												'<td>' + member.department + '</td>' +
												'<td>' + member.position + '</td>' + 
												'<td>' + member.status + '</td>' +
												'<td><button type="button" class="btn">관리</button></td>' +
												'</tr>';
				}
			}
			searchMemberResult.innerHTML = searchMemberResultHTML;
			checkEvent();
			
			let pageButtonHtml = '';
			if(preBtn != null){
				pageButtonHtml += '<button type="button" class="btn" data-page="' + preBtn + '">이전</button>';
			}
			for(const index of pageBtns){
				if(index == page){
					pageButtonHtml += '<button type="button" class="btn" disabled="disabled">' + (index + 1) + '</button>';
				} else {
					pageButtonHtml += '<button type="button" class="btn" data-page="' + index + '">' + (index + 1) + '</button>';
				}
			}
			if(nextBtn != null){
				pageButtonHtml += '<button type="button" class="btn" data-page="' + nextBtn + '">이후</button>';
			}
			
			pageButton.innerHTML = pageButtonHtml;
			addPageButtonEvnet();
		},
		error: function(error){
			console.error(error);
		}
	});
}

// 사원 상세정보 모달
function showMemberInfoModal(memberNumber){
	$.ajax({
		url: '/OJT/member/memberInfo',
		method: 'POST',
		dataType: 'html',
		data: {
			'memberNumber' : memberNumber
		},
		success: function(result){
			$('#modalMemberInfo').html(result);
		},
		error: function(error){
			Swal.fire('존재하지 않는 사원입니다.', '', 'error');
		}
	});
}

</script>
</html>