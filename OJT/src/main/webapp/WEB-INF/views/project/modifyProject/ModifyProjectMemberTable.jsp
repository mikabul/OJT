<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<html>
	<c:forEach var="item" items="${ pmList }" varStatus="status">
		<c:set var="index" value="${ status.index + rowsLength }" />
		<tr>
			<td>
				<input type="checkbox" class="check" />
			</td>
			<td>
				<input id="pmList${ index }.memberNumber" name="pmList[${ index }].memberNumber"
				class="read-input" readonly="readonly" type="text" value="${ item.memberNumber }"/>
			</td>
			<td>
				<input id="pmList${ index }.memberName" name="pmList[${ index }].memberName"
				class="read-input" readonly="readonly" type="text" value="${ item.memberName }"/>
			</td>
			<td>
				<input id="pmList${ index }.department" name="pmList[${ index }].department"
				class="read-input" readonly="readonly" type="text" value="${ item.department }"/>
			</td>
			<td>
				<input id="pmList${ index }.position" name="pmList[${ index }].position"
				class="read-input" readonly="readonly" type="text" value="${ item.position }"/>
			</td>
			<td>
				<input id="pmList${ index }.startDate" name="pmList[${ index }].startDate"
				min="${ startDate }" max="${ endDate }"
				class="startDate" type="date" value="${ item.startDate }"/>
			</td>
			<td>
				<input id="pmList${ index }.endDate" name="pmList[${ index }].endDate"
				min="${ startDate }" max="${ endDate }"
				class="endDate" type="date" value="${ item.endDate }"/>
			</td>
			<td>
				<select id="pmList${ index }.roleCode" name="pmList[${ index }].roleCode" class="role">
					<c:forEach var="role" items="${ roleList }">
						<c:choose>
							<c:when test="${ role.detailCode == item.roleCode }">
								<option class="text-left" value="${ role.detailCode }" selected>${ role.codeName }</option>
							</c:when>
							<c:otherwise>
								<option class="text-left" value="${ role.detailCode }">${ role.codeName }</option>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</select>
			</td>
		</tr>
	</c:forEach>
</html>