<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>INNOBL - 프로젝트</title>
<link rel="stylesheet" href="${root}resources/style/Main.css" />
</head>
<c:import url="/WEB-INF/views/include/TopMenu.jsp"></c:import>
<body style="margin: 70px 20px;">
	<div style="margin: 0 10%;">
		<div class="between" style="margin-top: 100px;">
			<div style="width: 5%;">프로젝트</div>
			<div style="width: 90%;"><hr /></div>
		</div>
		
		<!-- ===== 검색 ===== -->
		<div>
			<form onsubmit="onkeyupEvent(); return false;">
				<table class="table-center" style="margin-top: 30px;">
					<colgroup>
						<col style="width: 200px"/>
						<col style="width: 200px"/>
						<col style="width: 100px"/>
					</colgroup>
					<tbody>
						<tr>
							<td>
								<label>프로젝트 명</label>
								<input class="w-100" type="search" id="prj_nm" />
								
							</td>
							<td>
								<label>고객사</label>
								<input class="w-100" type="text" list="list" id="cust_nm" name="cust_nm"/>
								<datalist id="list"></datalist>
							</td>
							<td></td>
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
									<option value="prj_st_dt">시작일</option>
									<option value="prj_ed_dt">종료일</option>
									</select>
									<input class="w-30" type="date" name="firstDate" id="firstDate" min="2000-01-01" max="9999-12-31"/>
									<span> ~ </span>
									<input class="w-30" type="date" name="secondDate" id="secondDate" min="2000-01-01" max="9999-12-31"/>
								</div>
							</td>
							<td>
								<button type="button" class="btn-sm" onclick="textOnclick()">조회</button>
							</td>
						</tr>
					</tbody>
				</table>
			</form>
		</div>
		<!-- 등록 버튼 -->
		<div class="text-right" style="margin-top: 30px;">
			<button class="btn btn-green" onclick="location.href='${root}project/projectRegi'">등록</button>
		</div>
		
		<!-- ===== 검색 결과 ====== -->
		<div>
			<table class="table-center w-100" style="border: 1px solid black;">
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
				<thead id="projectListTableHead">
					
				</thead>
				<tbody id="projectListTable">
					
				</tbody>
			</table>
			
			<!-- 페이지 버튼과 삭제 버튼 -->
			<div>
				<table class="w-100">
					<tr>
						<td class="col-3"></td>
						<td class="text-center col-3" id="pageBtn">
							
						</td>
						<td class="text-right col-3" style="width: 33%;">
							<button class="btn btn-red">삭제</button>
						</td>
					</tr>
				</table>	
			</div>
		</div>
	</div>
</body>
<script>

	// 검색을 위한 변수
	let prj_nm;
	let cust_nm;
	let dateType;
	let firstDate;
	let secondDate;
	let index;
	let view;
	
	// 테이블 헤드
	const projectListTableHtml = '<tr>'
							+	'<td scope="col" class="text-center"><input type="checkbox" onclick=""/></td>'
							+	'<td scope="col" class="text-center">프로젝트 번호</td>'
							+	'<td scope="col" class="text-center">프로젝트 명</td>'
							+	'<td scope="col" class="text-center">고객사</td>'
							+	'<td scope="col" class="text-center">시작일</td>'
							+	'<td scope="col" class="text-center">종료일</td>'
							+	'<td scope="col" class="text-center">상태</td>'
							+	'<td scope="col" class="text-center">인원 관리</td></tr>';
	
	// 첫번째 검색
	$(document).ready(function(){
		projectSearchParam();
		projectSearchFetch();
	})
	
	// 프로젝트 검색 값 저장
	function projectSearchParam(){
		prj_nm = $('#prj_nm').val();
		cust_nm = $('#cust_nm').val();
		dateType = $('#dateType').val();
		firstDate = $('#firstDate').val();
		secondDate = $('#secondDate').val();
		view = $('#view').val();
		index = 1;
	}
	
	// fetch
	function projectSearchFetch(){
		
		fetch('${root}projectFetch/searchProject',{
			method: 'POST',
			headers: {
				'Content-Type' : 'application/json' // 데이터를 json으로 전송
			},
			body: JSON.stringify({ // 데이터를 json화
				prj_nm : prj_nm,
				cust_nm : cust_nm,
				dateType : dateType,
				firstDate : firstDate,
				secondDate : secondDate,
				index : index
			})
		}).then(response => {
			if(response.ok){
				return response.json();
			} else {
				throw new Error('응답 문제');
			}
		}).then(json => {
			
			let projectList = json.projectList;
			let pageBtns = json.pageBtns;
			let page = json.page;
			
			drawProjectTable(projectList);
			
		}).catch(error => {
			console.log('fetch 에러');
			console.log(error)
		});
		
	}
	
	// 테이블 작성
	function drawProjectTable(projectList){
		
		// 테이블 변수
		let projectTableHeadHtml = '';
		let projectTableListHtml = '';
		
		// 검색결과가 없을 시
		if(projectList.length == 0){
			
			$('#projectListTableHead').html('<tr><td colspan="8" class="text-center">조회 결과가 없습니다.</td></tr>');
			$('#projectListTable').html('');
			return;
		}
		
		// 테이블 바디 작성
		for(let i = 0; i < projectList.length; i++){
			projectTableListHtml += '<tr>'
							+	'<td class="text-center"><input type="checkbox" name="deleteProjectSeq[]" value="' + projectList[i].prj_seq + '" /></td>'
							+	'<td class="text-center">' + projectList[i].prj_seq + '</td>'
							+	'<td class="text-left"><a href="#">' + projectList[i].prj_nm + '</a></td>'
							+	'<td class="text-left">' + projectList[i].cust_nm + '</td>'
							+	'<td class="text-center">' + projectList[i].prj_st_dt + '</td>'
							+	'<td class="text=center">' + projectList[i].prj_ed_dt + '</td>'
							+	/* 작성필요 */'<td class="text-center">진행 중</td>'
							+	'<td class="text-center"><button class="btn" onclick="location.href=\'#\'">인원관리</button>'
							+	'</tr>';
		}
		
		// 테이블 출력
		$('#projectListTableHead').html(projectListTableHtml);
		$('#projectListTable').html(projectTableListHtml);
		
	}
</script>
</html>