<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>프로젝트 정보</title>
<style>
	
	.modal .container > div {
		display: flex;
		justify-content: space-between;
		align-items: center;
		border-bottom: 1px solid #F1F3F4;
		
	}
	
	.modal .row-4 > div:nth-child(1), .modal .row-4 > div:nth-child(3){
		width: 134px;
	}
	
	.modal .row-4 > div:nth-child(2), .modal .row-4 > div:nth-child(4){
		width: 198px;
/* 		border: 1px solid black; */
/* 		background-color: #F1F3F4; */
	}
	
	.modal .row-2 > div:nth-child(1){
		width: 134px;
	}
	
	.modal .row-2 > div:nth-child(2){
		width: 548px;
/* 		border: 1px solid black; */
/* 		background-color: #F1F3F4; */
	}
	
	.modal .row-2 > div, .modal .row-4 > div {
		margin-top: 3px;
		margin-bottom: 3px;
		border-radius: 0.3em;
	}
	
	.modal .container > div > div {
		min-height: 20px;
		padding: 6px 4px;
		display: flex;
		align-items: center;
	}
	
	.modal .text-area {
		min-height: 50px;
		font-size: 15px;
		max-height: 132px;
	}
	
	.modal section {
		margin-top: 30px;
	}

</style>
</head>
<body>
	<div class="modal-background">
		<div class="modal">
			<header>
				<div class="w-20"></div>
				<div class="w-60 text-center">
					<h3>프로젝트 정보</h3>
				</div>
				<div class="w-20 text-right">
					<button class="closeBtn" id="projectInfoClose">
						<img src="${root}resources/images/x.png" alt="" />
					</button>
				</div>
			</header>
			<section>
				<!-- 프로젝트 정보 -->
				<div class="container container-center">
					<div class="row-4">
						<div>프로젝트 번호</div>
						<div>${projectBean.projectNumber}</div>
						<div>프로젝트 상태</div>
						<div>${projectBean.projectStateName }</div>
					</div>
					
					<div class="row-2">
						<div>프로젝트 명</div>
						<div>${projectBean.projectName}</div>
					</div>
					
					<div class="row-2">
						<div>고객사</div>
						<div>${projectBean.customerName }</div>
					</div>
					
					<div class="row-4">
						<div>기간</div>
						<div>${projectBean.projectStartDate }</div>
						<div>
							<div class="w-100">~</div>
						</div>
						<div>${projectBean.projectEndDate }</div>
					</div>
					<div class="row-4">
						<div>유지보수</div>
						<div>${projectBean.maintStartDate }</div>
						<div>
							<div class="w-100">~</div>
						</div>
						<div>${projectBean.maintEndDate }</div>
					</div>
					<div class="row-2">
						<div>필요 기술</div>
						<div>
							<c:forEach var="item" items="${projectBean.projectSkillList }" varStatus="status">
								${item.codeName}
								<c:if test="${fn:length(projectBean.projectSkillList)-1 > status.index }">
									<span>,&nbsp;</span>
								</c:if>
							</c:forEach>
						</div>
					</div>
					
					<div class="row-2">
						<div>세부사항</div>
						<div>
							<textarea readonly="readonly" class="read-area">${projectBean.projectDetail}</textarea>
						</div>
					</div>
				</div>
			</section>
			
			<section>
				<div style="display: flex; align-items: center;">
					<div>멤버</div>
					<div class="text-line"><hr /></div>
				</div>
				<div id="scrollDiv" data-scroll="6">
					<table class="container-center">
						<colgroup>
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
								<th scope="col">사원 번호</th>
								<th scope="col">이름</th>
								<th scope="col">부서</th>
								<th scope="col">직급</th>
								<th scope="col">투입일</th>
								<th scope="col">철수일</th>
								<th scope="col">역할</th>
							</tr>
						</thead>
						<tbody id="projectMemberInfoBody">
							<c:choose>
								<c:when test="${fn:length(projectBean.pmList) == 0 }">
									<tr>
										<td colspan="7">등록된 멤버가 없습니다.</td>
									</tr>
								</c:when>
								<c:otherwise>
									<c:forEach var="item" items="${projectBean.pmList}">
										<tr>
											<td>${item.memberNumber }</td>
											<td>${item.memberName }</td>
											<td>${item.department }</td>
											<td>${item.position }</td>
											<td>${item.startDate }</td>
											<td>${item.endDate }</td>
											<td>${item.roleName }</td>
										</tr>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</div>
			</section>
			<section>
				<div>
					<div class="text-center">
						<button type="button" class="btn btn-green" id="modifyProjectInfoButton">수정</button>
						<button type="button" class="btn btn-orange" id="projectInfoCloseBtn">닫기</button>
					</div>
				</div>
			</section>
		</div>
	</div>
</body>
<script>
modalStack.push('#modalProject'); //modal이 열릴때 해당 모달의 아이디를 저장
currModal = getCurrModalDom();

$('#projectInfoClose').on('click', projectInfoCloseEvent);// 모달 닫기 이벤트
$('#projectInfoCloseBtn').on('click', projectInfoCloseEvent);// 모달 닫기 이벤트
document.getElementById('modifyProjectInfoButton').addEventListener('click', modifyProjectInfoButtonEvent); // 프로젝트 수정 모달

isScroll();

function projectInfoCloseEvent(){
	window.history.pushState({}, '', '/OJT/project/Main');
	$(modalStack.pop()).html('');
	currModal = getCurrModalDom();
}

function modifyProjectInfoButtonEvent(){
	const projectNumber = `${projectBean.projectNumber}`;
	
	$.ajax({
		url: '/OJT/projectModify/',
		method: 'GET',
		data: {
			'projectNumber' : projectNumber
		},
		success: function(result){
			$('#modalModifyProject').html(result);
		},
		error: function(error){
			Swal.fire('실패', '페이지로딩에 실패하였습니다.', 'error');
			console.error(error);
		}
	});
}
</script>
</html>