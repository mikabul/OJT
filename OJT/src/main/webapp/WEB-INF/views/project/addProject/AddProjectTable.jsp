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
				<input id="pmList${rowsLength + status.index}.memberNumber" name="pmList[${rowsLength + status.index}].memberNumber" 
					class="read-input" readonly="readonly" type="text" value="${item.memberNumber }" />
			</td>
			<td>
				<input id="pmList${rowsLength + status.index}.memberName" name="pmList[${rowsLength + status.index}].memberName" 
					class="read-input" readonly="readonly" type="text" value="${item.memberName }" />
			</td>
			<td>
				<input id="pmList${rowsLength + status.index}.department" name="pmList[${rowsLength + status.index}].department" 
					class="read-input" readonly="readonly" type="text" value="${item.department }" />
			</td>
			<td>
				<input id="pmList${rowsLength + status.index}.position" name="pmList[${rowsLength + status.index}].position" 
					class="read-input" readonly="readonly" type="text" value="${item.position }" />
			</td>
			<td>
				<input id="pmList${rowsLength + status.index}.startDate" name="pmList[${rowsLength + status.index}].startDate"
				type="date" class="startDate" value="${item.startDate}" min="${startDate}" max="${item.endDate }" index="${status.index}" required/>
			</td>
			<td>
				<input id="pmList${rowsLength + status.index}.endDate" name="pmList[${rowsLength + status.index}].endDate"
				type="date" class="endDate" value="${item.endDate}" min="${item.startDate}" max="${endDate}" index="${status.index}" required/>
			</td>
			<td>
				<select id="pmList${rowsLength + status.index}.roleCode" name="pmList[${rowsLength + status.index }].roleCode" class="role text-left">
					<c:forEach var="role" items="${roleList}">
						<c:choose>
							<c:when test="${role.detailCode == item.roleCode}">
								<option value="${role.detailCode}" selected>${role.codeName}</option>
							</c:when>
							<c:otherwise>
								<option value="${role.detailCode}">${role.codeName}</option>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</select>
			</td>
		</tr>
	</c:forEach>
</body>