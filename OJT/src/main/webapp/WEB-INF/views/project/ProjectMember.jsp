<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${root}resources/style/Main.css" />
<style type="text/css">
	.modal header {
		display: flex;
		justify-content: center;\
	}
	
	.modal header > div{
		width: 33.3%;
	}
	
	.modal section{
		margin: auto;
		margin-top: 30px;
	}
	
	.modal section.justify-content-center > div > div{
		padding: 5px 4px;
		border: 1px solid #e6e6e6;
		height: 44px;
	}
	
	.modal table td input{
		text-align: center;
	}
</style>
</head>
<body>
	<div class="modal-background">
		<div class="modal">
			<header>
				<div></div>
				<div class="text-center"><h3>인원 관리</h3></div>
				<div class="text-right">
					<button type="button" class="closeBtn" id="projectMemberClose">
						<img src="${root}resources/images/x.png" alt="닫기" />
					</button>
				</div>
			</header>
			
			<section>
				<form:form modelAttribute="projectBean" method="POST" action="#">
					<section class="justify-content-center">
						<form:hidden path="projectNumber"/>
						<form:hidden path="projectStartDate"/>
						<form:hidden path="projectEndDate"/>
						<form:hidden path="maintEndDate"/>
						<div class="w-50 flex">
							<div class="w-30">프로젝트 명</div>
							<div class="w-70">
								<form:input path="projectName" class="read-input" readonly="true"/>
							</div>
						</div>
						<div class="w-50 flex">
							<div class="w-30">고객사</div>
							<div class="w-70">
								<form:input path="customerName" class="read-input" readonly="true"/>
							</div>
						</div>
					</section>
					<section>
						<div id="scrollDiv" data-scroll="6">
							<table class="container-center">
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
										<th scope="col"><input type="checkbox" class="allCheckbox"/></th>
										<th scope="col">사원 번호</th>
										<th scope="col">사원명</th>
										<th scope="col">부서</th>
										<th scope="col">직급</th>
										<th scope="col">투입일</th>
										<th scope="col">철수일</th>
										<th scope="col">역할</th>
									</tr>
								</thead>
								<tbody id="pmListBody">
									<c:forEach var="item" items="${ projectBean.pmList }" varStatus="status">
										<tr>
											<td><input type="checkbox" class="checkbox"/></td>
											<td>
												<form:input path="pmList[${ status.index }].memberNumber" class="read-input text-center" readonly="true"/>
											</td>
											<td>
												<form:input path="pmList[${ status.index }].memberName" class="read-input text-center" readonly="true"/>
											</td>
											<td>
												<form:input path="pmList[${ status.index }].department" class="read-input" readonly="true"/>
											</td>
											<td>
												<form:input path="pmList[${ status.index }].position" class="read-input text-center" readonly="true"/>
											</td>
											<td>
												<form:input type="date" path="pmList[${status.index}].startDate"/>
											</td>
											<td>
												<form:input type="date" path="pmList[${status.index}].endDate"/>
											</td>
											<td>
												<form:select path="pmList[${status.index}].roleCode">
													<c:forEach var="role" items="${ roleList }">
														<form:option value="${ role.detailCode }">${ role.codeName }</form:option>
													</c:forEach>
												</form:select>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</section>
					<section>
						<div class="text-right">
							<button type="button" class="btn btn-red" id="projectMemberDeleteButton">삭제</button>
							<button type="button" class="btn btn-green" id="projectMemberAddButton">추가</button>
						</div>
						<div class="text-center">
							<button type="submit" class="btn">저장</button>
							<button type="button" class="btn" id="projectMemberCloseButton">닫기</button>
						</div>
					</section>
				</form:form>
			</section>
		</div>
	</div>
	
</body>
<script type="text/javascript">
	
	/* 	페이지 로딩 끝날시 실행	*/
	modalStack.push('#modalProjectMember');
	document.getElementById('projectMemberClose').addEventListener('click', function(){ // 닫기버튼 이벤트
		modalStack.pop();
		$('#modalProjectMember').html('');
	});
	document.getElementById('projectMemberCloseButton').addEventListener('click', projectMemberCloseButtonEvent); // 취소 버튼 이벤트
	document.getElementById('projectMemberAddButton'). addEventListener('click', addPMModalBtnEvent); // 추가 버튼 이벤트
	
	isScroll(); // 프로젝트 멤버 리스트 스크롤
		
	// 프로젝트 멤버 리스트에 스크롤을 추가할지
	function pmListScroll(){
		const pmList = document.getElementById('PMList');
		const table = pmList.querySelector('table');
		const rows = table.rows;
		if(rows.length > 6){
			pmList.classList.add('scroll');
		} else {
			pmList.classList.remove('scroll');
		}
	}
	
	function projectMemberCloseButtonEvent(){
		modalStack.pop();
		$('#modalProjectMember').html('');
	}
	
</script>
</html>