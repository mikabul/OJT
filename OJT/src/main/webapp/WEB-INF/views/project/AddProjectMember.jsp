<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>프로젝트 등록 - 멤버 추가</title>
<style>
#resultAddPMTable {
	min-height: 440px;
}

header {
	margin-top: 10px;
}

section {
	margin-top: 20px;
}

section div {
	display: flex;
	align-items: center;
}

section div * {
	margin: 0 4px;
}

article div {
	margin-top: 20px;
}

#search {
	width: 300px;
}
</style>
</head>
<body>
	<div class="modal-background">
		<div class="modal">
			<header>
				<div class="justify-content-center">
					<div class="w-20">
						
					</div>
					<div class="text-center w-60">
						<h3>프로젝트 등록 - 멤버 추가</h3>
					</div>
					<div class="text-right w-20">
						<button type="button" class="closeBtn" id="addProjectMemberClose">
							<img src="${root}resources/images/x.png" alt="" />
						</button>
					</div>
				</div>
			</header>
			<section>
				<div>
					<div class="container-center">
						<label for="search">사원명</label>
						<input type="search" name="search" id="search"/>
						<button type="button" id="searchBtn" class="btn btn-green">조회</button>
					</div>
				</div>
			</section>
			<article>
				<div id="resultAddPMTable">
					<table class="container-center">
						<colgroup>
							<!-- checkbox -->
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
								<th scope="col"><input type="checkbox" id="allCheckAddPM"/></th>
								<th scope="col">사원번호</th>
								<th scope="col">이름</th>
								<th scope="col">부서</th>
								<th scope="col">직급</th>
								<th scope="col">투입일</th>
								<th scope="col">철수일</th>
								<th scope="col">역할</th>
							</tr>
						</thead>
						<tbody id="memberList">
							
						</tbody>
					</table>
				</div>
				<div class="text-center">
					<button type="button" class="btn btn-green" id="addPMBtn">추가</button>
					<button type="button" class="btn btn-orange" id="cancelAddPMBtn">취소</button>
				</div>
			</article>
		</div><!-- 모달 끝 -->
	</div>
</body>
<script>
modalStack.push('#modalAddProjectMember');

// 닫기 버튼
document.getElementById('addProjectMemberClose').addEventListener('click', function(){
	$('#modalAddProjectMember').html('');
	modalStack.pop();
})

// 취소 버튼
document.getElementById('cancelAddPMBtn').addEventListener('click', function(){
	$('#modalAddProjectMember').html('');
	modalStack.pop();
})

// 처음 진입시 검색 실행
searchMember();

// 모두 체크 이벤트
document.getElementById('allCheckAddPM').addEventListener('click', allCheckAddPMEvent);

// 검색 버튼 이벤트
document.getElementById('searchBtn').addEventListener('click', searchMember);

// 저장 버튼 이벤트
document.getElementById('addPMBtn').addEventListener('click', addPMBtnEvent);
</script>
</html>