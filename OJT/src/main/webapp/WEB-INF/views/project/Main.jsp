<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>INNOBL - 프로젝트</title>
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
	max-width: 150px;
}

.between {
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	align-items: center;
}
</style>
</head>
<c:import url="/WEB-INF/views/include/TopMenu.jsp"></c:import>
<body style="margin: 70px 20px;">
	<div class="between">
		<div style="width: 10%;">프로젝트</div>
		<div style="width: 80%;"><hr /></div>
	</div>
	<div>
		<form onsubmit="onkeyupEvent(); return false;">
			<label>프로젝트 명</label>
			<input type="search" id="prj_nm"/>
			<label>고객사</label>
			<input type="text" list="list" id="cust_nm" name="cust_nm" onkeyup="getCustomerList()"/>
			<datalist id="list"></datalist>
			<select name="dateType" id="dateType">
				<option value="prj_st_dt">시작</option>
				<option value="prj_ed_dt">종료</option>
			</select>
			<input type="date" name="firstDate" id="firstDate" min="${minDate }" max="${maxDate }"/>
			<input type="date" name="secondDate" id="secondDate" min="${minDate }" max="${maxDate }"/>
			<button type="submit">조회</button>
		</form>
	</div>
	<div>
		<table>
			<colgroup>
				<!-- 프로젝트 번호 -->
				<col style="width: 130px">
				<!-- 프로젝트 명 -->
				<col style="width: 300px">
				<!-- 고객사 -->
				<col style="width: 300px">
				<!-- 시작일 -->
				<col style="width: 120px">
				<!-- 종료일 -->
				<col style="width: 120px">
				<!-- 필요 기술 -->
				<col style="width: 270px">
			</colgroup>
			<tr>
				<th scope="col">프로젝트 번호</th>
				<th scope="col">프로젝트 명</th>
				<th scope="col">고객사</th>
				<th scope="col">시작일</th>
				<th scope="col">종료일</th>
				<th scope="col">필요 기술</th>
			</tr>
			<tbody id="projectListTable">
				<c:forEach var="item" items="${projectList}">
					<tr>
						<td class="seq-num text-center">${item.prj_seq }</td>
						<td class="ellipsis text-center">${item.prj_nm }</td>
						<td class="ellipsis text-center">${item.cust_nm }</td>
						<td class="text-center">${item.prj_st_dt }</td>
						<td class="text-center">${item.prj_ed_dt }</td>
						<td class="ellipsis text-center sk-list">${item.prj_sk_list[0] } 
							<c:if test="${fn:length(item.prj_sk_list) > 1}">
								<c:forEach var="i" begin="1" end="${fn:length(item.prj_sk_list) - 1}">
									<span>, </span>
									${item.prj_sk_list[i]}
								</c:forEach>
							</c:if>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<div id="pageButtons">
		
		</div>
	</div>
</body>
<script>

	var prj_nm;
	var cust_nm;
	var dateType;
	var firstDate;
	var secondDate;
	var index;
	
	function onkeyupEvent(){
		index = 1;
		searchProject();
	}

	// 프로젝트 검색 함수
	function searchProject(){
		
		prj_nm = $("#prj_nm").val();
		cust_nm = $("#cust_nm").val();
		dateType = $("#dateType").val();
		firstDate = $("#firstDate").val();
		secondDate = $("#secondDate").val();
		
		console.log(prj_nm);
		console.log(cust_nm);
		console.log(dateType);
		console.log(firstDate);
		console.log(secondDate);
		
		
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
				return response.json;
			}
			return new Error('네트워크 응답 문제');
		})
		.then(result => {
			
			var projectHtml = '';
			
			for(var i = 0; i < result.length; i++){
				
				projectHtml += '<tr>'
							+	'<td class="seq-num text-center">' + result[i].prj_seq + '</td>'
							+	'<td class="ellipsis text-center">' + result[i].prj_nm + '</td>'
							+	'<td class="ellipsis text-center">' + result[i].cust_nm + '</td>'
							+	'<td class="text-center">' + result[i].prj_st_dt + '</td>'
							+	'<td class="text-center">' + result[i].prj_ed_dt + '</td>'
							+	'<td class="ellipsis text-center sk-list">';
				
				if(result[i].prj_sk_list.length >= 1){
					projectHtml += result[i].prj_sk_list[0];
					for(var j = 1; j < result[i]; j++){
						projectHtml += '<span>, </span>' + result[i].prj_sk_list[j];
					}
				} else {
					projectHtml += '없음';
				}
				
				projectHtml += '</td></tr>';
				
			}
				$("#projectListTable").html(projectHtml);
			
		})
		.catch(error => {
			console.error('Fetch 실패');
		});
		
	}
	
	// 페이징 버튼 생성
	function pageButtons(){
		
	}
	
	// 페이지 버튼 이벤트
	function eventPageButtons(){
		
	}

	// 고객사 검색 함수
	function getCustomerList(){
		var cust_nm = $("#cust_nm").val();
		
		fetch('${root}projectFetch/searchCustomer?cust_nm=' + cust_nm, {
			method: 'GET'
		})
		.then(response => {
			if(response.ok){
				return response.json();
			}
			return new Error('네트워크 응답 문제')
		})
		.then(result => {
			console.log(result);
			var html = '';
			
			for(var i = 0; i < result.length; i++){
				html += '<option >'
					+	result[i].cust_nm
					+	'</option>';
			}
			
			$("#list").html(html);
		})
		.catch(error => {
			console.error('Fetch 작업에 문제가 있습니다:', error);
		});
		
	};
	
	$(document).ready(function(){
		getCustomerList();
	});
</script>
</html>