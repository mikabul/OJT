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
	.modal header{
		display: flex;
		align-items: center;
	}
	
	.container > div {
		display: flex;
		justify-content: space-between;
		align-items: center;
		border-bottom: 1px solid #F1F3F4;
		
	}
	
	.row-4 > div:nth-child(1), .row-4 > div:nth-child(3){
		width: 134px;
	}
	
	.row-4 > div:nth-child(2), .row-4 > div:nth-child(4){
		width: 198px;
/* 		border: 1px solid black; */
/* 		background-color: #F1F3F4; */
	}
	
	.row-2 > div:nth-child(1){
		width: 134px;
	}
	
	.row-2 > div:nth-child(2){
		width: 548px;
/* 		border: 1px solid black; */
/* 		background-color: #F1F3F4; */
	}
	
	.row-2 > div, .row-4 > div {
		margin-top: 3px;
		margin-bottom: 3px;
		border-radius: 0.3em;
	}
	
	.container > div > div {
		min-height: 20px;
		padding: 6px 4px;
		display: flex;
		align-items: center;
	}
	
	.text-area {
		min-height: 50px;
		font-size: 15px;
		max-height: 132px;
	}
	
	section {
		margin-top: 30px;
	}
	
	section:nth-child(3) > div:nth-child(2){
		height: 228px;
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
						<div>${projectBean.prj_seq}</div>
						<div>프로젝트 상태</div>
						<div>${projectBean.ps_nm }</div>
					</div>
					
					<div class="row-2">
						<div>프로젝트 명</div>
						<div>${projectBean.prj_nm}</div>
					</div>
					
					<div class="row-2">
						<div>고객사</div>
						<div>${projectBean.cust_nm }</div>
					</div>
					
					<div class="row-4">
						<div>기간</div>
						<div>${projectBean.prj_st_dt }</div>
						<div>
							<div class="w-100">~</div>
						</div>
						<div>${projectBean.prj_ed_dt }</div>
					</div>
					<div class="row-4">
						<div>유지보수</div>
						<div>${projectBean.maint_st_dt }</div>
						<div>
							<div class="w-100">~</div>
						</div>
						<div>${projectBean.maint_ed_dt }</div>
					</div>
					<div class="row-2">
						<div>필요 기술</div>
						<div>
							<c:forEach var="item" items="${projectBean.prj_sk_list }" varStatus="status">
								${item.dtl_cd_nm}
								<c:if test="${fn:length(projectBean.prj_sk_list)-1 > status.index }">
									<span>,&nbsp;</span>
								</c:if>
							</c:forEach>
						</div>
					</div>
					
					<div class="row-2">
						<div>세부사항</div>
						<div>
							<textarea readonly="readonly" class="read-area">${projectBean.prj_dtl}</textarea>
						</div>
					</div>
				</div>
			</section>
			
			<section>
				<div style="display: flex; align-items: center;">
					<div>멤버</div>
					<div class="text-line"><hr /></div>
				</div>
				<div>
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
											<td>${item.mem_seq }</td>
											<td>${item.mem_nm }</td>
											<td>${item.dept }</td>
											<td>${item.position }</td>
											<td>${item.st_dt }</td>
											<td>${item.ed_dt }</td>
											<td>${item.role }</td>
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
						<button type="button" class="btn btn-green" id="projectModifyBtn">수정</button>
						<button type="button" class="btn btn-orange" id="projectInfoCloseBtn">닫기</button>
					</div>
				</div>
			</section>
		</div>
	</div>
</body>
<script>
modalStack.push('#modalProject'); //modal이 열릴때 해당 모달의 아이디를 저장
projectInfoMemberScroll(); // 스크롤

// 모달 닫기
$('#projectInfoClose').on('click', function(){
	window.history.pushState({}, '', '/OJT/project/Main');
	$('#modalProject').html('');
	modalStack.pop();
})

$('#projectInfoCloseBtn').on('click', function(){
	window.history.pushState({}, '', '/OJT/project/Main');
	$('#modalProject').html('');
	modalStack.pop();
});

// 프로젝트 멤버 인원이 6명 이상일때 스크롤 추가
function projectInfoMemberScroll(){
	let projectMemberInfoBody = document.getElementById('projectMemberInfoBody');
	let rows = projectMemberInfoBody.rows;
	if(rows.length >= 6){
		let section = document.querySelectorAll('section')[1];
		let div = section.querySelectorAll('div')[3];
		div.classList.add('scroll');
		console.log(section);
		console.log(div);
	}
}
</script>
</html>