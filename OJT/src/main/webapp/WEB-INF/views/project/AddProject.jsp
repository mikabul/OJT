<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>INNOBL - 프로젝트 등록</title>
<style>
	form div {
		margin: 3px 0;
		padding: 0 3px;
	}
	
	table th, table td{
		text-align: center;
	}
	
	textarea {
	width: 100%;
	height: 100px;
	resize: none;
	box-sizing: border-box;
	}
	
	.text-top {
		vertical-align: top;
	}
	
	tbody select, tbody input {
		padding: 3px 5px;
		text-align: center;
	}
	
	span {
		color: red;
	}
	
	.scroll {
		max-height: 200px;
	}
	
	#dropdown {
		border: 1px solid black;
		display: flex;
		width: 540px;
	}
	
	#dropdown div{
		cursor: default;
	}
	
	#dropdownMenu {
		position: fixed;
		background-color: white;
		border: 1px solid black;
		max-height: 130px;
	}
	
	#dropdownMenu div {
		display: felx;
		align-items: center;
	}
	
	#dropdownMenu input[type="checkbox"] {
		width: 13px;
		height: 13px;
	}
	
	#dropdownMenu label {
		flex: 1;
		margin-left: 5px;
	}
</style>
</head>
<body>
	<div class="modal-background">
	
		<div class="modal">
			<div class="justify-content-center">
				<div class="w-20">
					<span>*</span>필수입력
				</div>
				<div class="text-center w-60">
					<h3>프로젝트 등록</h3>
				</div>
				<div class="text-right w-20">
					<button type="button" class="closeBtn" id="addProjectClose">
						<img src="${root}resources/images/x.png" alt="" />
					</button>
				</div>
			</div>
			
			<form:form action="#" method="POST" modelAttribute="addProjectBean">
				<div class="justify-content-center">
					<div class="w-20">프로젝트 명<span>*</span></div>
					<div class="w-30">
						<form:input path="prj_nm"/>
						<form:errors path="prj_nm"/>
					</div>
					<div class="w-20">고객사<span>*</span></div>
					<div class="w-30">
						<form:select path="cust_seq">
							<form:option value="0">-선택-</form:option>
							<c:forEach var="item" items="${customerList}">
								<form:option value="${item.cust_seq}">${item.cust_nm}</form:option>
							</c:forEach>
						</form:select>
					</div>
				</div>
				<div class="justify-content-center">
					<div class="w-20">프로젝트 기간<span>*</span></div>
					<div class="w-30">
						<form:input type="date" path="prj_st_dt"/>
					</div>
					<div class="w-20 text-center">~</div>
					<div class="w-30">
						<form:input type="date" path="prj_ed_dt"/>
					</div>
				</div>
				<div class="justify-content-center" id="projectStatus">
					<div class="w-20">
						유지보수 기간					
					</div>
					<div class="w-30">
						<form:input type="date" path="maint_st_dt"/>
					</div>
					<div class="w-20 text-center">~</div>
					<div class="w-30">
						<form:input type="date" path="maint_ed_dt" />
					</div>
				</div>
				<div class="justify-content-center">
					<div class="w-20">필요기술</div>
					<div class="w-80 margin-0">
						<div id="dropdown" class="w-100" show="false">
							<div class="w-90 ellipsis" id="checkMessage" title="">
							
							</div>
							<div class="w-10 text-right" id="dropIcon">
							▼
							</div>
						</div>
						<div class="scroll none" id="dropdownMenu">
							<c:forEach var="item" items="${skList}" varStatus="status">
								<div style="display: flex;">
									<form:checkbox path="prj_sk_list" value="${item.dtl_cd}"/>
									<form:label style="flex: 1;" path="prj_sk_list" for="prj_sk_list${status.index + 1}">
										${item.dtl_cd_nm}
									</form:label>
								</div>
								<hr />
							</c:forEach>
						</div>
					</div>
				</div>
				
				<div class="justify-content-center" style="align-items: start;">
					<div class="w-20 text-top">세부사항</div>
					<div class="w-80">
						<form:textarea path="prj_dtl"/>
					</div>
				</div>
				<div class="justify-content-center">
					인원 추가<hr class="text-line"/>
				</div>
				<div class="scroll">
					<table class="container-center">
						<colgroup>
							<col style="width: 30px;"/>
							<col style="width: 80px;"/>
							<col style="width: 80px;"/>
							<col style="width: 80px;"/>
							<col style="width: 80px;"/>
							<col style="width: 120px;"/>
							<col style="width: 120px;"/>
							<col style="width: 100px;"/>
						</colgroup>
						<thead>
							<tr>
								<th scope="col"><input type="checkbox" id="allCheckAddProject" value="false"/></th>
								<th scope="col">사원 번호</th>
								<th scope="col">이름</th>
								<th scope="col">부서</th>
								<th scope="col">직급</th>
								<th scope="col">투입일</th>
								<th scope="col">철수일</th>
								<th scope="col">역할</th>
							</tr>
						</thead>
						<tbody id="pmListBody">
							<c:choose>
								<c:when test="${fn:length(addProjectBean.pmList) == 0 }">
									<tr>
										<td class="text-center" colspan="8">
											추가된 인원이 없습니다.
										</td>
									</tr>
								</c:when>
								<c:otherwise>
									<c:forEach var="item" items="${addProjectBean.pmList}" varStatus="status">
										<tr>
											<td><input type="checkbox" class="checkAddProject"/></td>
											<td>
												<form:input path="pmList[${status.index}].mem_seq" class="read-input" readonly="true"/>
											</td>
											<td>
												<form:input path="pmList[${status.index}].mem_nm" class="read-input" readonly="true"/>
											</td>
											<td>
												<form:input path="pmList[${status.index}].dept" class="read-input" readonly="true"/>
											</td>
											<td>
												<form:input path="pmList[${status.index }].position" class="read-input" readonly="true"/>
											</td>
											<td>
												<form:input type="date" path="pmList[${status.index}].st_dt" class="st_dt"/>
											</td>
											<td>
												<form:input type="date" path="pmList[${status.index}].ed_dt" class="ed_dt"/>
											</td>
											<td>
												<form:select path="pmList[${status.index}].role" class="role">
													<c:forEach var="role" items="${roleList}">
														<form:option value="${role.dtl_cd}">${role.dtl_cd_nm}</form:option>
													</c:forEach>
												</form:select>
											</td>
										</tr>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</div>
				<div class="text-right">
					<button type="button" class="btn btn-red" id="delete_addProjectBtn">삭제</button>
					<button type="button" class="btn btn-green" id="addPMModalBtn">추가</button>
				</div>
				<div class="text-center">
					<button type="submit" class="btn btn-green">저장</button>
					<button type="button" class="btn btn-orange" id="cancelBtn">취소</button>
				</div>
			</form:form>
			
		</div>
		
	</div>
</body>

</html>