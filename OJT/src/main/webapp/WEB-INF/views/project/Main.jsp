<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>INNOBL - 프로젝트</title>
</head>
<c:import url="/WEB-INF/views/include/TopMenu.jsp"></c:import>
<style>
.ellipsis {
	overflow: hidden;
	white-space: nowrap;
	text-overflow: ellipsis;
}

.text-center {
	text-align: center;
}

.sk-list {
	max-width: 20%;
}

.between {
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	align-items: center;
}

.justify-content-center {
	display: flex;
	flex-direction: row;
	justify-content: space-around;
	align-items: center;
}

.btn {
	border-radius: 10px;
    padding: 5px 4px;
    font-size: 15px;
    font-weight: 900;
    background-color: unset;
    border: 2px solid black;
    color: black;
    margin: 5px;
}

.btn:hover {
	background-color: #F1F3F4;
}

.btn-sm {
	border-radius: 10px;
    padding: 2px 4px;
    font-size: 15px;
    background-color: unset;
    border: 1px solid black;
    color: black;
}

.btn-sm:hover {
	background-color: #F1F3F4;
}

.search-td {
	margin: 10px 0;
}

.w-10 {
	width: 10%;
}

.w-20 {
	width: 20%;
}

.w-30 {
	width: 30%;
}

.w-90 {
	width: 90%;
}

.w-100 {
	width: 100%;
}

a {
	text-decoration: none;
	color: black;
}
</style>
<body style="margin: 70px 20px;">
	<div style="width: 80%; margin: 0 10%;">
		<div class="between" style="margin-top: 100px;">
			<div style="width: 5%;">프로젝트</div>
			<div style="width: 90%;"><hr /></div>
		</div>
		
		<!-- ===== 검색 ===== -->
		<div>
			<form onsubmit="onkeyupEvent(); return false;">
				<table style="margin-top: 30px;">
					<colgroup>
						<col style="width: 200px"/>
						<col style="width: 200px"/>
						<col style="width: 100px"/>
					</colgroup>
					<tbody>
						<tr>
							<td>
								<label>프로젝트 명</label>
								<input class="w-100" type="search" id="prj_nm" oninput="onkeyupEvent()"/>
								
							</td>
							<td class="search-td">
								<label>고객사</label>
								<input class="w-100" type="text" list="list" id="cust_nm" name="cust_nm" onkeyup="onkeyupEvent()"/>
								
								<datalist id="list"></datalist>
							</td>
							<td class="search-td"></td>
						</tr>
						<tr>
							<td><p id="prj_nm_error" class="errorMsg"></p></td>
							<td><p id="cust_nm_error" class="errorMsg"></p></td>
						</tr>
						<tr>
							<td colspan="2">
								<div class="between" style="margin-top: 30px;">
									<div style="width: 25%;">기간 검색</div>
									<div style="width: 70%;"><hr /></div>
								</div>
							</td>
							<td></td>
						</tr>
						<tr>
							<td colspan="2">
								<div class="between">
									<select name="dateType" id="dateType" class="w-20">
									<option value="prj_st_dt">시작</option>
									<option value="prj_ed_dt">종료</option>
									</select>
									<input class="w-30" type="date" name="firstDate" id="firstDate" min="${minDate }" max="${maxDate }"/>
									<span> ~ </span>
									<input class="w-30" type="date" name="secondDate" id="secondDate" min="${minDate }" max="${maxDate }"/>
								</div>
							</td>
							<td class="search-td">
								<button class="btn-sm" type="submit">조회</button>
							</td>
						</tr>
					</tbody>
				</table>
			</form>
		</div>
		<!-- 등록 버튼 -->
		<div style="margin-top: 30px; text-align: right;">
			<button class="btn" onclick="location.href='${root}project/projectRegi'">등록</button>
		</div>
		
		<!-- ===== 검색 결과 ====== -->
		<div>
			<table style="border: 1px solid black; margin: 0 auto; width: 100%">
				<colgroup>
					<!--  -->
					<col style="width: 5%"/>
					<!-- 프로젝트 번호 -->
					<col style="width: 10%;">
					<!-- 프로젝트 명 -->
					<col style="width: 20%;">
					<!-- 고객사 -->
					<col style="width: 20%;">
					<!-- 시작일 -->
					<col style="width: 10%;">
					<!-- 종료일 -->
					<col style="width: 10%;">
					<!-- 필요 기술 -->
					<col style="width: 15%;">
					<!-- 인원 관리 -->
					<col style="width: 10%;">
				</colgroup>
				<tr>
					<th scope="col"><input type="checkbox" /></th>
					<th scope="col">번호</th>
					<th scope="col">프로젝트 명</th>
					<th scope="col">고객사</th>
					<th scope="col">시작일</th>
					<th scope="col">종료일</th>
					<th scope="col">필요 기술</th>
					<th scope="col">인원 관리</th>
				</tr>
				<tbody id="projectListTable">
					
				</tbody>
			</table>
			
			<!-- 페이지 버튼과 삭제 버튼 -->
			<div>
				<table style="width: 100%;">
					<tr>
						<td style="width: 33%;"></td>
						<td style="width: 33%; text-align: center;" id="pageBtn">
							<c:forEach var="item" items="${pageBtn}">
								<button class="pageBtns" index=${item * view + 1}>${item + 1}</button>
							</c:forEach>
						</td>
						<td style="width: 33%; text-align: right;">
							<button class="btn">삭제</button>
						</td>
					</tr>
				</table>	
			</div>
		</div>
	</div>
