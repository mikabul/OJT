<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<style>
	table td{
		text-align: center;
	}
</style>
<div class="pop-background justify-content-center">
	<div class="pop">

		<!-- 상단 부분 -->
		<div class="justify-content-center">
			<div class="col-3">
				<span style="color: red">*</span> <span>필수입력</span>
			</div>
			<div class="col-3 text-center">
				<h3>프로젝트 인원 등록</h3>
			</div>
			<div class="col-3 text-right">
				<button type="button" class="closeBtn" onclick="closeAddPMPop()">
					<img src="${root}resources/images/x.png" alt="" class="closeImg" />
				</button>
			</div>
		</div>

		<div class="text-center" style="margin-top: 20px;">
			<label for="searchMem_nm">이름</label> <input type="search"
				id="searchMem_nm" />
			<button type="button" onclick="clickSearchPM()">조회</button>
		</div>

		<div class="scroll" style="height: 300px; margin-top: 40px;">
			<table class="table-center">
				<colgroup>
					<col style="width: 55px" />
					<col style="width: 77px" />
					<col style="width: 70px" />
					<col style="width: 55px" />
					<col style="width: 55px" />
					<col style="width: 123px" />
					<col style="width: 123px" />
					<col style="width: 55px" />
				</colgroup>
				<thead>
					<tr>
						<td scope="col"><input type="checkbox" onclick="" /></td>
						<td scope="col">사원 번호</td>
						<td scope="col">이름</td>
						<td scope="col">부서</td>
						<td scope="col">직급</td>
						<td scope="col">투입일</td>
						<td scope="col">철수일</td>
						<td scope="col">역할</td>
					</tr>
				</thead>
				<tbody id="addPMListBody">

				</tbody>
			</table>
		</div>
		<div class="text-right">
			<button type="button" class="btn btn-green" onclick="addPM()">추가</button>
		</div>
	</div>
</div>
<script src="${root}resources/javascript/AddProjectMember.js"></script>