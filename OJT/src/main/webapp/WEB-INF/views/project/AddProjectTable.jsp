<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<body>
	<c:forEach var="item" items="${addPMList}" varStatus="status">
		<tr>
			<td>
				<input type="checkbox" class="checkAddProject"/>
			</td>
			<td>
				<input id="pmList${rowsLength + status.index}.mem_seq" name="pmList[${rowsLength + status.index}].mem_seq" 
					class="read-input" readonly="readonly" type="text" value="${item.mem_seq }" />
			</td>
			<td>
				<input id="pmList${rowsLength + status.index}.mem_nm" name="pmList[${rowsLength + status.index}].mem_nm" 
					class="read-input" readonly="readonly" type="text" value="${item.mem_nm }" />
			</td>
			<td>
				<input id="pmList${rowsLength + status.index}.dept" name="pmList[${rowsLength + status.index}].dept" 
					class="read-input" readonly="readonly" type="text" value="${item.dept }" />
			</td>
			<td>
				<input id="pmList${rowsLength + status.index}.position" name="pmList[${rowsLength + status.index}].position" 
					class="read-input" readonly="readonly" type="text" value="${item.position }" />
			</td>
			<td>
				<input id="pmList${rowsLength + status.index}.st_dt" name="pmList[${rowsLength + status.index}].st_dt"
				type="date" class="st_dt" value="${item.st_dt}" min="${startDate}" max="${item.ed_dt }" index="${status.index}" required/>
			</td>
			<td>
				<input id="pmList${rowsLength + status.index}.ed_dt" name="pmList[${rowsLength + status.index}].ed_dt"
				type="date" class="ed_dt" value="${item.ed_dt}" min="${item.st_dt}" max="${endDate}" index="${status.index}" required/>
			</td>
			<td>
				<select id="pmList${rowsLength + status.index}.ro_cd" name="pmList[${rowsLength + status.index }].ro_cd" class="role text-left">
					<c:forEach var="role" items="${roleList}">
						<c:choose>
							<c:when test="${role.dtl_cd == item.ro_cd}">
								<option value="${role.dtl_cd}" selected>${role.dtl_cd_nm}</option>
							</c:when>
							<c:otherwise>
								<option value="${role.dtl_cd}">${role.dtl_cd_nm}</option>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</select>
			</td>
		</tr>
	</c:forEach>
</body>