</body>
<script>

	let prj_nm;
	let cust_nm;
	let dateType;
	let firstDate;
	let secondDate;
	let index;
	
	function onkeyupEvent(){
		index = 1;
		getCustomerList();
		searchProject();
	}

	// 프로젝트 검색 함수
	function searchProject(){
		
		prj_nm = $("#prj_nm").val();
		cust_nm = $("#cust_nm").val();
		dateType = $("#dateType").val();
		firstDate = $("#firstDate").val();
		secondDate = $("#secondDate").val();
		
		fetch('${root}projectFetch/searchProject?'
				+ 'prj_nm=' + prj_nm
				+ '&cust_nm=' + cust_nm
				+ '&dateType=' + dateType
				+ '&firstDate=' + firstDate
				+ '&secondDate=' + secondDate
				+ '&index=' + index, {
			method: 'GET'
		})
		.then(response => {
			if(response.ok){
				return response.json();
			}
			return new Error('네트워크 응답 문제');
		})
		.then(result => {
			
			let projectHtml = '';
			let projectList = result.projectList;
			let pageBtns = result.pageBtns;
			let view = result.view;
			
			if(projectList == null){
				projectHtml += '<tr><td colspan="8" class="text-center">검색결과가 없습니다.</td></tr>';
			} else {
				for(let i = 0; i < projectList.length; i++){
					
					// 프로젝트 정보
					projectHtml += '<tr>'
								+	'<td class="text-center"><input type="checkbox" value="' + projectList[i].prj_seq + '"/></td>'
								+	'<td class="seq-num text-center">' + projectList[i].prj_seq + '</td>'
								+	'<td class="ellipsis text-center">'
								+ 	'<a href="${root}project/info?prj_seq=' + projectList[i].prj_seq + '">'
								+ 	projectList[i].prj_nm + '</a></td>'
								+	'<td class="ellipsis text-center">' + projectList[i].cust_nm + '</td>'
								+	'<td class="text-center">' + projectList[i].prj_st_dt + '</td>'
								+	'<td class="text-center">' + projectList[i].prj_ed_dt + '</td>'
								+	'<td class="ellipsis sk-list">';
					
					if(projectList[i].prj_sk_list){
						projectHtml += projectList[i].prj_sk_list[0];
						for(let j = 1; j < projectList[i].prj_sk_list.length; j++){
							projectHtml += '<span>, </span>' + projectList[i].prj_sk_list[j];
						}
					} else {
						projectHtml += '없음';
					}
					
					projectHtml += '</td>';
					
					//프로젝트 인원등록 버튼
					projectHtml += '<td class="text-center"><button class="btn-sm memberRegiBtn" prj_seq="' 
								+ 	projectList[0].prj_seq + '" prj_nm="' + projectList[0].prj_nm + '" '
								+	'cust_nm="' + projectList[0].cust_nm + '">'
								+	'인원관리</button>';
				}
			}
			
			$("#projectListTable").html(projectHtml);
				
			// 페이지 버튼 생성
			pageButtons(pageBtns, view);
			// 인원 관리버튼 이벤트 추가
			memberRegiBtnAddEvent();
		})
		.catch(error => {
			console.error('Fetch 실패');
		});
		
	}
	
	// 페이징 버튼 생성
	function pageButtons(pageBtns, view){
		let pageBtnsHtml = "";
		
		if(pageBtns == null){
			pageBtnsHtml += '<button class="btn pageBtns" index="1">1</button>';
		} else {
			for(let i = 0; i < pageBtns.length; i++){
				pageBtnsHtml += '<button class="btn pageBtns" index="' + (((pageBtns[i] - 1) * view) + 1) + '">'
				+	pageBtns[i] + '</button>';
			}
		}
		
		$('#pageBtn').html(pageBtnsHtml);
		
		addEventPageButtons();
	}
	
	//페이지 버튼 이벤트 추가
	function addEventPageButtons(){
		const pageBtns = document.querySelectorAll(".pageBtns");
		
		pageBtns.forEach(pageBtn => {
			// 기존 이벤트 삭제 후 재설정
			pageBtn.removeEventListener('click', eventPageButtons);
			pageBtn.addEventListener('click', eventPageButtons);
		})
	}
	
	// 페이지 버튼 이벤트
	function eventPageButtons(){
		index = this.getAttribute("index");
		searchProject();
	}

	// 고객사 검색 함수
	function getCustomerList(){
		let cust_nm = $("#cust_nm").val();
		
		fetch('${root}projectFetch/searchCustomer?cust_nm=' + cust_nm, {
			method: 'GET'
		})
		.then(response => {
			if(response.ok){
				$("#cust_nm_error").html('');
				return response.json();
			}
			
			if(response.status == 400){
				return response.json().then(errMsg => {
					$("#cust_nm_error").html('<span>' + errMsg + '</span>');
				})
			}
			return new Error('네트워크 응답 문제');
		})
		.then(result => {
			let html = '';
			if(result == null){
				html += '<option >검색 결과가 없습니다.</option>';	
			} else {
				for(var i = 0; i < result.length; i++){
					html += '<option >'
						+	result[i].cust_nm
						+	'</option>';
				}
			}
			
			$("#list").html(html);
		})
		.catch(error => {
			console.error('Fetch 작업에 문제가 있습니다:', error);
		});
		
	};
	
	// 인원등록 버튼 이벤트 추가
	function memberRegiBtnAddEvent(){
		const memberRegiBtn = document.querySelectorAll(".memberRegiBtn");
		
		memberRegiBtn.forEach(btn => {
			btn.removeEventListener('click', projectMemberRegi);
			btn.addEventListener('click', projectMemberRegi);
		})
	}
	
	// 인원등록 버튼 이벤트
	function projectMemberRegi(){
		let prj_seq = this.getAttribute("prj_seq");
		const popOption = 'width: 400px, height: 800px, top: 400px, left: 700px';
		const url = '${root}project/projectMemberRegi?prj_seq=' + prj_seq;
		
		window.open(url, 'pop', popOption);
		
	}
	
	$(document).ready(function(){
		index = 1;
		getCustomerList();
		addEventPageButtons();
		searchProject();
	});
</script>
</html>