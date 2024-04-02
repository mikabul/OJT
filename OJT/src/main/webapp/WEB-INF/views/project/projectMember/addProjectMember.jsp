<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
	.modal table td {
		text-align: center;
	}
</style>
</head>
<body>
	<div class="modal-background">
		<div class="modal">
			<header>
				<div class="w-30">
					<!-- 공백 -->	
				</div>
				<div class="w-40 text-center">
					인원 등록
				</div>
				<div class="w-30 text-right">
					<button type="button" class="closeBtn" id="addProjectMemberClose">
						<img src="${root}resources/images/x.png" alt="닫기" />
					</button>
				</div>
			</header>
			<section>
				<form id="addProjectMemberSearch">
					<div class="flex">
						<div>사원명</div>
						<div>
							<input type="text" name="memberName"/>
						</div>
						<div>
							<button type="button" id="asdasd">조회</button>
						</div>
					</div>
				</form>
			</section>
			<section>
				<div id="scrollDiv" data-scroll="9">
					<table>
						<colgroup>
							<!-- 체크 박스 -->
							<col style="width: 30px;"/>
							<!-- 사원 번호 -->
							<col style="width: 80px;"/>
							<!-- 사원명 -->
							<col style="width: 80px;"/>
							<!-- 부서 -->
							<col style="width: 80px;"/>
							<!-- 직급 -->
							<col style="width: 80px;"/>
							<!-- 투입일 -->
							<col style="width: 120px;"/>
							<!-- 철수일 -->
							<col style="width: 120px;"/>
							<!-- 역할 -->
							<col style="width: 100px;"/>
						</colgroup>
						<thead>
							<tr>
								<td scope="col"><input type="checkbox" class="allCheck"/></td>
								<td scope="col">사원 번호</td>
								<td>사원명</td>
								<td>부서</td>
								<td>직급</td>
								<td>투입일</td>
								<td>철수일</td>
								<td>역할</td>
							</tr>
						</thead>
						<tbody>
							
						</tbody>
					</table>
				</div>
			</section>
			<section>
				<button type="button" class="btn btn-green" id="addProjectMemberButton">저장</button>
				<button type="button" class="btn btn-orange" id="">취소</button>
			</section>
		</div>
	</div>
</body>
<script>
	modalStack.push('#modalAddProjectMember');
	document.getElementById('addProjectMemberClose').addEventListener('click', closeEvent); // 닫기 버튼 이벤트
	document.getElementById('addProjectMemberSearch').addEventListener('submit', addProjectMemberSearchEvent); // 조회 이벤트
	
	let event = new Event('submit');
	console.log(event);
	document.getElementById('addProjectMemberSearch').dispatchEvent(event);
	/* 함수 실행 */
// 	document.querySelector(getCurrModal() + ' button[type="submit"]').click();
	
	// 닫기 이벤트
	function closeEvent(){
		$(modalStack.pop()).html('');
	}
	
	// 조회 이벤트
	function addProjectMemberSearchEvent(event){
		event.preventDefault(); // 기본이벤트 비활성화
				
		const currModal = getCurrModal();
		const memberName = document.querySelector(currModal + ' input[type="text"][name="memberName"]').value;
		const projectNumber = document.querySelector('input[type="hidden"][name="projectNumber"]').value;
		const projectStartDate = document.querySelector('input[type="hidden"][name="projectStartDate"]').value;
		const projectEndDate = document.querySelector('input[type="hidden"][name="projectEndDate"]').value;
		const maintEndDate = document.querySelector('input[type="hidden"][name="maintEndDate"]').value;
		let endDate;
	
		if(maintEndDate != ''){
			endDate = maintEndDate;
		} else {
			endDate = projectEndDate;
		}
		
		console.log(endDate);
		
		$.ajax({
			url: '/OJT/projectMember/addProjectMemberSearch',
			method: 'POST',
			traditional: true,
			data: {
				'memberName' : memberName,
				'projectNumber' : projectNumber,
				'startDate' : projectStartDate,
				'endDate' : endDate
			},
			success: function(result){
				document.querySelector(currModal + ' tbody').innerHTML = result;
				isScroll();
				checkEvent();
			}
		})
	}
	
</script>
</html>