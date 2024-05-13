<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원 상세 정보</title>
<style>
	#modalMemberInfo .modal {
		width: 1000px;
	}
	
	#modalMemberInfo .content {
		display: flex;
		align-items: center;
		margin-top: 10px;
		margin-left: 10px;
	}
	
	#modalMemberInfo .content > div {
		width: 50%;
		display: flex;
		align-items: center;
	}
	
	#modalMemberInfo .content > div > div:nth-child(1){
		width: 40%;
	}
	
	#modalMemberInfo .content > div > div:nth-child(2){
		width: 60%;
	}
	
	#modalMemberInfo .img-container {
		display: flex;
		justify-content: center;
		align-items: center;
		margin-right: 10px;
	}
	
	#modalMemberInfo .scroll {
		min-height: 620px;
		max-height: 620px;
	}
	
	#memberImage {
		max-width: 300px;
		max-height: 400px;
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
					<h2>사원 상세 정보</h2>
				</div>
				<div class="w-30 text-right">
					<button type="button" class="closeBtn" id="memberInfoCloseButton">
						<img src="${root}resources/images/x.png" alt="닫기" />
					</button>
				</div>
			</header>
			<div class="scroll">
				<section>
					<div class="flex">
						<div class="w-40 img-container">
							<img class="container-center" alt="EmptyImage" id="memberImage" src="${root}resources/images/member/${memberBean.pictureDir}">
						</div>
						<div class="w-60">
							<div class="content">
								<div>
									<div>이름</div>
									<div>${ memberBean.memberName }</div>
								</div>
								<div>
									<div>사원번호</div>
									<div>${ memberBean.memberNumber }</div>
								</div>
							</div>
							<div class="content">
								<div>
									<div>생년월일</div>
									<div>${ memberBean.memberRrnPrefix }</div>
								</div>
								<div>
									<div>ID</div>
									<div>${ memberBean.memberId }</div>
								</div>
							</div>
							<div class="content">
								<div>
									<div>연락처</div>
									<div>${ memberBean.tel }</div>
								</div>
								<div>
									<div>비상연락처</div>
									<div>${ memberBean.emTel }</div>
								</div>
							</div>
							<div class="content">
								<div>
									<div>부서</div>
									<div>${ memberBean.department }</div>
								</div>
								<div>
									<div>직급</div>
									<div>${ memberBean.position }</div>
								</div>
							</div>
							<div class="content">
								<div>
									<div>재직상태</div>
									<div>${ memberBean.status }</div>
								</div>
								<div>
									<div>보유기술</div>
									<div>
										<div class="w-100 dropdown">
											<div class="dropdown-header">
												<div class="dropdown-label ellipsis" title="">
													${ memberBean.skillString }
												</div>
												<div class="dropdown-icon">▼</div>
											</div>
											<div class="dropdown-menu" data-show="false">
												<c:forEach var="item" items="${ memberBean.skills }">
													<div>${ item }</div>
												</c:forEach>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="content">
								<div>
									<div>입사일</div>
									<div>${ memberBean.hireDate }</div>
								</div>
								<div>
									<c:if test="${ memberBean.resignationDate != null }">
										<div>퇴사일</div>
										<div>${ memberBean.resignationDate }</div>
									</c:if>
								</div>
							</div>
							<div>
								<div class="flex" style="margin-top: 10px; margin-left: 10px;">
									<div class="w-20">주소</div>
									<div class="w-80">
										(${ memberBean.zoneCode })${ memberBean.address }
										<c:if test="${ memberBean.detailAddress != null }">
											,&nbsp;${ memberBean.detailAddress }
										</c:if>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="text-right">
						<button type="button" class="btn btn-green" onclick="location.href='${root}member/modifyMember/?memberNumber=${ memberBean.memberNumber }'">수정</button>
					</div>
				</section>
				<section>
					<div class="flex">
						<div>참여 프로젝트</div>
						<hr class="text-line"/>
					</div>
					<div>
						<table class="container-center">
							<colgroup>
								<col style="width: 300px;"/>
								<col style="width: 300px;"/>
								<col style="width: 100px;"/>
								<col style="width: 100px;"/>
								<col style="width: 100px;"/>
							</colgroup>
							<thead>
								<tr>
									<th scope="col">프로젝트 명</th>
									<th scope="col">고객사</th>
									<th scope="col">투입일</th>
									<th scope="col">철수일</th>
									<th scope="col">역할</th>
								</tr>
							</thead>
							<tbody id="memberProjects">
								<c:forEach var="item" items="${ projectMemberList }">
									<tr>
										<td class="text-left">${ item.projectName }</td>
										<td>${ item.customerName }</td>
										<td>${ item.startDate }</td>
										<td>${ item.endDate }</td>
										<td>${ item.roleName }</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
					<div class="text-right">
						<button type="button" class="btn btn-green" id="modifyMemberProjectButton">수정</button>
					</div>
				</section>
			</div>
		</div>
	</div>
</body>
<script>
modalStack.push('#modalMemberInfo');
currModal = getCurrModalDom();

document.getElementById('memberInfoCloseButton').addEventListener('click', memberInfoCloseEvent);		// 닫기 이벤트
document.getElementById('modifyMemberProjectButton').addEventListener('click', modifyMemberProject);	// 프로젝트 수정 버튼 클릭 이벤트

addDropdownEvent();

// 닫기 이벤트
function memberInfoCloseEvent(){
	$(modalStack.pop()).html('');
	currModal = getCurrModalDom();
	window.history.pushState({}, '', window.location.pathname);
}

// 프로젝트 수정 버튼 클릭 이벤트
function modifyMemberProject(){
	const memberNumber = `${ memberBean.memberNumber }`;
	const memberName = `${ memberBean.memberName }`;
	
	location.href='/OJT/member/memberProject/info/' + memberNumber + '/' + memberName + '/';
}

</script>
</html>